public class LifeService {
  private Integer initialLifeLevel;
  private Map<ApexTank, Integer> lifeLevels = new Map<ApexTank, Integer>();

  private LifeService(final Integer initialLifeLevel) {
    this.initialLifeLevel = initialLifeLevel;
  }

  public static LifeService lifeService(final Integer initialLifeLevel) {
    return new LifeService(initialLifeLevel);
  }

  public LifeService withTank(final ApexTank tank) {
    lifeLevels.put(tank, initialLifeLevel);
    return this;
  }

  public Integer getCurrentLifeLevel(final ApexTank tank) {
    return lifeLevels.get(tank);
  }

  public Boolean modifyLifeLevel(final ApexTank tank, final Integer change) {
    final Integer currentLevel = lifeLevels.get(tank);
    if (currentLevel > 0) {
      lifeLevels.put(tank, Math.max(0, currentLevel + change));
      return true;
    }
    return false;
  }

  public Boolean isTankAlive(final ApexTank tank) {
    return lifeLevels.get(tank) > 0;
  }
}
