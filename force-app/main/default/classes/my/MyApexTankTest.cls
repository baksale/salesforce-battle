@isTest
public class MyApexTankTest {
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static FieldLocator locator = (FieldLocator) mocks.mock(FieldLocator.class);
    private final static EnemyProvider enemiesProvider = (EnemyProvider) mocks.mock(EnemyProvider.class);
    private final static MyApexTank myTank = new MyApexTank();

    static{
        myTank
            .withEnemyProvider(enemiesProvider)
            .withTanksLocator(locator);

        mocks.startStubbing();
            mocks.when(enemiesProvider.getEnemiesOnTheField()).thenReturn(new List<ApexTank>());
            mocks.when(locator.coordinateFor(myTank)).thenReturn(new Point(0, 9));
            mocks.when(locator.fieldExists(
                                (Point) fflib_Match.anyObject(),
                                // (MoveDirectionEnum) fflib_Match.eq(MoveDirectionEnum.UP)))
                                (MoveDirectionEnum) fflib_Match.anyObject()))
                            .thenReturn(true);
        mocks.stopStubbing();
    }

    @isTest static void movesUpByDefault() {
        final MoveDirectionEnum moveDirection = myTank.nextMoveDirection();

        System.assertEquals(MoveDirectionEnum.UP, moveDirection);
    }

    @isTest static void willMoveDownIfAtTheTopOfTheMap() {
        mocks.startStubbing();
            mocks.when(locator.fieldExists(
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
        mocks.when(enemiesProvider.getEnemiesOnTheField()).thenReturn(new List<ApexTank>{enemyTank});
        mocks.when(locator.coordinateFor(myTank)).thenReturn(currentLocation);
        mocks.when(locator.coordinateFor(enemyTank)).thenReturn(enemyLocation);
        mocks.stopStubbing();

        final MoveDirectionEnum moveDirection = myTank.nextMoveDirection();

        System.assertEquals(MoveDirectionEnum.NOMOVE, moveDirection);
    }

    @isTest static void attackEnemyInTheCorner() {
        final ApexTank enemyTank = testTank();
        final Point enemyLocation = new Point(0, 0);
        mocks.startStubbing();
            mocks.when(enemiesProvider.getEnemiesOnTheField()).thenReturn(new List<ApexTank>{enemyTank});
            mocks.when(locator.coordinateFor(enemyTank)).thenReturn(enemyLocation);
            mocks.when(locator.fieldExists(enemyLocation, MoveDirectionEnum.UP)).thenReturn(false);
            mocks.when(locator.fieldExists(enemyLocation, MoveDirectionEnum.LEFT)).thenReturn(false);
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
            mocks.when(enemiesProvider.getEnemiesOnTheField()).thenReturn(new List<ApexTank>{
                enemyTank1,
                enemyTank2
            });
            mocks.when(locator.coordinateFor(enemyTank1)).thenReturn(enemyLocation1);
            mocks.when(locator.coordinateFor(enemyTank2)).thenReturn(enemyLocation2);
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
        mocks.when(enemiesProvider.getEnemiesOnTheField()).thenReturn(new List<ApexTank>{enemyTank});
        mocks.when(locator.coordinateFor(myTank)).thenReturn(currentLocation);
        mocks.when(locator.coordinateFor(enemyTank)).thenReturn(enemyLocation);
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
