@isTest
public class GeneralFunctionsMethodsTest {

    @isTest
    static void saveUpdateRecordTest() {
        Test.startTest();
        Candidate__c newCandidate = new Candidate__c(
            Name = 'Genri Sinen', 
            Mobile_number__c = '0124587'
            );
        insert newCandidate;

        String nameCustomMetadataTypes = 'Extra_settings_on_position_extended_page';
        String nameRecCustomMetadataType = 'Settings_of_show_fields_for_Recruiter';
        Map<String,String> structureForFields = new Map<String,String>();
        structureForFields.put('Mobile_number__c','0124587');
        
        GeneralFunctionsMethods.StructureDataObjectOfObject dataObjectOfObject = GeneralFunctionsMethods.saveUpdateRecord('Candidate__c',json.serialize(structureForFields),newCandidate.id);
        AuraHandledException messageException = GeneralFunctionsMethods.newMessageException('Err');
        Test.stopTest();
        System.assert(dataObjectOfObject.message=='');
    }

}