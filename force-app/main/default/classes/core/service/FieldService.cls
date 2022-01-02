public class FieldService implements FieldLocator {
	private Map<MoveDirectionEnum, Point> pointsShift = new Map<MoveDirectionEnum,Point> {
		MoveDirectionEnum.UP => new Point(0, 1),
		MoveDirectionEnum.RIGHT => new Point(1, 0),
		MoveDirectionEnum.DOWN => new Point(0, -1),
		MoveDirectionEnum.LEFT => new Point(-1, 0),
		MoveDirectionEnum.NOMOVE => new Point(0, 0)
	};
	private Map<Point, ApexTank> cellsWithTanks;
	private Map<ApexTank, Point> tankCoordinates;

    public Integer x {get; private set;}
    public Integer y {get; private set;}

	public FieldService(){
		//for apex mocks only
	}
    private FieldService(final Integer x, final Integer y) {
		this.cellsWithTanks = new Map<Point, ApexTank>();
		this.tankCoordinates = new Map<ApexTank, Point>();
        this.x = x;
        this.y = y;
    }

	public static FieldService service(final Integer x, final Integer y){
		return new FieldService(x, y);
	}
 
	public Integer getNumberOfCells(){
        return x * y;
	}

	public Boolean addTankToField(final ApexTank tank, final Point tankCoordinate){
		if(storeIntoCell(tank, tankCoordinate)) {
			tankCoordinates.put(tank, tankCoordinate);
			return true;
		}
		return false;
	}
	private Boolean storeIntoCell(final ApexTank tank, final Point cell) {
		return cellsWithTanks.containsKey(cell)
				? false
				: cellsWithTanks.put(cell, tank) == null;
	}

	public ApexTank tankAt(final Point tankCoordinate){
		return cellsWithTanks.get(tankCoordinate);
	} 

	public Boolean moveTank(final ApexTank tank, final MoveDirectionEnum moveDirection){
		final Point currentCoordinate = tankCoordinates.get(tank);
		final Point targetCoordinate = currentCoordinate.add(pointsShift.get(moveDirection));
		return moveTank(tank, targetCoordinate);
	} 

	public Boolean moveTank(final ApexTank tank, final Point targetCoordinate){
		if(tankCoordinates.containsKey(tank)
				&& isTargetWithinField(targetCoordinate)
				&& !cellsWithTanks.containsKey(targetCoordinate)) {
			final Point currentCoordinate = tankCoordinates.get(tank);
			cellsWithTanks.remove(currentCoordinate);
			cellsWithTanks.put(targetCoordinate,tank);
			tankCoordinates.put(tank, targetCoordinate);
			return true;
		}
		return false;
	}

	private Boolean isTargetWithinField(final Point targetCoordinate){
		return 0 <= targetCoordinate.x && targetCoordinate.x < x
				&& 0 <= targetCoordinate.y && targetCoordinate.y < y;
	} 

	public Boolean fieldExists(final Point relativePoint, final MoveDirectionEnum direction) {
		final Point targetPoint = relativePoint.add(pointsShift.get(direction));
		return isTargetWithinField(targetPoint);
	}

	public Boolean addTankRandomly(ApexTank testTank){
		if(cellsWithTanks.size() == getNumberOfCells()) {
			return false;
		}
		Point randomPoint = null;
		do {
			randomPoint = getRandomPoint();
		} while(!addTankToField(testTank, randomPoint));
		return true;
	}

    private Point getRandomPoint() {
        final Integer xRandom = Integer.valueOf(Math.random() * x);
        final Integer yRandom = Integer.valueOf(Math.random() * y);
		return new Point(xRandom, yRandom);
	} 

	public Set<Point> getCoordinatesWithTanks(){
		return cellsWithTanks.keySet();
	} 

	public void removeTank(final ApexTank tank){
		final Point tanksCoordinate = tankCoordinates.get(tank);
		cellsWithTanks.remove(tanksCoordinate);
		tankCoordinates.remove(tank);
	} 
}
