@isTest
public class MyApexTankTest {
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static Radar radar = (Radar) mocks.mock(Radar.class);
    private final static MyApexTank myTank = new MyApexTank();
    private final static ApexTank enemyTank = testTank();
    private final static Point myLocation = new Point(1, 1);
    private final static Point enemyLocation = new Point(0, 0);

    static{
        myTank.withRadar(radar);

        mocks.startStubbing();
            mocks.when(radar.getCoordinatesWithTanks()).thenReturn(
                                new Set<Point>{myLocation, enemyLocation});
            mocks.when(radar.tankAt(myLocation)).thenReturn(myTank);
            mocks.when(radar.tankAt(enemyLocation)).thenReturn(enemyTank);
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
        mocks.startStubbing();
            mocks.when(radar.pathExists(enemyLocation, MoveDirectionEnum.UP)).thenReturn(false);
            mocks.when(radar.pathExists(enemyLocation, MoveDirectionEnum.LEFT)).thenReturn(false);
        mocks.stopStubbing();

        final Point pointToAttack = myTank.pointToAttack();

        System.assertEquals(enemyLocation, pointToAttack);
    }

    @isTest static void attackFirstEnemyIfNobodyInTheCorner() {
        mocks.startStubbing();
        mocks.when(radar.pathExists(
                (Point) fflib_Match.anyObject(), 
                (MoveDirectionEnum) fflib_Match.anyObject()))
            .thenReturn(false);
        mocks.stopStubbing();

        final Point pointToAttack = myTank.pointToAttack();

        System.assertEquals(enemyLocation, pointToAttack);
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
