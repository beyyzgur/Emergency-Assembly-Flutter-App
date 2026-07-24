import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/config/districts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/geo.dart';
import '../domain/assembly_area.dart';
import '../domain/route_mode.dart';
import '../utils/distance_color.dart';
import 'map_layer_provider.dart';
import 'location_providers.dart';
import '../utils/location_service.dart';
import 'providers/clustering_provider.dart';
import 'providers/map_zoom_provider.dart';
import 'providers/map_bounds_provider.dart';
import 'providers/assembly_areas_provider.dart';
import 'providers/selected_area_provider.dart';
import 'providers/route_provider.dart';
import 'providers/route_flow_provider.dart';
import 'providers/tracking_provider.dart';
import 'widgets/layer_switcher.dart';
import 'widgets/district_picker.dart';
import 'widgets/map_compass.dart';
import 'widgets/cluster_marker.dart';
import 'widgets/map_controls.dart';
import 'widgets/area_detail_card.dart';
import 'widgets/route_panel.dart';
import 'widgets/route_header.dart';
import 'map_camera_mixin.dart';
import 'route_flow_mixin.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin, MapCameraMixin, RouteFlowMixin {
  LatLng? _lastCamCenter;
  double _lastCamZoom = 13;
  Timer? _clusterDebounce;
  Timer? _autoZoomTimer;
  bool _overviewDone = false;
  bool _autoZoomed = false;
  bool _userInteracted = false;

  static final LatLng _ankara = LatLng(39.9334, 32.8597);

  @override
  void initState() {
    super.initState();
    _autoZoomTimer = Timer(const Duration(seconds: 3), () {
      _overviewDone = true;
      _tryAutoZoom();
    });
  }

  void _tryAutoZoom() {
    if (!mounted || _userInteracted || _autoZoomed || !_overviewDone) return;
    final loc = ref.read(effectiveLocationProvider);
    if (loc != null) {
      _autoZoomed = true;
      animatedMove(loc, 15);
    }
  }

  void _onMapMoved(MapCamera camera, {bool hasGesture = false}) {
    if (!mounted) return;
    if (hasGesture && !programmaticAnim) {
      _userInteracted = true;
      moveController?.stop();
      zoomTarget = null;
    }
    _clusterDebounce?.cancel();
    _clusterDebounce = Timer(
      const Duration(milliseconds: 150),
      _applyCameraToProviders,
    );
  }

  void _goToMyLocation() {
    _userInteracted = true;
    final pos = ref.read(userLocationProvider).valueOrNull;
    if (pos == null) {
      showDistrictPicker(context, onPickFromMap: startPickingOrigin);
      return;
    }
    if (ref.read(routePhaseProvider) == RoutePhase.idle) {
      ref.read(manualPointProvider.notifier).state = null;
      ref.read(manualDistrictProvider.notifier).state = null;
    }
    animatedMove(LatLng(pos.latitude, pos.longitude), 16);
  }

  void _goToSelectedPoint() {
    final p = ref.read(manualPointProvider);
    if (p != null) animatedMove(p, 16);
  }

  void _applyCameraToProviders() {
    if (!mounted) return;
    final cam = mapController.camera;
    final z = cam.zoom;
    final c = cam.center;
    final b = cam.visibleBounds;

    final zoomChanged = (z - _lastCamZoom).abs() >= 0.3;
    final wLng = (b.east - b.west).abs();
    final wLat = (b.north - b.south).abs();
    final movedEnough =
        _lastCamCenter == null ||
        (c.longitude - _lastCamCenter!.longitude).abs() > wLng * 0.25 ||
        (c.latitude - _lastCamCenter!.latitude).abs() > wLat * 0.25;

    if (zoomChanged || movedEnough) {
      _lastCamZoom = z;
      _lastCamCenter = c;
      ref.read(mapZoomProvider.notifier).state = z;
      ref.read(mapBoundsProvider.notifier).state = b;
    }
  }

  @override
  void dispose() {
    _clusterDebounce?.cancel();
    _autoZoomTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLayer = ref.watch(mapLayerProvider);
    final location = ref.watch(effectiveLocationProvider);
    final userAsync = ref.watch(userLocationProvider);
    final isLocating = userAsync.isLoading;
    final manualDistrict = ref.watch(manualDistrictProvider);
    final clustering = ref.watch(clusteringProvider);
    final areasLoading = ref.watch(assemblyAreasProvider).isLoading;
    final selectedArea = ref.watch(selectedAreaProvider);

    ref.listen<District?>(manualDistrictProvider, (previous, next) {
      if (next != null) {
        _autoZoomed = true;
        animatedMove(next.center, 15);
      } else if (previous != null) {
        final pos = ref.read(userLocationProvider).valueOrNull;
        if (pos != null) {
          animatedMove(LatLng(pos.latitude, pos.longitude), 16);
        }
      }
    });

    ref.listen<LatLng?>(manualPointProvider, (previous, next) {
      if (next == null && previous != null) {
        final pos = ref.read(userLocationProvider).valueOrNull;
        if (pos != null) {
          animatedMove(LatLng(pos.latitude, pos.longitude), 16);
        }
      }
    });

    ref.listen<LatLng?>(effectiveLocationProvider, (previous, next) {
      if (next != null) _tryAutoZoom();
    });

    final phase = ref.watch(routePhaseProvider);

    ref.listen(selectedAreaProvider, (previous, next) {
      ref.read(routePhaseProvider.notifier).state = RoutePhase.idle;
      navPos = null;
      arrived = false;
      swapped = false;
    });

    final route =
        (phase != RoutePhase.idle && selectedArea != null && location != null)
        ? ref
              .watch(
                routeProvider((
                  swapped ? selectedArea.center : location,
                  swapped ? location : selectedArea.center,
                )),
              )
              .valueOrNull
        : null;
    final routeMode = ref.watch(routeModeProvider);
    final manualPoint = ref.watch(manualPointProvider);
    final canNavigate = ref.watch(isGpsOriginProvider) && !swapped;
    final originLabel = manualPoint != null
        ? 'Haritadan seçilen nokta'
        : manualDistrict != null
        ? manualDistrict.name
        : 'Konumum (GPS)';
    final headerFrom = swapped ? (selectedArea?.name ?? '') : originLabel;
    final headerTo = swapped ? originLabel : (selectedArea?.name ?? '');

    if (phase == RoutePhase.navigating && selectedArea != null) {
      ref.listen(trackingPositionProvider, (previous, next) {
        final pos = next.valueOrNull;
        if (pos == null || !mounted) return;
        final p = LatLng(pos.latitude, pos.longitude);
        setState(() => navPos = p);
        mapController.move(p, mapController.camera.zoom);
        if (pointInPolygon(p, selectedArea.ring)) onArrived();
      });
    }

    final displayLoc = (phase == RoutePhase.navigating && navPos != null)
        ? navPos
        : location;

    final gpsPos = userAsync.valueOrNull;
    final gpsLatLng = gpsPos != null
        ? LatLng(gpsPos.latitude, gpsPos.longitude)
        : null;
    final gpsDot = (phase == RoutePhase.navigating && navPos != null)
        ? navPos
        : gpsLatLng;
    final gpsOrigin = ref.watch(isGpsOriginProvider);
    final routeFrom = (location != null && selectedArea != null)
        ? (swapped ? selectedArea.center : location)
        : null;
    final routeTo = (location != null && selectedArea != null)
        ? (swapped ? location : selectedArea.center)
        : null;

    final Widget? topInfo = (location == null && !isLocating)
        ? _promptCard()
        : null;

    final bounds = ref.watch(mapBoundsProvider);
    final showReturnToPoint =
        phase != RoutePhase.navigating &&
        manualPoint != null &&
        bounds != null &&
        !bounds.contains(manualPoint);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Afet Toplanma Haritası'),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            tooltip: 'En yakın alanlar',
            onPressed: showNearestAreas,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: _ankara,
              initialZoom: 13,
              minZoom: MapCameraMixin.minZoom,
              maxZoom: MapCameraMixin.maxZoom,
              interactionOptions: const InteractionOptions(
                enableMultiFingerGestureRace: true,
                rotationThreshold: 30.0,
              ),
              onMapReady: () => _onMapMoved(mapController.camera),
              onPositionChanged: (camera, hasGesture) =>
                  _onMapMoved(camera, hasGesture: hasGesture),
              onTap: (tapPosition, latlng) {
                _userInteracted = true;
                if (pickingOrigin) {
                  ref.read(manualPointProvider.notifier).state = latlng;
                  ref.read(manualDistrictProvider.notifier).state = null;
                  setState(() => pickingOrigin = false);
                  return;
                }
                AssemblyArea? hit;
                for (final area in clustering.polygons) {
                  if (pointInPolygon(latlng, area.ring)) {
                    hit = area;
                    break;
                  }
                }
                ref.read(selectedAreaProvider.notifier).state = hit;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: selectedLayer.url,
                userAgentPackageName: 'com.example.emergency_assembly_app',
              ),
              if (gpsLatLng != null &&
                  gpsPos != null &&
                  phase == RoutePhase.idle)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: gpsLatLng,
                      radius: gpsPos.accuracy,
                      useRadiusInMeter: true,
                      color: AppColors.userLocation.withValues(alpha: 0.18),
                      borderColor: AppColors.userLocation.withValues(
                        alpha: 0.6,
                      ),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (clustering.polygons.isNotEmpty || selectedArea != null)
                PolygonLayer(
                  polygons: [
                    for (final area in clustering.polygons)
                      if (!sameArea(area, selectedArea))
                        _polygonFor(area, location),
                    if (selectedArea != null)
                      _polygonFor(selectedArea, location, isSelected: true),
                  ],
                ),
              if (route != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route.points,
                      color: AppColors.primary,
                      strokeWidth: 6,
                      pattern: routeMode == RouteMode.walking
                          ? const StrokePattern.dotted(spacingFactor: 2)
                          : const StrokePattern.solid(),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  for (final cluster in clustering.clusters)
                    Marker(
                      point: cluster.center,
                      width: 56,
                      height: 56,
                      child: ClusterBadge(
                        key: ValueKey(
                          'c${cluster.center.latitude.toStringAsFixed(3)}'
                          '_${cluster.center.longitude.toStringAsFixed(3)}',
                        ),
                        count: cluster.count,
                        onTap: () => animatedMove(
                          cluster.center,
                          mapController.camera.zoom + 2,
                        ),
                      ),
                    ),
                ],
              ),
              if (gpsDot != null && (phase != RoutePhase.idle || !gpsOrigin))
                MarkerLayer(
                  markers: [
                    Marker(
                      point: gpsDot,
                      width: 22,
                      height: 22,
                      child: _gpsDot(),
                    ),
                  ],
                ),
              if (phase == RoutePhase.idle && displayLoc != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: displayLoc,
                      width: 170,
                      height: 96,
                      alignment: Alignment.topCenter,
                      child: _locationMarker(
                        manualDistrict != null
                            ? manualDistrict.name
                            : (manualPoint != null ? 'Seçilen nokta' : null),
                        showChip: true,
                      ),
                    ),
                  ],
                ),
              if (phase != RoutePhase.idle && routeFrom != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: routeFrom,
                      width: 34,
                      height: 34,
                      child: const Icon(
                        Icons.trip_origin,
                        color: AppColors.near,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              if (phase != RoutePhase.idle && routeTo != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: routeTo,
                      width: 40,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.far,
                        size: 42,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (phase == RoutePhase.idle && !pickingOrigin)
            Positioned(
              top: 16,
              right: 16,
              child: MapCompass(controller: mapController),
            ),
          if (!pickingOrigin &&
              phase != RoutePhase.idle &&
              selectedArea != null)
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: RouteHeader(
                fromLabel: headerFrom,
                toLabel: headerTo,
                onEditFrom: swapped ? editDestination : showOriginMenu,
                onEditTo: swapped ? showOriginMenu : editDestination,
                onSwap: () => setState(() => swapped = !swapped),
                canSwap: phase != RoutePhase.navigating,
              ),
            ),
          if (pickingOrigin) _pickingHint(),
          if (areasLoading) _areasLoadingBadge(),
          _bottomPanel(
            topInfo: topInfo,
            selectedArea: selectedArea,
            phase: phase,
            location: location,
            canNavigate: canNavigate,
            showReturnToPoint: showReturnToPoint,
          ),
        ],
      ),
    );
  }

  Widget _bottomPanel({
    required Widget? topInfo,
    required AssemblyArea? selectedArea,
    required RoutePhase phase,
    required LatLng? location,
    required bool canNavigate,
    required bool showReturnToPoint,
  }) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (topInfo != null) ...[topInfo, const SizedBox(height: 12)],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const LayerSwitcher(),
              const Spacer(),
              MapControls(
                onZoomIn: () {
                  _userInteracted = true;
                  zoomBy(1);
                },
                onZoomOut: () {
                  _userInteracted = true;
                  zoomBy(-1);
                },
                onMyLocation: _goToMyLocation,
                onReturnToPoint: showReturnToPoint ? _goToSelectedPoint : null,
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              alignment: Alignment.topCenter,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: selectedArea == null
                ? const SizedBox(
                    width: double.infinity,
                    key: ValueKey('no-detail'),
                  )
                : phase == RoutePhase.idle
                ? Padding(
                    key: ValueKey('detail-${selectedArea.name}'),
                    padding: const EdgeInsets.only(top: 12),
                    child: AreaDetailCard(
                      area: selectedArea,
                      onClose: () =>
                          ref.read(selectedAreaProvider.notifier).state = null,
                      userLoc: location,
                      onDirections: location == null
                          ? null
                          : () => onDirections(selectedArea, location),
                    ),
                  )
                : location == null
                ? const SizedBox(
                    width: double.infinity,
                    key: ValueKey('no-loc'),
                  )
                : Padding(
                    key: ValueKey('route-${selectedArea.name}'),
                    padding: const EdgeInsets.only(top: 12),
                    child: RoutePanel(
                      from: swapped ? selectedArea.center : location,
                      to: swapped ? location : selectedArea.center,
                      canNavigate: canNavigate,
                      onStart: () => startNavigation(location, selectedArea),
                      onStop: stopNavigation,
                      onClose: closeRoute,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _pickingHint() => Positioned(
    top: 10,
    left: 12,
    right: 12,
    child: Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.touch_app, color: AppColors.accent),
        title: const Text('Başlangıç için haritaya dokunun'),
        trailing: TextButton(
          onPressed: () => setState(() => pickingOrigin = false),
          child: const Text('Vazgeç'),
        ),
      ),
    ),
  );

  Widget _areasLoadingBadge() => const Positioned(
    top: 16,
    left: 16,
    child: Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('Toplanma alanları yükleniyor...'),
          ],
        ),
      ),
    ),
  );

  Polygon _polygonFor(
    AssemblyArea area,
    LatLng? userLoc, {
    bool isSelected = false,
  }) {
    if (isSelected) {
      return Polygon(
        points: area.ring,
        color: AppColors.selected.withValues(alpha: 0.45),
        borderColor: AppColors.selected,
        borderStrokeWidth: 4,
      );
    }
    final meters = userLoc == null
        ? null
        : const Distance().as(LengthUnit.Meter, userLoc, area.center);
    final color = colorForDistance(meters);
    return Polygon(
      points: area.ring,
      color: color.withValues(alpha: 0.35),
      borderColor: color,
      borderStrokeWidth: 2,
    );
  }

  Widget _promptCard() {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.location_off),
        title: const Text('Konum alınamadı'),
        subtitle: const Text('Bulunduğunuz ilçeyi seçin'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            showDistrictPicker(context, onPickFromMap: startPickingOrigin),
      ),
    );
  }

  Widget _gpsDot() => Container(
    decoration: BoxDecoration(
      color: AppColors.userLocation,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 3),
      ],
    ),
  );

  Widget _locationMarker(String? districtName, {bool showChip = true}) {
    final isManual = districtName != null;
    final pinColor = isManual ? AppColors.primary : AppColors.userLocation;
    final label = districtName ?? 'Konumum';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showChip) ...[
          Material(
            color: pinColor,
            elevation: 3,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => showDistrictPicker(
                context,
                onPickFromMap: startPickingOrigin,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.expand_more,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
        ],
        Icon(Icons.location_on, color: pinColor, size: 42),
      ],
    );
  }
}
