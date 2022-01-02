public interface FieldLocator {
	Point coordinateFor(ApexTank tank);
	Boolean fieldExists(Point relativePoint, MoveDirectionEnum direction);
}
