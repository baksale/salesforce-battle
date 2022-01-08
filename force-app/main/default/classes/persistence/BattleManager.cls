public class BattleManager {
  private String leagueName;
  private Id priceBookId;
  private List<Product2> tanksModels;
  private Integer maxNumberOfRounds;
  private FieldService battleFieldService;
  private LifeService battleLifeService;
  private Map<GameEngine, Opportunity> battleOpportunities = new Map<GameEngine, Opportunity>();

  private BattleManager() {
    leagueName = 'Apex League';
    tanksModels = new List<Product2>();
    maxNumberOfRounds = 100;
    battleLifeService = LifeService.lifeService(10);
    battleFieldService = FieldService.service(10, 10);
  }

  public static BattleManager orchestrate() {
    return new BattleManager();
  }

  public BattleManager inLeague(final String leagueName) {
    this.leagueName = leagueName;
    return this;
  }

  public BattleManager withPriceBook(final Id priceBookId) {
    this.priceBookId = priceBookId;
    return this;
  }

  public BattleManager withTanksModels(final List<Product2> tanksModels) {
    for (Product2 tankModel : tanksModels) {
      withTankModel(tankModel);
    }
    return this;
  }

  public BattleManager withTankModel(final Product2 tankModel) {
    tanksModels.add(tankModel);
    return this;
  }

  public BattleManager withMaxNumberOfRounds(final Integer maxNumberOfRounds) {
    this.maxNumberOfRounds = maxNumberOfRounds;
    return this;
  }

  public BattleManager withFieldService(final FieldService fieldService) {
    this.battleFieldService = fieldService;
    return this;
  }

  public BattleManager withLifeService(final LifeService lifeService) {
    this.battleLifeService = lifeService;
    return this;
  }

  public GameEngine runBattle() {
    final GameEngine singleBattle = GameEngine.getInstance()
      .withNumberOfRounds(maxNumberOfRounds)
      .withFieldService(battleFieldService)
      .withLifeService(battleLifeService);
    final Opportunity battleOpportunity = ensureOpportunityFor(singleBattle);
    final List<OpportunityLineItem> battlePlayers = new List<OpportunityLineItem>();
    for (Product2 tankModel : tanksModels) {
      singleBattle.withTank(tankFrom(tankModel));
      battlePlayers.add(
        playerAsOpportunityLineItem(battleOpportunity, tankModel)
      );
    }
    insert battlePlayers;
    singleBattle.battle();
    return completeBattle(singleBattle);
  }

  private Opportunity ensureOpportunityFor(final GameEngine singleBattle) {
    final Opportunity battleOpportunity = battleOpportunity(singleBattle);
    insert battleOpportunity;
    battleOpportunities.put(singleBattle, battleOpportunity);
    return battleOpportunity;
  }

  private Opportunity battleOpportunity(final GameEngine battleInTheBeginning) {
    return new Opportunity(
      Name = 'Test',
      StageName = 'Open',
      CloseDate = System.today(),
      AccountId = [SELECT Id FROM Account WHERE Name = :leagueName]
      .Id,
      FieldDefinition__c = battleInTheBeginning.fieldDefinition(),
      MaxRounds__c = battleInTheBeginning.maxNumberOfRounds,
      InitialLiveLevel__c = battleInTheBeginning.initialLiveLevel,
      Players__c = battleInTheBeginning.initialNumberOfPlayers,
      Pricebook2Id = priceBookId
    );
  }

  private ApexTankBase tankFrom(final Product2 product) {
    final String tankModelClassName = product.Name;
    return (ApexTankBase) Type.forName(tankModelClassName).newInstance();
  }

  private OpportunityLineItem playerAsOpportunityLineItem(
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

  private GameEngine completeBattle(final GameEngine completedGame) {
    update new Opportunity(
      Id = battleOpportunities.get(completedGame).Id,
      RoundsCompleted__c = completedGame.numberOfRounds,
      Players__c = completedGame.initialNumberOfPlayers,
      Winners__c = completedGame.winners().size()
    );
    return completedGame;
  }
}
