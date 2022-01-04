@isTest
public class CandidateTest {
    private final static Candidate candidateTest = Candidate.candidate();

    @isTest static void willCompeteOnField_10x10() {
        System.assertEquals(10, candidateTest.fieldSizeX);
        System.assertEquals(10, candidateTest.fieldSizeY);
    }
}
