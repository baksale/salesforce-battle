@isTest
public class GameEngineTest {
    private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
    private final static FieldService fieldServiceMock = (FieldService) mocks.mock(FieldService.class);

    static {
        mocks.startStubbing();
        mocks.when(fieldServiceMock.addTankRandomly((ApexTank) fflib_Match.anyObject())).thenReturn(true);
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
        final GameEngine engine = engine();
        for(Integer i = 0; i < numberOfTanks; i++) {
            engine.withTank(testTank());
        }

        for(Integer i = 0; i < numberOfRounds; i++) {
            engine.battleRound();
        }

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
        final TestTank attackingTank = testTank(victimTank);
        final GameEngine engine = engine()
                                    .withLifeService(lifeService)
                                    .withFieldService(FieldService.service(10, 10))
                                    .withTank(victimTank)
                                    .withTank(attackingTank);

        for(Integer i = 0; i < numberOfRounds; i++) {
            engine.battleRound();
        }

        System.assertEquals(10 - numberOfRounds, lifeService.getCurrentLifeLevel(victimTank));
        System.assertEquals(10, lifeService.getCurrentLifeLevel(attackingTank));
    }

    private static TestTank testTank() {
        return TestTank.testTank();
    }

    private static TestTank testTank(final ApexTank tankToAttack) {
        return TestTank.testTank(tankToAttack);
    }

    private static GameEngine engine() {
        return GameEngine.getInstance()
                .withFieldService(fieldServiceMock);
    }
}
