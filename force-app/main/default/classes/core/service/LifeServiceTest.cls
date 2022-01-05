@isTest
public class LifeServiceTest {
    private final static LifeService lifeServiceInstance = LifeService.lifeService(10);

    @isTest static void assignsDefaultLifeLevelToEveryTank() {
        final ApexTank testTank = testTank();
        
        lifeServiceInstance.withTank(testTank);

        System.assertEquals(10, lifeServiceInstance.getCurrentLifeLevel(testTank));
    }

    @isTest static void maintainsLifeLevelForEveryTank() {
        final ApexTank firstTank = testTank();
        final Integer firstTankLifeLevelChange = 3;
        final ApexTank secondTank = testTank();
        final Integer secondTankLifeLevelChange = -5;
        
        lifeServiceInstance
            .withTank(firstTank)
            .withTank(secondTank);

        lifeServiceInstance.modifyLifeLevel(firstTank, firstTankLifeLevelChange);
        lifeServiceInstance.modifyLifeLevel(secondTank, secondTankLifeLevelChange);

        System.assertEquals(10 + firstTankLifeLevelChange, lifeServiceInstance.getCurrentLifeLevel(firstTank));
        System.assertEquals(10 + secondTankLifeLevelChange, lifeServiceInstance.getCurrentLifeLevel(secondTank));
    }

    @isTest static void lifeLevelCannotBecomeLessThanZero() {
        final ApexTank testTank = testTank();
        
        lifeServiceInstance.withTank(testTank);

        lifeServiceInstance.modifyLifeLevel(testTank, -11);

        System.assertEquals(0, lifeServiceInstance.getCurrentLifeLevel(testTank));
    }

    @isTest static void cannotReanimateDeadTanks() {
        final ApexTank testTank = testTank();
        lifeServiceInstance.withTank(testTank);
        lifeServiceInstance.modifyLifeLevel(testTank, -11);

        final Boolean lifeLevelChanged = lifeServiceInstance.modifyLifeLevel(testTank, +11);

        System.assertEquals(false, lifeLevelChanged);
        System.assertEquals(0, lifeServiceInstance.getCurrentLifeLevel(testTank));
    }

    @isTest static void tankIsAliveIfLifeLevelIsPositive() {
        final ApexTank testTank = testTank();
        lifeServiceInstance.withTank(testTank);

        final Boolean tankIsAlive = lifeServiceInstance.isTankAlive(testTank);
        System.assertEquals(true, tankIsAlive);
        
        lifeServiceInstance.modifyLifeLevel(testTank, -11);
        System.assertEquals(false, lifeServiceInstance.isTankAlive(testTank));
    }

    @isTest static void missingTankIsAlwaysDead() {
        System.assertEquals(false, lifeServiceInstance.isTankAlive(testTank()));
    }


    @isTest static void cannotManageLifeOfMissingTank() {
        System.assertEquals(false, lifeServiceInstance.modifyLifeLevel(testTank(), 1));
        System.assertEquals(false, lifeServiceInstance.modifyLifeLevel(null, 1));
    }

    private static TestTank testTank() {
        return TestTank.testTank();
    }
}
