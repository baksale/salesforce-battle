public class LeagueBattleScheduler implements Schedulable {
  public static String CRON_EXPRESSION = '0 0 0 * * ?';

  private String league;
  private Id priceBookId;
  private List<Product2> modelsToCompete;

  private LeagueBattleScheduler() {
    league = 'Apex';
    modelsToCompete = new List<Product2>();
  }
  public static LeagueBattleScheduler scheduler() {
    return new LeagueBattleScheduler();
  }

  public void execute(final SchedulableContext ctx) {
    if (null == priceBookId) {
      throw new IllegalArgumentException('Price Book must be provided');
    }
    BattleManager.orchestrate()
      .inLeague(league)
      .withPriceBook(priceBookId)
      .withTanksModels(modelsToCompete)
      .runBattle();
  }

  public LeagueBattleScheduler inLeague(final String league) {
    this.league = league;
    return this;
  }

  public LeagueBattleScheduler withPriceBook(final Id priceBookId) {
    this.priceBookId = priceBookId;
    return this;
  }

  public LeagueBattleScheduler withTanksModels(
    final List<Product2> modelsToCompete
  ) {
    this.modelsToCompete = modelsToCompete;
    return this;
  }
}
