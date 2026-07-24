import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/config/districts.dart';
import '../utils/location_service.dart';

final manualDistrictProvider = StateProvider<District?>((ref) => null);
final manualPointProvider = StateProvider<LatLng?>((ref) => null);

final effectiveLocationProvider = Provider<LatLng?>((ref) {
  final point = ref.watch(manualPointProvider);
  if (point != null) return point;
  final manual = ref.watch(manualDistrictProvider)?.center;
  if (manual != null) return manual;
  final pos = ref.watch(userLocationProvider).valueOrNull;
  return pos != null ? LatLng(pos.latitude, pos.longitude) : null;
});

final isGpsOriginProvider = Provider<bool>((ref) {
  return ref.watch(manualPointProvider) == null &&
      ref.watch(manualDistrictProvider) == null;
});

final locationAccuracyProvider = Provider<double?>((ref) {
  if (!ref.watch(isGpsOriginProvider)) return null;
  return ref.watch(userLocationProvider).valueOrNull?.accuracy;
});
