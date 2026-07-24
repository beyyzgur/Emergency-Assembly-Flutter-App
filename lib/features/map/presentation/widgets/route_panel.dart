import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/route_mode.dart';
import '../../utils/route_format.dart';
import '../providers/route_provider.dart';
import '../providers/route_flow_provider.dart';

class RoutePanel extends ConsumerWidget {
  const RoutePanel({
    super.key,
    required this.from,
    required this.to,
    required this.canNavigate,
    required this.onStart,
    required this.onStop,
    required this.onClose,
  });

  final LatLng from;
  final LatLng to;
  final bool canNavigate;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(routeModeProvider);
    final navigating = ref.watch(routePhaseProvider) == RoutePhase.navigating;
    final routeAsync = ref.watch(routeProvider((from, to)));

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),

                routeAsync.when(
                  data: (r) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _stat(Icons.straighten, formatDistance(r.distanceMeters)),
                      const SizedBox(width: 22),
                      _stat(Icons.schedule, formatDuration(r.durationSeconds)),
                    ],
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text('Rota hesaplanıyor...'),
                      ],
                    ),
                  ),
                  error: (_, _) => const Text(
                    'Rota alınamadı, düz çizgi gösteriliyor.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _modeChip(
                          ref,
                          RouteMode.walking,
                          mode,
                          Icons.directions_walk,
                          enabled: !navigating,
                        ),
                      ),
                      Expanded(
                        child: _modeChip(
                          ref,
                          RouteMode.driving,
                          mode,
                          Icons.directions_car,
                          enabled: !navigating,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                if (navigating)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onStop,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.far,
                      ),
                      icon: const Icon(Icons.stop),
                      label: const Text('Durdur'),
                    ),
                  )
                else if (canNavigate)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onStart,
                      icon: const Icon(Icons.navigation),
                      label: const Text('Başlat'),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Rota önizleme — canlı takip için başlangıç GPS olmalı',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            Positioned(
              top: -6,
              right: -8,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                visualDensity: VisualDensity.compact,
                tooltip: 'Rotayı kapat',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 5),
      Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ],
  );

  Widget _modeChip(
    WidgetRef ref,
    RouteMode chip,
    RouteMode current,
    IconData icon, {
    required bool enabled,
  }) {
    final selected = chip == current;
    final bg = selected
        ? (enabled ? AppColors.primary : Colors.grey.shade400)
        : Colors.transparent;
    final fg = selected
        ? Colors.white
        : (enabled ? AppColors.primary : Colors.grey.shade400);
    return GestureDetector(
      onTap: enabled
          ? () => ref.read(routeModeProvider.notifier).state = chip
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Text(
              chip.label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
