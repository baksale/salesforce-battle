@isTest
public class VerticallyMovingTankTest {
    private final static Point currentLocation = new Point (3, 7);
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static Radar fieldRadar = (Radar) mocks.mock(Radar.class);
    private final static VerticallyMovingTank tank = new VerticallyMovingTank();

    static {
        tank.withRadar(fieldRadar);
        mocks.startStubbing();
        mocks.when(fieldRadar.coordinateFor(tank)).thenReturn(currentLocation);
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.UP)).thenReturn(true);
        mocks.stopStubbing();
    }

    @isTest static void movesUpByDefault() {
        System.assertEquals(MoveDirectionEnum.UP, tank.nextMoveDirection());
    }

    @isTest static void movesDownOnceTopIsReached() {
        mocks.startStubbing();
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.UP)).thenReturn(false);
        mocks.stopStubbing();
        System.assertEquals(MoveDirectionEnum.DOWN, tank.nextMoveDirection());
    }

    @isTest static void keepsMovingDown() {
        mocks.startStubbing();
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.UP))
                            .thenReturn(false)
                            .thenReturn(true);
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.DOWN))
                            .thenReturn(true);
        mocks.stopStubbing();

        System.assertEquals(MoveDirectionEnum.DOWN, tank.nextMoveDirection());
        System.assertEquals(MoveDirectionEnum.DOWN, tank.nextMoveDirection());
    }

    @isTest static void movesUpOnceBottomIsReached() {
        mocks.startStubbing();
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.UP))
                            .thenReturn(false)
                            .thenReturn(true);
        mocks.when(fieldRadar.pathExists(currentLocation, MoveDirectionEnum.DOWN))
                            .thenReturn(true)
                            .thenReturn(false);
        mocks.stopStubbing();

        System.assertEquals(MoveDirectionEnum.DOWN, tank.nextMoveDirection());
        System.assertEquals(MoveDirectionEnum.DOWN, tank.nextMoveDirection());
        System.assertEquals(MoveDirectionEnum.UP, tank.nextMoveDirection());
    }
}
