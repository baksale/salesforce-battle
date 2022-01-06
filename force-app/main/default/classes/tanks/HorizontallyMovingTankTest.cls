@isTest
public class HorizontallyMovingTankTest {
    private final static Point currentLocation = new Point (3, 7);
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static Radar fieldRadar = (Radar) mocks.mock(Radar.class);
    private final static HorizontallyMovingTank tank = new HorizontallyMovingTank();

    static {
        tank.withRadar(fieldRadar);
        mocks.startStubbing();
        mocks.when(fieldRadar.coordinateFor(tank)).thenReturn(currentLocation);
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.RIGHT)).thenReturn(true);
        mocks.stopStubbing();
    }

    @isTest static void movesRightByDefault() {
        System.assertEquals(MoveDirectionEnum.RIGHT, tank.nextMoveDirection());
    }

    @isTest static void movesLeftOnceRightEdgeIsReached() {
        mocks.startStubbing();
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.RIGHT))
                            .thenReturn(false)
                            .thenReturn(true);
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.LEFT))
                            .thenReturn(true);
        mocks.stopStubbing();

        System.assertEquals(MoveDirectionEnum.LEFT, tank.nextMoveDirection());
        System.assertEquals(MoveDirectionEnum.LEFT, tank.nextMoveDirection());
    }
}
