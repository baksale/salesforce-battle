public class BattleManager {
  public void runBattle(final GameEngine battle) {
    final Account apexLeague = [SELECT Id FROM Account];
    final Opportunity battleAsOpportunity = new Opportunity(
      Name = 'Test',
      StageName = 'Open',
      CloseDate = System.today().addDays(1),
      AccountId = apexLeague.Id
    );
    insert battleAsOpportunity;
  }
}
