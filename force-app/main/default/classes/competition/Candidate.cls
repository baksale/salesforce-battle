public class Candidate {
    public Integer fieldSizeX {get; private set;}
    public Integer fieldSizeY {get; private set;}

    private Candidate() {
        fieldSizeX = 10;
        fieldSizeY = 10;
    }
    public static Candidate candidate() {
        return new Candidate();
    }
}
