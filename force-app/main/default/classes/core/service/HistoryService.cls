public class HistoryService {
  private Map<ApexTank, TankHistory> history;

  public HistoryService() {
    history = new Map<ApexTank, TankHistory>();
  }
  public void recordMoveAttempt(
    final Integer roundNumber,
    final ApexTank tank,
    final MoveDirectionEnum direction
  ) {
    ensureRoundHistoryFor(tank, roundNumber).withDirection(direction);
  }

  public void recordAttack(
    final Integer roundNumber,
    final ApexTank tank,
    final Point pointToAttack
  ) {
    ensureRoundHistoryFor(tank, roundNumber).withAttacked(pointToAttack);
  }

  public void updateMoveStatus(
    final Integer roundNumber,
    final ApexTank tank,
    final Boolean moved
  ) {
    ensureRoundHistoryFor(tank, roundNumber).withMoveStatus(moved);
  }

  public void updateAttackStatus(
    final Integer roundNumber,
    final ApexTank tank,
    final Boolean hit
  ) {
    ensureRoundHistoryFor(tank, roundNumber).withAttackStatus(hit);
  }

  public String getHistory(final ApexTank tank) {
    return JSON.serialize(history.get(tank));
  }

  private RoundHistory ensureRoundHistoryFor(
    final ApexTank tank,
    final Integer roundNumber
  ) {
    final TankHistory tankHistory = ensureHistoryRecord(tank);
    return tankHistory.ensureRoundHistory(roundNumber);
  }
  private TankHistory ensureHistoryRecord(final ApexTank tank) {
    if (!history.containsKey(tank)) {
      history.put(tank, new TankHistory());
    }
    return history.get(tank);
  }
}
