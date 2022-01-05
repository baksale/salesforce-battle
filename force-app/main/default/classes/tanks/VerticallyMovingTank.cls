public class VerticallyMovingTank extends TowerTank {
    private MoveDirectionEnum moveDirection = MoveDirectionEnum.UP;
    @TestVisible
    protected override MoveDirectionEnum nextMoveDirection() {
        final Point currentLocation = fieldRadar.coordinateFor(this);
        if(!fieldRadar.pathExists(currentLocation, moveDirection)) {
            switchDirection();
        }
        return moveDirection;
    }

    private void switchDirection() {
        if(MoveDirectionEnum.UP == moveDirection) {
            moveDirection = MoveDirectionEnum.DOWN;
        } else { 
            moveDirection = MoveDirectionEnum.UP;
        }
    }
}
