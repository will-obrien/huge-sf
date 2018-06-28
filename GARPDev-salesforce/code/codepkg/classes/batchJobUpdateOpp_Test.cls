@isTest
public class batchJobUpdateOpp_Test {

    Static Account acc;
    Static Opportunity opp;
    Static Opportunity opp1;
    Static Opportunity opp2;
    Static Opportunity opp3;
    
	Static Exam_Attempt__c ea;
	Static Exam_Attempt__c ea1;
	Static Exam_Attempt__c ea2;
	Static Exam_Attempt__c ea3;
    
    Static Exam_Sites__c es;
    
     static void testData()
     {
        acc = new Account(name = 'Test Account1', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
        insert acc;
    
		es = new Exam_Sites__c(name = 'Test ES1');
        insert es;
         
        opp = new Opportunity(name = 'Test Opp1', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', FRM_1_Registration_Fee__c = 350.00);
        insert opp;
         
        ea = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp.Id );
        insert ea;

        opp1 = new Opportunity(name = 'Test Opp2', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', FRM_2_Registration_Fee__c = 350.00);
        insert opp1;

        ea1 = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp1.Id );
        insert ea1;

        opp2 = new Opportunity(name = 'Test Opp3', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', EA_Id__c = String.valueOf(ea.Id));
        insert opp2;

        ea2 = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp2.Id );
        insert ea2;

        opp3 = new Opportunity(name = 'Test Opp4', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', Undefred_EA_Id__c = String.valueOf(ea.Id));
        insert opp3;

        ea3 = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp3.Id );
        insert ea3;

     }
     
     static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        batchJobUpdateOpp b = new batchJobUpdateOpp('mode');
        database.executeBatch(b);
        test.stopTest();
    }

}