public with sharing class GeneralFunctionsMethods {
   
    public class StructureDataObjectOfObject {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String message { get; set; }
        @AuraEnabled public List<StructureFieldsOfObject> fields { get; set; }
        public StructureDataObjectOfObject() {
            this.id     = '';
            this.name   = '';
            this.message= '';
            this.fields = new List<StructureFieldsOfObject>();
        }
        public StructureDataObjectOfObject(String id, String name, List<StructureFieldsOfObject> fields) {
            this.id     = id;
            this.name   = name;
            this.message= '';
            this.fields = fields;
        }
        public StructureDataObjectOfObject(String id, String name, List<StructureFieldsOfObject> fields, String message) {
            this.id     = id;
            this.name   = name;
            this.message= message;
            this.fields = fields;
        }
        public StructureDataObjectOfObject(String message) {
            this.id     = '';
            this.name   = '';
            this.message= message;
            this.fields = new List<StructureFieldsOfObject>();
        }
    }
    public class StructureFieldsOfObject {
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String lable { get; set; }
        @AuraEnabled public Object value { get; set; }
        public StructureFieldsOfObject(String name, String lable, Object value) {
            this.name   = name;
            this.lable  = lable;
            this.value  = value;
        }
    }

    public class InformationAboutMetadataObject {
        @AuraEnabled public AccessPropertiesForObject accessPropertiesObject;
        @AuraEnabled public Map<String,String> labelAndNameFieldsObject;
        @AuraEnabled public Map<String,Map<String,String>> labelAndNameFieldsFieldSet;
        @AuraEnabled public Map<String,Map<String,String>> labelAndNameFieldsFieldSetJobApp;
        InformationAboutMetadataObject(){
            accessPropertiesObject = new AccessPropertiesForObject();
            labelAndNameFieldsObject = new Map<String,String>();
            labelAndNameFieldsFieldSet = new Map<String,Map<String,String>>();
            labelAndNameFieldsFieldSetJobApp = new Map<String,Map<String,String>>();
        }
    }

    public class AccessPropertiesForObject {
        @AuraEnabled public Boolean isAccessible;
        @AuraEnabled public Boolean isCreateable;
        @AuraEnabled public Boolean isUpdateable;
        @AuraEnabled public Map<String,Boolean> accessibleFields;
        @AuraEnabled public Map<String,Boolean> createableFields;
        @AuraEnabled public Map<String,Boolean> updateableFields;
        public Map<String, DescribeFieldResult> fieldsDescribeMetadata;
        AccessPropertiesForObject(){
            isAccessible = false;
            isCreateable = false;
            isUpdateable = false;
            accessibleFields = new Map<String,Boolean>();
            createableFields = new Map<String,Boolean>();
            updateableFields = new Map<String,Boolean>();
            fieldsDescribeMetadata = new Map<String, DescribeFieldResult>();
        }
    }

    public static AccessPropertiesForObject getAccessPropertiesToObject(String nameObjectDatabase) {
        AccessPropertiesForObject accessObjectFields = new AccessPropertiesForObject();
        //Object
        DescribeSObjectResult sObjects = Schema.getGlobalDescribe().get(nameObjectDatabase).getDescribe();
        accessObjectFields.isAccessible = sObjects.isAccessible();
        accessObjectFields.isCreateable = sObjects.isCreateable();
        accessObjectFields.isUpdateable = sObjects.isUpdateable();
        //Object fields
        Map<String, SObjectField> fieldsObjectMap = sObjects.fields.getMap();
        //// Comment because problem with MAP key, object's fields is in lowercase names!!!!!
        // for(String fieldName : fieldsObjectMap.keySet()) {
        //     DescribeFieldResult fieldPosition = fieldsObjectMap.get(fieldName).getDescribe();
        //     accessObjectFields.fieldsDescribeMetadata.put(fieldName,fieldPosition);
        // }
        for(SObjectField fieldSObject : fieldsObjectMap.values()){
            DescribeFieldResult fieldMetadata = fieldSObject.getDescribe();
            accessObjectFields.accessibleFields.put(fieldMetadata.getName(),fieldMetadata.isAccessible());
            accessObjectFields.createableFields.put(fieldMetadata.getName(),fieldMetadata.isCreateable());
            accessObjectFields.updateableFields.put(fieldMetadata.getName(),fieldMetadata.isUpdateable());
            accessObjectFields.fieldsDescribeMetadata.put(fieldMetadata.getName(),fieldMetadata);
        }
        return accessObjectFields;
    }
    
    public static Map<String,String> getLabelAndNameFieldsFromMetadataObject(String nameMetadataObject) {
        Map<String,String> labelAndNameFields = new Map<String,String>();
        if (!(String.isBlank(nameMetadataObject))) {
            Schema.SObjectType typeObject = Schema.getGlobalDescribe().get(nameMetadataObject);
            if (typeObject!=null) {        
                Map<String, Schema.SObjectField> fieldMap = typeObject.getDescribe().fields.getMap();
                for(String fiedName : fieldMap.keySet()) {
                    Schema.DescribeFieldResult field = fieldMap.get(fiedName).getDescribe() ;
                    labelAndNameFields.put(field.getName(),field.getLabel());
                }
            }
        }
        return labelAndNameFields;
    }

    public static Map<String,Map<String,String>> getLabelAndNameFieldsFromFieldSetOfMetadataObject(String nameMetadataObject) {
        Map<String,Map<String,String>> fieldSetOfObject = new Map<String,Map<String,String>>();
        Schema.SObjectType typeObject = Schema.getGlobalDescribe().get(nameMetadataObject);
        if (typeObject!=null) {
            Map<String, Schema.FieldSet> fsMap = typeObject.getDescribe().fieldSets.getMap();
            for(String fieldsetName : fsMap.keyset()){
                List<Schema.FieldSetMember> listFields = fsMap.get(fieldsetName).getFields();
                Map<String,String> labelAndNameFieldsOfObject = new Map<String,String>();                
                for(Schema.FieldSetMember field : listFields) {
                    labelAndNameFieldsOfObject.put(field.getFieldPath(),field.getLabel());
                }
                fieldSetOfObject.put(fieldsetName,labelAndNameFieldsOfObject);
            }
        }
        return fieldSetOfObject;
    }

    @AuraEnabled
    public static InformationAboutMetadataObject getInformationAboutMetadataObject(String nameMetadataObject) {
        InformationAboutMetadataObject informationMetadataObject = new InformationAboutMetadataObject();
        informationMetadataObject.accessPropertiesObject = getAccessPropertiesToObject(nameMetadataObject);
        informationMetadataObject.labelAndNameFieldsObject = getLabelAndNameFieldsFromMetadataObject(nameMetadataObject);
        informationMetadataObject.labelAndNameFieldsFieldSet = getLabelAndNameFieldsFromFieldSetOfMetadataObject(nameMetadataObject);
        informationMetadataObject.labelAndNameFieldsFieldSetJobApp = getLabelAndNameFieldsFromFieldSetOfMetadataObject('Job_Application__c');
        return informationMetadataObject;
    }

    public static String createQueryTextForCandidateRecordsOfPosition(Id idPosition, String queryTextFields) {
        String queryText = '';
        if ((idPosition!=null) && !(String.isBlank(queryTextFields))) {
            queryText = 'SELECT '+queryTextFields+' FROM Candidate__c WHERE Id IN (SELECT Candidate__c FROM Job_Application__c WHERE Position__r.Id = :idPosition)';
            queryText = queryText + ' WITH SECURITY_ENFORCED';
        }
        return queryText;
    }

    public static String createQueryTextForPosition(String queryFields, String filterStatus) {
        String queryText = 'SELECT '+queryFields+' FROM Position__c';
        if (!String.isBlank(filterStatus) && filterStatus != 'All') {
            queryText = queryText.replace('FROM Position__c', 'FROM Position__c WHERE Status__c = :filterStatus'); 
        }
        queryText = queryText + ' WITH SECURITY_ENFORCED';
        return queryText;
    }

    @AuraEnabled
    public static StructureDataObjectOfObject getInfoOfRecord(String metadataNameObject, Id idRecordObject, List<String> listNameFields) {
        if (listNameFields==null || listNameFields.isEmpty()) {
            return new StructureDataObjectOfObject();
        }
        GeneralFunctionsMethods.AccessPropertiesForObject accessObject = GeneralFunctionsMethods.getAccessPropertiesToObject(metadataNameObject);
        if (!(accessObject.isAccessible)) {
            return new StructureDataObjectOfObject();
        }
        
        List<String> requiredFieldsToRequest = new List<String>{'Id','Name'};
        List<String> exclusionFieldsForFieldList = new List<String>{'id','name'}; //LowerCase
        
        //Data records
        String queryTextFields = '';
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
        String queryText = '';
        if (!(String.isBlank(queryTextFields))) {
            queryText = 'SELECT '+queryTextFields+' FROM '+metadataNameObject+' WHERE Id =:idRecordObject';
            queryText = queryText + ' WITH SECURITY_ENFORCED LIMIT 1';
        }
        sObject rezultDataRecord = Database.query(queryText);
        
        Map<String,String> labelAndNameFields = GeneralFunctionsMethods.getLabelAndNameFieldsFromMetadataObject(metadataNameObject);

        //Create list fields
        List<StructureFieldsOfObject> detailsFields = new List<StructureFieldsOfObject>();

        //get fields from query elem
        Map<String, Object> valuesOfFieldsFromQuery = rezultDataRecord.getPopulatedFieldsAsMap();
        for (String fieldName : valuesOfFieldsFromQuery.keySet()) {
            if (!(exclusionFieldsForFieldList.contains(fieldName.toLowerCase()))) {
                //String fieldLable = Candidate__c.sObjectType.getDescribe().fields.getMap().get(fieldName).getDescribe().getLabel();
                String fieldLable = Schema.getGlobalDescribe().get(metadataNameObject).getDescribe().fields.getMap().get(fieldName).getDescribe().getLabel();
                Object fieldValue = valuesOfFieldsFromQuery.get(fieldName);
                detailsFields.add(new StructureFieldsOfObject(fieldName, fieldLable, fieldValue));
            }
        }
        //get fields from object, which are not in query, and add
        for (String fieldName : labelAndNameFields.keySet()) {
            if (listNameFields.contains(fieldName) 
                        && !valuesOfFieldsFromQuery.containsKey(fieldName)
                            && !exclusionFieldsForFieldList.contains(fieldName.toLowerCase())) {
                String fieldLable = labelAndNameFields.get(fieldName);
                detailsFields.add(new StructureFieldsOfObject(fieldName, fieldLable, null));
            }
        }
        return new StructureDataObjectOfObject((String)rezultDataRecord.get('Id'), (String)rezultDataRecord.get('Name'), detailsFields);        
    }

    public static Map<String, Object> convertEasyListObjectJStoMapAPEX(String strData) {
        Map<String, Object> mapData = new Map<String, Object>();
        try {
            JSONParser parsedMap = JSON.createParser(strData);
            while(parsedMap.nextToken() != null) {
                if(parsedMap.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String tempKey = parsedMap.getText();
                    parsedMap.nextToken();
                    Object tempValue = parsedMap.getText();
                    mapData.put(tempKey, tempValue);
                }
            }
        } catch (Exception err) {
            System.debug(err);
            mapData.clear();
        }
        return mapData;
    }

    @AuraEnabled
    public static StructureDataObjectOfObject saveUpdateRecord(String nameMetadataObject, String strFields, String idRec) {        
        String errMessage = '';
        Map<String, Object> mapFields = convertEasyListObjectJStoMapAPEX(strFields);
        if (mapFields.size()==0) {
            errMessage = 'Invalid field list format for object!';
            return new StructureDataObjectOfObject(errMessage);
        }
        GeneralFunctionsMethods.AccessPropertiesForObject accessObject = getAccessPropertiesToObject(nameMetadataObject);
        if (!(accessObject.isCreateable || accessObject.isUpdateable)) {
            errMessage = 'No permission to create/update an object!';
            return new StructureDataObjectOfObject(errMessage);
        }

        Map<String, String> labelAndNameFieldsObject = getLabelAndNameFieldsFromMetadataObject(nameMetadataObject);
        
        List<StructureFieldsOfObject> detailsFields = new List<StructureFieldsOfObject>();
    
        //new Object Database 
        sObject recObject = Schema.getGlobalDescribe().get(nameMetadataObject).newSObject();
        //create fields of new Object Database
        for (String fieldName : mapFields.keySet()) {
            String fieldLabel = labelAndNameFieldsObject.get(fieldName);
            if (fieldLabel==null) {
                errMessage = 'Error! Field "' + fieldName + '" is missing in object!';
                return new StructureDataObjectOfObject(errMessage);
            }
            if (accessObject.accessibleFields.get(fieldName)) {
                Object fieldValue = mapFields.get(fieldName);
                recObject.put(fieldName,fieldValue);               
                detailsFields.add(new StructureFieldsOfObject(fieldName, fieldLabel, fieldValue));
            }
        }
        //Insert new Object Database 
        try {
            Database.SaveResult databaseResult;
            if(String.isBlank(idRec)){
                databaseResult = Database.insert(recObject);
            }
            else {
                recObject.id = idRec;
                databaseResult = Database.update(recObject);
            }
            if (!databaseResult.isSuccess()) {
                errMessage = 'The following error has occurred.' + '\n' ;
                for (Database.Error err : databaseResult.getErrors()) { 
                    errMessage = errMessage + err.getStatusCode() + ': ' + err.getMessage() + '\n' ;
                    errMessage = errMessage + nameMetadataObject + ' fields that affected this error: ' + err.getFields();
                }
            }            
        } 
        catch (Exception exc) {            
            errMessage = 'The following error has occurred.' + '\n' ;
            errMessage = errMessage + exc.getMessage();
        }
        
        String id = '';
        String name = '';
        if(String.isBlank(errMessage)) {
            id = recObject.id==null?'':(String)recObject.id;
            name = recObject.get('Name')==null?'':(String)recObject.get('Name');
        }
        
        return new StructureDataObjectOfObject(id, name, detailsFields, errMessage);
    }

    public static Integer returnMaxRecordsAsPerLimit() {
        return (Limits.getLimitQueryRows() - Limits.getQueryRows());
    }

    @AuraEnabled
    public static void saveInsertAndUpdateCustomMetadataTypes(String fullNameMetadata, String labelMetadata, String fieldsWithValues){
        Map<String, String> fieldsWithValuesMap = (Map<String, String>) json.deserialize(fieldsWithValues, Map<String, String>.class);        
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = fullNameMetadata;
        customMetadata.label = labelMetadata;
        for (String key: fieldsWithValuesMap.keySet()) {
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();        
            customField.field = key;
            customField.value = fieldsWithValuesMap.get(key);
            customMetadata.values.add(customField);
        }
    
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();        
        mdContainer.addMetadata(customMetadata);        
        
        Id recId = Metadata.Operations.enqueueDeployment(mdContainer, null);        
    }
    
    @AuraEnabled
    public static Map<String,Map<String,Map<String,String>>> getListOfValuesCustomMetadataTypes(List<String> listNameMetadata) {
        Map<String,Map<String,Map<String,String>>> valuesAllRecFromCustomMetadata = new Map<String,Map<String,Map<String,String>>>();
        
        for(String nameMetadata : listNameMetadata){
            List<String> listRecMetadata = new List<String>();
            String queryText = 'SELECT QualifiedApiName FROM '+nameMetadata+'__mdt';
            List<sObject> queryResult;
            try {
                queryResult = Database.query(queryText);    
            } catch (Exception exc) {
                return valuesAllRecFromCustomMetadata;
            }            
            for(sObject mdObject : queryResult){
                listRecMetadata.add((String)mdObject.get('QualifiedApiName'));
            }
            Map<String,Map<String,String>> valuesMetadata = new Map<String,Map<String,String>>();
            for(String nameRecMetadata : listRecMetadata){
                String nameFullMetadata = nameMetadata + '.' + nameRecMetadata; 
                Map<String,String> fieldsAndValuesMetadata = retrieveRecCustomMetadata(nameFullMetadata);
                valuesMetadata.put(nameRecMetadata,fieldsAndValuesMetadata);
            }
            valuesAllRecFromCustomMetadata.put(nameMetadata,valuesMetadata);
        }
        
        return valuesAllRecFromCustomMetadata;
    }

    public static Map<String,String> retrieveRecCustomMetadata (String fullNameMetadata) {
        Map<String,String> customMetadata = new Map<String,String>();
        
        List<String> componentNameList = new List<String>{fullNameMetadata};
        
        List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, componentNameList);
        Metadata.CustomMetadata customMetadataRecord = (Metadata.CustomMetadata) components.get(0);
        
        List<Metadata.CustomMetadataValue> values = customMetadataRecord.values;
        for (integer i=0; i<values.size(); i++) {
            String nameField    = values.get(i).field;
            String valueField   = (String)values.get(i).value;
            customMetadata.put(nameField,valueField);
        }
        
        return customMetadata;
    }

    public static Map<String,Object> getInfoOfCurrentUser() {
        Map<String,Object> infoOfCurrentUser = new Map<String,Object>();

        String userRoleId = UserInfo.getUserRoleId();
        String roleName = [SELECT Id, Name FROM UserRole WHERE Id =:userRoleId LIMIT 1].Name;
        infoOfCurrentUser.put('roleName',roleName);

        String userProfileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id =:userProfileId LIMIT 1].Name;
        infoOfCurrentUser.put('profileName',profileName);
        
        Boolean isRecruiter = roleName.toLowerCase().contains('recruiter');
        Boolean isInterviewer = roleName.toLowerCase().contains('interviewer');
        infoOfCurrentUser.put('isRecruiter',isRecruiter);
        infoOfCurrentUser.put('isInterviewer',isInterviewer);
        
        Boolean isAdmin = profileName.toLowerCase().contains('admin');//('system administrator');
        infoOfCurrentUser.put('isAdmin',isAdmin);

        return infoOfCurrentUser;
    }

    public static AuraHandledException newMessageException(String message) {
        AuraHandledException err = new AuraHandledException(message);
        err.setMessage(message);
        return err;
    }

}