@isTest
public class BattleManagerTest {
  private final static String LEAGUE_NAME_APEX = 'Apex';
  private final static String LEAGUE_NAME_FLOW = 'Flow';
  private final static BattleManager battleOrchestrator = BattleManager.orchestrate()
    .inLeague(LEAGUE_NAME_APEX)
    .withPriceBook(Test.getStandardPricebookId());

  @TestSetup
  static void makeData() {
    setupLeaguesAccounts();
    setupTankModels();
  }
  static void setupLeaguesAccounts() {
    insert new List<Account>{
      new Account(Name = LEAGUE_NAME_APEX, League__c = LEAGUE_NAME_APEX),
      new Account(Name = LEAGUE_NAME_FLOW, League__c = LEAGUE_NAME_FLOW)
    };
  }
  static void setupTankModels() {
    final List<Product2> tankModels = new List<Product2>{
      new Product2(Name = PiecefulTank.class.toString()),
      new Product2(Name = TowerTank.class.toString()),
      new Product2(Name = VerticallyMovingTank.class.toString())
    };
    insert tankModels;
    setupPrices(tankModels);
  }
  static void setupPrices(final List<Product2> tankModels) {
    final List<PricebookEntry> prices = new List<PricebookEntry>();
    for (Product2 tankModel : tankModels) {
      prices.add(
        new PricebookEntry(
          Product2Id = tankModel.Id,
          Pricebook2Id = Test.getStandardPricebookId(),
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

    battleOrchestrator
      .withFieldService(FieldService.service(fieldSizeX, fieldSizeY))
      .withMaxNumberOfRounds(maxNumberOfRounds)
      .runBattle();

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
    final Product2 piecefullModel = [
      SELECT Id, Name
      FROM Product2
      WHERE Name LIKE 'Piece%'
    ];
    final Integer initialLiveLevel = 2;
    final Integer numberOfRoundsCompleted = numberOfAims * initialLiveLevel;
    final Integer numberOfWinners = 1;

    for (Integer i = 0; i < numberOfAims; i++) {
      battleOrchestrator.withTankModel(piecefullModel);
    }
    final Product2 towerModel = [
      SELECT Id, Name
      FROM Product2
      WHERE Name LIKE 'Tower%'
    ];
    battleOrchestrator.withTankModel(towerModel);

    battleOrchestrator
      .withLifeService(LifeService.lifeService(initialLiveLevel))
      .runBattle();

    final Opportunity battleAsOpportunity = [
      SELECT
        Id,
        InitialLiveLevel__c,
        RoundsCompleted__c,
        NumberOfPlayers__c,
        NumberOfWinners__c
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
      battleAsOpportunity.NumberOfPlayers__c
    );
    System.assertEquals(
      numberOfWinners,
      battleAsOpportunity.NumberOfWinners__c
    );
  }

  @isTest
  static void eachPlayerIsAddedAsOpportunityLineItemIntoBattleOportunity() {
    final List<Product2> tanksModels = [SELECT Name FROM Product2];
    battleOrchestrator.withTanksModels(tanksModels).runBattle();

    final Opportunity battle = [SELECT Id FROM Opportunity];
    final List<OpportunityLineItem> players = [
      SELECT Id
      FROM OpportunityLineItem
      WHERE OpportunityId = :battle.Id
    ];

    System.assertEquals(tanksModels.size(), players.size());
  }

  @isTest
  static void tankActionsAreStoredOnOpportunityLineItems() {
    final Product2 movingTankModel = [
      SELECT Id, Name
      FROM Product2
      WHERE Name LIKE '%Moving%'
    ];
    final List<Product2> tanksModels = [SELECT Id, Name FROM Product2];
    final Integer numberOfRounds = 3;
    battleOrchestrator
      .withTanksModels(tanksModels)
      .withMaxNumberOfRounds(numberOfRounds)
      .runBattle();

    final OpportunityLineItem movingPlayer = [
      SELECT Id, BattleHistory__c
      FROM OpportunityLineItem
      WHERE Product2Id = :movingTankModel.Id
    ];

    final TankHistory tankHistory = (TankHistory) JSON.deserialize(
      movingPlayer.BattleHistory__c,
      TankHistory.class
    );

    for (Integer i = 0; i < numberOfRounds; i++) {
      final RoundHistory roundHistory = tankHistory.getRoundRecord(i);

      System.assert(
        MoveDirectionEnum.UP == roundHistory.direction ||
        MoveDirectionEnum.DOWN == roundHistory.direction
      );
      System.assertNotEquals(null, roundHistory.attack);
      System.assertEquals(true, roundHistory.successfullAttack);
    }
  }

  @isTest
  static void aliveTanksHaveUnitInQuantity() {
    final List<Product2> tanksModels = [SELECT Id, Name FROM Product2];
    battleOrchestrator.withTanksModels(tanksModels).runBattle();

    final Opportunity battle = [SELECT Id FROM Opportunity];
    final OpportunityLineItem winner = [
      SELECT Id, TotalPrice, IsWinner__c
      FROM OpportunityLineItem
      WHERE Product2.Name = 'VerticallyMovingTank'
    ];

    System.assertEquals(1, winner.TotalPrice);
    System.assert(winner.IsWinner__c);
  }

  @isTest
  static void deadTanksHaveZeroQuantity() {
    final List<Product2> tanksModels = [SELECT Id, Name FROM Product2];
    battleOrchestrator.withTanksModels(tanksModels).runBattle();

    final Opportunity battle = [SELECT Id FROM Opportunity];
    final List<OpportunityLineItem> players = [
      SELECT Id, TotalPrice, IsWinner__c
      FROM OpportunityLineItem
      WHERE Product2.Name != 'VerticallyMovingTank'
    ];

    System.assert(players.size() > 0);
    for (OpportunityLineItem player : players) {
      System.assertEquals(0, player.TotalPrice);
      System.assert(!player.IsWinner__c);
    }
  }

  @isTest
  static void setsNumericIdsToBattles() {
    final Integer numberOfBattles = 3;
    for (Integer i = 0; i < numberOfBattles; i++) {
      battleOrchestrator.runBattle();
    }

    final List<Opportunity> battles = [
      SELECT BattleId__c
      FROM Opportunity
      ORDER BY CreatedDate
    ];
    for (Integer i = 0; i < numberOfBattles; i++) {
      final String battleId = 'Battle-00000' + i;
      System.assertEquals(battleId, battles[i].BattleId__c);
    }
  }

  @isTest
  static void setsNumericIdsToPlayers() {
    battleOrchestrator
      .withTanksModels([SELECT Id, Name FROM Product2])
      .runBattle();

    final List<OpportunityLineItem> players = [
      SELECT Id, PlayerId__c
      FROM OpportunityLineItem
    ];

    Integer i = 0;
    for (OpportunityLineItem player : players) {
      final String playerId = 'Battle-000000-Player-000000' + i;
      System.assertEquals(playerId, player.PlayerId__c);
      i++;
    }
  }
}
