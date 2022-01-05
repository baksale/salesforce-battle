@isTest
public class CandidateTest {

    @isTest static void shouldWinAllPiecefullTanks() {
        competeWithTanks(PiecefulTank.class);
    }

    @isTest static void shouldWinAllTowerTanks() {
        competeWithTanks(TowerTank.class);
    }

    private static void competeWithTanks(final Type tankType) {
        final ApexTankBase candidate = CandidateFactory.getInstane().candidate();
        System.assertNotEquals(null, candidate, 'CandidateFactory to return candidate tank instance');

        final GameEngine engine = GameEngine.getInstance()
                                    .withFieldService(FieldService.service(10, 10))
                                    .withLifeService(LifeService.lifeService(5))
                                    .withNumberOfRounds(100)
                                    .withTank(candidate);
        final List<ApexTankBase> competitors = CompetitorsProvider.getInstance()
                                                .competitors(10, tankType);
        for(ApexTankBase competitor: competitors) {
            engine.withTank(competitor);
        }

        engine.battle();

        final Set<ApexTank> winners = engine.winners();
        System.assert(winners.contains(candidate), 'candidate lost to tanks: ' + tankType);
        System.assertEquals(1, winners.size(), 'candidate should be the only winner');
    }
}
