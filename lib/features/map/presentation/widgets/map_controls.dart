import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;

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
      ],
    );
  }

  Widget _button(String tag, IconData icon, VoidCallback onPressed) {
    return FloatingActionButton.small(
      heroTag: tag,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      elevation: 2,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
