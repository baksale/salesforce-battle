final List<CronTrigger> leagueSchedules = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'League Competition: Apex'];

if(leagueSchedules.size() == 0) {
  Id standardPriceBookId = [SELECT Id FROM PriceBook2 WHERE IsStandard = true].Id;

  System.schedule(
    'League Competition: Apex',
    LeagueBattleScheduler.CRON_EXPRESSION,
    LeagueBattleScheduler.scheduler()
      .inLeague('Apex')
      .withPriceBook(standardPriceBookId)
      .withTanksModels([SELECT Id, Name FROM Product2])
  );
}
