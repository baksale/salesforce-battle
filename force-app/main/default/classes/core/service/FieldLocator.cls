public interface FieldLocator {
	Boolean fieldExists(Point relativePoint, MoveDirectionEnum direction);
	Set<Point> getCoordinatesWithTanks();
	ApexTank tankAt(Point point);
}
