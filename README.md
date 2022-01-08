# Salesforce Battle
Practice :muscle: your Salesforce Platform skills by implementing move and shoot algorithms for your tank.  
Win a league and become a champion :trophy:.  
  
The concept is taken from a popular Robocode game.  
  
- [Mission](#mission)
- [How it works?](#how-does-it-work)
    - [Move](#move)
    - [Attack](#attack)
- [Where to start?](#where-to-start)
- [Roadmap](#roadmap)
    - [Leagues](#leagues)
    - [Leaderboard](#leaderboard)
    - [Visualization](#visualization)

## Mission
Get familiar with many Salesforce Platform Apex capabilities via playing the game with other Trailblazers (kudo to [Trailhead](https://trailhead.salesforce.com/en)).  

## How does it work?
1. The battle happens on a field (e.g. a square 10x10)
1. At the beginning, tanks are placed randomly onto the field
1. On every round two things happen:
    1. tanks move
    1. tanks attack other tanks
1. Tanks with no lifes left are removed from the field
1. The winner is the only tank left after the last round

### Move
Tanks notify engine about their desired move via [ApexTankBase.cls#nextMoveDirection](force-app/main/default/classes/core/model/ApexTankBase.cls) method.  
  
Tanks can make [5 decisions](force-app/main/default/classes/core/model/MoveDirectionEnum.cls) for the next round move:
1. UP
1. RIGHT
1. DOWN
1. LEFT
1. NOMOVE
  
Tanks movements happen during every round *move* phase:
1. Engine iterates over alive tanks in random order
1. Tank is moved in the chosen direction
1. The move fails and the tank remains in the current location:
    1. if there is another tank in the target field already
    1. if there is no field in the target direction
  
Every tank has access to [Radar](force-app/main/default/classes/core/service/Radar.cls) to implement its *move* tactics:
```java
Point coordinateFor(ApexTank tank);
Boolean pathExists(Point relativePoint, MoveDirectionEnum direction);
```  
  
### Attack
Tanks notify engine via [ApexTankBase.cls#pointToAttack](force-app/main/default/classes/core/model/ApexTankBase.cls) method about their attack coordinate for the next round.  
[Radar](force-app/main/default/classes/core/service/Radar.cls) methods allow to implement *attack* strategy:
```java
List<Point> getCoordinatesWithTanks();
ApexTank tankAt(Point point);
```  
  
## Where to start?
Take a look at [CONTRIBUTING.md](./CONTRIUBTING.md) or raise an issue in this repository.
  
## Roadmap
### Leagues
Leagues will be focusing on different aspects of the platform
- Apex League  
basic apex knowledge(loops, variables, data structures)
- Limits  
consume the smallest amount of the platform resources
- Teams  
communicate between tanks to win as a team
- Flows  
implement move tactics or shoot strategy via flows
- ...
### Leaderboard
Use Digital Experience, Reporting, Guest Profile, Contact, Opportunity, etc. platform capabilities to build leaderboard where everyone can see the results.
### Visualization
Implement custom UI via visualforce page or lwc to replay battles visually.
