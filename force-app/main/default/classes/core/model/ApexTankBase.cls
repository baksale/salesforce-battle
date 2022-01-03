public abstract class ApexTankBase implements ApexTank {
    protected Radar fieldRadar;

    public ApexTankBase withRadar(final Radar fieldRadar) {
        this.fieldRadar = fieldRadar;
        return this;
    }

    protected abstract MoveDirectionEnum nextMoveDirection();
    protected abstract Point pointToAttack();

    public virtual RoundAction getAction() {
        return new RoundAction(nextMoveDirection(), pointToAttack());
    }
}
