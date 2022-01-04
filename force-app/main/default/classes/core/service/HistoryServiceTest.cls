@isTest
public class HistoryServiceTest {
    private final static HistoryService historyService = new HistoryService();

    @isTest static void hasMoveAndAttackHistory() {
        final TestTank tank = testTank();

        final MoveDirectionEnum direction = MoveDirectionEnum.UP;
        final Boolean successfullMove = true;
        final Point attack = new Point(7, 4);
        final Boolean successfullAttack = false;

        historyService.recordMoveAttempt(0, tank, direction);
        historyService.updateMoveStatus(0, tank, successfullMove);
        historyService.recordAttack(0, tank, attack);
        historyService.updateAttackStatus(0, tank, successfullAttack);

        final String tankHistoryString = historyService.getHistory(tank);
        final TankHistory tankHistory = (TankHistory) JSON.deserialize(tankHistoryString, TankHistory.class);
        final RoundHistory firstRound = tankHistory.getRoundRecord(0);

        System.assertEquals(direction, firstRound.direction);
        System.assertEquals(successfullMove, firstRound.successfullMove);
        System.assertEquals(attack, firstRound.attack);
        System.assertEquals(successfullAttack, firstRound.successfullAttack);
    }

    private static TestTank testTank() {
        return TestTank.testTank();
    }
}
