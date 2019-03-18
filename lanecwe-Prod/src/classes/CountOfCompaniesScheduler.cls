/**
 * This is scheduler class for scheduling CountOfCompaniesBatch batch
 *
 * @author Carmen Wong
 * @version 1.0
 */
global class CountOfCompaniesScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        CountOfCompaniesBatch batch = new CountOfCompaniesBatch();
        batch.query = 'SELECT Id, Count_of_Companies__c FROM Account';	
        Database.executeBatch(batch);
    }
}