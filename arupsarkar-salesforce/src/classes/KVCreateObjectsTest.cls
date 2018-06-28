@isTest (seeAllData=true)

public class KVCreateObjectsTest{

    static testMethod void testCreateObjects(){
        
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
        //Testing trigger and Goal Management Engine -- END


        KVApexJobVisualController visualController = new KVApexJobVisualController();
        Boolean goalAchieversExist = visualController.GoalAchieversExist;
        System.assertEquals(true, goalAchieversExist);        
        
        Boolean apexJobON = visualController.isApexJobEnabled;
        System.assertEquals(true, apexJobON);        
        
        PageReference page3 = visualController.ApexScheduleOFF();
        System.assertEquals(null, page3);
        
        PageReference page2 = visualController.UpdateCronId();
        System.assertEquals(null, page2);
        PageReference page1 = visualController.ApexScheduleON();        
        System.assertEquals(null, page1);                
        

        //PageReference page4 = visualController.processAllPendingItemsInQueue();
        
        
               
        //Testing Apex Utility Engine Schedule -START
        /*
        //Testing Apex UtilityEngine -START
        KVApexJobSchedule__c KVapexScheduler = KVApexUtilityEngine.GetorCreateApexSchedule();
        KVApexUtilityEngine.SendEmailToGoalOwner('Test Subject','Test Email Body','arup.sarkar@kavayah.com');
        //Testing Apex UtilityEngine -END        
                
         //Test ApexBatchExecute -START
        Boolean apexBatchExecute = KVApexBatchExecute.mockCallout(goalAchieverList[0]);
        //Test ApexBatchExecute -END
        */


        
        /*
        String CRON_EXP = '0 0 0-23 * * ?';
        SchedulableContext sc;
        KVApexSchedule apexsched = new KVApexSchedule();
        apexsched.execute(sc);
        */
        
 
                 
 
        //Testing Apex Batch -END
        
        
    }
}