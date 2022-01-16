public class BaksaleTank extends ApexTankBase {
  private final static List<MoveDirectionEnum> allDirections = new List<MoveDirectionEnum>{
    MoveDirectionEnum.DOWN,
    MoveDirectionEnum.UP,
    MoveDirectionEnum.RIGHT,
    MoveDirectionEnum.LEFT,
    MoveDirectionEnum.NOMOVE
  };
  private ApexTank competitor;
  private Point competitorLastLocation;
  private Point myLastLocation;
  private MoveDirectionEnum myDirection = MoveDirectionEnum.UP;

  protected override MoveDirectionEnum nextMoveDirection() {
    if (!hasMoved()) {
      switchDirectionClockWise();
    }
    return myDirection;
  }

  private Boolean hasMoved() {
    return fieldRadar.coordinateFor(this).equals(myLastLocation);
  }

  private void switchDirectionClockWise() {
    if (myDirection == MoveDirectionEnum.RIGHT) {
      myDirection = MoveDirectionEnum.DOWN;
    } else if (myDirection == MoveDirectionEnum.DOWN) {
      myDirection = MoveDirectionEnum.LEFT;
    } else if (myDirection == MoveDirectionEnum.LEFT) {
      myDirection = MoveDirectionEnum.UP;
    } else if (myDirection == MoveDirectionEnum.UP) {
      myDirection = MoveDirectionEnum.RIGHT;
    }
  }

  @TestVisible
  protected override Point pointToAttack() {
    ensureCompetitor();
    final Point currentLocation = fieldRadar.coordinateFor(competitor);
    final MoveDirectionEnum predictedMove = predictNextMove(currentLocation);
    return currentLocation.add(predictedMove);
  }

  private MoveDirectionEnum predictNextMove(final Point currentLocation) {
    MoveDirectionEnum predictedMove = null;
    if (null == competitorLastLocation) {
      predictedMove = MoveDirectionEnum.NOMOVE;
    } else {
      for (MoveDirectionEnum prediction : allDirections) {
        if (competitorLastLocation.add(prediction).equals(currentLocation)) {
          predictedMove = prediction;
          break;
        }
      }
    }
    competitorLastLocation = currentLocation;
    return predictedMove;
  }

  @TestVisible
  private void spyOn(final ApexTank competitor) {
    this.competitor = competitor;
  }

  private void ensureCompetitor() {
    if (null != competitor && null == fieldRadar.coordinateFor(competitor)) {
      competitor = null;
      competitorLastLocation = null;
    }
    if (null == competitor) {
      final List<Point> coordinatesWithTanks = fieldRadar.getCoordinatesWithTanks();
      for (Point cooridnateWithTank : coordinatesWithTanks) {
        final ApexTank candidate = fieldRadar.tankAt(cooridnateWithTank);
        if (!this.equals(candidate)) {
          competitor = candidate;
          break;
        }
      }
    }
  }
}
