trigger ReviewUpdateTrigger on Review__c (after insert, after update, after delete) {

    List<Job_Application__c> listJobApp = new List<Job_Application__c>();

    //Get list ID for all JobApplications from Reviews
    Set<Id> jobAppSetId = new Set<Id>();
    if (Trigger.oldMap!=null) {
        for (Id keyMapId : Trigger.oldMap.keySet()) {
            if (Trigger.oldMap.get(keyMapId).Job_Application__c!=null) {
                jobAppSetId.add(Trigger.oldMap.get(keyMapId).Job_Application__c);
            }
        }
    }
    if (Trigger.newMap!=null) {
        for (Id keyMapId : Trigger.newMap.keySet()) {
            if (Trigger.newMap.get(keyMapId).Job_Application__c!=null) {
                jobAppSetId.add(Trigger.newMap.get(keyMapId).Job_Application__c);
            }
        }
    }
    
    //Get info to Job_Application__c from Review__c using aggregate functions
    if ( ! jobAppSetId.isEmpty() ) {
        List<AggregateResult> aggrResultJobApp = [SELECT Job_Application__c,Count(ID),SUM(Rating__c) 
                                         FROM Review__c WHERE Job_Application__c IN:jobAppSetId
                                         GROUP BY Job_Application__c];        
        for (AggregateResult aggResult : aggrResultJobApp) {
            Decimal globalRatingReview = 0;
            Integer ReviewCount = (Integer)aggResult.get('expr0');
            Decimal ReviewSum = (Decimal)aggResult.get('expr1');
            if (ReviewCount!=0) {
                globalRatingReview = ReviewSum / ReviewCount;
            }
            listJobApp.add(new Job_Application__c(
                                                Id = (Id)aggResult.get('Job_Application__c'), 
                                                Global_rating_review__c = globalRatingReview)
                          );
        }
    }

    if ( ! listJobApp.isEmpty() ) {
        update listJobApp;
    }
    
}