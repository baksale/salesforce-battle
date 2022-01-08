public class BattleManager {
  private String leagueName = 'Apex League';
  private Map<GameEngine, Opportunity> battleOpportunities = new Map<GameEngine, Opportunity>();

  public Opportunity createBattleOpportunity(final GameEngine singleGame) {
    final Opportunity battleOpportunity = battleOpportunity(singleGame);
    insert battleOpportunity;
    battleOpportunities.put(singleGame, battleOpportunity);
    return battleOpportunity;
  }

  private Opportunity battleOpportunity(final GameEngine gameBeforeStart) {
    final Account apexLeague = [
      SELECT Id
      FROM Account
      WHERE Name = :leagueName
    ];
    return new Opportunity(
      Name = 'Test',
      StageName = 'Open',
      CloseDate = System.today(),
      AccountId = apexLeague.Id,
      FieldDefinition__c = gameBeforeStart.fieldDefinition(),
      MaxRounds__c = gameBeforeStart.maxNumberOfRounds,
      InitialLiveLevel__c = gameBeforeStart.initialLiveLevel,
      Players__c = gameBeforeStart.initialNumberOfPlayers,
      Pricebook2Id = Test.getStandardPricebookId()
    );
  }

  public GameEngine completeBattle(final GameEngine completedGame) {
    update new Opportunity(
      Id = battleOpportunities.get(completedGame).Id,
      RoundsCompleted__c = completedGame.numberOfRounds,
      Players__c = completedGame.initialNumberOfPlayers,
      Winners__c = completedGame.winners().size()
    );
    return completedGame;
  }

  public BattleManager inLeague(final String leagueName) {
    this.leagueName = leagueName;
    return this;
  }

  public GameEngine runBattle() {
    final GameEngine singleBattle = GameEngine.getInstance();
    final Opportunity battleOpportunity = createBattleOpportunity(singleBattle);
    final List<Product2> tanksModels = [SELECT Id, Name FROM Product2];
    final List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
    for (Product2 tankModel : tanksModels) {
      singleBattle.withTank(modelInstance(tankModel));
      olis.add(player(battleOpportunity, tankModel));
    }
    insert olis;
    singleBattle.battle();
    return completeBattle(singleBattle);
  }
  private ApexTankBase modelInstance(final Product2 product) {
    final String modelClassName = product.Name;
    return (ApexTankBase) Type.forName(modelClassName).newInstance();
  }

  private OpportunityLineItem player(
    final Opportunity battle,
    final Product2 tankModel
  ) {
    return new OpportunityLineItem(
      OpportunityId = battle.Id,
      Product2Id = tankModel.Id,
      Quantity = 1,
      TotalPrice = 1
    );
  }
}
