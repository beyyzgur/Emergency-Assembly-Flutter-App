import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_assembly_app/features/map/utils/geo_calculations.dart';

void main() {
  group('Harita Matematik (GeoCalculations) Testleri', () {
    test('1. Nokta Poligon İçinde mi Testi (Ray Casting)', () {
      final List<GeoPoint> testPolygon = [
        const GeoPoint(0, 0),
        const GeoPoint(10, 0),
        const GeoPoint(10, 10),
        const GeoPoint(0, 10),
      ];

      final insidePoint = const GeoPoint(5, 5);
      final isInside = GeoCalculations.isPointInPolygon(
        insidePoint,
        testPolygon,
      );
      expect(
        isInside,
        true,
        reason:
            'Hata: Nokta poligonun tam içindeydi ama algoritma false döndü!',
      );

      final outsidePoint = const GeoPoint(15, 15);
      final isOutside = GeoCalculations.isPointInPolygon(
        outsidePoint,
        testPolygon,
      );
      expect(
        isOutside,
        false,
        reason: 'Hata: Nokta poligonun dışındaydı ama algoritma true döndü!',
      );
    });

    test('2. Mesafe Ölçüm Testi (Haversine Formülü)', () {
      final point1 = const GeoPoint(0, 0);
      final point2 = const GeoPoint(0, 1);

      final distance = GeoCalculations.calculateDistanceInMeters(
        point1,
        point2,
      );

      expect(
        distance > 111000 && distance < 112000,
        true,
        reason:
            'Hata: Mesafe dünya standartlarına uygun hesaplanmadı. Çıkan sonuç: $distance metre',
      );
    });
  });
}
