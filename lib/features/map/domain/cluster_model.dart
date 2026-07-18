import 'package:latlong2/latlong.dart';

class ClusterModel {
  final LatLng center;
  final int count;
  final List<LatLng> points;

  ClusterModel({
    required this.center,
    required this.count,
    required this.points,
  });
}
