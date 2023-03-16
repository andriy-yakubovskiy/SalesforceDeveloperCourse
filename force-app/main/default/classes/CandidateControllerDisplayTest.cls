@isTest
public class CandidateControllerDisplayTest {
    
    @IsTest
    static void getAdvancedSettingsTest() {
        Test.startTest();
        String settingsNameCustomMetadataTypes = 'Extra_settings_on_position_extended_page';
        Map<String,Object> settingsForDisplayingCandidatesInPositionsPage = CandidateControllerDisplay.getAdvancedSettingsForDisplayingCandidatesInPositionsPage(settingsNameCustomMetadataTypes);
        settingsNameCustomMetadataTypes = 'Settings_for_creation_form_Candidate';
        Map<String,Object> settingsForCreationFormCandidate = CandidateControllerDisplay.getAdvancedSettingsForCreationFormCandidate(settingsNameCustomMetadataTypes);
        Test.stopTest();
        
        System.assert(settingsForDisplayingCandidatesInPositionsPage.size() != 0);        
        System.assert(settingsForCreationFormCandidate.size() != 0);        
    }

    @IsTest
    static void recordTest() {
        Test.startTest();
        Map <String, Schema.RecordTypeInfo> recordTypesPosition = Schema.SObjectType.Position__c.getRecordTypeInfosByDeveloperName();
        Id idRecordTypePosTech  = recordTypesPosition.get('Tech').getRecordTypeId();
        Position__c newPosition = new Position__c(
                                    RecordTypeId = idRecordTypePosTech,
                                    Name = 'Tech for department', 
                                    TypeEmployment__c = 'Full Time',
                                    Status__c = 'Open',
                                    Open_Date__c = date.today()
                                    );
        insert newPosition;

        Candidate__c newCandidate1 = new Candidate__c(
                                    Name = 'Genri Sinen', 
                                    Mobile_number__c = '0124587'
                                    );
        insert newCandidate1;

        Candidate__c newCandidate2 = new Candidate__c(
                                    Name = 'Sinen Genri', 
                                    Mobile_number__c = '3855454'
                                    );
        insert newCandidate2;

        Job_Application__c newJobApp = new Job_Application__c(
                                    Position__c = newPosition.id, 
                                    Candidate__c = newCandidate1.id
                                    );
        insert newJobApp;

        Job_Application__c newJobApp2 = new Job_Application__c(
                                    Position__c = newPosition.id, 
                                    Candidate__c = newCandidate2.id
                                    );
        insert newJobApp2;

        String metadataNameCandidate = 'Candidate__c';
        Id idPosition = newPosition.id;//'a007Q000009aHeSQAU';
        List<String> listNameFields = new List<String>();
        listNameFields.add('First_Name__c');
        listNameFields.add('Country__c');
        listNameFields.add('Education__c');
        listNameFields.add('Add_Education__c');
        Integer startRecord = 1;
        Integer quantityRecords = 2;
        CandidateControllerDisplay.DataObjectOfCandidateForShow candidateRecordsRelatedPosition = CandidateControllerDisplay.getCandidateRecordsRelatedPosition(metadataNameCandidate, idPosition, listNameFields, startRecord, quantityRecords);
        
        List<String> listNameFieldsJobApp = new List<String>();
        listNameFieldsJobApp.add('Name');
        listNameFieldsJobApp.add('Position__c');
        List<CandidateControllerDisplay.StructureDataObject> jobApplicationsRecordsRelatedCandidate = CandidateControllerDisplay.getJobApplicationsRecordsRelatedCandidate(newCandidate1.id, listNameFieldsJobApp);
        Test.stopTest();
        
        System.assert(candidateRecordsRelatedPosition.countRecords != 0);        
        System.assert(jobApplicationsRecordsRelatedCandidate.size() != 0);        
    }
    
}