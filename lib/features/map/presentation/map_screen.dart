import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/config/districts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/geo.dart';
import '../domain/assembly_area.dart';
import '../utils/distance_color.dart';
import 'map_layer_provider.dart';
import 'location_providers.dart';
import '../utils/location_service.dart';
import 'providers/clustering_provider.dart';
import 'providers/map_zoom_provider.dart';
import 'providers/map_bounds_provider.dart';
import 'providers/assembly_areas_provider.dart';
import 'providers/selected_area_provider.dart';
import 'widgets/layer_switcher.dart';
import 'widgets/district_picker.dart';
import 'widgets/map_compass.dart';
import 'widgets/cluster_marker.dart';
import 'widgets/map_controls.dart';
import 'widgets/area_detail_card.dart';
import 'widgets/nearest_areas_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  AnimationController? _moveController;
  LatLng? _lastCamCenter;
  double _lastCamZoom = 13;
  Timer? _clusterDebounce;
  Timer? _autoZoomTimer;
  bool _overviewDone = false;
  bool _autoZoomed = false;
  bool _userInteracted = false;
  double? _zoomTarget;

  static final LatLng _ankara = LatLng(39.9334, 32.8597);
  static const double _minZoom = 2;
  static const double _maxZoom = 19.5;

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
      _animatedMove(loc, 15);
    }
  }

  void _onMapMoved(MapCamera camera, {bool hasGesture = false}) {
    if (!mounted) return;
    if (hasGesture) {
      _userInteracted = true;
      _moveController?.stop();
      _zoomTarget = null;
    }
    _clusterDebounce?.cancel();
    _clusterDebounce = Timer(
      const Duration(milliseconds: 150),
      _applyCameraToProviders,
    );
  }

  void _zoomBy(double delta) {
    _userInteracted = true;
    final base = _zoomTarget ?? _mapController.camera.zoom;
    final target = (base + delta).clamp(_minZoom, _maxZoom);
    _animatedMove(_mapController.camera.center, target);
    _zoomTarget = target;
  }

  void _goToMyLocation() {
    _userInteracted = true;
    final pos = ref.read(userLocationProvider).valueOrNull;
    if (pos == null) {
      showDistrictPicker(context);
      return;
    }
    if (ref.read(manualDistrictProvider) != null) {
      ref.read(manualDistrictProvider.notifier).state = null;
    } else {
      _animatedMove(LatLng(pos.latitude, pos.longitude), 16);
    }
  }

  void _applyCameraToProviders() {
    if (!mounted) return;
    final cam = _mapController.camera;
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
    _moveController?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _animatedMove(LatLng dest, double destZoom) {
    _zoomTarget = null;
    _moveController?.dispose();

    final camera = _mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: dest.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: dest.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _moveController = controller;
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLayer = ref.watch(mapLayerProvider);
    final location = ref.watch(effectiveLocationProvider);
    final accuracy = ref.watch(locationAccuracyProvider);
    final userAsync = ref.watch(userLocationProvider);
    final isLocating = userAsync.isLoading;
    final manualDistrict = ref.watch(manualDistrictProvider);
    final clustering = ref.watch(clusteringProvider);
    final areasLoading = ref.watch(assemblyAreasProvider).isLoading;
    final selectedArea = ref.watch(selectedAreaProvider);
    final usingManual = manualDistrict != null;

    ref.listen<District?>(manualDistrictProvider, (previous, next) {
      if (next != null) {
        _autoZoomed = true;
        _animatedMove(next.center, 15);
      } else if (previous != null) {
        final pos = ref.read(userLocationProvider).valueOrNull;
        if (pos != null) {
          _animatedMove(LatLng(pos.latitude, pos.longitude), 16);
        }
      }
    });

    ref.listen<LatLng?>(effectiveLocationProvider, (previous, next) {
      if (next != null) _tryAutoZoom();
    });

    final Widget? topInfo = (location == null && !isLocating)
        ? _promptCard()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Afet Toplanma Haritası'),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            tooltip: 'En yakın alanlar',
            onPressed: _showNearestAreas,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _ankara,
              initialZoom: 13,
              minZoom: _minZoom,
              maxZoom: _maxZoom,
              interactionOptions: const InteractionOptions(
                enableMultiFingerGestureRace: true,
                rotationThreshold: 30.0,
              ),
              onMapReady: () => _onMapMoved(_mapController.camera),
              onPositionChanged: (camera, hasGesture) =>
                  _onMapMoved(camera, hasGesture: hasGesture),
              onTap: (tapPosition, latlng) {
                _userInteracted = true;
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
              if (location != null && accuracy != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: location,
                      radius: accuracy,
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
                    // Seçili olmayan poligonlar (mesafe rengi)
                    for (final area in clustering.polygons)
                      if (!_sameArea(area, selectedArea))
                        _polygonFor(area, location),
                    if (selectedArea != null)
                      _polygonFor(selectedArea, location, isSelected: true),
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
                        onTap: () => _animatedMove(
                          cluster.center,
                          _mapController.camera.zoom + 2,
                        ),
                      ),
                    ),
                ],
              ),
              if (location != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 170,
                      height: 96,
                      alignment: Alignment.topCenter,
                      child: _locationMarker(
                        usingManual ? manualDistrict.name : null,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: MapCompass(controller: _mapController),
          ),
          if (areasLoading)
            const Positioned(
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
            ),
          Positioned(
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
                      onZoomIn: () => _zoomBy(1),
                      onZoomOut: () => _zoomBy(-1),
                      onMyLocation: _goToMyLocation,
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
                      : Padding(
                          key: ValueKey('detail-${selectedArea.name}'),
                          padding: const EdgeInsets.only(top: 12),
                          child: AreaDetailCard(
                            area: selectedArea,
                            onClose: () =>
                                ref.read(selectedAreaProvider.notifier).state =
                                    null,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _sameArea(AssemblyArea a, AssemblyArea? b) =>
      b != null &&
      a.center.latitude == b.center.latitude &&
      a.center.longitude == b.center.longitude;

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

  void _showNearestAreas() {
    showModalBottomSheet(
      context: context,
      builder: (_) => NearestAreasSheet(
        onSelect: (area) {
          Navigator.pop(context);
          _animatedMove(area.center, 18);
          ref.read(selectedAreaProvider.notifier).state = area;
        },
      ),
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
        onTap: () => showDistrictPicker(context),
      ),
    );
  }

  Widget _locationMarker(String? districtName) {
    final isManual = districtName != null;
    final pinColor = isManual ? AppColors.primary : AppColors.userLocation;
    final label = districtName ?? 'Konumum';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          color: pinColor,
          elevation: 3,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => showDistrictPicker(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  const Icon(Icons.expand_more, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Icon(Icons.location_on, color: pinColor, size: 42),
      ],
    );
  }
}
