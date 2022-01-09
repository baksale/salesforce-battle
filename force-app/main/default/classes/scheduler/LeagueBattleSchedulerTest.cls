@isTest
public class LeagueBattleSchedulerTest {
  private final static BattleManager battleOrchestrator = BattleManager.orchestrate()
    .inLeague('Apex')
    .withPriceBook(Test.getStandardPricebookId());

  @TestSetup
  static void makeData() {
    BattleManagerTest.makeData();
  }

  @isTest
  static void runsApexLeagueBattleWithAllModelsAtMidnight() {
    Test.startTest();
    System.schedule(
      'League Competition: Apex',
      LeagueBattleScheduler.CRON_EXPRESSION,
      LeagueBattleScheduler.scheduler()
        .inLeague('Apex')
        .withPriceBook(Test.getStandardPricebookId())
        .withTanksModels([SELECT Id, Name FROM Product2])
    );
    Test.stopTest();

    System.assertEquals(1, [SELECT Id FROM Opportunity].size());
  }
}
