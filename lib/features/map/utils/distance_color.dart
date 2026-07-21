import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

Color colorForDistance(double? meters) {
  if (meters == null) return AppColors.accent;
  if (meters <= 1000) return AppColors.near; // ≤ 1 km
  if (meters <= 3000) return AppColors.mid; // 1–3 km
  return AppColors.far; // > 3 km
}
