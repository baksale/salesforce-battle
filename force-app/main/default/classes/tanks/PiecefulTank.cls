public class PiecefulTank extends ApexTankBase {
    protected override MoveDirectionEnum nextMoveDirection() {
        return MoveDirectionEnum.NOMOVE;
    }
    protected override Point pointToAttack() {
        return null;
    }
}
