public class RoundAction {
    public MoveDirectionEnum direction {get; private set;}
    public Point coordinateToAttack  {get; private set;}

    public RoundAction(final MoveDirectionEnum direction, final Point coordinateToAttack) {
        this.direction = direction;
        this.coordinateToAttack = coordinateToAttack;
    }
}
