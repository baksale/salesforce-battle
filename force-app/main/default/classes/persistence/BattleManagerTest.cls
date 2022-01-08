@isTest
public class BattleManagerTest {
  private final static String LEAGUE_NAME_APEX = 'Apex League';
  private final static String LEAGUE_NAME_FLOW = 'Flow League';
  private final static BattleManager battleOrchestrator = new BattleManager();

  @TestSetup
  static void makeData() {
    insert new List<Account>{
      new Account(Name = LEAGUE_NAME_APEX),
      new Account(Name = LEAGUE_NAME_FLOW)
    };
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

  @isTest
  static void choosesLeagueBasedOnParameter() {
    battleOrchestrator
      .inLeague(LEAGUE_NAME_FLOW)
      .runBattle(GameEngine.getInstance());

    System.assertEquals(
      LEAGUE_NAME_FLOW,
      [SELECT Account.Name FROM Opportunity]
      .Account.Name
    );
  }
}
