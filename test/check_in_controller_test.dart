import 'package:emergency_assembly_app/features/checkin/data/check_in_controller.dart';
import 'package:emergency_assembly_app/features/checkin/domain/check_in_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckInController', () {
    testWidgets('10 dakikalık döngüde üç yanıtsız kontrolden sonra durur', (
      tester,
    ) async {
      final controller = CheckInController(
        interval: const Duration(minutes: 10),
      );

      controller.start();
      expect(controller.state.status, CheckInStatus.active);

      await tester.pump(const Duration(minutes: 10));
      expect(controller.state.status, CheckInStatus.awaitingResponse);
      expect(controller.state.unansweredCount, 0);

      await tester.pump(const Duration(minutes: 10));
      expect(controller.state.unansweredCount, 1);

      await tester.pump(const Duration(minutes: 10));
      expect(controller.state.unansweredCount, 2);

      await tester.pump(const Duration(minutes: 10));
      expect(controller.state.status, CheckInStatus.attentionRequired);
      expect(controller.state.unansweredCount, maxUnansweredCheckIns);

      controller.dispose();
    });

    testWidgets('Yoldayım yanıtı yanıtsız sayacını sıfırlar', (tester) async {
      final controller = CheckInController(
        interval: const Duration(minutes: 10),
      );

      controller.start();
      await tester.pump(const Duration(minutes: 20));
      expect(controller.state.unansweredCount, 1);

      controller.answerOnTheWay();
      expect(controller.state.status, CheckInStatus.active);
      expect(controller.state.unansweredCount, 0);

      controller.dispose();
    });

    testWidgets('Vardım yanıtı zamanlayıcıyı durdurur', (tester) async {
      final controller = CheckInController(
        interval: const Duration(minutes: 10),
      );

      controller.start();
      controller.markArrived();
      await tester.pump(const Duration(hours: 1));

      expect(controller.state.status, CheckInStatus.stopped);
      expect(controller.state.stopReason, CheckInStopReason.arrived);

      controller.dispose();
    });
  });
}
