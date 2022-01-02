@isTest
public class GameEngineTest {
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static FieldService fieldServiceMock = (FieldService) mocks.mock(FieldService.class);

    static {
        mocks.startStubbing();
        mocks.when(fieldServiceMock.addTankRandomly((ApexTank) fflib_Match.anyObject())).thenReturn(true);
        mocks.when(fieldServiceMock.getCoordinatesWithTanks()).thenReturn(new Set<Point>());
        mocks.stopStubbing();
    }

    @isTest static void placesEveryTankIntoField() {
        final Integer numberOfTanks = 10;
        final ApexTank tank = testTank();
        final GameEngine engine = engine();
        for(Integer i = 0; i < numberOfTanks; i++) {
            engine.withTank(testTank());
        }

        ((FieldService) mocks.verify(fieldServiceMock, numberOfTanks))
            .addTankRandomly((ApexTank) fflib_Match.anyObject());
    }

    @isTest static void exceptionIfTanksCannotBePlacedIntoField() {
        final ApexTankBase testTank = testTank();
        mocks.startStubbing();
        mocks.when(fieldServiceMock.addTankRandomly(testTank)).thenReturn(false);
        mocks.stopStubbing();

        Boolean exceptionThrown = false;
        try{ 
            engine().withTank(testTank);
        } catch(final Exception e) {
            exceptionThrown = true;
        }

        System.assert(exceptionThrown, 'should throw exception if cannot add players anymore');
    }

    @isTest static void movesTanksOnEveryRound() {
        final Integer numberOfTanks = 10;
        final Integer numberOfRounds = 20;
        final GameEngine engine = engine().withNumberOfRounds(numberOfRounds);
        for(Integer i = 0; i < numberOfTanks; i++) {
            engine.withTank(testTank().direction(MoveDirectionEnum.UP));
        }

        engine.battle();

        ((FieldService) mocks.verify(fieldServiceMock, numberOfTanks * numberOfRounds))
            .moveTank(
                (ApexTank) fflib_Match.anyObject(),
                (MoveDirectionEnum) fflib_Match.anyObject()
            );
    }

    @isTest static void letsTanksAttackEachOther() {
        final LifeService lifeService = new LifeService();
        final Integer numberOfRounds = 4;
        final TestTank victimTank = testTank();
        final TestTank attackingTank = testTank().attack(victimTank);
        final GameEngine engine = engine()
                                    .withLifeService(lifeService)
                                    .withFieldService(FieldService.service(10, 10))
                                    .withNumberOfRounds(numberOfRounds)
                                    .withTank(victimTank)
                                    .withTank(attackingTank);

        engine.battle();

        System.assertEquals(10 - numberOfRounds, lifeService.getCurrentLifeLevel(victimTank));
        System.assertEquals(10, lifeService.getCurrentLifeLevel(attackingTank));
    }

    @isTest static void finishesBattleOnceZeroOrOneTankLeft() {
        final LifeService lifeService = new LifeService();
        final TestTank victimTank = testTank().direction(MoveDirectionEnum.UP);
        final TestTank attackingTank = testTank().direction(MoveDirectionEnum.UP)
                                        .attack(victimTank);
        final TestTank leaderTank = testTank().direction(MoveDirectionEnum.UP)
                                        .attack(attackingTank)
                                        .attack(victimTank);
        final GameEngine engine = engine()
                                    .withLifeService(lifeService)
                                    .withFieldService(FieldService.service(8, 8))
                                    .withTank(victimTank)
                                    .withTank(attackingTank)
                                    .withTank(leaderTank);

        engine.battle();

        System.assertEquals(false, lifeService.isTankAlive(victimTank));
        System.assertEquals(false, lifeService.isTankAlive(attackingTank));
        System.assertEquals(true, lifeService.isTankAlive(leaderTank));
    }

    @isTest static void doesNotSelfAttack() {
        final LifeService lifeService = new LifeService();
        final TestTank hippyTank = testTank().direction(MoveDirectionEnum.UP);
        final TestTank selfAttackingTank = testTank().direction(MoveDirectionEnum.UP);
        selfAttackingTank.attack(selfAttackingTank);
        final GameEngine engine = engine()
                                    .withLifeService(lifeService)
                                    .withFieldService(FieldService.service(1, 10))
                                    .withNumberOfRounds(20)
                                    .withTank(hippyTank)
                                    .withTank(selfAttackingTank);

        engine.battle();

        System.assertEquals(true, lifeService.isTankAlive(hippyTank));
        System.assertEquals(true, lifeService.isTankAlive(selfAttackingTank));
    }

    private static TestTank testTank() {
        return TestTank.testTank();
    }

    private static GameEngine engine() {
        return GameEngine.getInstance()
                .withFieldService(fieldServiceMock);
    }
}
