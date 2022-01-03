public interface Radar {
	Boolean pathExists(Point relativePoint, MoveDirectionEnum direction);
	Set<Point> getCoordinatesWithTanks();
	ApexTank tankAt(Point point);
}
