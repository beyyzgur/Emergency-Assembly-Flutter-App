import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/map_layers.dart';
import '../../../../core/theme/app_colors.dart';
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
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.bottomLeft,
          child: _open
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: kMapLayers.map((layer) {
                    final isSelected = layer.type == selected.type;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FloatingActionButton.extended(
                        heroTag: 'layer_${layer.type}',
                        elevation: 2,
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
                        label: Text(layer.label),
                      ),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
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
}
