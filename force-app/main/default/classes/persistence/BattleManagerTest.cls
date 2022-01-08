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
    final Id priceBookEntryId = Test.getStandardPricebookId();
    final List<Product2> tankModels = new List<Product2>{
      new Product2(Name = PiecefulTank.class.toString()),
      new Product2(Name = TowerTank.class.toString()),
      new Product2(Name = VerticallyMovingTank.class.toString())
    };
    insert tankModels;
    final List<PricebookEntry> prices = new List<PricebookEntry>();
    for (Product2 tankModel : tankModels) {
      prices.add(
        new PricebookEntry(
          Product2Id = tankModel.Id,
          Pricebook2Id = priceBookEntryId,
          UnitPrice = 1,
          IsActive = true
        )
      );
    }
    insert prices;
  }

  @isTest
  static void persistsEveryBattleAsOpportunity() {
    final Integer numberOfBattles = 3;
    for (Integer i = 0; i < numberOfBattles; i++) {
      battleOrchestrator.runBattle();
    }

    System.assertEquals(numberOfBattles, [SELECT Id FROM Opportunity].size());
  }

  @isTest
  static void associatesEachBattleWithALeagueAsAccount() {
    battleOrchestrator.runBattle();

    System.assertEquals(
      LEAGUE_NAME_APEX,
      [SELECT Account.Name FROM Opportunity]
      .Account.Name
    );
  }

  @isTest
  static void choosesLeagueBasedOnParameter() {
    battleOrchestrator.inLeague(LEAGUE_NAME_FLOW).runBattle();

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

    battleOrchestrator.createBattleOpportunity(battle);

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
    final Integer initialLifeLevel = 2;
    final Integer numberOfRoundsCompleted = numberOfAims * initialLifeLevel;
    final Integer numberOfWinners = 1;

    final GameEngine battle = GameEngine.getInstance()
      .withLifeService(LifeService.lifeService(initialLifeLevel));

    for (Integer i = 0; i < numberOfAims; i++) {
      battle.withTank(new PiecefulTank());
    }
    battle.withTank(new TowerTank());

    battleOrchestrator.createBattleOpportunity(battle);
    battleOrchestrator.runBattle(battle);
    battleOrchestrator.completeBattle(battle);

    final Opportunity battleAsOpportunity = [
      SELECT Id, InitialLiveLevel__c, RoundsCompleted__c, Players__c, Winners__c
      FROM Opportunity
    ];
    System.assertEquals(
      numberOfRoundsCompleted,
      battleAsOpportunity.RoundsCompleted__c
    );
    System.assertEquals(
      initialLifeLevel,
      battleAsOpportunity.InitialLiveLevel__c
    );
    System.assertEquals(
      numberOfAims + numberOfWinners,
      battleAsOpportunity.Players__c
    );
    System.assertEquals(numberOfWinners, battleAsOpportunity.Winners__c);
  }

  @isTest
  static void addsAllProductsAsTanksIntoBattle() {
    final Integer amountOfTanks = 3;
    final Integer tanksAmount = [SELECT Id FROM Product2].size();
    System.assertEquals(amountOfTanks, tanksAmount);

    final GameEngine singleBattle = battleOrchestrator
      .inLeague(LEAGUE_NAME_APEX)
      .runBattle();

    System.assertEquals(amountOfTanks, singleBattle.initialNumberOfPlayers);
  }

  @isTest
  static void eachPlayerIsAddedAsOpportunityLineItemIntoBattleOportunity() {
    battleOrchestrator.inLeague(LEAGUE_NAME_APEX).runBattle();

    final Opportunity battle = [SELECT Id FROM Opportunity];
    final List<OpportunityLineItem> players = [
      SELECT Id
      FROM OpportunityLineItem
      WHERE OpportunityId = :battle.Id
    ];

    System.assertEquals(3, players.size());
  }
}
