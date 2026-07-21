import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Bir cluster'ı temsil eden rozet: lacivert daire + içinde nokta sayısı.
/// Belirirken bir kez yumuşakça büyür/görünür (tek seferlik → sürekli çalışmaz).
class ClusterBadge extends StatelessWidget {
  const ClusterBadge({super.key, required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double size = count >= 20
        ? 52
        : count >= 10
        ? 46
        : 40;

    // Belirirken bir kez 0→1 oynar, sonra durur (her karede değil)
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.6 + 0.4 * t, child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
