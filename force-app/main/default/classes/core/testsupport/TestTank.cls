@isTest
@TestVisible
private class TestTank extends ApexTankBase {
    private ApexTank tankToAttack = null;
    private MoveDirectionEnum moveDirection = MoveDirectionEnum.NOMOVE;

    public static TestTank testTank() {
        return testTank(MoveDirectionEnum.NOMOVE);
    }

    public static TestTank testTank(final MoveDirectionEnum movingDirection) {
        final TestTank tank = new TestTank();
        tank.moveDirection = movingDirection;
        return tank;
    }

    public static TestTank testTank(final ApexTank tankToAttack) {
        final TestTank testTank = testTank();
        testTank.tankToAttack = tankToAttack;
        return testTank;
    }

    protected override MoveDirectionEnum nextMoveDirection() {
        return moveDirection;
    }
    protected override Point pointToAttack() {
        return locator.coordinateFor(tankToAttack);
    }
}
