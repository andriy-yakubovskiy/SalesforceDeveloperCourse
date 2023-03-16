@isTest
public class PositionControllerLWS_Tests {
    
    @TestSetup
    static void generationData() {
        Integer countPositions = 11;
        List<Position__c> listPositionForTest = DataFactory_Test.createPositions(countPositions);
    }

    @IsTest
    static void getPositionsRecordsTest() {
        Test.startTest();
        PositionControllerLWS.DataPositionRecords dataPositionRecordsBefore = PositionControllerLWS.getPositionsRecords('All', 1, 9);
        
        List<Position__c> positionRecordsNew = dataPositionRecordsBefore.listRecords;
        for (Integer i = 0; i < positionRecordsNew.size(); i++) {
            positionRecordsNew[i].Status__c = getNewStatus(positionRecordsNew[i].Status__c);
        }
        PositionControllerLWS.updataPositionsList(positionRecordsNew); 
        
        PositionControllerLWS.DataPositionRecords dataPositionRecordsAfter = PositionControllerLWS.getPositionsRecords('All', 1, 9);
        List<Position__c> positionRecordsGeted = dataPositionRecordsAfter.listRecords;

        boolean statusChanged;
        if (positionRecordsNew.size() > 0 && positionRecordsNew.size() == positionRecordsGeted.size()) {
            statusChanged = true;
            for (Integer i = 0; i < positionRecordsGeted.size(); i++) {
                if (positionRecordsGeted[i].Status__c != positionRecordsNew[i].Status__c) {
                    statusChanged = false;
                    break;
                }
            }
        }
        
        PositionControllerLWS.DataPositionRecords dataPositionRecordsStatusOpen = PositionControllerLWS.getPositionsRecords('Open', 1, 9);  
        Test.stopTest();
        
        System.assert(dataPositionRecordsBefore.listRecords.size() != 0, 'Data positions array before is not full!');
        System.assert(dataPositionRecordsAfter.listRecords.size() != 0, 'Data positions array after is not full!');
        System.assert(dataPositionRecordsStatusOpen.listRecords.size() != 0,'Data positions array whith Status=Open is not full!');
        System.assert(statusChanged, 'Status dont change!');
    }

    static String getNewStatus(String statusPosOld) {
        String statusPosNew;
        if (statusPosOld == 'Open') {
            statusPosNew = 'Close successful';
        }
        if (statusPosOld == 'Close successful') {
            statusPosNew = 'Open';
        }         
        return statusPosNew;
    }

}