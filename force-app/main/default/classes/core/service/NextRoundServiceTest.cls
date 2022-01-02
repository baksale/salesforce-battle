@isTest
public class NextRoundServiceTest {
    private final static NextRoundService nextRoundService = new NextRoundService();
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static FieldService fieldService = (FieldService) mocks.mock(FieldService.class);

    @isTest static void calculatesNextCoordinateForTank(){
        final ApexTank upMovingTank = testTank(MoveDirectionEnum.UP);
        final Point currentLocation = new Point(0, 0);
        mocks.startStubbing();
        mocks.when(fieldService.coordinateFor(upMovingTank)).thenReturn(currentLocation);
        mocks.stopStubbing();

        final RoundCoordinates nextRoundCoordinates
            = nextRoundService.calculateNextCoordinates(upMovingTank, fieldService);
        final Point pointToMove = nextRoundCoordinates.coordinateToMove;

        System.assertEquals(currentLocation.x, pointToMove.x);
        System.assertEquals(currentLocation.y + 1, pointToMove.y);
    }

    @isTest static void calculatesPointToAttackForTank(){
        final ApexTank forwardFiringTank = testTank(MoveDirectionEnum.UP);
        final Point currentLocation = new Point(0, 0);
        mocks.startStubbing();
        mocks.when(fieldService.coordinateFor(forwardFiringTank)).thenReturn(currentLocation);
        mocks.stopStubbing();

        final RoundCoordinates nextRoundCoordinates
            = nextRoundService.calculateNextCoordinates(forwardFiringTank, fieldService);
        final Point pointToMove = nextRoundCoordinates.coordinateToMove;

        System.assertEquals(currentLocation.x, pointToMove.x);
        System.assertEquals(currentLocation.y + 1, pointToMove.y);
    }

    private static TestTank testTank(final MoveDirectionEnum movingDirection) {
        return TestTank.testTank(movingDirection);
    }

    private class ForwardFiringTank extends ApexTankBase {
        protected override MoveDirectionEnum nextMoveDirection() {
            return MoveDirectionEnum.UP;
        }
        protected override Point pointToAttack() {
            final Point currentLocation = locator.coordinateFor(this);
            return currentLocation.add(new Point(1, 1));
        }
    }
}
