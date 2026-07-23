import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/assembly_area.dart';

/// Seçili toplanma alanının bilgi kartı (ad, kapasite, tür, ilçe).
class AreaDetailCard extends StatelessWidget {
  const AreaDetailCard({super.key, required this.area, required this.onClose});

  final AssemblyArea area;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
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
                  tooltip: context.l10n.close,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: [
                _info(Icons.groups, context.l10n.capacity(area.capacity)),
                if (area.type.isNotEmpty)
                  _info(Icons.category_outlined, area.type),
                if (area.district.isNotEmpty)
                  _info(Icons.location_city_outlined, area.district),
              ],
            ),
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
}
