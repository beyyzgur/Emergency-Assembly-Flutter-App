import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/check_in_state.dart';

const checkInInterval = Duration(minutes: 10);
const maxUnansweredCheckIns = 3;

final checkInControllerProvider =
    StateNotifierProvider<CheckInController, CheckInState>(
      (ref) => CheckInController(),
    );

/// Uygulama açıkken çalışan yerel check-in döngüsü.
///
/// Sunucu, FCM veya cihaz bildirimi kullanmaz. Uygulama arka plana geçtiğinde
/// sayaç durur ve kullanıcı geri döndüğünde yeniden 10 dakika saymaya başlar.
class CheckInController extends StateNotifier<CheckInState> {
  CheckInController({this.interval = checkInInterval})
    : super(const CheckInState.idle());

  final Duration interval;
  Timer? _timer;

  void start() {
    _beginNextInterval(unansweredCount: 0);
  }

  void answerOnTheWay() {
    if (!state.hasActiveSession) {
      return;
    }

    _beginNextInterval(unansweredCount: 0, lastResponseAt: DateTime.now());
  }

  void markArrived() {
    _finish(CheckInStopReason.arrived);
  }

  void stop() {
    _finish(CheckInStopReason.manuallyStopped);
  }

  void pauseForBackground() {
    if (!state.hasActiveSession) {
      return;
    }

    _timer?.cancel();
    _timer = null;
    state = state.copyWith(
      status: CheckInStatus.paused,
      clearNextCheckAt: true,
    );
  }

  void resumeInForeground() {
    if (state.status != CheckInStatus.paused) {
      return;
    }

    _beginNextInterval(unansweredCount: state.unansweredCount);
  }

  void _beginNextInterval({
    required int unansweredCount,
    DateTime? lastResponseAt,
  }) {
    _timer?.cancel();

    final nextCheckAt = DateTime.now().add(interval);
    state = CheckInState(
      status: CheckInStatus.active,
      unansweredCount: unansweredCount,
      nextCheckAt: nextCheckAt,
      lastResponseAt: lastResponseAt ?? state.lastResponseAt,
      promptVersion: state.promptVersion,
    );
    _timer = Timer(interval, _onIntervalCompleted);
  }

  void _onIntervalCompleted() {
    final nextUnansweredCount = state.status == CheckInStatus.awaitingResponse
        ? state.unansweredCount + 1
        : state.unansweredCount;

    if (nextUnansweredCount >= maxUnansweredCheckIns) {
      _timer?.cancel();
      _timer = null;
      state = CheckInState(
        status: CheckInStatus.attentionRequired,
        unansweredCount: nextUnansweredCount,
        lastResponseAt: state.lastResponseAt,
        promptVersion: state.promptVersion,
      );
      return;
    }

    final nextCheckAt = DateTime.now().add(interval);
    state = CheckInState(
      status: CheckInStatus.awaitingResponse,
      unansweredCount: nextUnansweredCount,
      nextCheckAt: nextCheckAt,
      lastResponseAt: state.lastResponseAt,
      promptVersion: state.promptVersion + 1,
    );
    _timer = Timer(interval, _onIntervalCompleted);
  }

  void _finish(CheckInStopReason reason) {
    _timer?.cancel();
    _timer = null;
    state = CheckInState(
      status: CheckInStatus.stopped,
      unansweredCount: state.unansweredCount,
      lastResponseAt: state.lastResponseAt,
      stopReason: reason,
      promptVersion: state.promptVersion,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
