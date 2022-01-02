@isTest
public class FieldServiceTest {
    @isTest static void hasRectangularArea() {
        final Integer x = 10;
        final Integer y = 20;
        final FieldService service = FieldService.service(x, y);

        System.assertEquals(x, service.x);
        System.assertEquals(y, service.y);
        System.assertEquals(x * y, service.getNumberOfCells());
    }

    @isTest static void placesTankIntoACell() {
        final ApexTank testTank = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point tankCoordinate = new Point(1, 2);

        final Boolean tankIsOnTheFieldNow = service.addTankToField(testTank, tankCoordinate);

        System.assertEquals(true, tankIsOnTheFieldNow);
    }

    @isTest static void cannotPlaceTwoTanksIntoACell() {
        final ApexTank firstTankInCell = newTank();
        final ApexTank secondTankInCell = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point sameCoordinate = new Point(1, 2);

        service.addTankToField(firstTankInCell, sameCoordinate);
        final Boolean secondTankIsOnTheFieldNow = service.addTankToField(secondTankInCell, sameCoordinate);

        System.assertEquals(false, secondTankIsOnTheFieldNow);
    }

    @isTest static void canGetTankAtAParticularCell() {
        final ApexTank testTank = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point tankCoordinate = new Point(1, 2);
        final Point emptyCell = new Point(2, 1);

        service.addTankToField(testTank, tankCoordinate);

        System.assertEquals(testTank, service.tankAt(tankCoordinate));
        System.assertEquals(null, service.tankAt(emptyCell));
    }

    @isTest static void findsTankLocation() {
        final ApexTank testTank = newTank();
        final ApexTank tankNotOnTheField = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point tankCoordinate = new Point(1, 2);
        final Point emptyCell = new Point(2, 1);
        service.addTankToField(testTank, tankCoordinate);

        final Point foundCoordinate = service.coordinateFor(testTank);

        System.assertEquals(tankCoordinate, foundCoordinate);
        System.assertEquals(null, service.coordinateFor(tankNotOnTheField));
    }

    @isTest
    static void movesTankWithinFieldByOnePointUsingDirections() {
        final ApexTank testTank = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point initialLocation = new Point(1, 1);
        final Point targetLocation = new Point(1, 2);
        
        service.addTankToField(testTank, initialLocation);

        service.moveTank(testTank, MoveDirectionEnum.UP);

        System.assertEquals(null, service.tankAt(initialLocation));
        System.assertEquals(testTank, service.tankAt(targetLocation));
    }

    @isTest
    static void movesTankWithinField() {
        final ApexTank testTank = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point initialLocation = new Point(1, 2);
        final Point targetLocation = new Point(2, 1);
        
        service.addTankToField(testTank, initialLocation);

        service.moveTank(testTank, targetLocation);

        System.assertEquals(null, service.tankAt(initialLocation));
        System.assertEquals(testTank, service.tankAt(targetLocation));
    }

    @isTest
    static void cannotMoveTanksMissingOnTheField() {
        final ApexTank tankNotOnTheField = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point initialLocation = new Point(1, 2);
        final Point targetLocation = new Point(2, 1);
        
        final Boolean tankWasMoved = service.moveTank(tankNotOnTheField, targetLocation);

        System.assertEquals(false, tankWasMoved);
    }

    @isTest
    static void cannotMoveTankBeyondTheField() {
        final ApexTank testTank = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point initialLocation = new Point(1, 2);
        final Point outOfFieldLocation = new Point(22, 11);
        service.addTankToField(testTank, initialLocation);
        
        final Boolean tankWasMoved = service.moveTank(testTank, outOfFieldLocation);

        System.assertEquals(false, tankWasMoved);
    }

    @isTest
    static void cannotMoveTankIntoBusyCell() {
        final ApexTank firstTank = newTank();
        final ApexTank secondtank = newTank();
        final FieldService service = FieldService.service(3, 3);
        final Point firstTankLocation = new Point(1, 2);
        final Point secondTankLocation = new Point(1, 2);
        service.addTankToField(firstTank, firstTankLocation);
        service.addTankToField(secondtank, secondTankLocation);
        
        final Boolean tankWasMoved = service.moveTank(firstTank, secondTankLocation);

        System.assertEquals(false, tankWasMoved);
        System.assertEquals(false, service.moveTank(firstTank, firstTankLocation));
    }

    @isTest
    static void addsAllTanksRandomly() {
        final FieldService service = FieldService.service(2, 2);
        final Integer numberOfTanks = 4;

        for(Integer i = 0; i < numberOfTanks; i++) {
            final ApexTank testTank = newTank();
            final Boolean tankAdded = service.addTankRandomly(testTank);

            System.assertEquals(true, tankAdded, 'failed on index: ' + i);

            final Point tankAddedAt = service.coordinateFor(testTank);

            System.assertNotEquals(null, tankAddedAt);
            System.assertEquals(testTank, service.tankAt(tankAddedAt));
        }
    }

    @isTest
    static void doesNotAddIfNoFreeCells() {
        final Integer singleDimensionSize = 3;
        final FieldService service = FieldService.service(singleDimensionSize, singleDimensionSize);
        final Integer numberOfTanks = service.getNumberOfCells();

        for(Integer i = 0; i < numberOfTanks; i++) {
            service.addTankRandomly(newTank());
        }

        final ApexTank oneMoreTank = newTank();

        final Boolean tankAdded = service.addTankRandomly(oneMoreTank);

        System.assertEquals(false, tankAdded, 'could add more tanks than cells available');
    }

    @isTest
    static void highlightsFieldEdges() {
        final FieldService service = FieldService.service(1, 1);
        final Point theOnlyPoint = new Point(0, 0);

        System.assertEquals(false, service.fieldExists(theOnlyPoint, MoveDirectionEnum.UP));
        System.assertEquals(false, service.fieldExists(theOnlyPoint, MoveDirectionEnum.LEFT));
        System.assertEquals(false, service.fieldExists(theOnlyPoint, MoveDirectionEnum.RIGHT));
        System.assertEquals(false, service.fieldExists(theOnlyPoint, MoveDirectionEnum.DOWN));
        System.assertEquals(true,  service.fieldExists(theOnlyPoint, MoveDirectionEnum.NOMOVE));
    }


    @isTest
    static void seesFieldAround() {
        final FieldService service = FieldService.service(3, 3);
        final Point center = new Point(1, 1);

        System.assertEquals(true, service.fieldExists(center, MoveDirectionEnum.UP));
        System.assertEquals(true, service.fieldExists(center, MoveDirectionEnum.LEFT));
        System.assertEquals(true, service.fieldExists(center, MoveDirectionEnum.RIGHT));
        System.assertEquals(true, service.fieldExists(center, MoveDirectionEnum.DOWN));
        System.assertEquals(true, service.fieldExists(center, MoveDirectionEnum.NOMOVE));
    }

    private static TestTank newTank() {
        return TestTank.testTank();
    }
}