public class LifeService {
    private Map<ApexTank, Integer> lifeLevels = new Map<ApexTank, Integer>();

	public LifeService withTank(final ApexTank tank){
        lifeLevels.put(tank, 10);
        return this;
	} 

	public Integer getCurrentLifeLevel(final ApexTank tank){
        return lifeLevels.get(tank);
	} 

	public Boolean modifyLifeLevel(final ApexTank tank, final Integer change){
        final Integer currentLevel = lifeLevels.get(tank);
        if(currentLevel > 0) {
            lifeLevels.put(tank,  Math.max(0, currentLevel + change));
            return true;
        }
        return false;
	} 

	public Boolean isTankAlive(final ApexTank tank){
		return lifeLevels.get(tank) > 0;
	} 
}
