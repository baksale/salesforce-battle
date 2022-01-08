@isTest
public class BattleManagerTest {
  private final static BattleManager battleOrchestrator = new BattleManager();

  @isTest
  static void persistsEveryBattleAsOpportunity() {
    final Integer numberOfBattles = 3;
    for (Integer i = 0; i < numberOfBattles; i++) {
      battleOrchestrator.runBattle(GameEngine.getInstance());
    }

    System.assertEquals(numberOfBattles, [SELECT Id FROM Opportunity].size());
  }
}
