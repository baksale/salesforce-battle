@isTest
@TestVisible
private class TestTank extends ApexTankBase {
    private ApexTank tankToAttack = null;
    private MoveDirectionEnum moveDirection = MoveDirectionEnum.NOMOVE;

    public static TestTank testTank() {
        return new TestTank();
    }

    public TestTank direction(final MoveDirectionEnum movingDirection) {
        this.moveDirection = movingDirection;
        return this;
    }

    public TestTank attack(final ApexTank tankToAttack) {
        this.tankToAttack = tankToAttack;
        return this;
    }

    protected override MoveDirectionEnum nextMoveDirection() {
        return moveDirection;
    }

    protected override Point pointToAttack() {
        final Set<Point> cellsWithTank = locator.getCoordinatesWithTanks();
        for(Point p: cellsWithTank) {
            if(locator.tankAt(p).equals(tankToAttack)) {
                return p;
            }
        }
        return null;
    }
}
