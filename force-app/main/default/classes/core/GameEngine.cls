public class GameEngine {
    private Integer maxNumberOfRounds = 100;
    private Integer numberOfRounds = 0;
    private List<ApexTankBase> activePlayers;

    private FieldService fieldService;
    private LifeService lifeService;
    private HistoryService historyService;

    private GameEngine() {
        this.activePlayers = new List<ApexTankBase>();
    }

	public static GameEngine getInstance(){
        final GameEngine engine = new GameEngine();
        return engine
                .withFieldService(FieldService.service(10, 10))
                .withLifeService(new LifeService())
                .withHistoryService(new HistoryService());
	}

	public void battle(){
        do {
            battleRound();
            removeDeadTanksFromTheField();
            numberOfRounds++;
        } while (hasFightingTanks() && hasMoreRounds());
	}

	private void battleRound() {
        final TankMoveVisitor movesVisitor = moveVisitor();
        movesVisitor
            .withRoundNumber(numberOfRounds)
            .withHistoryService(historyService);

        final TankAttackVisitor attacksVisitor = attackVisitor();
        attacksVisitor
            .withRoundNumber(numberOfRounds)
            .withHistoryService(historyService);        
        visitAliveTanks(new List<TankVisitor>{movesVisitor, attacksVisitor});

        moveTanks(movesVisitor.moves);
        attackTanks(attacksVisitor.attacks);
	}
    private void visitAliveTanks(final List<RoundTankVisitor> visitors) {
        for(ApexTankBase tank: activePlayers) {
            final RoundAction tankAction = tank.getAction();
            for(RoundTankVisitor visitor: visitors) {
                visitor.visit(tank, tankAction);
            }
        }
    }
    private void moveTanks(final Map<ApexTankBase, MoveDirectionEnum> moves) {
        for(ApexTankBase tank: moves.keySet()) {
            final MoveDirectionEnum direction = moves.get(tank);
            final Boolean moveAttemptResult = fieldService.moveTank(tank, direction);
            historyService.updateMoveStatus(numberOfRounds, tank, moveAttemptResult);
        }
    }
    private void attackTanks(final Map<ApexTankBase, Point> attackers) {
        for(ApexTankBase attacker: attackers.keySet()) {
            final Point pointToAttack = attackers.get(attacker);
            final ApexTank tankUnderAttack = fieldService.tankAt(pointToAttack);
            if(!attacker.equals(tankUnderAttack)) {
                lifeService.modifyLifeLevel(tankUnderAttack, -1);
            }
        }

    }
    private void removeDeadTanksFromTheField() {
        final Set<Integer> tankIndexesToRemove = collectDeadTanksIndexes();
        for(Integer removeIndex: tankIndexesToRemove) {
            final ApexTankBase tankToRemove = activePlayers.remove(removeIndex);
            fieldService.removeTank(tankToRemove);
        }
    }

    private Set<Integer> collectDeadTanksIndexes() {
        final Set<Integer> result = new Set<Integer>();
        for(Integer i = 0; i < activePlayers.size(); i++) {
            if(!lifeService.isTankAlive(activePlayers.get(i))) {
                result.add(i);
            }
        }
        return result;
    }

    private Boolean hasFightingTanks() {
        return activePlayers.size() > 1;
    }

    private Boolean hasMoreRounds() {
        return maxNumberOfRounds > numberOfRounds;
    }

	public GameEngine withTanks(final List<ApexTankBase> players){
        for(ApexTankBase extraPlayer: players) {
            withTank(extraPlayer);
        }
        return this;
	} 

	public GameEngine withTank(final ApexTankBase extraPlayer){
        if(fieldService.addTankRandomly(extraPlayer)) {
            activePlayers.add(extraPlayer);
            lifeService.withTank(extraPlayer);
            extraPlayer.withRadar(fieldService);
            return this;
        }
        throw new IllegalArgumentException('Cannot add tanks anymore');
	}

    @TestVisible
	private GameEngine withFieldService(final FieldService fieldService){
        this.fieldService = fieldService;
        return this;
	}

    @TestVisible
	private GameEngine withLifeService(final LifeService lifeService){
        this.lifeService = lifeService;
        return this;
	}

    @TestVisible
	private GameEngine withHistoryService(final HistoryService historyService){
        this.historyService = historyService;
        return this;
	}

    @TestVisible
	private GameEngine withNumberOfRounds(final Integer maximumNumberOfRounds){
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

    public static TankMoveVisitor moveVisitor() {
        return new TankMoveVisitor();
    }
    private class TankMoveVisitor extends TankVisitor {
        private Map<ApexTankBase, MoveDirectionEnum> moves = new Map<ApexTankBase, MoveDirectionEnum>();
        public void visit(final ApexTankBase apexTank, final RoundAction tankAction) {
            final MoveDirectionEnum direction = tankAction.direction;
            historyService.recordMoveAttempt(roundNumber, apexTank, tankAction.direction);
            if(MoveDirectionEnum.NOMOVE != direction) {
                moves.put(apexTank, direction);
            }
        }
    }

    public static TankAttackVisitor attackVisitor() {
        return new TankAttackVisitor();
    }
    private class TankAttackVisitor extends TankVisitor {
        private Map<ApexTankBase, Point> attacks = new Map<ApexTankBase, Point>();

        public void visit(final ApexTankBase apexTank, final RoundAction tankAction) {
            final Point coordinateToAttack = tankAction.coordinateToAttack;
            historyService.recordAttack(roundNumber, apexTank, coordinateToAttack);            
            if(null != coordinateToAttack) {
                attacks.put(apexTank, coordinateToAttack);
            }
        }
    }
}