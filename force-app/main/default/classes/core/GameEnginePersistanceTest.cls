@isTest
public class GameEnginePersistanceTest {
    private final static GameEngine engine = GameEngine.getInstance();

    @isTest static void createsBattleRecordForEveryBattle() {
        final Integer numberOfBattles = 4;

        for(Integer i = 0; i < numberOfBattles; i++) {
            engine.battle();
        }

        final List<Battle__c> allBattles = [SELECT Id FROM Battle__c];
        System.assertEquals(numberOfBattles, allBattles.size());
    }
}
