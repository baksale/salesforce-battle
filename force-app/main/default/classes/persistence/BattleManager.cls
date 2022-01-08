public class BattleManager {
  public void runBattle(final GameEngine battle) {
    final Opportunity battleAsOpportunity = new Opportunity(
      Name = 'Test',
      StageName = 'Open',
      CloseDate = System.today().addDays(1)
    );
    insert battleAsOpportunity;
  }
}
