@isTest
public class BattleManagerTest {
  private final static String LEAGUE_NAME_APEX = 'Apex League';
  private final static BattleManager battleOrchestrator = new BattleManager();

  @TestSetup
  static void makeData() {
    final String leagueName = 'Apex League';
    insert new Account(Name = leagueName);
  }

  @isTest
  static void persistsEveryBattleAsOpportunity() {
    final Integer numberOfBattles = 3;
    for (Integer i = 0; i < numberOfBattles; i++) {
      battleOrchestrator.runBattle(GameEngine.getInstance());
    }

    System.assertEquals(numberOfBattles, [SELECT Id FROM Opportunity].size());
  }

  @isTest
  static void associatesEachBattleWithALeagueAsAccount() {
    battleOrchestrator.runBattle(GameEngine.getInstance());

    System.assertEquals(
      LEAGUE_NAME_APEX,
      [SELECT Account.Name FROM Opportunity]
      .Account.Name
    );
  }
}
