@isTest (seeAllData=true)
public class KVApexBatchTest{

    static testMethod void testApexBatch(){
        
        Test.startTest();
        
        KVCreateObjects createObjects = new KVCreateObjects();
        
        
        
        //Testing trigger and Goal Management Engine -- START
        //Goal is created after Goal Achievers call
        List<Goal_Achiever__c> goalAchieverList = createObjects.getGoalAchiever(); 
        Goal__c accountGoal = createObjects.accountGoal;
        Account account = createObjects.account;
        Contact contact = createObjects.contact;
        
        System.debug('~~~~~~~~~~~~ Goal Id : ' + accountGoal.Id);
        //System.debug('~~~~~~~~~~~~ Account Id : ' + account.Id);
        //System.debug('~~~~~~~~~~~~ Contact Id : ' + contact.Id);
        System.debug('~~~~~~~~~~~~ Account Goal Achiever Id : ' + goalAchieverList[0].Id);        
        System.debug('~~~~~~~~~~~~ Contact Goal Achiever Id : ' + goalAchieverList[1].Id);                
        
        System.assertEquals(goalAchieverList[0].Object_Id__c, (String)account.Id);
        System.assertEquals(goalAchieverList[1].Object_Id__c, (String)contact.Id);                
        
        
        KVApexBatch obj = new KVApexBatch();
        obj.errorList.add(goalAchieverList[1]);
        Database.BatchableContext BC;
        ID batchassignid = Database.executeBatch(obj);

        Test.stopTest();        
    
    }
    
}