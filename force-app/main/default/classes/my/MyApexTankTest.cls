@isTest
public class MyApexTankTest {
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static Radar radar = (Radar) mocks.mock(Radar.class);
    private final static MyApexTank myTank = new MyApexTank();

    static{
        myTank.withRadar(radar);

        mocks.startStubbing();
            mocks.when(radar.getCoordinatesWithTanks()).thenReturn(new Set<Point>{new Point(0, 0)});
            mocks.when(radar.tankAt(new Point(0, 0))).thenReturn(myTank);
            mocks.when(radar.pathExists(
                                (Point) fflib_Match.anyObject(),
                                (MoveDirectionEnum) fflib_Match.eq(MoveDirectionEnum.UP)))
                            .thenReturn(true);
        mocks.stopStubbing();
    }

    @isTest static void movesUpByDefault() {
        final MoveDirectionEnum moveDirection = myTank.nextMoveDirection();

        System.assertEquals(MoveDirectionEnum.UP, moveDirection);
    }

    @isTest static void willMoveDownIfAtTheTopOfTheMap() {
        mocks.startStubbing();
            mocks.when(radar.pathExists(
                (Point) fflib_Match.anyObject(),
                (MoveDirectionEnum) fflib_Match.eq(MoveDirectionEnum.UP)))
            .thenReturn(false);
        mocks.stopStubbing();

        final MoveDirectionEnum moveDirection = myTank.nextMoveDirection();

        System.assertEquals(MoveDirectionEnum.DOWN, moveDirection);
    }

    @isTest static void willStayIfEnemyIsBelow() {
        final ApexTank enemyTank = testTank();
        final Point currentLocation = new Point(0, 9);
        final Point enemyLocation = new Point(0, 8);
        mocks.startStubbing();
            mocks.when(radar.getCoordinatesWithTanks()).thenReturn(new Set<Point>{
                currentLocation, enemyLocation
            });
            mocks.when(radar.tankAt(currentLocation)).thenReturn(myTank);
            mocks.when(radar.tankAt(enemyLocation)).thenReturn(enemyTank);
        mocks.stopStubbing();

        final MoveDirectionEnum moveDirection = myTank.nextMoveDirection();

        System.assertEquals(MoveDirectionEnum.NOMOVE, moveDirection);
    }

    @isTest static void attackEnemyInTheCorner() {
        final ApexTank enemyTank = testTank();
        final Point enemyLocation = new Point(0, 0);
        mocks.startStubbing();
            mocks.when(radar.pathExists(enemyLocation, MoveDirectionEnum.UP)).thenReturn(false);
            mocks.when(radar.pathExists(enemyLocation, MoveDirectionEnum.LEFT)).thenReturn(false);
        mocks.stopStubbing();

        final Point pointToAttack = myTank.pointToAttack();

        System.assertEquals(enemyLocation, pointToAttack);
    }

    @isTest static void attackFirstEnemyIfNobodyInTheCorner() {
        final ApexTank enemyTank1 = testTank();
        final ApexTank enemyTank2 = testTank();
        final Point enemyLocation1 = new Point(0, 0);
        final Point enemyLocation2 = new Point(3, 3);
        mocks.startStubbing();
        mocks.stopStubbing();

        final Point pointToAttack = myTank.pointToAttack();

        System.assertEquals(enemyLocation1, pointToAttack);
    }

    //TODO: [ ] - support history for each enemy tank
    //TODO: [ ] - support teams
    //TODO: [ ] - support communication between tanks within team
    static void movesRightIfEnemyIsBelowForTwoRounds() {
        final ApexTank enemyTank = testTank();
        final Point currentLocation = new Point(0, 9);
        final Point enemyLocation = new Point(0, 8);
        mocks.startStubbing();
        // mocks.when(historyTrack.historyFor(enemyTank)).thenReturn(new List<MoveDirectionEnum>{
        //     MoveDirectionEnum.NOMOVE,
        //     MoveDirectionEnum.UP,
        //     MoveDirectionEnum.UP
        // });
        mocks.stopStubbing();

        final MoveDirectionEnum moveDirection = myTank.nextMoveDirection();

        System.assertEquals(MoveDirectionEnum.NOMOVE, moveDirection);
    }

    private static ApexTank testTank() {
        return TestTank.testTank();
    }
}
