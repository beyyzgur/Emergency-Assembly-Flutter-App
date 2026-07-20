import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import 'map_layer_provider.dart';
import 'location_providers.dart';
import '../utils/location_service.dart';
import 'widgets/layer_switcher.dart';
import 'widgets/district_picker.dart';
import 'widgets/map_compass.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  // Tek kamera animasyonu — yenisi başlarken öncekini durdururuz ki
  // (ör. Dev1'in canlı konum stream'i gelince) controller'lar yarışmasın.
  AnimationController? _moveController;

  static final LatLng _ankara = LatLng(39.9334, 32.8597);

  @override
  void dispose() {
    _moveController?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _animatedMove(LatLng dest, double destZoom) {
    _moveController?.dispose();

    final camera = _mapController.camera;
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
    _moveController = controller;
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLayer = ref.watch(mapLayerProvider);
    final location = ref.watch(effectiveLocationProvider);
    final accuracy = ref.watch(locationAccuracyProvider);
    final userAsync = ref.watch(userLocationProvider);
    final isLocating = userAsync.isLoading;
    final hasGps = userAsync.valueOrNull != null;
    final manualDistrict = ref.watch(manualDistrictProvider);

    // Elle ilçe seçiliyken pin'e ilçe adı etiketi eklenir.
    final usingManual = manualDistrict != null && !hasGps;

    ref.listen<LatLng?>(effectiveLocationProvider, (previous, next) {
      if (next != null) _animatedMove(next, 14);
    });

    // Konum hiç yoksa "ilçe seç" kartı (henüz marker olmadığı için altta).
    final Widget? topInfo =
        (location == null && !isLocating) ? _promptCard() : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Genel Harita')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _ankara,
              initialZoom: 13,
              interactionOptions: const InteractionOptions(
                // Aynı anda tek jest kazanır → pinch-zoom sırasında harita
                // dönmez/kaymaz, stabil kalır (Google Maps davranışı).
                enableMultiFingerGestureRace: true,
                // Dönüş için belirgin bir bükme gerekir; kaza eseri dönmeyi azaltır.
                rotationThreshold: 30.0,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: selectedLayer.url,
                userAgentPackageName: 'com.example.emergency_assembly_app',
              ),
              // Doğruluk çemberi — sadece GPS konumunda anlamlı
              if (location != null && accuracy != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: location,
                      radius: accuracy,
                      useRadiusInMeter: true,
                      color: AppColors.userLocation.withValues(alpha: 0.18),
                      borderColor:
                          AppColors.userLocation.withValues(alpha: 0.6),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              // Konum pini (+ elle seçimde ilçe adı etiketi)
              if (location != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 170,
                      height: 96,
                      // Pin ucu tam konuma otursun. flutter_map'te alignment,
                      // "point kutunun neresine denk gelir"i belirtir:
                      // topCenter → kutu yukarı çıkar, altındaki pin ucu noktada kalır.
                      alignment: Alignment.topCenter,
                      child: _locationMarker(
                        usingManual ? manualDistrict.name : null,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Pusula — kendi durumunu/animasyonunu yönetir (MapCompass)
          Positioned(
            top: 16,
            right: 16,
            child: MapCompass(controller: _mapController),
          ),
          // Alt-sol katman: üst bilgi (kart) + katman seçici tek Column'da.
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (topInfo != null) ...[topInfo, const SizedBox(height: 12)],
                const LayerSwitcher(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Konum hiç yokken: ilçe seçimine davet eden kart.
  Widget _promptCard() {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.location_off),
        title: const Text('Konum alınamadı'),
        subtitle: const Text('Bulunduğunuz ilçeyi seçin'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showDistrictPicker(context),
      ),
    );
  }

  /// Konum pini. [districtName] verilirse (elle seçim) pin'in üstünde
  /// dokunulabilir bir ilçe etiketi gösterilir; dokununca picker açılır.
  Widget _locationMarker(String? districtName) {
    final isManual = districtName != null;
    final pinColor = isManual ? AppColors.primary : AppColors.userLocation;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isManual) ...[
          Material(
            color: AppColors.primary,
            elevation: 3,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => showDistrictPicker(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      districtName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.expand_more,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
        ],
        Icon(Icons.location_on, color: pinColor, size: 42),
      ],
    );
  }
}
