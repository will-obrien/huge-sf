/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_Batch_Account_Balance_His_Weekly{

    static testmethod void test(){
        
        // The query used by the batch job.
        String query = 'SELECT id, name, Remaining_Balance__c, AccountId, Sub_Stage__c from Opportunity WHERE AccountId != null AND Remaining_Balance__c > 0';
        //Create Account for testing
        Account acc = new Account(Name='Test Account');
        insert acc;  
        //Create opporutnities to be tested.
        Opportunity opp = new Opportunity(Name = 'Test', AccountId = acc.Id,StageName = 'Close Won', Sub_Stage__c = 'SubStage', CloseDate=system.today());      
        insert opp;
        //Create Term
        Payment_Terms__c pt = new Payment_Terms__c(Active__c = true, Opportunity__c = opp.id);
        insert pt;
        //Create Planned Payment
        Planned_Payment__c pp= new Planned_Payment__c(Amount_Due__c = 5000, Due_Date__c = system.today(), Payment_Terms__c = pt.id);  
        insert pp; 
        //Create Account balance history record to check previous value.
        Account_Bal_History__c abh = new Account_Bal_History__c();      
        abh.Account__c = acc.id;
        abh.Current_total_remaining_balance__c = 6000;  
        abh.Opportunity__c = opp.Id;
        abh.Previous_total_remaining_balance__c = 7000;
        abh.Recorded_Date__c = system.now(); //Datetime.newInstance(2016, 3, 10);
        abh.Recorded_time_period__c = 'Weekly';
        abh.Opportunity_Sub_Stage__c = opp.Sub_Stage__c;
        insert abh;
        
        Test.StartTest();
            Batch_Account_Balance_History_Weekly cls = new Batch_Account_Balance_History_Weekly();
            Database.executeBatch(cls, 1);
        Test.StopTest();
           
        list<Account_Bal_History__c> abhrec = new list<Account_Bal_History__c>([SELECT Account__c, Current_total_remaining_balance__c, Previous_total_remaining_balance__c, Opportunity__c FROM Account_Bal_History__c WHERE Opportunity__c = :opp.id AND Recorded_time_period__c = 'Weekly' ORDER BY Current_total_remaining_balance__c ASC ]);
        system.assertequals(2, abhrec.size()); 
        system.assertequals(abhrec[0].Current_total_remaining_balance__c, 5000);
        system.assertequals(abhrec[0].Previous_total_remaining_balance__c, 6000);   
    }
}