- Fork this repository. [Need help with forks?](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- Clone the forked repository to local machine
- Open the local copy with your favourite IDE
- You can run the [scratch-org-setup.sh](scratch-org-setup.sh) script to prepare Scratch Org or perform the below steps manually:
  - Create a scratch org using [project-scratch-def.json](config/project-scratch-def.json)
  - Deploy [fflib Apex Mocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks) to the scratch org
  - Push project source to the scratch org
  - Import Battle static data and previous Battle Stats
  ```bash
  ./scripts/import-data.sh
  ```
- You can run a test battle via Anonymous Apex from Developer Console

```
Id stdPB = [SELECT Id FROM PriceBook2 WHERE IsStandard = true].Id;
BattleManager.orchestrate()
    .withPriceBook(stdPB)
    .withTanksModels([SELECT Id, Name FROM Product2 WHERE TankModel__c != null])
    .runBattle();
```

- Implement your Tank
  - Create a folder under force-app/main/default/classes/tanks with your _username_, e.g.
  ```
  force-app/main/default/classes/tanks/baksale
  ```
  - Create your Tank class under the folder, e.g. MyBestTank.cls (please be aware, the class name must be unique)
  ```
  force-app/main/default/classes/tanks/baksale/MyBestTank.cls
  ```
  - Extend your class with [ApexTankBase.cls](force-app/main/default/classes/core/model/ApexTankBase.cls)
  ```
  public class MyBestTank extends ApexTankBase {
  }
  ```
  - Implement methods to move and shoot
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

- Once the code is deployed to the scratch org, please esnure [CandidateTest.cls](force-app/main/default/classes/competition/CandidateTest.cls) is green
- Raise a PR with tank into this repository and wait for a feedback

Once all good with the PR, it will be merged to the main repository for leagues competition with other trailblazers tanks.

```
Id stdPB = [SELECT Id FROM PriceBook2 WHERE IsStandard = true].Id;
BattleManager.orchestrate()
    .withTanksModels([SELECT Name FROM Product2])
    .runBattle();
```
