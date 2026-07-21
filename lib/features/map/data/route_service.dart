import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../domain/route_result.dart';

/// OSRM'den rota alır; servis kullanılamazsa uygulamanın rota UI'ı çalışmaya
/// devam etsin diye doğru-çizgi ve yürüme süresi tahmini döndürür.
class RouteService {
  const RouteService({
    this.timeout = const Duration(seconds: 5),
    this.walkingSpeedMetersPerSecond = 1.4,
  });

  final Duration timeout;
  final double walkingSpeedMetersPerSecond;

  Future<RouteResult> getRoute({
    required LatLng from,
    required LatLng to,
  }) async {
    try {
      final response = await http
          .get(_osrmUri(from: from, to: to))
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw FormatException(
          'OSRM rota isteği başarısız: ${response.statusCode}',
        );
      }

      return parseOsrmRoute(jsonDecode(response.body) as Map<String, dynamic>);
    } on TimeoutException {
      return localFallback(from: from, to: to);
    } on http.ClientException {
      return localFallback(from: from, to: to);
    } on FormatException {
      return localFallback(from: from, to: to);
    }
  }

  /// OSRM GeoJSON yanıtını, UI'ın kullandığı ortak rota modeline çevirir.
  static RouteResult parseOsrmRoute(Map<String, dynamic> response) {
    final routes = response['routes'] as List?;
    if (routes == null || routes.isEmpty) {
      throw const FormatException('OSRM yanıtında rota bulunamadı.');
    }

    final route = routes.first as Map<String, dynamic>;
    final geometry = route['geometry'] as Map<String, dynamic>?;
    final coordinates = geometry?['coordinates'] as List?;
    if (coordinates == null || coordinates.length < 2) {
      throw const FormatException('OSRM rota geometrisi geçersiz.');
    }

    final points = coordinates
        .map((coordinate) {
          final pair = coordinate as List;
          return LatLng(
            (pair[1] as num).toDouble(),
            (pair[0] as num).toDouble(),
          );
        })
        .toList(growable: false);

    return RouteResult(
      points: points,
      distanceMeters: (route['distance'] as num).toDouble(),
      durationSeconds: (route['duration'] as num).toDouble(),
    );
  }

  /// Ağ yokken çizilebilir rota ve tahmini yürüyüş süresi sağlayan fallback.
  RouteResult localFallback({required LatLng from, required LatLng to}) {
    final distanceMeters = const Distance().as(LengthUnit.Meter, from, to);
    return RouteResult(
      points: [from, to],
      distanceMeters: distanceMeters,
      durationSeconds: distanceMeters / walkingSpeedMetersPerSecond,
    );
  }

  Uri _osrmUri({required LatLng from, required LatLng to}) {
    final coordinates =
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';
    return Uri.https(
      'router.project-osrm.org',
      '/route/v1/driving/$coordinates',
      {'overview': 'full', 'geometries': 'geojson'},
    );
  }
}
