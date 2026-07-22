import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../data/check_in_controller.dart';
import '../domain/check_in_state.dart';

class CheckInForegroundListener extends ConsumerStatefulWidget {
  const CheckInForegroundListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CheckInForegroundListener> createState() =>
      _CheckInForegroundListenerState();
}

class _CheckInForegroundListenerState
    extends ConsumerState<CheckInForegroundListener>
    with WidgetsBindingObserver {
  bool _promptDialogVisible = false;
  bool _attentionDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    final controller = ref.read(checkInControllerProvider.notifier);
    switch (appLifecycleState) {
      case AppLifecycleState.resumed:
        controller.resumeInForeground();
        return;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        controller.pauseForBackground();
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CheckInState>(checkInControllerProvider, (previous, next) {
      final hasNewPrompt =
          next.status == CheckInStatus.awaitingResponse &&
          next.promptVersion > (previous?.promptVersion ?? 0);

      if (hasNewPrompt) {
        _showPrompt(next);
      }

      final requiresAttention =
          next.status == CheckInStatus.attentionRequired &&
          previous?.status != CheckInStatus.attentionRequired;
      if (requiresAttention) {
        _showAttention();
      }
    });

    return widget.child;
  }

  void _showPrompt(CheckInState state) {
    if (_promptDialogVisible || !mounted) {
      return;
    }

    _promptDialogVisible = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            icon: const Icon(
              Icons.health_and_safety_outlined,
              color: AppColors.primary,
              size: 34,
            ),
            title: const Text('Durum kontrolü'),
            content: Text(
              state.unansweredCount == 0
                  ? 'Yol durumun nedir? Güvenliğin için kısa bir bilgi paylaş.'
                  : '${state.unansweredCount}. yanıtsız kontrol kaydedildi. Lütfen durumunu paylaş.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(checkInControllerProvider.notifier).stop();
                  Navigator.of(dialogContext).pop();
                },
                child: const Text(
                  'Durdur',
                  style: TextStyle(color: AppColors.far),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  ref.read(checkInControllerProvider.notifier).markArrived();
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Vardım'),
              ),
              FilledButton(
                onPressed: () {
                  ref.read(checkInControllerProvider.notifier).answerOnTheWay();
                  Navigator.of(dialogContext).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Yoldayım'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() => _promptDialogVisible = false);
  }

  Future<void> _showAttention() async {
    if (!mounted || _attentionDialogVisible) {
      return;
    }

    if (_promptDialogVisible) {
      await Navigator.of(context, rootNavigator: true).maybePop();
      _promptDialogVisible = false;
    }

    if (!mounted) {
      return;
    }

    _attentionDialogVisible = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.far,
          size: 38,
        ),
        title: const Text('Check-in durduruldu'),
        content: const Text(
          '3 durum kontrolü yanıtsız kaldığı için check-in sonlandırıldı. Yeni bir check-in başlatabilirsin.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tamam'),
          ),
        ],
      ),
    ).whenComplete(() => _attentionDialogVisible = false);
  }
}
