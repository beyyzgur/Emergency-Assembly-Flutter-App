import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../data/check_in_controller.dart';
import '../domain/check_in_state.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInState = ref.watch(checkInControllerProvider);
    final controller = ref.read(checkInControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Durum Bildirimi'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        surfaceTintColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const _Header(),
          const SizedBox(height: 24),
          _StatusCard(state: checkInState),
          const SizedBox(height: 20),
          if (checkInState.hasActiveSession)
            _ActiveActions(state: checkInState, controller: controller)
          else
            _StartActions(state: checkInState, controller: controller),
          const SizedBox(height: 24),
          const _ForegroundInfo(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yol durumunu güvenle paylaş',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Check-in başlattığında uygulama açıkken her 10 dakikada bir durumunu sorar.',
          style: TextStyle(color: Color(0xFF65738A), height: 1.45),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state});

  final CheckInState state;

  @override
  Widget build(BuildContext context) {
    final presentation = _presentationFor(state);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14243553),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: presentation.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(presentation.icon, color: presentation.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      presentation.title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      presentation.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF65738A),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (state.nextCheckAt != null) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sonraki kontrol: ${_formatTime(state.nextCheckAt!)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (state.hasActiveSession ||
              state.status == CheckInStatus.attentionRequired) ...[
            const SizedBox(height: 18),
            const Text(
              'Yanıtsız kontroller',
              style: TextStyle(
                color: Color(0xFF65738A),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                maxUnansweredCheckIns,
                (index) => Expanded(
                  child: Container(
                    height: 8,
                    margin: EdgeInsets.only(
                      right: index == maxUnansweredCheckIns - 1 ? 0 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: index < state.unansweredCount
                          ? AppColors.far
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _StatusPresentation _presentationFor(CheckInState state) {
    switch (state.status) {
      case CheckInStatus.active:
        return const _StatusPresentation(
          title: 'Check-in aktif',
          subtitle: 'Yol durumun için bir sonraki kontrol bekleniyor.',
          icon: Icons.directions_walk_rounded,
          color: AppColors.accent,
        );
      case CheckInStatus.awaitingResponse:
        return const _StatusPresentation(
          title: 'Durum yanıtın bekleniyor',
          subtitle: 'Yoldayım veya vardım bilgisini paylaş.',
          icon: Icons.notifications_active_outlined,
          color: Color(0xFFB26A00),
        );
      case CheckInStatus.paused:
        return const _StatusPresentation(
          title: 'Check-in bekletildi',
          subtitle: 'Uygulamaya geri döndüğünde 10 dakika yeniden sayılır.',
          icon: Icons.pause_circle_outline_rounded,
          color: Color(0xFF65738A),
        );
      case CheckInStatus.stopped:
        final arrived = state.stopReason == CheckInStopReason.arrived;
        return _StatusPresentation(
          title: arrived ? 'Vardığın kaydedildi' : 'Check-in durduruldu',
          subtitle: arrived
              ? 'Güvenli şekilde vardığını bildirdin.'
              : 'İstediğinde yeni bir check-in başlatabilirsin.',
          icon: arrived ? Icons.verified_rounded : Icons.stop_circle_outlined,
          color: arrived ? AppColors.accent : const Color(0xFF65738A),
        );
      case CheckInStatus.attentionRequired:
        return const _StatusPresentation(
          title: '3 kontrol yanıtsız kaldı',
          subtitle:
              'Check-in güvenlik için durduruldu. Yeni bir oturum başlatabilirsin.',
          icon: Icons.warning_amber_rounded,
          color: AppColors.far,
        );
      case CheckInStatus.idle:
        return const _StatusPresentation(
          title: 'Check-in henüz başlamadı',
          subtitle: 'Yola çıktığında durum kontrolünü başlatabilirsin.',
          icon: Icons.shield_outlined,
          color: AppColors.primary,
        );
    }
  }
}

class _ActiveActions extends StatelessWidget {
  const _ActiveActions({required this.state, required this.controller});

  final CheckInState state;
  final CheckInController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: controller.answerOnTheWay,
            icon: const Icon(Icons.directions_walk_rounded),
            label: const Text('Yoldayım'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: controller.markArrived,
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Vardım'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: controller.stop,
          icon: const Icon(Icons.stop_circle_outlined),
          label: const Text('Check-in’i durdur'),
          style: TextButton.styleFrom(foregroundColor: AppColors.far),
        ),
      ],
    );
  }
}

class _StartActions extends StatelessWidget {
  const _StartActions({required this.state, required this.controller});

  final CheckInState state;
  final CheckInController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: controller.start,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('10 dakikalık check-in başlat'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _ForegroundInfo extends StatelessWidget {
  const _ForegroundInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Bu sürüm yalnızca uygulama açıkken çalışır. Uygulama arka plana geçtiğinde sayaç bekletilir.',
              style: TextStyle(color: AppColors.primary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPresentation {
  const _StatusPresentation({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
