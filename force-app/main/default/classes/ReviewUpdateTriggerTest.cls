@isTest
public with sharing class ReviewUpdateTriggerTest {
    @TestSetup
    static void generationData() {
        Job_Application__c jobApplication = new Job_Application__c(Global_rating_review__c = 0);
        insert jobApplication;        
    }

    @isTest static void TestActionsTriggerReviewTest() {
        
        Job_Application__c jobApplication_before = [SELECT Id,Global_rating_review__c FROM Job_Application__c LIMIT 1];

        Integer quantityList = 8;
        List<Review__c> listReview = new List<Review__c>();
        for(Integer i=0; i<quantityList; i++) {
            Review__c newReview = new Review__c(
                                Description__c = 'Norm #' + String.valueOf(i), 
                                Job_Application__c = jobApplication_before.Id,
                                Rating__c = i
                                );
            listReview.add(newReview);
        }

        Test.startTest(); 

        insert listReview;
        Job_Application__c jobApplication_after = [SELECT Id,Global_rating_review__c FROM Job_Application__c LIMIT 1];                
        

        System.assert(jobApplication_before.Global_rating_review__c != jobApplication_after.Global_rating_review__c, 'before' + jobApplication_before.Global_rating_review__c + ' - ' + 'after' + jobApplication_after.Global_rating_review__c);

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        Job_Application__c jobApplication_beforeUP = [SELECT Id,Global_rating_review__c FROM Job_Application__c LIMIT 1];

           
        List<Review__c> listReviewUpDate = [SELECT Id,Rating__c FROM Review__c LIMIT :quantityList/2];                
        for (Review__c reviewUp : listReviewUpDate) {
            reviewUp.Rating__c = 9;
        }
        update listReviewUpDate;
        Job_Application__c jobApplication_afterUP = [SELECT Id,Global_rating_review__c FROM Job_Application__c LIMIT 1];                
        

        System.assert(jobApplication_beforeUP.Global_rating_review__c != jobApplication_afterUP.Global_rating_review__c, 'before' + jobApplication_before.Global_rating_review__c + ' - ' + 'after' + jobApplication_after.Global_rating_review__c);

        Test.stopTest();

    }
}