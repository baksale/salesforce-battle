public interface Radar {
  Boolean pathExists(Point relativePoint, MoveDirectionEnum direction);
  List<Point> getCoordinatesWithTanks();
  ApexTank tankAt(Point point);
  Point coordinateFor(ApexTank tank);
}
