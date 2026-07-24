import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

mixin MapCameraMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  final MapController mapController = MapController();

  AnimationController? moveController;
  double? zoomTarget;

  bool programmaticAnim = false;

  static const double minZoom = 2;
  static const double maxZoom = 19.5;

  void animatedMove(LatLng dest, double destZoom) {
    zoomTarget = null;
    moveController?.dispose();

    final camera = mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: dest.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: dest.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    moveController = controller;
    programmaticAnim = true;
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (identical(moveController, controller)) programmaticAnim = false;
      }
    });
    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });
    controller.forward();
  }

  void zoomBy(double delta) {
    final base = zoomTarget ?? mapController.camera.zoom;
    final target = (base + delta).clamp(minZoom, maxZoom);
    animatedMove(mapController.camera.center, target);
    zoomTarget = target;
  }

  void fitToPoints(List<LatLng> pts) {
    if (pts.isEmpty) return;
    moveController?.stop();
    mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(pts),
        padding: const EdgeInsets.fromLTRB(50, 90, 50, 240),
      ),
    );
  }

  @override
  void dispose() {
    moveController?.dispose();
    mapController.dispose();
    super.dispose();
  }
}
