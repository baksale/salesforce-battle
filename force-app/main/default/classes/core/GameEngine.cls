public class GameEngine {
  public Integer maxNumberOfRounds { get; private set; }
  public Integer numberOfRounds { get; private set; }
  public Integer initialLiveLevel {
    get {
      return this.lifeService.initialLifeLevel;
    }
  }
  private List<ApexTankBase> activePlayers;

  private FieldService fieldService;
  private LifeService lifeService;
  private HistoryService historyService;
  private ScoreService scoreService;

  private GameEngine() {
    this.activePlayers = new List<ApexTankBase>();
    this.maxNumberOfRounds = 100;
    this.numberOfRounds = 0;
  }

  public static GameEngine getInstance() {
    final GameEngine engine = new GameEngine();
    return engine
      .withFieldService(FieldService.service(10, 10))
      .withLifeService(LifeService.lifeService(10))
      .withHistoryService(new HistoryService())
      .withScoreService(ScoreService.service());
  }

  public void battle() {
    do {
      battleRound();
      removeDeadTanksFromTheField();
      numberOfRounds++;
    } while (hasFightingTanks() && hasMoreRounds());
  }

  private void battleRound() {
    final TankMoveVisitor movesVisitor = moveVisitorForRound();
    final TankAttackVisitor attacksVisitor = attackVisitorForRound();
    visitAliveTanks(new List<TankVisitor>{ movesVisitor, attacksVisitor });

    moveTanks(movesVisitor.moves);
    attackTanks(attacksVisitor.attacks);
  }

  private void visitAliveTanks(final List<RoundTankVisitor> visitors) {
    for (ApexTankBase tank : activePlayers) {
      final RoundAction tankAction = tank.getAction();
      for (RoundTankVisitor visitor : visitors) {
        visitor.visit(tank, tankAction);
      }
    }
  }

  private void moveTanks(final Map<ApexTankBase, MoveDirectionEnum> moves) {
    for (ApexTankBase tank : moves.keySet()) {
      final MoveDirectionEnum direction = moves.get(tank);
      final Boolean moveAttemptResult = fieldService.moveTank(tank, direction);
      historyService.updateMoveStatus(numberOfRounds, tank, moveAttemptResult);
    }
  }

  private void attackTanks(final Map<ApexTankBase, Point> attackers) {
    for (ApexTankBase attacker : attackers.keySet()) {
      final Point pointToAttack = attackers.get(attacker);
      final ApexTank tankUnderAttack = fieldService.tankAt(pointToAttack);
      Boolean successfullAttack = false;
      if (!attacker.equals(tankUnderAttack)) {
        final Integer attackScore = 1;
        successfullAttack = lifeService.modifyLifeLevel(tankUnderAttack, -attackScore);
        if (successfullAttack) {
          scoreService.modifyScore(attacker, attackScore);
        }
      }
      historyService.updateAttackStatus(numberOfRounds, attacker, successfullAttack);
    }
  }

  private void removeDeadTanksFromTheField() {
    final List<ApexTankBase> activePlayersSwap = new List<ApexTankBase>();
    for (ApexTankBase tank : activePlayers) {
      if (!lifeService.isTankAlive(tank)) {
        fieldService.removeTank(tank);
      } else {
        activePlayersSwap.add(tank);
      }
    }
    activePlayers = activePlayersSwap;
  }

  private Boolean hasFightingTanks() {
    return activePlayers.size() > 1;
  }

  private Boolean hasMoreRounds() {
    return maxNumberOfRounds > numberOfRounds;
  }

  public GameEngine withTanks(final List<ApexTankBase> players) {
    for (ApexTankBase extraPlayer : players) {
      withTank(extraPlayer);
    }
    return this;
  }

  public GameEngine withTank(final ApexTankBase extraPlayer) {
    if (fieldService.addTankRandomly(extraPlayer)) {
      activePlayers.add(extraPlayer);
      lifeService.withTank(extraPlayer);
      extraPlayer.withRadar(fieldService);
      scoreService.withTank(extraPlayer);
      return this;
    }
    throw new IllegalArgumentException('Cannot add tanks anymore');
  }

  public GameEngine withFieldService(final FieldService fieldService) {
    this.fieldService = fieldService;
    return this;
  }

  public GameEngine withLifeService(final LifeService lifeService) {
    this.lifeService = lifeService;
    return this;
  }

  public GameEngine withHistoryService(final HistoryService historyService) {
    this.historyService = historyService;
    return this;
  }

  public GameEngine withScoreService(final ScoreService scoreService) {
    this.scoreService = scoreService;
    return this;
  }

  public GameEngine withNumberOfRounds(final Integer maximumNumberOfRounds) {
    this.maxNumberOfRounds = maximumNumberOfRounds;
    return this;
  }

  private abstract class TankVisitor implements RoundTankVisitor {
    protected Integer roundNumber;
    protected HistoryService historyService;

    public TankVisitor withRoundNumber(final Integer roundNumber) {
      this.roundNumber = roundNumber;
      return this;
    }

    public TankVisitor withHistoryService(final HistoryService historyService) {
      this.historyService = historyService;
      return this;
    }
  }

  private TankMoveVisitor moveVisitorForRound() {
    final TankMoveVisitor visitor = new TankMoveVisitor();
    setupVisitor(visitor);
    return visitor;
  }

  private void setupVisitor(final TankVisitor visitor) {
    visitor.withRoundNumber(numberOfRounds);
    visitor.withHistoryService(historyService);
  }

  private class TankMoveVisitor extends TankVisitor {
    private Map<ApexTankBase, MoveDirectionEnum> moves = new Map<ApexTankBase, MoveDirectionEnum>();

    public void visit(final ApexTankBase apexTank, final RoundAction tankAction) {
      final MoveDirectionEnum direction = tankAction.direction;
      historyService.recordMoveAttempt(roundNumber, apexTank, tankAction.direction);
      if (MoveDirectionEnum.NOMOVE != direction) {
        moves.put(apexTank, direction);
      }
    }
  }

  public TankAttackVisitor attackVisitorForRound() {
    final TankAttackVisitor visitor = new TankAttackVisitor();
    setupVisitor(visitor);
    return visitor;
  }

  private class TankAttackVisitor extends TankVisitor {
    private Map<ApexTankBase, Point> attacks = new Map<ApexTankBase, Point>();

    public void visit(final ApexTankBase apexTank, final RoundAction tankAction) {
      final Point coordinateToAttack = tankAction.coordinateToAttack;
      historyService.recordAttack(roundNumber, apexTank, coordinateToAttack);
      if (null != coordinateToAttack) {
        attacks.put(apexTank, coordinateToAttack);
      }
    }
  }

  public Set<ApexTank> winners() {
    final Set<ApexTank> winners = new Set<ApexTank>();
    for (ApexTankBase leftPlayer : activePlayers) {
      winners.add(leftPlayer);
    }
    return winners;
  }

  public String fieldDefinition() {
    return fieldService.definition();
  }
}
