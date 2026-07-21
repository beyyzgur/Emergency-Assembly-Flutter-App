import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/gathering_polygon.dart';

class ApiService {
  Future<List<GatheringPolygon>> fetchPolygons() async {
    // TODO: Gerçek endpoint URL'si geldiğinde http paketi ile değiştirilecek
    // Şimdilik projeye dahil ettiğin assets/ANKARA_IL_SINIRI.geojson dosyasından okuyoruz
    final String response = await rootBundle.loadString(
      'assets/ANKARA_IL_SINIRI.geojson',
    );
    final data = await json.decode(response);

    final List features = data['features'];
    return features.map((json) => GatheringPolygon.fromJson(json)).toList();
  }
}
