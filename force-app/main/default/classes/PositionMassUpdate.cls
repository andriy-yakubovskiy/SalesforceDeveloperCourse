public class PositionMassUpdate implements Database.Batchable<sObject>, Database.Stateful {
        public Integer recordsIterationsBatch = 0;
        
        public Database.QueryLocator start(Database.BatchableContext bc) {
            Integer dayPoint = 90;
            String textQuery =  'SELECT Id,Open_Date__c,Close_Date__c,Status__c ' +
                                'FROM Position__c ' +
                                'WHERE Open_Date__c < LAST_N_DAYS:'+String.valueOf(dayPoint)+
                                ' AND Close_Date__c = NULL';

            return Database.getQueryLocator(textQuery);
        }

        public void execute(Database.BatchableContext bc, List<Position__c> records){
            List<Position__c> positionsList = new List<Position__c>();
            for (Position__c position : records) {
                position.Close_Date__c = Date.today();
                position.Status__c = 'Close not successful';
                positionsList.add(position);
            }
            Database.update(positionsList);
            recordsIterationsBatch = recordsIterationsBatch + 1;
        }

        //information for me
        public void finish(Database.BatchableContext bc){
            System.debug('Iterations Batch = ' + recordsIterationsBatch);
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
                JobItemsProcessed,
                TotalJobItems
                FROM AsyncApexJob
                WHERE Id = :bc.getJobId()];
            System.debug('jobPositionMassUpdate:');
            System.debug(job);
        }
    }