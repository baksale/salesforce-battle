public class TowerTank extends ApexTankBase {
    @TestVisible
    protected override MoveDirectionEnum nextMoveDirection() {
        return MoveDirectionEnum.NOMOVE;
    }

    @TestVisible
    protected override Point pointToAttack() {
        return new Point(0, 0);
    }
}
