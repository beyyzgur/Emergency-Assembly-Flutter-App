import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/assembly_area.dart';
import '../../utils/route_format.dart';

class AreaDetailCard extends StatelessWidget {
  const AreaDetailCard({
    super.key,
    required this.area,
    required this.onClose,
    this.userLoc,
    this.onDirections,
  });

  final AssemblyArea area;
  final VoidCallback onClose;
  final LatLng? userLoc;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    final meters = userLoc == null
        ? null
        : const Distance().as(LengthUnit.Meter, userLoc!, area.center);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emergency_share,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    area.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Kapat',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: [
                _info(Icons.groups, '${area.capacity} kişi kapasiteli'),
                if (area.type.isNotEmpty)
                  _info(Icons.category_outlined, area.type),
                if (area.district.isNotEmpty)
                  _info(Icons.location_city_outlined, area.district),
              ],
            ),
            if (meters != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  _metric(Icons.straighten, formatDistance(meters)),
                  const SizedBox(width: 18),
                  _metric(
                    Icons.directions_walk,
                    '~${formatDuration(estimateSeconds(meters, kWalkingSpeedMps))}',
                  ),
                  const SizedBox(width: 18),
                  _metric(
                    Icons.directions_car,
                    '~${formatDuration(estimateSeconds(meters, kDrivingSpeedMps))}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onDirections,
                  icon: const Icon(Icons.directions),
                  label: const Text('Yol Tarifi'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _metric(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
