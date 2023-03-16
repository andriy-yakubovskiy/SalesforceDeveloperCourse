@isTest
public class DataFactory_Test {

    public static List<Position__c> createPositions(Integer quantityPos) {
        Map <String, Schema.RecordTypeInfo> recordTypesPosition = Schema.SObjectType.Position__c.getRecordTypeInfosByDeveloperName();
        Id idRecordTypePosAdmin = recordTypesPosition.get('Admin').getRecordTypeId();
        Id idRecordTypePosTech  = recordTypesPosition.get('Tech').getRecordTypeId();
        List<Position__c> listPositions = new List<Position__c>();
        for(Integer i=0; i<quantityPos; i++) {
            Id idRecordTypePos = idRecordTypePosAdmin; 
            String namePos = 'Dev for department #' + String.valueOf(i);
            if(math.mod(i, 2) == 0) {
                idRecordTypePos = idRecordTypePosTech;
                namePos = 'Tech for department #' + String.valueOf(i);
            }
            Position__c newPosition = new Position__c(
                                RecordTypeId = idRecordTypePos,
                                Name = namePos, 
                                TypeEmployment__c = 'Full Time',
                                Status__c = 'Open',
                                Open_Date__c = date.today()
                                );
            listPositions.add(newPosition);
        }
        insert listPositions;
        return listPositions;
    }
    
}