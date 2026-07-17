import 'package:latlong2/latlong.dart';

class District {
  final String name;
  final LatLng center;
  const District(this.name, this.center);
}

/// Ankara'nın 25 ilçesi (yaklaşık merkez koordinatları).
final List<District> kAnkaraDistricts = [
  District('Akyurt', LatLng(40.1333, 33.0833)),
  District('Altındağ', LatLng(39.9500, 32.8667)),
  District('Ayaş', LatLng(40.0167, 32.3333)),
  District('Balâ', LatLng(39.5500, 33.1167)),
  District('Beypazarı', LatLng(40.1667, 31.9167)),
  District('Çamlıdere', LatLng(40.4833, 32.4833)),
  District('Çankaya', LatLng(39.9179, 32.8627)),
  District('Çubuk', LatLng(40.2389, 33.0331)),
  District('Elmadağ', LatLng(39.9200, 33.2300)),
  District('Etimesgut', LatLng(39.9500, 32.6667)),
  District('Evren', LatLng(39.0333, 33.8000)),
  District('Gölbaşı', LatLng(39.7900, 32.8100)),
  District('Güdül', LatLng(40.2167, 32.2500)),
  District('Haymana', LatLng(39.4333, 32.4967)),
  District('Kahramankazan', LatLng(40.2000, 32.6833)),
  District('Kalecik', LatLng(40.1000, 33.4083)),
  District('Keçiören', LatLng(39.9833, 32.8667)),
  District('Kızılcahamam', LatLng(40.4700, 32.6500)),
  District('Mamak', LatLng(39.9333, 32.9167)),
  District('Nallıhan', LatLng(40.1833, 31.3500)),
  District('Polatlı', LatLng(39.5833, 32.1500)),
  District('Pursaklar', LatLng(40.0333, 32.9000)),
  District('Sincan', LatLng(39.9667, 32.5833)),
  District('Şereflikoçhisar', LatLng(38.9333, 33.5333)),
  District('Yenimahalle', LatLng(39.9667, 32.7667)),
];
