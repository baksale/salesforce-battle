@isTest
public class BaksaleTankTest {
  private final static Point currentLocation = new Point(3, 7);
  private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
  private final static Radar fieldRadar = (Radar) mocks.mock(Radar.class);

  @isTest
  static void predictsOpponentMoveDirection() {
    final List<MoveDirectionEnum> allDirections = new List<MoveDirectionEnum>{
      MoveDirectionEnum.DOWN,
      MoveDirectionEnum.LEFT,
      MoveDirectionEnum.UP,
      MoveDirectionEnum.RIGHT,
      MoveDirectionEnum.NOMOVE
    };
    final ApexTank competitor = testTank();
    final Point lastRoundPoint = new Point(0, 0);

    for (MoveDirectionEnum competitorDirection : allDirections) {
      final BaksaleTank tank = new BaksaleTank();
      tank.withRadar(fieldRadar);
      tank.spyOn(competitor);
      final Point currentRoundPoint = lastRoundPoint.add(competitorDirection);

      mocks.startStubbing();
      mocks.when(fieldRadar.tankAt(lastRoundPoint)).thenReturn(competitor);
      mocks.when(fieldRadar.coordinateFor(competitor))
        .thenReturn(lastRoundPoint)
        .thenReturn(lastRoundPoint)
        .thenReturn(currentRoundPoint)
        .thenReturn(currentRoundPoint);
      mocks.stopStubbing();

      final Point firstPoint = tank.pointToAttack();
      final Point correctedPoint = tank.pointToAttack();

      System.assertEquals(lastRoundPoint, firstPoint);
      System.assertEquals(
        currentRoundPoint.add(competitorDirection),
        correctedPoint,
        'Failed to detect move: ' + competitorDirection
      );
    }
  }

  @isTest
  static void spiesOnFirstCompetitor() {
    final ApexTank competitor = testTank();
    final BaksaleTank tank = new BaksaleTank();
    tank.withRadar(fieldRadar);

    final Point lastRoundPoint = new Point(0, 0);

    mocks.startStubbing();
    mocks.when(fieldRadar.getCoordinatesWithTanks()).thenReturn(new List<Point>{ lastRoundPoint });
    mocks.when(fieldRadar.tankAt(lastRoundPoint)).thenReturn(competitor);
    mocks.when(fieldRadar.coordinateFor(competitor)).thenReturn(lastRoundPoint);
    mocks.stopStubbing();

    System.assertEquals(lastRoundPoint, tank.pointToAttack());
  }

  static ApexTank testTank() {
    return TestTank.testTank();
  }
}
