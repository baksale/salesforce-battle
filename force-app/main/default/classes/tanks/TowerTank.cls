public class TowerTank extends ApexTankBase {
    @TestVisible
    protected override MoveDirectionEnum nextMoveDirection() {
        return MoveDirectionEnum.NOMOVE;
    }

    @TestVisible
    protected override Point pointToAttack() {
        final List<Point> cellsWithTanks = fieldRadar.getCoordinatesWithTanks();
        final Point currentLocation = fieldRadar.coordinateFor(this);
        final Integer cellIndex = cellsWithTanks.indexOf(currentLocation);
        cellsWithTanks.remove(cellIndex);
        if(!cellsWithTanks.isEmpty()) {
            return cellsWithTanks.get(Integer.valueOf(Math.random() * cellsWithTanks.size()));
        }
        return null;
    }
}
