import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../auth/data/auth_service.dart';
import '../../../core/config/map_layers.dart';
import '../../../core/config/districts.dart';
import 'map_layer_provider.dart';
import 'location_providers.dart';
import '../data/user_location_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  static final LatLng _ankara = LatLng(39.9334, 32.8597);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _animatedMove(LatLng dest, double destZoom) {
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

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLayer = ref.watch(mapLayerProvider);
    final location = ref.watch(effectiveLocationProvider);
    final accuracy = ref.watch(locationAccuracyProvider);
    final isLocating = ref.watch(userLocationProvider).isLoading;

    ref.listen<LatLng?>(effectiveLocationProvider, (previous, next) {
      if (next != null) _animatedMove(next, 14);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Genel Harita'),
        actions: [
          PopupMenuButton<MapLayer>(
            icon: const Icon(Icons.layers),
            onSelected: (layer) =>
                ref.read(mapLayerProvider.notifier).state = layer,
            itemBuilder: (context) => kMapLayers
                .map(
                  (l) => PopupMenuItem(
                    value: l,
                    child: Row(
                      children: [
                        Icon(l.icon, size: 20),
                        const SizedBox(width: 8),
                        Text(l.label),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _ankara,
              initialZoom: 13,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: selectedLayer.url,
                userAgentPackageName: 'com.example.emergency_assembly_app',
              ),
              if (location != null && accuracy != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: location,
                      radius: accuracy,
                      useRadiusInMeter: true,
                      color: Colors.blue.withValues(alpha: 0.15),
                      borderColor: Colors.blue.withValues(alpha: 0.4),
                      borderStrokeWidth: 1,
                    ),
                  ],
                ),
              if (location != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (location == null && !isLocating)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.location_off),
                  title: const Text('Konum alınamadı'),
                  subtitle: const Text('Bulunduğunuz ilçeyi seçin'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showDistrictPicker,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDistrictPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _DistrictPickerSheet(),
    );
  }
}

class _DistrictPickerSheet extends ConsumerStatefulWidget {
  const _DistrictPickerSheet();

  @override
  ConsumerState<_DistrictPickerSheet> createState() =>
      _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends ConsumerState<_DistrictPickerSheet> {
  String _query = '';

  String _normalize(String s) {
    const tr = {
      'ı': 'i',
      'İ': 'i',
      'ş': 's',
      'Ş': 's',
      'ğ': 'g',
      'Ğ': 'g',
      'ü': 'u',
      'Ü': 'u',
      'ö': 'o',
      'Ö': 'o',
      'ç': 'c',
      'Ç': 'c',
      'â': 'a',
      'Â': 'a',
    };
    var out = s;
    tr.forEach((k, v) => out = out.replaceAll(k, v));
    return out.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final q = _normalize(_query);
    final filtered = kAnkaraDistricts
        .where((d) => _normalize(d.name).contains(q))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'İlçe ara...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('İlçe bulunamadı'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final d = filtered[i];
                        return ListTile(
                          title: Text(d.name),
                          onTap: () {
                            ref.read(manualLocationProvider.notifier).state =
                                d.center;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
