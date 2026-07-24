import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

class RouteHeader extends StatelessWidget {
  const RouteHeader({
    super.key,
    required this.fromLabel,
    required this.toLabel,
    required this.onEditFrom,
    required this.onEditTo,
    required this.onSwap,
    required this.canSwap,
  });

  final String fromLabel;
  final String toLabel;
  final VoidCallback onEditFrom;
  final VoidCallback onEditTo;
  final VoidCallback onSwap;
  final bool canSwap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _row(
                    icon: Icons.my_location,
                    iconColor: AppColors.userLocation,
                    label: context.l10n.routeOrigin,
                    value: fromLabel,
                    onTap: onEditFrom,
                  ),
                  Divider(height: 1, indent: 36, color: Colors.grey.shade200),
                  _row(
                    icon: Icons.place,
                    iconColor: AppColors.far,
                    label: context.l10n.routeDestination,
                    value: toLabel,
                    onTap: onEditTo,
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.grey.shade100,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: canSwap ? onSwap : null,
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Icon(
                    Icons.swap_vert,
                    color: canSwap ? AppColors.primary : Colors.grey.shade400,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, size: 15, color: Colors.grey.shade400),
            const SizedBox(width: 2),
          ],
        ),
      ),
    );
  }
}
