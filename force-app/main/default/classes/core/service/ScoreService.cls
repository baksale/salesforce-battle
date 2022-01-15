public class ScoreService {
  private final Map<ApexTank, Integer> scores;
  private ScoreService() {
    scores = new Map<ApexTank, Integer>();
  }
  public static ScoreService service() {
    return new ScoreService();
  }

  public ScoreService withTank(final ApexTank tank) {
    scores.put(tank, 0);
    return this;
  }

  public Integer scoreOf(final ApexTank tank) {
    Integer score = 0;
    if (scores.containsKey(tank)) {
      score = scores.get(tank);
    }
    return score;
  }

  public void modifyScore(final ApexTank tank, final Integer scoreChange) {
    if (scores.containsKey(tank)) {
      final Integer currentScore = scores.get(tank);
      scores.put(tank, currentScore + scoreChange);
    }
  }
}
