import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/assembly_area.dart';
import '../providers/nearest_areas_provider.dart';

class NearestAreasSheet extends ConsumerWidget {
  const NearestAreasSheet({super.key, required this.onSelect});

  final void Function(AssemblyArea area) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearest = ref.watch(nearestAreasProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              context.l10n.nearestAreas,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: nearest.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.l10n.noNearbyAreas,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: nearest.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final n = nearest[i];
                      final walkMin = (n.meters / 80)
                          .round(); // ~80 m/dk yürüme
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(n.area.name),
                        subtitle: Text(
                          _distanceText(
                            context,
                            n.meters.round(),
                            walkMin,
                            n.area.district,
                          ),
                        ),
                        onTap: () => onSelect(n.area),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _distanceText(
    BuildContext context,
    int meters,
    int minutes,
    String district,
  ) {
    final distance = context.l10n.walkingDistance(meters, minutes);
    return district.isEmpty ? distance : '$distance · $district';
  }
}
