@isTest
public class LifeServiceTest {
    private final static LifeService lifeService = new LifeService();

    @isTest static void assignsDefaultLifeLevelToEveryTank() {
        final ApexTank testTank = testTank();
        
        lifeService.withTank(testTank);

        System.assertEquals(10, lifeService.getCurrentLifeLevel(testTank));
    }

    @isTest static void maintainsLifeLevelForEveryTank() {
        final ApexTank firstTank = testTank();
        final Integer firstTankLifeLevelChange = 3;
        final ApexTank secondTank = testTank();
        final Integer secondTankLifeLevelChange = -5;
        
        lifeService
            .withTank(firstTank)
            .withTank(secondTank);

        lifeService.modifyLifeLevel(firstTank, firstTankLifeLevelChange);
        lifeService.modifyLifeLevel(secondTank, secondTankLifeLevelChange);

        System.assertEquals(10 + firstTankLifeLevelChange, lifeService.getCurrentLifeLevel(firstTank));
        System.assertEquals(10 + secondTankLifeLevelChange, lifeService.getCurrentLifeLevel(secondTank));
    }

    @isTest static void lifeLevelCannotBecomeLessThanZero() {
        final ApexTank testTank = testTank();
        
        lifeService.withTank(testTank);

        lifeService.modifyLifeLevel(testTank, -11);

        System.assertEquals(0, lifeService.getCurrentLifeLevel(testTank));
    }

    @isTest static void cannotReanimateDeadTanks() {
        final ApexTank testTank = testTank();
        lifeService.withTank(testTank);
        lifeService.modifyLifeLevel(testTank, -11);

        final Boolean lifeLevelChanged = lifeService.modifyLifeLevel(testTank, +11);

        System.assertEquals(false, lifeLevelChanged);
        System.assertEquals(0, lifeService.getCurrentLifeLevel(testTank));
    }

    @isTest static void tankIsAliveIfLifeLevelIsPositive() {
        final ApexTank testTank = testTank();
        lifeService.withTank(testTank);

        final Boolean tankIsAlive = lifeService.isTankAlive(testTank);
        System.assertEquals(true, tankIsAlive);
        
        lifeService.modifyLifeLevel(testTank, -11);
        System.assertEquals(false, lifeService.isTankAlive(testTank));
    }

    @isTest static void missingTankIsAlwaysDead() {
        System.assertEquals(false, lifeService.isTankAlive(testTank()));
    }


    @isTest static void cannotManageLifeOfMissingTank() {
        System.assertEquals(false, lifeService.modifyLifeLevel(testTank(), 1));
        System.assertEquals(false, lifeService.modifyLifeLevel(null, 1));
    }

    private static TestTank testTank() {
        return TestTank.testTank();
    }
}
