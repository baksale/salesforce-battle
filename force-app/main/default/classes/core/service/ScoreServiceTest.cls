@isTest
public class ScoreServiceTest {
  private static final ScoreService service = ScoreService.service();

  @isTest
  static void addsEachTankWithNoScore() {
    final ApexTankBase tank1 = testTank();
    final ApexTankBase tank2 = testTank();

    service.withTank(tank1).withTank(tank2);

    System.assertEquals(0, service.scoreOf(tank1));
    System.assertEquals(0, service.scoreOf(tank2));
  }

  @isTest
  static void scoreOfAbsentTankIsZero() {
    System.assertEquals(0, service.scoreOf(testTank()));
  }

  @isTest
  static void managesTankScore() {
    final Integer scoreIncrease = 3;
    final Integer increaseTimes = 2;
    final ApexTankBase tank = testTank();

    service.withTank(tank);

    for (Integer i = 0; i < increaseTimes; i++) {
      service.modifyScore(tank, scoreIncrease);
    }

    System.assertEquals(scoreIncrease * increaseTimes, service.scoreOf(tank));
  }

  @isTest
  static void doesNotManageScoreForAbsentTank() {
    final Integer scoreIncrease = 3;
    final ApexTankBase tank = testTank();

    service.modifyScore(tank, scoreIncrease);

    System.assertEquals(0, service.scoreOf(tank));
  }

  static ApexTankBase testTank() {
    return TestTank.testTank();
  }
}
