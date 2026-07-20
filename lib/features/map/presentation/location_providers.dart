import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../utils/location_service.dart';

final manualLocationProvider = StateProvider<LatLng?>((ref) => null);

final effectiveLocationProvider = Provider<LatLng?>((ref) {
  final pos = ref.watch(userLocationProvider).valueOrNull;
  if (pos != null) return LatLng(pos.latitude, pos.longitude);
  return ref.watch(manualLocationProvider);
});

final locationAccuracyProvider = Provider<double?>((ref) {
  return ref.watch(userLocationProvider).valueOrNull?.accuracy;
});
