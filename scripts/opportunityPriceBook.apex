final Id stdPbId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true].Id;
final List<Opportunity> battles = [SELECT Id FROM Opportunity WHERE Account.League__c != null];
for(Opportunity battle: battles) {
  battle.Pricebook2Id = stdPbId;
}

update battles;
