import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
    this.onReturnToPoint,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;
  final VoidCallback? onReturnToPoint;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _button('zoomIn', Icons.add, onZoomIn),
        const SizedBox(height: 8),
        _button('zoomOut', Icons.remove, onZoomOut),
        const SizedBox(height: 8),
        _button('myLocation', Icons.my_location, onMyLocation),
        if (onReturnToPoint != null) ...[
          const SizedBox(height: 8),
          _button(
            'returnToPoint',
            Icons.pin_drop,
            onReturnToPoint!,
            foreground: AppColors.accent,
          ),
        ],
      ],
    );
  }

  Widget _button(
    String tag,
    IconData icon,
    VoidCallback onPressed, {
    Color? foreground,
  }) {
    return FloatingActionButton.small(
      heroTag: tag,
      backgroundColor: Colors.white,
      foregroundColor: foreground ?? AppColors.primary,
      elevation: 2,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
