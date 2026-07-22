import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/districts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/turkish.dart';
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

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            // Manuel seçim aktifken ilk satır: GPS'e dön.
            if (hasManual) ...[
              ListTile(
                leading: const Icon(Icons.gps_fixed, color: AppColors.accent),
                title: const Text('GPS Konumuna dön'),
                subtitle: const Text('Manuel seçimi kaldır'),
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
                            ref.read(manualDistrictProvider.notifier).state = d;
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
