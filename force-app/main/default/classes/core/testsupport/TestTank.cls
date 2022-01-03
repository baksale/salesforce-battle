@isTest
@TestVisible
private class TestTank extends ApexTankBase {
    private Set<ApexTank> tanksToAttack = new Set<ApexTank>();
    private MoveDirectionEnum moveDirection = MoveDirectionEnum.NOMOVE;

    public static TestTank testTank() {
        return new TestTank();
    }

    public TestTank direction(final MoveDirectionEnum movingDirection) {
        this.moveDirection = movingDirection;
        return this;
    }

    public TestTank attack(final ApexTank tankToAttack) {
        tanksToAttack.add(tankToAttack);
        return this;
    }

    protected override MoveDirectionEnum nextMoveDirection() {
        return moveDirection;
    }

    protected override Point pointToAttack() {
        final Set<Point> cellsWithTank = fieldRadar.getCoordinatesWithTanks();
        for(Point p: cellsWithTank) {
            if(tanksToAttack.contains(fieldRadar.tankAt(p))) {
                return p;
            }
        }
        return null;
    }
}
