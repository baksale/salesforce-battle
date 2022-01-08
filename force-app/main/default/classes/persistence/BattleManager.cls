public class BattleManager {
  private String leagueName = 'Apex League';
  public void runBattle(final GameEngine battle) {
    battle.battle();
    final Account apexLeague = [
      SELECT Id
      FROM Account
      WHERE Name = :leagueName
    ];
    final Opportunity battleAsOpportunity = new Opportunity(
      Name = 'Test',
      StageName = 'Open',
      CloseDate = System.today().addDays(1),
      AccountId = apexLeague.Id,
      FieldDefinition__c = battle.fieldDefinition(),
      MaxRounds__c = battle.maxNumberOfRounds,
      RoundsCompleted__c = battle.numberOfRounds,
      Players__c = battle.initialNumberOfPlayers,
      Winners__c = battle.winners().size()
    );
    insert battleAsOpportunity;
  }

  public BattleManager inLeague(final String leagueName) {
    this.leagueName = leagueName;
    return this;
  }
}
