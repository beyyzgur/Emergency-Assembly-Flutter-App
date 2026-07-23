import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/map_layers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../map_layer_provider.dart';

class LayerSwitcher extends ConsumerStatefulWidget {
  const LayerSwitcher({super.key});

  @override
  ConsumerState<LayerSwitcher> createState() => _LayerSwitcherState();
}

class _LayerSwitcherState extends ConsumerState<LayerSwitcher> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(mapLayerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            alignment: Alignment.bottomCenter,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: _open
              ? Column(
                  key: const ValueKey('layers-open'),
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: kMapLayers.map((layer) {
                    final isSelected = layer.type == selected.type;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FloatingActionButton.extended(
                        heroTag: 'layer_${layer.type}',
                        elevation: 2,
                        extendedPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : Colors.white,
                        foregroundColor: isSelected
                            ? Colors.white
                            : AppColors.primary,
                        onPressed: () {
                          ref.read(mapLayerProvider.notifier).state = layer;
                          setState(() => _open = false);
                        },
                        icon: Icon(layer.icon),
                        label: SizedBox(
                          width: 58,
                          child: Text(_label(context, layer)),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(key: ValueKey('layers-closed')),
        ),
        // Ana buton
        FloatingActionButton(
          heroTag: 'layer_main',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onPressed: () => setState(() => _open = !_open),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _open ? Icons.close : Icons.layers,
              key: ValueKey(_open),
            ),
          ),
        ),
      ],
    );
  }

  String _label(BuildContext context, MapLayer layer) {
    return switch (layer.type) {
      MapLayerType.roadmap => context.l10n.mapLayerRoad,
      MapLayerType.satellite => context.l10n.mapLayerSatellite,
      MapLayerType.hybrid => context.l10n.mapLayerHybrid,
      MapLayerType.osm => context.l10n.mapLayerOpenStreetMap,
    };
  }
}
