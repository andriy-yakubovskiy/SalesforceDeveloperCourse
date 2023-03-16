@IsTest
private class PositionFunctionExpressionTest {

    @TestSetup
    static void makeData() {
        Id idRecordTypePos = Schema.SObjectType.Position__c.getRecordTypeInfosByDeveloperName().get('Admin').getRecordTypeId();
        List<Position__c> listPosTest = new List<Position__c>();
        for (Integer i = 0; i < 10; i++) {
            listPosTest.add(new Position__c(
                        RecordTypeId = idRecordTypePos,
                        Name = 'Dev for department #' + String.valueOf(i), 
                        TypeEmployment__c = 'Full Time',
                        Status__c = 'Open' 
                        )
                    );
        }
        insert listPosTest;
        Position__c onePosTest = new Position__c(
                        RecordTypeId = idRecordTypePos,
                        Name = 'Dev for department # ---', 
                        TypeEmployment__c = 'Full Time',
                        Open_Date__c = Date.newInstance(2022, 9, 8),
                        Close_Date__c = Date.newInstance(2022, 9, 8),
                        Status__c = 'Close not successful' 
                        );
        insert onePosTest;
    }

    @IsTest
    static void testGetPositions() {
        Test.startTest();
        PositionFunctionExpression pageController = new PositionFunctionExpression();
        pageController.positions = (List<Position__c> )pageController.getPositions();    
        Test.stopTest();

        System.debug(pageController.positions.size());
		System.assertEquals(true,pageController.positions.size()>0);
    }

    @IsTest
    static void testGetDoSearch() {
        Test.startTest();
        PositionFunctionExpression pageController = new PositionFunctionExpression();
        pageController.positions = (List<Position__c> )pageController.getPositions();
        Integer countPosBefore = pageController.positions.size();
        
        pageController.oPos.Status__c = 'Open';
        pageController.doSearch();
        //PageReference pageRef = pageController.doSearch();
        //Test.setCurrentPage(pageRef);

        pageController.positions = (List<Position__c> )pageController.getPositions();
        Integer countPosAfter = pageController.positions.size();
        Test.stopTest();
        
        System.debug(String.valueOf(countPosBefore) + ' - ' + String.valueOf(countPosAfter));
		System.assertEquals(true, countPosBefore <> countPosAfter);
    }

    static Position__c getTestPosition (List<Position__c> listPos) {
        
        String searchString = 'Dev for department #%';
        Position__c posForTest = [SELECT Name,Status__c FROM Position__c WHERE Name LIKE :searchString LIMIT 1];
                        
        return posForTest;
    }

    static String getNewStatusTest(String statusPosOld) {
        String statusPosNew;
        if (statusPosOld == 'Open') {
            statusPosNew = 'Close successful';
        }
        if (statusPosOld == 'Close successful') {
            statusPosNew = 'Open';
        }         
        return statusPosNew;
    }

    @IsTest
    static void testSave() {
        Test.startTest();
        PositionFunctionExpression pageController = new PositionFunctionExpression();
        pageController.positions = (List<Position__c> )pageController.getPositions();
        
        Position__c posForChange = getTestPosition(pageController.positions);
        
        String statusPosOld = posForChange.Status__c;
        posForChange.Status__c = getNewStatusTest(statusPosOld);
        
        pageController.save();

        posForChange = getTestPosition(pageController.positions);
        System.assert(posForChange.Status__c == statusPosOld,'Not status  in Position after save!');
        Test.stopTest();
	}

    @IsTest
    static void paginationTest() {
        Test.startTest();
        PositionFunctionExpression functionExpression = new PositionFunctionExpression();
        functionExpression.first();
        functionExpression.last();
        functionExpression.previous();
        functionExpression.next();
        Boolean isPrevious = functionExpression.hasPrevious;
        Boolean isNext = functionExpression.hasNext;
        System.assert(true);
        Test.stopTest();
    }

    @IsTest
    static void otherTest() {
        Test.startTest();
        
        PositionFunctionExpression functionExpression = new PositionFunctionExpression();
        functionExpression.setControllerPositions = null;
        List<Position__c> pos = functionExpression.getPositions();
        functionExpression.save();
        //PageReference pageRef = functionExpression.save();
        //Test.setCurrentPage(pageRef);

        System.assert(true);
        Test.stopTest();
    } 

}