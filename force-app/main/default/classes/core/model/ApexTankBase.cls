public abstract class ApexTankBase implements ApexTank {
    protected EnemyProvider enemies;
    protected FieldLocator locator;

    public ApexTankBase withEnemyProvider(final EnemyProvider enemyProvider) {
        this.enemies = enemyProvider;
        return this;
    }
    public ApexTankBase withTanksLocator(final FieldLocator locator) {
        this.locator = locator;
        return this;
    }

    protected abstract MoveDirectionEnum nextMoveDirection();
    protected abstract Point pointToAttack();

    public virtual RoundAction getAction() {
        final Point pointToAttack = pointToAttack();
        System.debug('Point to attack: ' + pointToAttack + ' ;tank: ' + this);
        return new RoundAction(nextMoveDirection(), pointToAttack);
    }
}