const double kWalkingSpeedMps = 1.4;
const double kDrivingSpeedMps = 8.3;
const double kRoadDetourFactor = 1.3;

String formatDistance(double meters) {
  if (meters < 1000) return '${meters.round()} m';
  return '${(meters / 1000).toStringAsFixed(1)} km';
}

String formatDuration(double seconds) {
  final min = (seconds / 60).round();
  if (min < 1) return '<1 dk';
  if (min < 60) return '$min dk';
  final h = min ~/ 60;
  final m = min % 60;
  return m == 0 ? '$h sa' : '$h sa $m dk';
}

double estimateSeconds(double straightLineMeters, double speedMps) =>
    (straightLineMeters * kRoadDetourFactor) / speedMps;
