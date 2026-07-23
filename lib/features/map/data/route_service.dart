import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../domain/route_mode.dart';
import '../domain/route_result.dart';

/// Açık OSRM servislerinden rota alır.
///
/// [RouteMode.walking] FOSSGIS'in anahtarsız `routed-foot` servisini kullanır.
/// [RouteMode.driving] ise genel OSRM `driving` servisini kullanır. Her iki
/// servis de OSRM yanıt biçiminde olduğu için tek bir parser kullanılır.
///
/// Ağ veya servis problemi olduğunda uygulamanın rota akışı kırılmasın diye
/// iki noktalı düz çizgi ve profile uygun süre tahmini döndürülür.
class RouteService {
  const RouteService({
    this.timeout = const Duration(seconds: 5),
    this.walkingSpeedMetersPerSecond = 1.4,
    this.drivingSpeedMetersPerSecond = 13.9,
  });

  final Duration timeout;
  final double walkingSpeedMetersPerSecond;
  final double drivingSpeedMetersPerSecond;

  Future<RouteResult> getRoute({
    required LatLng from,
    required LatLng to,
    RouteMode mode = RouteMode.walking,
  }) async {
    try {
      final response = await http
          .get(
            routeUri(from: from, to: to, mode: mode),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw FormatException(
          '${mode.label} rota isteği başarısız: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('OSRM rota yanıtı geçersiz.');
      }
      return parseOsrmRoute(decoded);
    } on TimeoutException {
      return localFallback(from: from, to: to, mode: mode);
    } on http.ClientException {
      return localFallback(from: from, to: to, mode: mode);
    } on FormatException {
      return localFallback(from: from, to: to, mode: mode);
    }
  }

  /// OSRM yanıtını, UI'ın kullandığı ortak rota modeline çevirir.
  static RouteResult parseOsrmRoute(Map<String, dynamic> response) {
    final routes = response['routes'];
    if (routes is! List || routes.isEmpty) {
      throw const FormatException('OSRM yanıtında rota bulunamadı.');
    }

    final route = routes.first;
    if (route is! Map<String, dynamic>) {
      throw const FormatException('OSRM rota verisi geçersiz.');
    }

    final geometry = route['geometry'];
    if (geometry is! Map<String, dynamic>) {
      throw const FormatException('OSRM rota geometrisi geçersiz.');
    }

    final coordinates = geometry['coordinates'];
    if (coordinates is! List || coordinates.length < 2) {
      throw const FormatException('OSRM rota geometrisi geçersiz.');
    }

    final points = <LatLng>[];
    for (final coordinate in coordinates) {
      if (coordinate is! List ||
          coordinate.length < 2 ||
          coordinate[0] is! num ||
          coordinate[1] is! num) {
        throw const FormatException('OSRM koordinat verisi geçersiz.');
      }
      points.add(
        LatLng(
          (coordinate[1] as num).toDouble(),
          (coordinate[0] as num).toDouble(),
        ),
      );
    }

    final distance = route['distance'];
    final duration = route['duration'];
    if (distance is! num || duration is! num) {
      throw const FormatException('OSRM rota özeti geçersiz.');
    }

    return RouteResult(
      points: points,
      distanceMeters: distance.toDouble(),
      durationSeconds: duration.toDouble(),
    );
  }

  /// Ağ yokken çizilebilir rota ve profile uygun tahmini süre sağlayan fallback.
  RouteResult localFallback({
    required LatLng from,
    required LatLng to,
    RouteMode mode = RouteMode.walking,
  }) {
    final distanceMeters = const Distance().as(LengthUnit.Meter, from, to);
    final speed = switch (mode) {
      RouteMode.walking => walkingSpeedMetersPerSecond,
      RouteMode.driving => drivingSpeedMetersPerSecond,
    };
    return RouteResult(
      points: [from, to],
      distanceMeters: distanceMeters,
      durationSeconds: distanceMeters / speed,
    );
  }

  /// Seçilen profile ait anahtarsız OSRM uç noktasını üretir.
  static Uri routeUri({
    required LatLng from,
    required LatLng to,
    RouteMode mode = RouteMode.walking,
  }) {
    final coordinates =
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';
    final host = switch (mode) {
      RouteMode.walking => 'routing.openstreetmap.de',
      RouteMode.driving => 'router.project-osrm.org',
    };
    final path = switch (mode) {
      RouteMode.walking => '/routed-foot/route/v1/foot/$coordinates',
      RouteMode.driving => '/route/v1/driving/$coordinates',
    };

    return Uri.https(host, path, const {
      'overview': 'full',
      'geometries': 'geojson',
    });
  }
}
