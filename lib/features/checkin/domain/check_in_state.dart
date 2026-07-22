enum CheckInStatus {
  idle,
  active,
  awaitingResponse,
  paused,
  stopped,
  attentionRequired,
}

enum CheckInStopReason { arrived, manuallyStopped }

class CheckInState {
  const CheckInState({
    required this.status,
    this.unansweredCount = 0,
    this.nextCheckAt,
    this.lastResponseAt,
    this.stopReason,
    this.promptVersion = 0,
  });

  const CheckInState.idle() : this(status: CheckInStatus.idle);

  final CheckInStatus status;
  final int unansweredCount;
  final DateTime? nextCheckAt;
  final DateTime? lastResponseAt;
  final CheckInStopReason? stopReason;

  /// Her yeni foreground uyarısında artar. Arayüz bu değerle dialogu açar.
  final int promptVersion;

  bool get hasActiveSession =>
      status == CheckInStatus.active ||
      status == CheckInStatus.awaitingResponse ||
      status == CheckInStatus.paused;

  CheckInState copyWith({
    CheckInStatus? status,
    int? unansweredCount,
    DateTime? nextCheckAt,
    bool clearNextCheckAt = false,
    DateTime? lastResponseAt,
    CheckInStopReason? stopReason,
    bool clearStopReason = false,
    int? promptVersion,
  }) {
    return CheckInState(
      status: status ?? this.status,
      unansweredCount: unansweredCount ?? this.unansweredCount,
      nextCheckAt: clearNextCheckAt ? null : (nextCheckAt ?? this.nextCheckAt),
      lastResponseAt: lastResponseAt ?? this.lastResponseAt,
      stopReason: clearStopReason ? null : (stopReason ?? this.stopReason),
      promptVersion: promptVersion ?? this.promptVersion,
    );
  }
}
