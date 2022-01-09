@isTest
public class PriceBookEntryForEachProductTest {
  @isTest(SeeAllData=true)
  static void createsStandardPriceBookEntryForEveryTankModel() {
    final Product2 brandNewTank = new Product2(
      Name = 'Tiger',
      TankModel__c = 'Tiger',
      Family = 'Tank Models'
    );
    insert brandNewTank;

    final PricebookEntry entryForNewModel = [
      SELECT Id, Pricebook2Id
      FROM PricebookEntry
      WHERE Product2Id = :brandNewTank.Id
    ];

    System.assertNotEquals(
      null,
      entryForNewModel,
      'no entry in standard price book'
    );
    System.assertEquals(
      Test.getStandardPricebookId(),
      entryForNewModel.Pricebook2Id
    );
  }
}
