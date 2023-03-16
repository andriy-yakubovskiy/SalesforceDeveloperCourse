@isTest
public class PositionMassUpdateTest {
    @testSetup
    static void setup() {
        Integer quantityPos = 200;//50000000;
        List<Position__c> positions = new List<Position__c>();
        Id idRecordTypePosAdmin = Schema.SObjectType.Position__c.getRecordTypeInfosByDeveloperName().get('Admin').getRecordTypeId();       
        for (Integer i=0;i<quantityPos;i++) {
            positions.add(new Position__c(Name = 'Position '+i, 
                                        RecordTypeId = idRecordTypePosAdmin,
                                        TypeEmployment__c = 'Full Time',
                                        Open_Date__c = Date.newInstance(1999, 1, 1)));
        }
        insert positions;
    }
    @isTest static void test() {
        Integer countPositionBeforTest =  [SELECT count() FROM Position__c 
                                            WHERE Open_Date__c < LAST_N_DAYS:90 AND Close_Date__c = NULL];
        Test.startTest();
        PositionMassUpdate batchableMassUpdate = new PositionMassUpdate(); 
        Id batchId = Database.executebatch(batchableMassUpdate);
        Test.stopTest();
        Integer countPositionAfterTest =  [SELECT count() FROM Position__c 
                                            WHERE NOT(Open_Date__c < LAST_N_DAYS:90 AND Close_Date__c = NULL)];
        System.assert(countPositionBeforTest == countPositionAfterTest);
    }
}