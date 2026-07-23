import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/districts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/turkish.dart';
import '../../../../l10n/l10n.dart';
import '../location_providers.dart';

void showDistrictPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const DistrictPickerSheet(),
  );
}

class DistrictPickerSheet extends ConsumerStatefulWidget {
  const DistrictPickerSheet({super.key});

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
    final hasManual = ref.watch(manualDistrictProvider) != null;
    final screenH = MediaQuery.of(context).size.height;
    final kb = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      // Klavye açılınca içerik yukarı itilir.
      padding: EdgeInsets.only(bottom: kb),
      child: SizedBox(
        // Klavye kadar küçülsün ki toplam yükseklik ekranı doldurmasın.
        height: (screenH * 0.55 - kb).clamp(260.0, screenH * 0.55),
        child: GestureDetector(
          // Boşluğa dokununca klavyeyi kapat.
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // Manuel seçim aktifken ilk satır: GPS'e dön.
              if (hasManual) ...[
                ListTile(
                  leading: const Icon(Icons.gps_fixed, color: AppColors.accent),
                  title: Text(context.l10n.returnToGps),
                  subtitle: Text(context.l10n.clearManualSelection),
                  onTap: () {
                    ref.read(manualDistrictProvider.notifier).state = null;
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 1),
              ],
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
