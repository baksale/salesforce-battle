@isTest
public class TowerTankTest {
    private final static Point towerLocation = new Point(7, 8);
    private final static TowerTank tank = new TowerTank();
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static Radar fieldRadar = (Radar) mocks.mock(Radar.class);

    static {
        tank.withRadar(fieldRadar);
        mocks.startStubbing();
        mocks.when(fieldRadar.getCoordinatesWithTanks()).thenReturn(new List<Point>{towerLocation});
        mocks.when(fieldRadar.coordinateFor(tank)).thenReturn(towerLocation);
        mocks.stopStubbing();
    }

    @isTest static void doesNotMove() {
        System.assertEquals(MoveDirectionEnum.NOMOVE, tank.nextMoveDirection());
    }

    @isTest static void doesNotAttackIfNoEnemies() {
        System.assertEquals(null, tank.pointToAttack());
    }

    @isTest static void attacksRandomTank() {
        final List<Point> tanksLocations = new List<Point>{
            new Point(0, 0),
            new Point(0, 1),
            new Point(2, 0),
            towerLocation
        };

        mocks.startStubbing();
        mocks.when(fieldRadar.getCoordinatesWithTanks()).thenReturn(tanksLocations);
        mocks.stopStubbing();

        final Point pointToAttack = tank.pointToAttack();
        System.assert(tanksLocations.contains(pointToAttack), 'does not attack any enemy');
        System.assertNotEquals(towerLocation, pointToAttack, 'attacked own tank');
    }

    private static TestTank testTank() {
        return TestTank.testTank();
    }
}
