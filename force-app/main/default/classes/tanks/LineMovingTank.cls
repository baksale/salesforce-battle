public abstract class LineMovingTank extends TowerTank {
  private MoveDirectionEnum moveDirection = getDefaultDirection();

  protected abstract MoveDirectionEnum getDefaultDirection();
  protected abstract MoveDirectionEnum getOppositeDirection();

  @TestVisible
  protected override MoveDirectionEnum nextMoveDirection() {
    final Point currentLocation = fieldRadar.coordinateFor(this);
    if (!fieldRadar.pathExists(currentLocation, moveDirection)) {
      switchDirection();
    }
    return moveDirection;
  }

  private void switchDirection() {
    if (getDefaultDirection() == moveDirection) {
      moveDirection = getOppositeDirection();
    } else {
      moveDirection = getDefaultDirection();
    }
  }
}
