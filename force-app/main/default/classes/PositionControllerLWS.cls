public with sharing class PositionControllerLWS {

    public class DataPositionRecords {
        @AuraEnabled public Integer countRecords { get; set; }
        @AuraEnabled public List<Position__c> listRecords { get; set; }
        public DataPositionRecords() {
            countRecords = 0;
            listRecords = new List<Position__c>();             
        }
    }

    @AuraEnabled
    public static DataPositionRecords getPositionsRecords(String filterStatus, Integer startFromRecord, Integer quantityRecords) {
        DataPositionRecords wrapperRezult = new DataPositionRecords();
        try { 
            if ((startFromRecord != NULL && quantityRecords != NULL) && (startFromRecord > 0 && quantityRecords > 0)) {
                List<String> listNameFieldsPosition = new List<String>();
                listNameFieldsPosition.add('Status__c');
                listNameFieldsPosition.add('Open_Date__c');
                listNameFieldsPosition.add('Close_Date__c');

                String notAccessibleFields = '';
                GeneralFunctionsMethods.AccessPropertiesForObject accessObject = GeneralFunctionsMethods.getAccessPropertiesToObject('Position__c');
                for (String nameField : listNameFieldsPosition) {
                    DescribeFieldResult fieldObjectMetadata = accessObject.fieldsDescribeMetadata.get(nameField);
                    if(!fieldObjectMetadata.isAccessible()) {
                        notAccessibleFields = notAccessibleFields + (String.isEmpty(notAccessibleFields)? '' : ', ') + fieldObjectMetadata.getLabel();
                    }
                }
                if((accessObject.isAccessible) && (String.isEmpty(notAccessibleFields))) {
                    String queryText = '';
                    String queryFields = '';
                    
                    queryFields = 'Count()';
                    queryText = GeneralFunctionsMethods.createQueryTextForPosition(queryFields,filterStatus);
                    Integer rezultQueryCount = Database.countQuery(queryText);
                    
                    queryFields = 'Id,Name';
                    for (String nameField : listNameFieldsPosition) {                        
                        queryFields = queryFields + ',' + nameField;
                    }
                    Integer MaxRecords = GeneralFunctionsMethods.returnMaxRecordsAsPerLimit();
                    //Example: SELECT * FROM Position__c LIMIT 5 OFFSET 2; // = from 3 to 7(include)
                    queryText = GeneralFunctionsMethods.createQueryTextForPosition(queryFields,filterStatus);                    
                    queryText = queryText + ' LIMIT '+String.valueOf((quantityRecords>MaxRecords)?MaxRecords:quantityRecords)+' OFFSET '+String.valueOf(startFromRecord-1);
                    List<Position__c> rezultQueryRecords = Database.query(queryText);
                
                    wrapperRezult.countRecords = rezultQueryCount;
                    wrapperRezult.listRecords = rezultQueryRecords;                
                }
                else {
                    String testMessage = System.Label.Access_denied + ' ' + System.Label.for + ' ' + System.Label.Position.toLowerCase() + '!';
                    if(!String.isEmpty(notAccessibleFields)) {
                        testMessage = testMessage + ' ' + System.Label.Access_denied + ' ' + System.Label.for + ' ' + System.Label.position.toLowerCase() + ' ' + System.Label.field + ' : ' + notAccessibleFields + '!';
                    }
                    throw GeneralFunctionsMethods.newMessageException(testMessage);
                }
            }            
        }
        catch (System.QueryException e) {
            throw GeneralFunctionsMethods.newMessageException(System.Label.Error + ' ' + System.Label.Access_denied.toLowerCase() + '! | Error : ' + e.getMessage());
        }
        catch (Exception e) {
            throw GeneralFunctionsMethods.newMessageException(System.Label.Error + ' ' + System.Label.get.toLowerCase() + ' ' + System.Label.Data.toLowerCase() + ' ' + System.Label.from.toLowerCase() + ' ' + System.Label.positions.toLowerCase() + '! | Error : ' + e.getMessage());
        }
        return wrapperRezult;
    }
    
    @AuraEnabled
    public static Boolean updataPositionsList(List<Position__c> dataUpdate) {
        Boolean rezultUp;
        try {
            GeneralFunctionsMethods.AccessPropertiesForObject accessObject = GeneralFunctionsMethods.getAccessPropertiesToObject('Position__c');
            if(accessObject.isUpdateable) {
                Database.update(dataUpdate);
                rezultUp = true;
            }
        }
        catch (Exception e) {
            throw GeneralFunctionsMethods.newMessageException(System.Label.Error + ' ' + System.Label.Data.toLowerCase()  + ' (' + System.Label.Position.toLowerCase() + ') ' + System.Label.Updata.toLowerCase() + '! | Error : ' + e.getMessage());
        }
        return rezultUp;
    }

    
    
      
}