public with sharing class CandidateControllerDisplay {

    public class DataObjectOfCandidateForShow {
        @AuraEnabled public Integer countRecords { get; set; }
        @AuraEnabled public List<StructureDataObject> listRecords { get; set; }
        public DataObjectOfCandidateForShow() {
            countRecords = 0;
            listRecords = new List<StructureDataObject>();
        }
    }

    public class StructureDataObject {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public List<StructureFieldsOfObject> fields { get; set; }
        public StructureDataObject(String id, String name, List<StructureFieldsOfObject> fields) {
            this.id     = id;
            this.name   = name;
            this.fields = fields;
        }
    }
    public class StructureFieldsOfObject {
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String lable { get; set; }
        @AuraEnabled public Object value { get; set; }
        @AuraEnabled public Boolean access { get; set; }
        public StructureFieldsOfObject(String name, String lable, Object value) {
            this.name   = name;
            this.lable  = lable;
            this.value  = value;            
        }
        public StructureFieldsOfObject(String name, String lable, Object value, Boolean access) {
            this.name   = name;
            this.lable  = lable;
            this.value  = value;
            this.access = access;
        }
    }
    public class StructureFieldsOfObject_Wrapper implements Comparable {
        public StructureFieldsOfObject theStructureFieldsOfObject;
        
        public StructureFieldsOfObject_Wrapper(StructureFieldsOfObject theStructureFieldsOfObject) {
            this.theStructureFieldsOfObject = theStructureFieldsOfObject;
        }

        public Integer compareTo(Object compareTo) {
            StructureFieldsOfObject_Wrapper compareToStructureField = (StructureFieldsOfObject_Wrapper)compareTo;
            Integer returnValue = 0;            
            if ((theStructureFieldsOfObject.name == null) && (compareToStructureField.theStructureFieldsOfObject.name == null)) {
                returnValue = 0;
            } else if ((theStructureFieldsOfObject.name == null) && (compareToStructureField.theStructureFieldsOfObject.name != null)){
                returnValue = -1;
            } else if ((theStructureFieldsOfObject.name != null) && (compareToStructureField.theStructureFieldsOfObject.name == null)){
                returnValue = 1;
            } else if (theStructureFieldsOfObject.name > compareToStructureField.theStructureFieldsOfObject.name) {
                returnValue = 1;
            } else if (theStructureFieldsOfObject.name < compareToStructureField.theStructureFieldsOfObject.name) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    @AuraEnabled
    public static Map<String,Object> getAdvancedSettingsForDisplayingCandidatesInPositionsPage(String nameCustomMetadataTypes) {
        Map<String,Object> advancedSettingsForDisplayingCandidates = new Map<String,Object>();
 
        Map<String,Object> infoOfCurrentUser = GeneralFunctionsMethods.getInfoOfCurrentUser();
        advancedSettingsForDisplayingCandidates.put('infoOfUser',infoOfCurrentUser);

        String userType = '';
        if((Boolean)infoOfCurrentUser.get('isInterviewer')){
            userType = 'Interviewer';
        }
        if((Boolean)infoOfCurrentUser.get('isRecruiter')){
            userType = 'Recruiter';
        }
        if((Boolean)infoOfCurrentUser.get('isInterviewer') && (Boolean)infoOfCurrentUser.get('isRecruiter')){
            userType = 'Recruiter';
        }
        if((Boolean)infoOfCurrentUser.get('isAdmin')){
            userType = 'Recruiter';
        }
        advancedSettingsForDisplayingCandidates.put('userType',userType);
        
        GeneralFunctionsMethods.InformationAboutMetadataObject informationMetadataCandidate = GeneralFunctionsMethods.getInformationAboutMetadataObject('Candidate__c');
        GeneralFunctionsMethods.InformationAboutMetadataObject informationMetadataJobApp = GeneralFunctionsMethods.getInformationAboutMetadataObject('Job_Application__c');
        
        Map<String,Map<String,Map<String,String>>> listOfValuesCustomMetadataTypes = GeneralFunctionsMethods.getListOfValuesCustomMetadataTypes(new List<String>{nameCustomMetadataTypes});
        advancedSettingsForDisplayingCandidates.put('listOfValuesCustomMetadata',listOfValuesCustomMetadataTypes);
        
        Map<String,Object> recFromCustomMetadata = new Map<String,Object>();
        for (String nameCustomMetadata : listOfValuesCustomMetadataTypes.keySet()) {
            for (String nameRecCustomMetadata : listOfValuesCustomMetadataTypes.get(nameCustomMetadata).keySet()) {
                String userTypeFromSetting = (String)listOfValuesCustomMetadataTypes.get(nameCustomMetadata).get(nameRecCustomMetadata).get('Setting_for_user_type__c');
                if(userTypeFromSetting==userType){
                    recFromCustomMetadata = listOfValuesCustomMetadataTypes.get(nameCustomMetadata).get(nameRecCustomMetadata);
                }
            }
        }
        
        Map<String,Object> listMetadataObject = new Map<String,Object>();

        Map<String,Object> settingsFromRecCustomMetadata_candidate = new Map<String,Object>();        
        settingsFromRecCustomMetadata_candidate.put('card',getSettingsFromRecCustomMetadata(recFromCustomMetadata,'FieldSet_for_candidate_card__c','Fields_in_FieldSet_for_candidate_card__c'));
        settingsFromRecCustomMetadata_candidate.put('popup',getSettingsFromRecCustomMetadata(recFromCustomMetadata,'FieldSet_for_candidate_popup__c','Fields_in_FieldSet_for_candidate_popup__c'));

        Map<String,Object> settingsForMetadataCandidate = new Map<String,Object>();
        settingsForMetadataCandidate.put('informationMetadata',informationMetadataCandidate);
        settingsForMetadataCandidate.put('settingsMetadata',settingsFromRecCustomMetadata_candidate);
        listMetadataObject.put('Candidate__c',settingsForMetadataCandidate);
        
        Map<String,Object> settingsFromRecCustomMetadata_jobApp = new Map<String,Object>();
        settingsFromRecCustomMetadata_jobApp.put('popup',getSettingsFromRecCustomMetadata(recFromCustomMetadata,'FieldSet_for_JobApp_popup__c','Fields_in_FieldSet_for_JobApp_popup__c'));

        Map<String,Object> settingsForMetadataJobApplication = new Map<String,Object>();
        settingsForMetadataJobApplication.put('informationMetadata',informationMetadataJobApp);
        settingsForMetadataJobApplication.put('settingsMetadata',settingsFromRecCustomMetadata_jobApp);
        listMetadataObject.put('Job_Application__c',settingsForMetadataJobApplication);

        advancedSettingsForDisplayingCandidates.put('informationAboutMetadataObject',listMetadataObject);

        return advancedSettingsForDisplayingCandidates;
    }

    @AuraEnabled
    public static Map<String,Object> getAdvancedSettingsForCreationFormCandidate(String nameCustomMetadataTypes) {
        Map<String,Object> advancedSettings = new Map<String,Object>();
        
        Map<String,Map<String,Map<String,String>>> listOfValuesCustomMetadataTypes = GeneralFunctionsMethods.getListOfValuesCustomMetadataTypes(new List<String>{nameCustomMetadataTypes});
        if (listOfValuesCustomMetadataTypes.size()==0) {
            return advancedSettings; 
        }
        advancedSettings.put('listOfValuesCustomMetadata',listOfValuesCustomMetadataTypes);
        
        Map<String,Object> recFromCustomMetadata = new Map<String,Object>();
        for (String nameCustomMetadata : listOfValuesCustomMetadataTypes.keySet()) {
            for (String nameRecCustomMetadata : listOfValuesCustomMetadataTypes.get(nameCustomMetadata).keySet()) {
                recFromCustomMetadata = listOfValuesCustomMetadataTypes.get(nameCustomMetadata).get(nameRecCustomMetadata);                
            }
        }
        
        GeneralFunctionsMethods.InformationAboutMetadataObject informationMetadataCandidate = GeneralFunctionsMethods.getInformationAboutMetadataObject('Candidate__c');
        GeneralFunctionsMethods.InformationAboutMetadataObject informationMetadataJobApp = GeneralFunctionsMethods.getInformationAboutMetadataObject('Job_Application__c');
        
        Map<String,Object> listMetadataObject = new Map<String,Object>();
        Map<String,Object> settingsForMetadataCandidate = new Map<String,Object>();
        settingsForMetadataCandidate.put('informationMetadata',informationMetadataCandidate);
        settingsForMetadataCandidate.put('settingsMetadata',getSettingsFromRecCustomMetadata(recFromCustomMetadata,'FieldSet__c','Fields_in_FieldSet__c'));
        listMetadataObject.put('Candidate__c',settingsForMetadataCandidate);
        
        Map<String,Object> settingsForMetadataJobApplication = new Map<String,Object>();
        settingsForMetadataJobApplication.put('informationMetadata',informationMetadataJobApp);
        settingsForMetadataJobApplication.put('settingsMetadata',getSettingsFromRecCustomMetadata(recFromCustomMetadata,'FieldSet_for_JobApp__c','Fields_in_FieldSet_for_JobApp__c'));
        listMetadataObject.put('Job_Application__c',settingsForMetadataJobApplication);

        advancedSettings.put('informationAboutMetadataObject',listMetadataObject);

        return advancedSettings;
    }

    public static Map<String,Object> getSettingsFromRecCustomMetadata(Map<String,Object> recFromCustomMetadata, String nameField_FieldSet, String nameField_Fields) {
        Map<String,Object> settingsStructure = new Map<String,Object>();
        
        String nameFieldSet = (String)recFromCustomMetadata.get(nameField_FieldSet);
        nameFieldSet = (nameFieldSet==null)?'':nameFieldSet;
        String strListNameFields = (String)recFromCustomMetadata.get(nameField_Fields);
        strListNameFields = (strListNameFields==null)?'':strListNameFields;
        List<String> listFromString = getListFromString(strListNameFields,';');
        
        settingsStructure.put(nameFieldSet,listFromString);

        return settingsStructure;
    }

    public static List<String> getListFromString(String currentString, String delimiter) {
        List<String> listFromString = new List<String>();
        String workString = currentString.mid(0,currentString.length());
        Integer strIndex = workString.indexOf(delimiter);
        while(strIndex != -1){ 
            String nameField = workString.mid(0,strIndex);
            listFromString.add(nameField);
            
            workString = workString.replaceFirst(nameField + delimiter, '');
            strIndex = workString.indexOf(delimiter);            
        }
        return listFromString;
    }

    @AuraEnabled
    public static DataObjectOfCandidateForShow getCandidateRecordsRelatedPosition(String metadataNameCandidate, Id idPosition, List<String> listNameFields, Integer startFromRecord, Integer quantityRecords) {
        DataObjectOfCandidateForShow wrapperRezult = new DataObjectOfCandidateForShow();
        if (listNameFields==null || listNameFields.isEmpty()) {
            return wrapperRezult;
        }
        GeneralFunctionsMethods.AccessPropertiesForObject accessObject = GeneralFunctionsMethods.getAccessPropertiesToObject(metadataNameCandidate);
        if (!(accessObject.isAccessible)) {
            return wrapperRezult;
        }
        
        List<String> requiredFieldsToRequest = new List<String>{'Id','Name'};
        List<String> exclusionFieldsForFieldList = new List<String>{'id','name'}; //LowerCase

        String queryTextFields;
        String queryText;
        
        try {
            //Count records
            queryTextFields = 'Count()';
            queryText = GeneralFunctionsMethods.createQueryTextForCandidateRecordsOfPosition(idPosition, queryTextFields);
            wrapperRezult.countRecords = Database.countQuery(queryText);
            
            //Data records
            queryTextFields = '';            
            for (String nameField : listNameFields) {
                if (accessObject.accessibleFields.get(nameField)){
                    queryTextFields = queryTextFields + (String.isBlank(queryTextFields)?'':',') + nameField;
                }
            }
            for(String nameField : requiredFieldsToRequest) {
                if (!listNameFields.contains(nameField)) {
                    queryTextFields = queryTextFields + (String.isBlank(queryTextFields)?'':',') + nameField;
                }
            }

            Integer MaxRecords = GeneralFunctionsMethods.returnMaxRecordsAsPerLimit();
            queryText = GeneralFunctionsMethods.createQueryTextForCandidateRecordsOfPosition(idPosition, queryTextFields);
            //Example: SELECT * FROM Position__c LIMIT 5 OFFSET 2; // = from 3 to 7(include)
            queryText = queryText + ' LIMIT ' + String.valueOf((quantityRecords>MaxRecords)?MaxRecords:quantityRecords) + ' OFFSET '+String.valueOf(startFromRecord-1);
            List<Candidate__c> rezultQueryRecords = Database.query(queryText);
            
            Map<String,String> labelAndNameFieldsCandidate = GeneralFunctionsMethods.getLabelAndNameFieldsFromMetadataObject(metadataNameCandidate);
            
            for (Candidate__c candidate : rezultQueryRecords) {
                List<StructureFieldsOfObject> detailsFields = new List<StructureFieldsOfObject>();
                for (String nameField : listNameFields) {
                    if (!(exclusionFieldsForFieldList.contains(nameField.toLowerCase()))) {
                        Boolean accessField = false;
                        String lableField = labelAndNameFieldsCandidate.get(nameField);
                        Object valueField = candidate.get(nameField);
                        if (accessObject.accessibleFields.get(nameField)){
                            accessField = true;
                        }
                        detailsFields.add(new StructureFieldsOfObject(nameField, lableField, valueField, accessField));            
                    }
                }
                wrapperRezult.listRecords.add(new StructureDataObject(candidate.Id, candidate.Name, detailsFields)); 
            }
           
        }
        catch (System.QueryException e) {
            throw GeneralFunctionsMethods.newMessageException(System.Label.Error + ' ' + System.Label.Access_denied.toLowerCase() + '! | Error : ' + e.getMessage());
        }
        catch (Exception e) {
            throw GeneralFunctionsMethods.newMessageException(System.Label.Error + ' ' + System.Label.get.toLowerCase() + ' ' + System.Label.Data.toLowerCase() + '! | Error : ' + e.getMessage());
        }
        
        return wrapperRezult;
    }

    @AuraEnabled
    public static List<StructureDataObject> getJobApplicationsRecordsRelatedCandidate(Id idCandidate, List<String> listNameFields) {
        List<StructureDataObject> wrapperRezult = new List<StructureDataObject>();
        
        GeneralFunctionsMethods.AccessPropertiesForObject accessObject = GeneralFunctionsMethods.getAccessPropertiesToObject('Job_Application__c');
        if (!(accessObject.isAccessible)) {
            return wrapperRezult;
        }
        if (listNameFields.size()==0) {
            return wrapperRezult;
        }
        
        List<String> exclusionFieldsForFieldList = new List<String>{'id','name'}; //LowerCase

        String queryTextFields = '';
        String queryText = '';
        
        try {
            for (String nameField : listNameFields) {
                if (accessObject.accessibleFields.get(nameField)){
                    queryTextFields = queryTextFields + (String.isBlank(queryTextFields)?'':',') + nameField;
                }
            }

            Integer MaxRecords = GeneralFunctionsMethods.returnMaxRecordsAsPerLimit();
            queryText = 'SELECT '+queryTextFields+' FROM Job_Application__c WHERE Candidate__r.Id = :idCandidate';            
            queryText = queryText + ' WITH SECURITY_ENFORCED';
            queryText = queryText + ' LIMIT ' + String.valueOf(MaxRecords);
            List<Job_Application__c> rezultQueryRecords = Database.query(queryText);

            Map<String,String> labelAndNameFieldsJa = GeneralFunctionsMethods.getLabelAndNameFieldsFromMetadataObject('Job_Application__c');
            
            //List of fields
            for (Job_Application__c ja : rezultQueryRecords) {
                //Create list fields
                List<StructureFieldsOfObject_Wrapper> detailsFields = new List<StructureFieldsOfObject_Wrapper>();
                //get fields from query elem
                Map<String, Object> valuesOfFieldsFromQuery = ja.getPopulatedFieldsAsMap();
                for (String fieldName : valuesOfFieldsFromQuery.keySet()) {
                    if (!(exclusionFieldsForFieldList.contains(fieldName.toLowerCase())) && (listNameFields.indexOf(fieldName)!=-1)) {
                        String fieldLable = Job_Application__c.sObjectType.getDescribe().fields.getMap().get(fieldName).getDescribe().getLabel();
                        
                        Object fieldValue = valuesOfFieldsFromQuery.get(fieldName);
                        if(fieldName.indexOf('__c') != -1){                            
                            GeneralFunctionsMethods.StructureDataObjectOfObject structureDataObject = GeneralFunctionsMethods.getInfoOfRecord(fieldName, (Id)fieldValue, new List<String>{'Name'});
                            fieldValue = (Object)structureDataObject.Name;                            
                        }
                        detailsFields.add(new StructureFieldsOfObject_Wrapper(new StructureFieldsOfObject(fieldName, fieldLable, fieldValue)));
                    }
                }
                //get fields from object, which are not in query, and add
                for (String fieldName : labelAndNameFieldsJa.keySet()) {
                    if (listNameFields.contains(fieldName) 
                             && !valuesOfFieldsFromQuery.containsKey(fieldName)
                                 && !exclusionFieldsForFieldList.contains(fieldName.toLowerCase())) {
                        String fieldLable = labelAndNameFieldsJa.get(fieldName);
                        detailsFields.add(new StructureFieldsOfObject_Wrapper(new StructureFieldsOfObject(fieldName, fieldLable, null)));
                    }
                }
                detailsFields.sort();

                //Handmade casting to StructureFieldsOfObject
                List<StructureFieldsOfObject> sortedDetailsFields = new List<StructureFieldsOfObject>();
                for (StructureFieldsOfObject_Wrapper elemDetailsFields : detailsFields) 
                    sortedDetailsFields.add(elemDetailsFields.theStructureFieldsOfObject);
                
                //Save to main list
                wrapperRezult.add(new StructureDataObject(ja.Id, ja.Name, sortedDetailsFields)); 
            }       
        }
        catch (System.QueryException e) {
            throw GeneralFunctionsMethods.newMessageException(System.Label.Error + ' ' + System.Label.Access_denied.toLowerCase() + '! | Error : ' + e.getMessage());
        }
        catch (Exception e) {
            throw GeneralFunctionsMethods.newMessageException(System.Label.Error + ' ' + System.Label.get.toLowerCase() + ' ' + System.Label.Data.toLowerCase() + '! | Error : ' + e.getMessage());
        }
        
        return wrapperRezult;
    }
}