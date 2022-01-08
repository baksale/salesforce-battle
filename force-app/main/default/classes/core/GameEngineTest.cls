@isTest
public class GameEngineTest {
  private final static LifeService lifeServiceInstance = LifeService.lifeService(
    10
  );
  private final static fflib_ApexMocks mocks = new fflib_ApexMocks();
  private final static FieldService fieldServiceMock = (FieldService) mocks.mock(
    FieldService.class
  );
  private final static HistoryService historyServiceMock = (HistoryService) mocks.mock(
    HistoryService.class
  );

  static {
    mocks.startStubbing();
    mocks.when(
        fieldServiceMock.addTankRandomly((ApexTank) fflib_Match.anyObject())
      )
      .thenReturn(true);
    mocks.when(fieldServiceMock.getCoordinatesWithTanks())
      .thenReturn(new List<Point>());
    mocks.stopStubbing();
  }

  @isTest
  static void placesEveryTankIntoField() {
    final Integer numberOfTanks = 10;
    final ApexTank tank = testTank();
    final GameEngine engine = engine();
    for (Integer i = 0; i < numberOfTanks; i++) {
      engine.withTank(testTank());
    }

    ((FieldService) mocks.verify(fieldServiceMock, numberOfTanks))
      .addTankRandomly((ApexTank) fflib_Match.anyObject());
  }

  @isTest
  static void exceptionIfTanksCannotBePlacedIntoField() {
    final ApexTankBase testTank = testTank();
    mocks.startStubbing();
    mocks.when(fieldServiceMock.addTankRandomly(testTank)).thenReturn(false);
    mocks.stopStubbing();

    Boolean exceptionThrown = false;
    try {
      engine().withTank(testTank);
    } catch (final Exception e) {
      exceptionThrown = true;
    }

    System.assert(
      exceptionThrown,
      'should throw exception if cannot add players anymore'
    );
  }

  @isTest
  static void movesTanksOnEveryRound() {
    final Integer numberOfTanks = 10;
    final Integer numberOfRounds = 20;
    final GameEngine engine = engine().withNumberOfRounds(numberOfRounds);
    for (Integer i = 0; i < numberOfTanks; i++) {
      engine.withTank(testTank().direction(MoveDirectionEnum.UP));
    }

    engine.battle();

    ((FieldService) mocks.verify(
        fieldServiceMock,
        numberOfTanks * numberOfRounds
      ))
      .moveTank(
        (ApexTank) fflib_Match.anyObject(),
        (MoveDirectionEnum) fflib_Match.anyObject()
      );
  }

  @isTest
  static void letsTanksAttackEachOther() {
    final Integer numberOfRounds = 4;
    final TestTank victimTank = testTank();
    final TestTank attackingTank = testTank().attack(victimTank);
    final GameEngine engine = engine()
      .withFieldService(FieldService.service(10, 10))
      .withNumberOfRounds(numberOfRounds)
      .withTank(victimTank)
      .withTank(attackingTank);

    engine.battle();

    System.assertEquals(
      10 - numberOfRounds,
      lifeServiceInstance.getCurrentLifeLevel(victimTank)
    );
    System.assertEquals(
      10,
      lifeServiceInstance.getCurrentLifeLevel(attackingTank)
    );
  }

  @isTest
  static void finishesBattleOnceZeroOrOneTankLeft() {
    final TestTank victimTank = testTank().direction(MoveDirectionEnum.UP);
    final TestTank attackingTank = testTank()
      .direction(MoveDirectionEnum.UP)
      .attack(victimTank);
    final TestTank leaderTank = testTank()
      .direction(MoveDirectionEnum.UP)
      .attack(attackingTank)
      .attack(victimTank);
    final GameEngine engine = engine()
      .withFieldService(FieldService.service(8, 8))
      .withTank(victimTank)
      .withTank(attackingTank)
      .withTank(leaderTank);

    engine.battle();

    System.assertEquals(false, lifeServiceInstance.isTankAlive(victimTank));
    System.assertEquals(false, lifeServiceInstance.isTankAlive(attackingTank));
    System.assertEquals(true, lifeServiceInstance.isTankAlive(leaderTank));
  }

  @isTest
  static void doesNotSelfAttack() {
    final TestTank hippyTank = testTank().direction(MoveDirectionEnum.UP);
    final TestTank selfAttackingTank = testTank()
      .direction(MoveDirectionEnum.UP);
    selfAttackingTank.attack(selfAttackingTank);
    final GameEngine engine = engine()
      .withFieldService(FieldService.service(1, 10))
      .withNumberOfRounds(20)
      .withTank(hippyTank)
      .withTank(selfAttackingTank);

    engine.battle();

    System.assertEquals(true, lifeServiceInstance.isTankAlive(hippyTank));
    System.assertEquals(
      true,
      lifeServiceInstance.isTankAlive(selfAttackingTank)
    );
  }

  @isTest
  static void recordsTanksMoveAttemptsForEveryTank() {
    final Integer numberOfRounds = 10;
    final Integer numberOfTanks = 4;
    final GameEngine engine = engine().withNumberOfRounds(numberOfRounds);
    for (Integer i = 0; i < numberOfTanks; i++) {
      engine.withTank(testTank());
    }

    engine.battle();

    ((HistoryService) mocks.verify(
        historyServiceMock,
        numberOfRounds * numberOfTanks
      ))
      .recordMoveAttempt(
        fflib_Match.anyInteger(),
        (ApexTankBase) fflib_Match.anyObject(),
        (MoveDirectionEnum) fflib_Match.anyObject()
      );
  }

  @isTest
  static void recordsMoveAttemptAndUpdatesStatus() {
    final ApexTankBase testTank = testTank().direction(MoveDirectionEnum.UP);
    final GameEngine engine = engine()
      .withFieldService(FieldService.service(1, 1))
      .withNumberOfRounds(1)
      .withTank(testTank);

    engine.battle();

    ((HistoryService) mocks.verify(historyServiceMock))
      .recordMoveAttempt(0, testTank, MoveDirectionEnum.UP);
    ((HistoryService) mocks.verify(historyServiceMock))
      .updateMoveStatus(0, testTank, false);
  }

  @isTest
  static void recordsTanksAttackForEveryTank() {
    final Integer numberOfRounds = 10;
    final Integer numberOfTanks = 4;
    final GameEngine engine = engine().withNumberOfRounds(numberOfRounds);
    for (Integer i = 0; i < numberOfTanks; i++) {
      engine.withTank(testTank());
    }

    engine.battle();

    ((HistoryService) mocks.verify(
        historyServiceMock,
        numberOfRounds * numberOfTanks
      ))
      .recordAttack(
        fflib_Match.anyInteger(),
        (ApexTankBase) fflib_Match.anyObject(),
        (Point) fflib_Match.isNull()
      );
  }

  @isTest
  static void recordsTankAttackAndStatus() {
    final ApexTankBase victimTank = testTank();
    final ApexTankBase attacker = testTank().attack(victimTank);
    final Point victimLocation = new Point(0, 0);
    final GameEngine engine = engine()
      .withNumberOfRounds(1)
      .withTank(victimTank)
      .withTank(attacker);

    mocks.startStubbing();
    mocks.when(fieldServiceMock.getCoordinatesWithTanks())
      .thenReturn(new List<Point>{ victimLocation });
    mocks.when(fieldServiceMock.tankAt(victimLocation)).thenReturn(victimTank);
    mocks.stopStubbing();

    engine.battle();

    ((HistoryService) mocks.verify(historyServiceMock))
      .recordAttack(0, victimTank, null);
    ((HistoryService) mocks.verify(historyServiceMock))
      .recordAttack(0, attacker, victimLocation);
    ((HistoryService) mocks.verify(historyServiceMock))
      .updateAttackStatus(0, attacker, true);
  }

  private static TestTank testTank() {
    return TestTank.testTank();
  }

  private static GameEngine engine() {
    return GameEngine.getInstance()
      .withFieldService(fieldServiceMock)
      .withLifeService(lifeServiceInstance)
      .withHistoryService(historyServiceMock);
  }
}
