import '../../../l10n/l10n.dart';

const double kWalkingSpeedMps = 1.4;
const double kDrivingSpeedMps = 8.3;
const double kRoadDetourFactor = 1.3;

String formatDistance(double meters) {
  if (meters < 1000) return '${meters.round()} m';
  return '${(meters / 1000).toStringAsFixed(1)} km';
}

String formatDuration(double seconds, AppLocalizations l10n) {
  final min = (seconds / 60).round();
  final mn = l10n.unitMinuteShort;
  final hr = l10n.unitHourShort;
  if (min < 1) return '<1 $mn';
  if (min < 60) return '$min $mn';
  final h = min ~/ 60;
  final m = min % 60;
  return m == 0 ? '$h $hr' : '$h $hr $m $mn';
}

double estimateSeconds(double straightLineMeters, double speedMps) =>
    (straightLineMeters * kRoadDetourFactor) / speedMps;
