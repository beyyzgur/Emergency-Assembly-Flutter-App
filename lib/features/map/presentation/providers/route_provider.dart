import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../data/route_service.dart';
import '../../domain/route_mode.dart';
import '../../domain/route_result.dart';

/// Rota çiziminin ihtiyaç duyduğu başlangıç ve hedef koordinatlar.
typedef RouteEndpoints = (LatLng from, LatLng to);

final routeServiceProvider = Provider<RouteService>((ref) {
  return const RouteService();
});

/// Harita ekranındaki aktif ulaşım profili.
///
/// Varsayılan yaya rotasıdır. Arayüz araç seçeneğini sunduğunda bu sağlayıcıyı
/// [RouteMode.driving] yapması yeterlidir; [routeProvider] otomatik yenilenir.
final routeModeProvider = StateProvider<RouteMode>((ref) {
  return RouteMode.walking;
});

/// Harita arayüzünün rota çizimi için ortak sözleşmesi.
///
/// Kullanım: `ref.watch(routeProvider((userLocation, selectedArea.center)))`
///
/// Araç moduna geçmek için:
/// `ref.read(routeModeProvider.notifier).state = RouteMode.driving`
final routeProvider = FutureProvider.family<RouteResult, RouteEndpoints>((
  ref,
  endpoints,
) {
  final mode = ref.watch(routeModeProvider);
  return ref
      .watch(routeServiceProvider)
      .getRoute(from: endpoints.$1, to: endpoints.$2, mode: mode);
});
