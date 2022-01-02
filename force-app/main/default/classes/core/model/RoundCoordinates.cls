public class RoundCoordinates {
    public Point coordinateToAttack {get; private set;}
    public Point coordinateToMove {get; private set;}

    public RoundCoordinates(final Point move, final Point attack) {
        this.coordinateToMove = move;
        this.coordinateToAttack = attack;
    }
}
