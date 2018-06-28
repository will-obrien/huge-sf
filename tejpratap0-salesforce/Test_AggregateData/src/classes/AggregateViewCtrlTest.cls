@isTest
public class AggregateViewCtrlTest {
	static testMethod void AggregateTest()
    { 
        Test.startTest(); 
        
        // Create a Account object
        Account accObj = new Account(Name='Test1');
        insert accObj;  
        
        // Create a AggregateData__c object
        AggregatedData__c aggObj = new AggregatedData__c();    
    	aggObj.Cases__c = 3;
        aggObj.Contacts__c = 2;
        aggObj.OpportunitiesCL__c = 4; 
        aggObj.OpportunitiesCW__c = 3;
        aggObj.OpportunitiesER__c = 1;
        aggObj.OpportunitiesOP__c = 2; 
        aggObj.Opportunities__c = 3;		 
		aggObj.WeekEndDate__c = Datetime.newInstance(2014, 5, 1, 11, 12, 14);
        aggObj.WeekNumber__c =  34;
        aggObj.WeekStartDate__c =  Datetime.newInstance(2014, 5, 8, 11, 12, 14);
        aggObj.Year__c = 2014;
        aggObj.Account__c = accObj.Id; 
        insert aggObj;
       
        //User Input
        AggregateViewCtrl avc = new AggregateViewCtrl(); 
        avc.startDate = Date.newInstance(2014, 1, 15);
        avc.endDate = Date.newInstance(2014, 11, 15);
        avc.account = accObj.Name; 
        avc.go(); 
        System.debug('Response Data '+ avc.aggregateRecords);
        
        System.assertEquals(1, avc.aggregateRecords.size() );
        test.stopTest();
          
    }
}