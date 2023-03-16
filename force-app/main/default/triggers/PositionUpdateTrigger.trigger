trigger PositionUpdateTrigger on Position__c (before update) {
    for(Position__c ElementRecord : Trigger.New) {
        
        //Set field 'Close_Date__c'
        Date closeDate;
        System.debug(ElementRecord.Status__c);
        if ((ElementRecord.Status__c!=null) && ElementRecord.Status__c.contains('Close')) {
            closeDate = Date.today();
        }
        ElementRecord.Close_Date__c = closeDate;

        //Set field 'Flow_start_day_by_status__c'
        Integer day = ElementRecord.Position_opening_days__c.intValue();        
        ElementRecord.Flow_start_day_by_status__c = ElementRecord.Open_Date__c.addDays(day);
        
    }    
}