class ClusterModel {
  final String id;
  final double centroidLatitude;
  final double centroidLongitude;
  final int pointCount;

  ClusterModel({
    required this.id,
    required this.centroidLatitude,
    required this.centroidLongitude,
    required this.pointCount,
  });
}
