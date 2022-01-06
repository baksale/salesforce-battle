public class HorizontallyMovingTank extends LineMovingTank {
    protected override MoveDirectionEnum getDefaultDirection() {
        return MoveDirectionEnum.RIGHT;
    }
    protected override MoveDirectionEnum getOppositeDirection() {
        return MoveDirectionEnum.LEFT;
    }
}
