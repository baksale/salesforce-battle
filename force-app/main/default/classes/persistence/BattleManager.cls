public class BattleManager {
  private String leagueName = 'Apex League';
  public void runBattle(final GameEngine battle) {
    final Account apexLeague = [
      SELECT Id
      FROM Account
      WHERE Name = :leagueName
    ];
    final Opportunity battleAsOpportunity = new Opportunity(
      Name = 'Test',
      StageName = 'Open',
      CloseDate = System.today().addDays(1),
      AccountId = apexLeague.Id
    );
    insert battleAsOpportunity;
  }

  public BattleManager inLeague(final String leagueName) {
    this.leagueName = leagueName;
    return this;
  }
}
