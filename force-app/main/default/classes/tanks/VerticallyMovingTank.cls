public class VerticallyMovingTank extends LineMovingTank {
    protected override MoveDirectionEnum getDefaultDirection() {
        return MoveDirectionEnum.UP;
    }
    protected override MoveDirectionEnum getOppositeDirection() {
        return MoveDirectionEnum.DOWN;
    }
}
