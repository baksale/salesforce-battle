@isTest
public class CompetitorsProvider {

	public static CompetitorsProvider getInstance(){
        return new CompetitorsProvider();
	}

    public List<ApexTankBase> competitors(final Integer amount, final Type instance) {
        final List<ApexTankBase> result = new List<ApexTankBase>();
        for(Integer i = 0; i < amount; i++) {
            result.add((ApexTankBase) instance.newInstance());
        }
        return result;
    }
}
