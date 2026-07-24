import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/districts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/turkish.dart';
import '../../../../l10n/l10n.dart';
import '../location_providers.dart';

void showDistrictPicker(BuildContext context, {VoidCallback? onPickFromMap}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => DistrictPickerSheet(onPickFromMap: onPickFromMap),
  );
}

class DistrictPickerSheet extends ConsumerStatefulWidget {
  const DistrictPickerSheet({super.key, this.onPickFromMap});

  final VoidCallback? onPickFromMap;

  @override
  ConsumerState<DistrictPickerSheet> createState() =>
      _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends ConsumerState<DistrictPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = normalizeTr(_query);
    final filtered = kAnkaraDistricts
        .where((d) => normalizeTr(d.name).contains(q))
        .toList();
    final hasManual =
        ref.watch(manualDistrictProvider) != null ||
        ref.watch(manualPointProvider) != null;
    final screenH = MediaQuery.of(context).size.height;
    final kb = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: kb),
      child: SizedBox(
        height: (screenH * 0.55 - kb).clamp(260.0, screenH * 0.55),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              if (hasManual)
                ListTile(
                  leading: const Icon(Icons.gps_fixed, color: AppColors.accent),
                  title: Text(context.l10n.returnToGps),
                  subtitle: Text(context.l10n.clearManualSelection),
                  onTap: () {
                    ref.read(manualDistrictProvider.notifier).state = null;
                    ref.read(manualPointProvider.notifier).state = null;
                    Navigator.pop(context);
                  },
                ),
              if (widget.onPickFromMap != null)
                ListTile(
                  leading: const Icon(Icons.touch_app, color: AppColors.accent),
                  title: Text(context.l10n.pickOnMap),
                  subtitle: Text(context.l10n.tapMapForStart),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onPickFromMap!();
                  },
                ),
              if (hasManual || widget.onPickFromMap != null)
                const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: context.l10n.searchDistrict,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(child: Text(context.l10n.districtNotFound))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final d = filtered[i];
                          return ListTile(
                            title: Text(d.name),
                            onTap: () {
                              ref.read(manualPointProvider.notifier).state =
                                  null;
                              ref.read(manualDistrictProvider.notifier).state =
                                  d;
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
