- Fork this repository. [Need help with forks?](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- Implement your Tank
    - Create a folder under force-app/main/default/classes/tanks with your _username_, e.g.
    ```
    force-app/main/default/classes/tanks/baksale
    ```
    - Create your Tank class under the folder, e.g. MyBestTank.cls (please be aware, the class name must be  unique)
    ```
    force-app/main/default/classes/tanks/baksale/MyBestTank.cls
    ```
    - Extend your class with [ApexTankBase.cls](force-app/main/default/classes/core/model/ApexTankBase.cls)
    ```
    public class MyBestTank extends ApexTankBase {
    }
    ```
    - Implement methods for move and shoot
    ```
    protected override MoveDirectionEnum nextMoveDirection() {
        return MoveDirectionEnum.NOMOVE;
    }
    protected override Point pointToAttack() {
        return null;
    }
    ```
- Ensure [CandidateFactory.cls#candidate()](force-app/main/default/classes/competition/CandidateFactory.cls) method returns your new tank - this is required to pass basic tests before league competition
```
public ApexTankBase candidate(){
    return new MyBestTank();
}
```
- Raise a PR with tank into this repository and wait for a green build
  
Once all good with the PR, it will be merged to the main repository for leagues competition with other trailblazers tanks.