public class NextRoundService {
    private Set<MoveDirectionEnum> xMovingDirection = new Set<MoveDirectionEnum>{
        MoveDirectionEnum.LEFT,
        MoveDirectionEnum.RIGHT
    };
    private Set<MoveDirectionEnum> yMovingDirection = new Set<MoveDirectionEnum>{
        MoveDirectionEnum.UP,
        MoveDirectionEnum.DOWN
    };

	public RoundCoordinates calculateNextCoordinates(final ApexTank tank, final FieldService fieldService) {
        final RoundAction nextRoundAction = tank.getAction();
        final Point currentLocation = fieldService.coordinateFor(tank);
        final Point pointToMove = calculateNewPoint(currentLocation, nextRoundAction);
		return new RoundCoordinates(pointToMove, nextRoundAction.coordinateToAttack);
	} 

	private Point calculateNewPoint(final Point currentLocation, final RoundAction nextRoundAction) {
        final Integer currentX = currentLocation.x;
        final Integer currentY = currentLocation.y;
        final MoveDirectionEnum nextRoundMoveDirection = nextRoundAction.direction;
        return new Point(
                    currentX + xMove(nextRoundMoveDirection),
                    currentY + yMove(nextRoundMoveDirection));
	}

    private Integer yMove(final MoveDirectionEnum direction){
        if(yMovingDirection.contains(direction)) {
            return MoveDirectionEnum.UP == direction ? 1 : -1;
        }
        return 0;
    }
    
    private Integer xMove(final MoveDirectionEnum direction){
        if(xMovingDirection.contains(direction)) {
            return MoveDirectionEnum.RIGHT == direction ? 1 : -1;
        }
        return 0;
    }
}
