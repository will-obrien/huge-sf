/*
Create an Apex class that implements the Database.Batchable interface to update all Lead records in the org with a specific LeadSource. 
Write unit tests that achieve 100% code coverage for the class.

Create an Apex class called 'LeadProcessor' that uses the Database.Batchable interface.
Use a QueryLocator in the start method to collect all Lead records in the org.
The execute method must update all Lead records in the org with the LeadSource value of 'Dreamforce'.
Create an Apex test class called 'LeadProcessorTest'.
In the test class, insert 200 Lead records, execute the 'LeadProcessor' Batch class and test that all Lead records were updated correctly.
The unit tests must cover all lines of code included in the LeadProcessor class, resulting in 100% code coverage.
Run your test class at least once (via 'Run All' tests the Developer Console) before attempting to verify this challenge.
*/

global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    
    //instance memeber to retain state acrosss transactions
    global Integer recordsProcessed = 0;

    //collect the batches of records or objects to be passed to execute
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(
            'SELECT Id, FirstName, LastName,LeadSource FROM Lead'
            );
    }

    //process each batch of records
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        List<Lead> leads = new List<Lead>();

        for (Lead lead1 : scope){
            lead1.LeadSource = 'Dreamforce';
            leads.add(lead1);
            //increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
        }
        update leads;
    }

    //execute any post-processing operations
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + 'records processed.');
        AsyncApexJob job =[SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];

        //call some utility to send email;      
        //EmailUtils.sendMessage(a, recordsProcessed);
    }
}