import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../data/route_service.dart';
import '../../domain/route_result.dart';

/// Rota çiziminin ihtiyaç duyduğu başlangıç ve hedef koordinatlar.
typedef RouteEndpoints = (LatLng from, LatLng to);

final routeServiceProvider = Provider<RouteService>((ref) {
  return const RouteService();
});

/// Beyza'nın rota çizimi için ortak sözleşme.
///
/// Kullanım: `ref.watch(routeProvider((userLocation, selectedArea.center)))`
final routeProvider = FutureProvider.family<RouteResult, RouteEndpoints>((
  ref,
  endpoints,
) {
  return ref
      .watch(routeServiceProvider)
      .getRoute(from: endpoints.$1, to: endpoints.$2);
});
