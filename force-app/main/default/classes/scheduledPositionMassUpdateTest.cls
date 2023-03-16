@isTest
public class scheduledPositionMassUpdateTest {

    public static String CRON_EXP = '0 0 0 10 12 ? 2023';
    
    static testmethod void testScheduledJob() {
        Integer quantityPos = 200;//50000000;
        
        //Generate test data
        List<Position__c> positions = new List<Position__c>();
        Id idRecordTypePosAdmin = Schema.SObjectType.Position__c.getRecordTypeInfosByDeveloperName().get('Admin').getRecordTypeId();       
        for (Integer i=0;i<quantityPos;i++) {
            positions.add(new Position__c(Name = 'Position '+i, 
                                        RecordTypeId = idRecordTypePosAdmin,
                                        TypeEmployment__c = 'Full Time',
                                        Open_Date__c = Date.newInstance(1999, 1, 1)));
        }
        insert positions;
        Map<Id, Position__c> positionMap = new Map<Id, Position__c>(positions);
        List<Id> positionIds = new List<Id>(positionMap.keySet());
        
        Test.startTest();

        //My test, with fictiv CRON_EXP(date start)!
        String jobID = System.schedule('scheduledPosUpdateApexTest', CRON_EXP, new scheduledPositionMassUpdate());
        
        Test.stopTest();
        
        CronTrigger cronTrig = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, State FROM CronTrigger WHERE id = :jobID];
        System.assert(cronTrig.State == 'WAITING'); 
        System.assertEquals('2023-12-10 00:00:00', String.valueOf(cronTrig.NextFireTime));   
    }
}