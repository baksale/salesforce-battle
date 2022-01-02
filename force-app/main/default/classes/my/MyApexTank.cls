public class MyApexTank extends ApexTankBase {

    @TestVisible
	protected override MoveDirectionEnum nextMoveDirection(){
        final Point myLocation = locator.coordinateFor(this);
        final List<ApexTank> enemyTanks = enemies.getEnemiesOnTheField();
        for(ApexTank enemy: enemyTanks) {
            final Point enemyLocation = locator.coordinateFor(enemy);
            if(isBelowCurrentLocation(myLocation, enemyLocation)) {
                return MoveDirectionEnum.NOMOVE;
            }
        }
        if(locator.fieldExists(myLocation, MoveDirectionEnum.UP)) {
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
        final List<ApexTank> enemyTanks = enemies.getEnemiesOnTheField();
        for(ApexTank enemy: enemyTanks) {
            final Point enemyLocation = locator.coordinateFor(enemy);
            if(inTheConner(enemyLocation)) {
                return enemyLocation;
            }
        }
        return locator.coordinateFor(enemyTanks.get(0));
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
