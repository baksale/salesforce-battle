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

  @isTest
  static void recordsBattleParametersAsOpportunityFields() {
    final Integer fieldSizeX = 10;
    final Integer fieldSizeY = 20;
    final Integer maxNumberOfRounds = 23;

    final GameEngine battle = GameEngine.getInstance()
      .withFieldService(FieldService.service(fieldSizeX, fieldSizeY))
      .withNumberOfRounds(maxNumberOfRounds);

    battleOrchestrator.runBattle(battle);

    final Opportunity battleAsOpportunity = [
      SELECT Id, FieldDefinition__c, MaxRounds__c
      FROM Opportunity
    ];
    final String fieldDefinition = String.valueOf(
      battleAsOpportunity.FieldDefinition__c
    );
    System.assert(fieldDefinition.contains(String.valueOf(fieldSizeX)));
    System.assert(fieldDefinition.contains(String.valueOf(fieldSizeY)));
    System.assertEquals(maxNumberOfRounds, battleAsOpportunity.MaxRounds__c);
  }

  @isTest
  static void recordsBattlePlayersInformationAsOpportunityFields() {
    final Integer numberOfAims = 4;
    final Integer initialLiveLevel = 2;
    final Integer numberOfRoundsCompleted = numberOfAims * initialLiveLevel;
    final Integer numberOfWinners = 1;

    final GameEngine battle = GameEngine.getInstance()
      .withLifeService(LifeService.lifeService(initialLiveLevel));

    for (Integer i = 0; i < numberOfAims; i++) {
      battle.withTank(new PiecefulTank());
    }
    battle.withTank(new TowerTank());

    battleOrchestrator.runBattle(battle);

    final Opportunity battleAsOpportunity = [
      SELECT Id, InitialLiveLevel__c, RoundsCompleted__c, Players__c, Winners__c
      FROM Opportunity
    ];
    System.assertEquals(
      numberOfRoundsCompleted,
      battleAsOpportunity.RoundsCompleted__c
    );
    System.assertEquals(
      initialLiveLevel,
      battleAsOpportunity.InitialLiveLevel__c
    );
    System.assertEquals(
      numberOfAims + numberOfWinners,
      battleAsOpportunity.Players__c
    );
    System.assertEquals(numberOfWinners, battleAsOpportunity.Winners__c);
  }
}
