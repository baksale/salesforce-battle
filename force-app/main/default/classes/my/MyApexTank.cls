public class MyApexTank extends ApexTankBase {

    @TestVisible
	protected override MoveDirectionEnum nextMoveDirection(){
        final List<Point> cellsWithTanks = fieldRadar.getCoordinatesWithTanks();
        final Point myLocation = fieldRadar.coordinateFor(this);
        for(Point enemyLocation: cellsWithTanks) {
            if(enemyLocation.equals(myLocation)) {
                continue;
            }
            if(isBelowCurrentLocation(myLocation, enemyLocation)) {
                return MoveDirectionEnum.NOMOVE;
            }
        }
        if(fieldRadar.pathExists(myLocation, MoveDirectionEnum.UP)) {
            return MoveDirectionEnum.UP;
        }
		return MoveDirectionEnum.DOWN;
	}

    private Boolean isBelowCurrentLocation(final Point currentLocation, final Point enemyLocation) {
        return currentLocation.x == enemyLocation.x
                && currentLocation.y == enemyLocation.y + 1;
    }

    @TestVisible
	protected override Point pointToAttack(){
        final List<Point> cellsWithTanks = fieldRadar.getCoordinatesWithTanks();
        final Point myLocation = fieldRadar.coordinateFor(this);
        cellsWithTanks.remove(cellsWithTanks.indexOf(myLocation));
        for(Point enemyLocation: cellsWithTanks) {
            if(inTheConner(enemyLocation)) {
                return enemyLocation;
            }
        }
        return cellsWithTanks.iterator().next();
	}
    private Boolean inTheConner(final Point enemyLocation) {
        return leftTopCorner(enemyLocation)
                || rightTopCorner(enemyLocation)
                || rightBottomCorner(enemyLocation)
                || leftBottomCorner(enemyLocation);
    }

	private Boolean leftTopCorner(final Point coordinate) {
        return !fieldRadar.pathExists(coordinate, MoveDirectionEnum.UP)
                && !fieldRadar.pathExists(coordinate, MoveDirectionEnum.LEFT);
	}
	private Boolean rightTopCorner(final Point coordinate) {
        return !fieldRadar.pathExists(coordinate, MoveDirectionEnum.UP)
                && !fieldRadar.pathExists(coordinate, MoveDirectionEnum.RIGHT);
	} 
	private Boolean rightBottomCorner(final Point coordinate) {
        return !fieldRadar.pathExists(coordinate, MoveDirectionEnum.DOWN)
                && !fieldRadar.pathExists(coordinate, MoveDirectionEnum.RIGHT);
	} 
	private Boolean leftBottomCorner(final Point coordinate) {
        return !fieldRadar.pathExists(coordinate, MoveDirectionEnum.DOWN)
                && !fieldRadar.pathExists(coordinate, MoveDirectionEnum.LEFT);
	} 
}
