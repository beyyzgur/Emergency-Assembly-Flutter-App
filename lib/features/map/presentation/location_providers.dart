import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/config/districts.dart';
import '../utils/location_service.dart';

final manualDistrictProvider = StateProvider<District?>((ref) => null);

final effectiveLocationProvider = Provider<LatLng?>((ref) {
  final manual = ref.watch(manualDistrictProvider)?.center;
  if (manual != null) return manual;
  final pos = ref.watch(userLocationProvider).valueOrNull;
  return pos != null ? LatLng(pos.latitude, pos.longitude) : null;
});

final locationAccuracyProvider = Provider<double?>((ref) {
  if (ref.watch(manualDistrictProvider) != null) return null;
  return ref.watch(userLocationProvider).valueOrNull?.accuracy;
});
