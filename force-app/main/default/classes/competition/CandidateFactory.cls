@isTest
public class CandidateFactory {

    private CandidateFactory() {}

	public static CandidateFactory getInstane() {
        return new CandidateFactory();
	} 

	public ApexTankBase candidate(){
		return new VerticallyMovingTank();
	} 
}
