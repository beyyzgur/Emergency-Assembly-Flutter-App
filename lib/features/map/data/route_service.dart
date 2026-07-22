import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../domain/route_result.dart';

/// OpenRouteService'in `foot-walking` profilinden yaya rotası alır.
///
/// API anahtarı kaynak koda yazılmaz; uygulama çalıştırılırken
/// `--dart-define=ORS_API_KEY=...` ile verilir. Anahtar yoksa veya servis
/// kullanılamazsa rota UI'ı çalışmaya devam etsin diye doğru-çizgi ve yürüme
/// süresi tahmini döndürür.
class RouteService {
  const RouteService({
    this.timeout = const Duration(seconds: 5),
    this.walkingSpeedMetersPerSecond = 1.4,
    this.apiKey = const String.fromEnvironment('ORS_API_KEY'),
  });

  final Duration timeout;
  final double walkingSpeedMetersPerSecond;
  final String apiKey;

  Future<RouteResult> getRoute({
    required LatLng from,
    required LatLng to,
  }) async {
    if (apiKey.isEmpty) {
      return localFallback(from: from, to: to);
    }

    try {
      final response = await http
          .get(
            _openRouteServiceUri(from: from, to: to),
            headers: {
              'Authorization': apiKey,
              'Accept': 'application/geo+json',
            },
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw FormatException(
          'ORS yaya rota isteği başarısız: ${response.statusCode}',
        );
      }

      return parseOrsRoute(jsonDecode(response.body) as Map<String, dynamic>);
    } on TimeoutException {
      return localFallback(from: from, to: to);
    } on http.ClientException {
      return localFallback(from: from, to: to);
    } on FormatException {
      return localFallback(from: from, to: to);
    }
  }

  /// ORS GeoJSON yanıtını, UI'ın kullandığı ortak rota modeline çevirir.
  static RouteResult parseOrsRoute(Map<String, dynamic> response) {
    final features = response['features'];
    if (features is! List || features.isEmpty) {
      throw const FormatException('ORS yanıtında rota bulunamadı.');
    }

    final feature = features.first;
    if (feature is! Map<String, dynamic>) {
      throw const FormatException('ORS rota verisi geçersiz.');
    }

    final geometry = feature['geometry'];
    final properties = feature['properties'];
    if (geometry is! Map<String, dynamic> ||
        properties is! Map<String, dynamic>) {
      throw const FormatException('ORS rota geometrisi geçersiz.');
    }

    final coordinates = geometry['coordinates'];
    final summary = properties['summary'];
    if (coordinates is! List || coordinates.length < 2 || summary is! Map) {
      throw const FormatException('ORS rota geometrisi geçersiz.');
    }

    final points = <LatLng>[];
    for (final coordinate in coordinates) {
      if (coordinate is! List ||
          coordinate.length < 2 ||
          coordinate[0] is! num ||
          coordinate[1] is! num) {
        throw const FormatException('ORS koordinat verisi geçersiz.');
      }
      points.add(
        LatLng(
          (coordinate[1] as num).toDouble(),
          (coordinate[0] as num).toDouble(),
        ),
      );
    }

    final distance = summary['distance'];
    final duration = summary['duration'];
    if (distance is! num || duration is! num) {
      throw const FormatException('ORS rota özeti geçersiz.');
    }

    return RouteResult(
      points: points,
      distanceMeters: distance.toDouble(),
      durationSeconds: duration.toDouble(),
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

  Uri _openRouteServiceUri({required LatLng from, required LatLng to}) {
    return Uri.https(
      'api.openrouteservice.org',
      '/v2/directions/foot-walking',
      {
        'start': '${from.longitude},${from.latitude}',
        'end': '${to.longitude},${to.latitude}',
      },
    );
  }
}
