import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/config/districts.dart';
import '../utils/location_service.dart';

final manualDistrictProvider = StateProvider<District?>((ref) => null);

final effectiveLocationProvider = Provider<LatLng?>((ref) {
  final pos = ref.watch(userLocationProvider).valueOrNull;
  if (pos != null) return LatLng(pos.latitude, pos.longitude);
  return ref.watch(manualDistrictProvider)?.center;
});

final locationAccuracyProvider = Provider<double?>((ref) {
  return ref.watch(userLocationProvider).valueOrNull?.accuracy;
});
