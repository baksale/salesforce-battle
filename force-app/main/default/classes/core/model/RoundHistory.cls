public class RoundHistory {
    public MoveDirectionEnum direction {get; private set;}
    public Boolean successfullMove;
    public Point attack;
    public Boolean successfullAttack;

    public RoundHistory() {

    }

    public RoundHistory withDirection(final MoveDirectionEnum direction) {
        this.direction = direction;
        return this;
    }

    public RoundHistory withMoveStatus(final Boolean moved) {
        this.successfullMove = moved;
        return this;
    }

    public RoundHistory withAttacked(final Point point) {
        this.attack = point;
        return this;
    }

    public RoundHistory withAttackStatus(final Boolean attacked) {
        this.successfullAttack = attacked;
        return this;
    }

}
