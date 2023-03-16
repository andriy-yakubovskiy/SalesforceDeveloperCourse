@isTest
public with sharing class PositionUpdateTriggerTest {
    
    @TestSetup
    static void generationData() {
        Id idRecordTypePos = Schema.SObjectType.Position__c.getRecordTypeInfosByDeveloperName().get('Admin').getRecordTypeId();
        Position__c pos = new Position__c(RecordTypeId = idRecordTypePos, TypeEmployment__c = 'Full Time', Open_Date__c = Date.today(), Status__c = 'Open');
        insert pos;        
    }

    @isTest 
    static void TestActionsTriggerPositionTest() {
        Test.startTest();
        Position__c positionFormBase = [SELECT Id,Open_Date__c,Close_Date__c,Status__c FROM Position__c LIMIT 1];

        String statusCloseDate = positionFormBase.Status__c;
        
        positionFormBase.Status__c = 'Close';
        update positionFormBase;        
        Test.stopTest();

        System.assert(positionFormBase.Status__c != statusCloseDate);

    }
}