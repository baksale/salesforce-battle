public class Point {
  public Integer x { get; private set; }
  public Integer y { get; private set; }

  private static final Map<MoveDirectionEnum, Point> pointsShift = new Map<MoveDirectionEnum, Point>{
    MoveDirectionEnum.UP => new Point(0, 1),
    MoveDirectionEnum.RIGHT => new Point(1, 0),
    MoveDirectionEnum.DOWN => new Point(0, -1),
    MoveDirectionEnum.LEFT => new Point(-1, 0),
    MoveDirectionEnum.NOMOVE => new Point(0, 0)
  };

  public Point(final Integer x, final Integer y) {
    this.x = x;
    this.y = y;
  }

  public Point add(final Point pointToAdd) {
    return new Point(this.x + pointToAdd.x, this.y + pointToAdd.y);
  }

  public Point add(final MoveDirectionEnum direction) {
    final Point shift = pointsShift.get(direction);
    return this.add(shift);
  }

  public Integer hashCode() {
    return x + y;
  }

  public Boolean equals(final Object obj) {
    if (!(obj instanceof Point)) {
      return false;
    }
    final Point point = (Point) obj;
    return x == point?.x && y == point?.y;
  }
}
