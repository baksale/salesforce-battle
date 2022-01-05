@isTest
public class TowerTankTest {
    private final static TowerTank tank = new TowerTank();
    @isTest static void doesNotMove() {
        System.assertEquals(MoveDirectionEnum.NOMOVE, tank.nextMoveDirection());
    }
}
