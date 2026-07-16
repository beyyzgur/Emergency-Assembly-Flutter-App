import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

class GeoCalculations {
  static double calculateDistanceInMeters(GeoPoint point1, GeoPoint point2) {
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    const double earthRadius = 6371000;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  static bool isPointInPolygon(GeoPoint userPoint, List<GeoPoint> polygon) {
    if (polygon.isEmpty) {
      return false;
    }

    int intersectCount = 0;
    double userLat = userPoint.latitude;
    double userLng = userPoint.longitude;

    for (int i = 0; i < polygon.length; i++) {
      int j = (i + 1) % polygon.length;

      double vertex1Lat = polygon[i].latitude;
      double vertex1Lng = polygon[i].longitude;
      double vertex2Lat = polygon[j].latitude;
      double vertex2Lng = polygon[j].longitude;

      if (vertex1Lng > userLng) {
        if (vertex2Lng <= userLng) {
          double intersectLat =
              (userLng - vertex1Lng) *
                  (vertex2Lat - vertex1Lat) /
                  (vertex2Lng - vertex1Lng) +
              vertex1Lat;
          if (userLat < intersectLat) {
            intersectCount = intersectCount + 1;
          }
        }
      } else {
        if (vertex2Lng > userLng) {
          double intersectLat =
              (userLng - vertex1Lng) *
                  (vertex2Lat - vertex1Lat) /
                  (vertex2Lng - vertex1Lng) +
              vertex1Lat;
          if (userLat < intersectLat) {
            intersectCount = intersectCount + 1;
          }
        }
      }
    }

    if (intersectCount % 2 == 1) {
      return true;
    } else {
      return false;
    }
  }
}
