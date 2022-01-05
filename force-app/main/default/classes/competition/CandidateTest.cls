@isTest
public class CandidateTest {

    @isTest static void shouldWinAllPiecefullTanks() {
        final ApexTankBase candidate = CandidateFactory.getInstane().candidate();
        System.assertNotEquals(null, candidate, 'CandidateFactory to return candidate tank instance');

        final GameEngine engine = GameEngine.getInstance()
                                    .withFieldService(FieldService.service(10, 10))
                                    .withLifeService(LifeService.lifeService(5))
                                    .withNumberOfRounds(100)
                                    .withTank(candidate);
        final List<ApexTankBase> competitors = CompetitorsProvider.getInstance()
                                                .competitors(10, PiecefulTank.class);
        for(ApexTankBase competitor: competitors) {
            engine.withTank(competitor);
        }

        engine.battle();

        final Set<ApexTank> winners = engine.winners();
        System.assert(winners.contains(candidate), 'candidate lost to piecefull tanks');
        System.assertEquals(1, winners.size(), 'candidate should be the only winner');
    }

    @isTest static void shouldWinTowerTanksInMoreThanHalfBattles() {
        final ApexTankBase candidate = CandidateFactory.getInstane().candidate();
        final Integer numberOfBattles = 10;
        Integer victories = 0;
        for(Integer i = 0; i< numberOfBattles; i++) {
            final GameEngine engine = GameEngine.getInstance()
                                        .withFieldService(FieldService.service(10, 10))
                                        .withLifeService(LifeService.lifeService(5))
                                        .withNumberOfRounds(100)
                                        .withTank(candidate);
            final List<ApexTankBase> competitors = CompetitorsProvider.getInstance()
                                                        .competitors(10, TowerTank.class);
            for(ApexTankBase competitor: competitors) {
                engine.withTank(competitor);
            }

            engine.battle();

            final Set<ApexTank> winners = engine.winners();
            if(winners.contains(candidate)) {
                victories++;
            }
        }
        System.assert(victories > 0.5 * numberOfBattles, 'won in ' + victories + ' out of ' + numberOfBattles);
    }
}
