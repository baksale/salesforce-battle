public class MyApexTank extends ApexTankBase {

    @TestVisible
	protected override MoveDirectionEnum nextMoveDirection(){
        final Set<Point> cellsWithTanks = locator.getCoordinatesWithTanks();
        final Point myLocation = myLocation(cellsWithTanks);
        for(Point enemyLocation: cellsWithTanks) {
            if(enemyLocation.equals(myLocation)) {
                continue;
            }
            if(isBelowCurrentLocation(myLocation, enemyLocation)) {
                return MoveDirectionEnum.NOMOVE;
            }
        }
        if(locator.fieldExists(myLocation, MoveDirectionEnum.UP)) {
            return MoveDirectionEnum.UP;
        }
		return MoveDirectionEnum.DOWN;
	}

    private Point myLocation(final Set<Point> cellsWithTanks) {
        for(Point cellWithTank: cellsWithTanks) {
            if(locator.tankAt(cellWithTank).equals(this)) {
                return cellWithTank;
            }
        }
        return null; //TODO: throw unreachable statement exception
    }

    private Boolean isBelowCurrentLocation(final Point currentLocation, final Point enemyLocation) {
        return currentLocation.x == enemyLocation.x
                && currentLocation.y == enemyLocation.y + 1;
    }

    @TestVisible
	protected override Point pointToAttack(){
        final Set<Point> cellsWithTanks = locator.getCoordinatesWithTanks();
        final Point myLocation = myLocation(cellsWithTanks);
        for(Point enemyLocation: cellsWithTanks) {
            if(enemyLocation.equals(myLocation)) {
                continue;
            }
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
        return !locator.fieldExists(coordinate, MoveDirectionEnum.UP)
                && !locator.fieldExists(coordinate, MoveDirectionEnum.LEFT);
	}
	private Boolean rightTopCorner(final Point coordinate) {
        return !locator.fieldExists(coordinate, MoveDirectionEnum.UP)
                && !locator.fieldExists(coordinate, MoveDirectionEnum.RIGHT);
	} 
	private Boolean rightBottomCorner(final Point coordinate) {
        return !locator.fieldExists(coordinate, MoveDirectionEnum.DOWN)
                && !locator.fieldExists(coordinate, MoveDirectionEnum.RIGHT);
	} 
	private Boolean leftBottomCorner(final Point coordinate) {
        return !locator.fieldExists(coordinate, MoveDirectionEnum.DOWN)
                && !locator.fieldExists(coordinate, MoveDirectionEnum.LEFT);
	} 
}
