import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/assembly_area.dart';
import '../domain/route_mode.dart';
import '../utils/route_format.dart';
import 'location_providers.dart';
import '../utils/location_service.dart';
import 'providers/selected_area_provider.dart';
import 'providers/nearest_areas_provider.dart';
import 'providers/route_provider.dart';
import 'providers/route_flow_provider.dart';
import 'widgets/district_picker.dart';
import 'widgets/nearest_areas_sheet.dart';
import 'map_camera_mixin.dart';

mixin RouteFlowMixin<W extends ConsumerStatefulWidget>
    on ConsumerState<W>, MapCameraMixin<W> {
  LatLng? navPos;
  bool arrived = false;
  bool pickingOrigin = false;
  bool swapped = false;

  void startPickingOrigin() => setState(() => pickingOrigin = true);

  void onDirections(AssemblyArea area, LatLng from) {
    final areaMeters = const Distance().as(LengthUnit.Meter, from, area.center);
    final nearest = ref.read(nearestAreasProvider);
    if (areaMeters > 1000 && nearest.isNotEmpty) {
      final closest = nearest.first;
      if (!sameArea(closest.area, area) && closest.meters < areaMeters * 0.8) {
        showNearerDialog(closest.area, closest.meters, from, area);
        return;
      }
    }
    enterDirections(from, area);
  }

  void enterDirections(LatLng from, AssemblyArea area) {
    ref.read(routePhaseProvider.notifier).state = RoutePhase.directions;
    fitToPoints([from, area.center]);
  }

  void showNearerDialog(
    AssemblyArea nearer,
    double nearerMeters,
    LatLng from,
    AssemblyArea current,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Daha yakın bir alan var'),
        content: Text(
          'Yaklaşık ${formatDistance(nearerMeters)} uzaklıkta daha yakın bir '
          'toplanma alanı var. Onu görmek ister misiniz?',
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade800,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    enterDirections(from, current);
                  },
                  child: const Text('İptal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ref.read(selectedAreaProvider.notifier).state = nearer;
                    animatedMove(nearer.center, 18);
                  },
                  child: const Text('Yakını Gör'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void startNavigation(LatLng from, AssemblyArea area) {
    ref.read(routePhaseProvider.notifier).state = RoutePhase.navigating;
    arrived = false;
    final route = ref.read(routeProvider((from, area.center))).valueOrNull;
    fitToPoints(route?.points ?? [from, area.center]);
  }

  void stopNavigation() {
    ref.read(routePhaseProvider.notifier).state = RoutePhase.directions;
    navPos = null;
  }

  void closeRoute() {
    ref.read(routePhaseProvider.notifier).state = RoutePhase.idle;
    ref.read(routeModeProvider.notifier).state = RouteMode.walking;
    navPos = null;
    swapped = false;
  }

  void onArrived() {
    if (arrived) return;
    arrived = true;
    ref.read(routePhaseProvider.notifier).state = RoutePhase.idle;
    navPos = null;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Vardınız! Toplanma alanına ulaştınız.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void showOriginMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.my_location,
                color: AppColors.userLocation,
              ),
              title: const Text('Konumum (GPS)'),
              onTap: () {
                Navigator.pop(ctx);
                setOriginGps();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.location_city,
                color: AppColors.primary,
              ),
              title: const Text('İlçe seç'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(manualPointProvider.notifier).state = null;
                showDistrictPicker(context, onPickFromMap: startPickingOrigin);
              },
            ),
            ListTile(
              leading: const Icon(Icons.touch_app, color: AppColors.accent),
              title: const Text('Haritadan seç'),
              subtitle: const Text('Başlangıç için haritaya dokunun'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => pickingOrigin = true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void setOriginGps() {
    ref.read(manualPointProvider.notifier).state = null;
    ref.read(manualDistrictProvider.notifier).state = null;
    final pos = ref.read(userLocationProvider).valueOrNull;
    if (pos != null) animatedMove(LatLng(pos.latitude, pos.longitude), 16);
  }

  void editDestination() => showNearestAreas();

  bool sameArea(AssemblyArea a, AssemblyArea? b) =>
      b != null &&
      a.center.latitude == b.center.latitude &&
      a.center.longitude == b.center.longitude;

  void showNearestAreas() {
    showModalBottomSheet(
      context: context,
      builder: (_) => NearestAreasSheet(
        onSelect: (area) {
          Navigator.pop(context);
          animatedMove(area.center, 18);
          ref.read(selectedAreaProvider.notifier).state = area;
        },
      ),
    );
  }
}
