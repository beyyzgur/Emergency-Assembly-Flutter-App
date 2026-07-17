import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../data/user_location_provider.dart';

final manualLocationProvider = StateProvider<LatLng?>((ref) => null);

final effectiveLocationProvider = Provider<LatLng?>((ref) {
  final pos = ref.watch(userLocationProvider).valueOrNull;
  if (pos != null) return LatLng(pos.latitude, pos.longitude);
  return ref.watch(manualLocationProvider);
});

final locationAccuracyProvider = Provider<double?>((ref) {
  return ref.watch(userLocationProvider).valueOrNull?.accuracy;
});
