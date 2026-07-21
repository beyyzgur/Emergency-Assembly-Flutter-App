import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../../core/theme/app_colors.dart';

/// Harita dönükken beliren, dokununca haritayı animasyonlu kuzeye döndüren pusula.
class MapCompass extends StatefulWidget {
  const MapCompass({super.key, required this.controller});

  final MapController controller;

  @override
  State<MapCompass> createState() => _MapCompassState();
}

class _MapCompassState extends State<MapCompass> with TickerProviderStateMixin {
  final ValueNotifier<double> _rotation = ValueNotifier<double>(0);
  StreamSubscription<MapEvent>? _sub;
  AnimationController? _animController;

  @override
  void initState() {
    super.initState();
    _sub = widget.controller.mapEventStream.listen((_) {
      _rotation.value = widget.controller.camera.rotation;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _animController?.dispose();
    _rotation.dispose();
    super.dispose();
  }

  void _rotateToNorth() {
    _animController?.dispose();

    final start = _rotation.value;
    final norm = (start % 360 + 360) % 360;
    // En kısa yön: 180'den küçükse geri dön, değilse ileri tamamla
    final end = norm <= 180 ? start - norm : start + (360 - norm);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animController = controller;
    final tween = Tween<double>(begin: start, end: end);
    final anim = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(
      () => widget.controller.rotate(tween.evaluate(anim)),
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _rotation,
      builder: (context, rotation, _) {
        final norm = (rotation % 360 + 360) % 360;
        final isRotated = norm > 0.5 && norm < 359.5;
        return AnimatedScale(
          scale: isRotated ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: FloatingActionButton.small(
            heroTag: 'compass',
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: _rotateToNorth,
            child: Transform.rotate(
              angle: -rotation * math.pi / 180,
              child: const Icon(Icons.navigation),
            ),
          ),
        );
      },
    );
  }
}
