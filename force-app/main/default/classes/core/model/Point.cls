public class Point {
    public Integer x {get; private set;}
    public Integer y {get; private set;}

    public Point(final Integer x, final Integer y) {
        this.x = x;
        this.y = y;
    }

    public Point add(final Point pointToAdd) {
        return new Point(this.x + pointToAdd.x, this.y + pointToAdd.y);
    }

    public Integer hashCode() {
        return x + y;
    }

    public Boolean equals(final Object obj) {
        if(!(obj instanceof Point)) {
            return false;
        }
        final Point point = (Point) obj;
        return x == point?.x && y == point?.y;
    }
}