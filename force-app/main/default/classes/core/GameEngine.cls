public class GameEngine {
    private Integer maxNumberOfRounds = 100;
    private Integer numberOfRounds = 0;
    private List<ApexTank> initialListOfPlayersTanks;

    private FieldService fieldService;
    private LifeService lifeService;

    private GameEngine() {
        this.initialListOfPlayersTanks = new List<ApexTank>();
    }

	public static GameEngine getInstance(){
        final GameEngine engine = new GameEngine();
        return engine
                .withFieldService(new FieldService())
                .withLifeService(new LifeService());
	}

	public void battle(){
        do {
            battleRound();
            final Set<Integer> indexesToRemove = new Set<Integer>();
            for(Integer i = 0; i < initialListOfPlayersTanks.size(); i++) {
                if(!lifeService.isTankAlive(initialListOfPlayersTanks.get(i))) {
                    indexesToRemove.add(i);
                }
            }
            for(Integer removeIndex: indexesToRemove) {
                initialListOfPlayersTanks.remove(removeIndex);
            }
        } while (initialListOfPlayersTanks.size() > 1 && numberOfRounds < maxNumberOfRounds);
	}

	public void battleRound(){
        numberOfRounds++;
        final List<Point> pointsToAttack = new List<Point>();
        for(ApexTank tank: initialListOfPlayersTanks) {
            final RoundAction tankAction = tank.getAction();
            fieldService.moveTank(tank, tankAction.direction);
            pointsToAttack.add(tankAction.coordinateToAttack);
        }
        for(Point pointToAttack: pointsToAttack) {
            final ApexTank tankAtPoint = fieldService.tankAt(pointToAttack);
            if(null != tankAtPoint) {
                lifeService.modifyLifeLevel(tankAtPoint, -1);
            }
        }
	}

	public GameEngine withTanks(final List<ApexTankBase> players){
        for(ApexTankBase extraPlayer: players) {
            withTank(extraPlayer);
        }
        return this;
	} 

	public GameEngine withTank(final ApexTankBase extraPlayer){
        if(fieldService.addTankRandomly(extraPlayer)) {
            initialListOfPlayersTanks.add(extraPlayer);
            lifeService.withTank(extraPlayer);
            extraPlayer
                .withTanksLocator(fieldService);
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
}