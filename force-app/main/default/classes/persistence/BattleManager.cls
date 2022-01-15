public class BattleManager {
  private String leagueName;
  private Id priceBookId;
  private List<Product2> tanksModels;
  private Integer maxNumberOfRounds;
  private FieldService battleFieldService;
  private LifeService battleLifeService;
  private HistoryService battleHistoryService;

  private GameEngine singleBattle;
  private Opportunity battleOpportunity;

  private Map<ApexTank, OpportunityLineItem> tankPlayerRecords;

  private BattleManager() {
    leagueName = 'Apex';
    tanksModels = new List<Product2>();
    maxNumberOfRounds = 100;
    battleLifeService = LifeService.lifeService(10);
    battleFieldService = FieldService.service(10, 10);
    battleHistoryService = new HistoryService();
    tankPlayerRecords = new Map<ApexTank, OpportunityLineItem>();
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
    setupBattle();

    singleBattle.battle();

    completeBattle();

    return singleBattle;
  }

  private void setupBattle() {
    setupGameEngine();
    ensureOpportunityForBattle();
    setupPlayers();
  }

  private void setupGameEngine() {
    singleBattle = GameEngine.getInstance()
      .withNumberOfRounds(maxNumberOfRounds)
      .withFieldService(battleFieldService)
      .withLifeService(battleLifeService)
      .withHistoryService(battleHistoryService);
  }

  private void ensureOpportunityForBattle() {
    battleOpportunity = battleOpportunity(singleBattle);
    insert battleOpportunity;
  }

  private Opportunity battleOpportunity(final GameEngine battleInTheBeginning) {
    final Account league = [
      SELECT Id, NumberOfBattles__c
      FROM Account
      WHERE League__c = :leagueName
    ];
    final String battleId = calculateBattleId(league.NumberOfBattles__c);
    return new Opportunity(
      AccountId = league.Id,
      BattleId__c = battleId,
      CloseDate = System.today(),
      FieldDefinition__c = battleInTheBeginning.fieldDefinition(),
      InitialLiveLevel__c = battleInTheBeginning.initialLiveLevel,
      MaxRounds__c = battleInTheBeginning.maxNumberOfRounds,
      Name = 'Battle in League: ' + leagueName,
      Pricebook2Id = priceBookId,
      StageName = 'Open'
    );
  }

  private String calculateBattleId(final Decimal numberOfBattles) {
    return 'Battle-' + mask(numberOfBattles, 6);
  }

  private void setupPlayers() {
    for (Integer i = 0; i < tanksModels.size(); i++) {
      final Product2 tankModel = tanksModels[i];
      final ApexTankBase tank = tankFrom(tankModel);
      singleBattle.withTank(tank);
      final OpportunityLineItem player = playerAsOpportunityLineItem(tankModel);
      player.PlayerId__c = calculatePlayerId(i);
      tankPlayerRecords.put(tank, player);
    }
    insert tankPlayerRecords.values();
  }

  private ApexTankBase tankFrom(final Product2 product) {
    final String tankModelClassName = product.Name;
    return (ApexTankBase) Type.forName(tankModelClassName).newInstance();
  }

  private OpportunityLineItem playerAsOpportunityLineItem(
    final Product2 tankModel
  ) {
    return new OpportunityLineItem(
      OpportunityId = battleOpportunity.Id,
      Product2Id = tankModel.Id,
      Quantity = 1,
      TotalPrice = 1
    );
  }

  private String calculatePlayerId(final Integer playerNumberWithinBattle) {
    return battleOpportunity.BattleId__c +
      '-Player-' +
      mask(playerNumberWithinBattle, 7);
  }

  private String mask(final Decimal input, final Integer maskLength) {
    final String digitsAsString = String.valueOf(input);
    String mask = '';
    for (Integer i = digitsAsString.length(); i < maskLength; i++) {
      mask += '0';
    }
    return mask + digitsAsString;
  }

  private void completeBattle() {
    recordHistory();
    updateBattleInfo();
  }

  private void recordHistory() {
    final Set<ApexTank> winners = singleBattle.winners();
    for (ApexTank tank : tankPlayerRecords.keySet()) {
      final OpportunityLineItem battlePlayer = tankPlayerRecords.get(tank);
      battlePlayer.BattleHistory__c = battleHistoryService.getHistory(tank);
      if (!winners.contains(tank)) {
        battlePlayer.TotalPrice = 0;
      } else {
        battlePlayer.IsWinner__c = true;
      }
    }
    update tankPlayerRecords.values();
  }

  private void updateBattleInfo() {
    update new Opportunity(
      Id = battleOpportunity.Id,
      RoundsCompleted__c = singleBattle.numberOfRounds
    );
  }
}
