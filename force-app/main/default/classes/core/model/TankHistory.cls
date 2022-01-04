public class TankHistory {
    private List<RoundHistory> rounds;
    public TankHistory() {
        rounds = new List<RoundHistory>();
    }

	public RoundHistory getRoundRecord(final Integer round){
		return rounds.get(round);
	} 

	public RoundHistory ensureRoundHistory(final Integer roundNumber){
		if(rounds.size() < roundNumber + 1) {
			rounds.add(new RoundHistory());
		}
		return rounds.get(roundNumber);
	} 
}
