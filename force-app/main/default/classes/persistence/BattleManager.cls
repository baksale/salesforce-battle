public class BattleManager {
  private String leagueName = 'Apex League';
  // private Map<String, Product2> productsByName {
  //   get {
  //     if(null == productsByName) {
  //       productsByName = new Map<String, Product2>();
  //       for(Product2 tankModel: [SELECT Name FROM Product2]) {
  //         productsByName.put(tankModel.Name, tankModel);
  //       }
  //     }
  //     return productsByName;
  //   }
  //   set;
  // }
  private Map<GameEngine, Opportunity> battleOpportunities = new Map<GameEngine, Opportunity>();

  public Opportunity createBattleOpportunity(final GameEngine singleGame) {
    final Opportunity battleOpportunity = battleOpportunity(singleGame);
    insert battleOpportunity;
    battleOpportunities.put(singleGame, battleOpportunity);
    return battleOpportunity;
  }

  public GameEngine runBattle(final GameEngine singleGame) {
    // final List<OpportunityLineItem> players = new List<OpportunityLineItem>();
    // for(ApexTankBase tank: singleGame.joinedPlayers) {
    //   final OpportunityLineItem oli = player(tank);
    //   oli.OpportunityId = battleOpportunity.Id;
    //   oli.Product2Id = productsByName.get(tank.getType().toString());
    //   players.add(oli);
    // }
    // insert players;

    singleGame.battle();
    // final Opportunity completedBattle = completeBattle(singleGame);
    // completedBattle.Id = battleOpportunity.Id;
    // update completedBattle;
    return singleGame;
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
    runBattle(singleBattle);
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
