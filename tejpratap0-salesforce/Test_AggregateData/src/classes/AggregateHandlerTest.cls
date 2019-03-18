@isTest 
public with sharing class AggregateHandlerTest {
	static testMethod void test_syncWeekly(){
        AggregateHandler aggrHandler = new AggregateHandler();
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.CaseIds__c = '5009000000XlTtVAAV,5009000000XlTtqAAF';
        acc.Cases__c = 2.0;
        acc.ContactIds__c = '0039000001ASZGkAAP,0039000001ASZC7AAP';
        acc.Contacts__c = 2.0; 
        acc.OpportunitiesCL__c = 1.0;
        acc.OpportunitiesCW__c = 2.0;
        acc.OpportunitiesOP__c = 1.0;
        acc.Opportunities__c = 4.0;
        acc.OpportunityCWIds__c = '0069000000Oif6nAAB,0069000000Oif08AAB';
        acc.OpportunityCLIds__c = '0069000000OAklQAAT';
        acc.OpportunityOPIds__c = '0069000000OiexGAAR';
        acc.OpprtunityIds__c = '0069000000OiexGAAR,0069000000OAklQAAT,0069000000Oif6nAAB,0069000000Oif08AAB';
        acc.OpportunitiesER__c = 1000.0;
        insert acc; 
        
        Test.startTest(); 
        aggrHandler.syncWeekly();
        Test.stopTest();   
	}
    
    static testMethod void test_syncPrevious(){
        AggregateHandler aggrHandler = new AggregateHandler();
          
        Account accObj = new Account();
        accObj.Name = 'Test Account'; 
        insert accObj;  
        System.debug('Account Id : '+accObj.Id+', Account : '+accObj);
  	
        Case caseObj = new Case();
        caseObj.AccountId = accObj.Id; 
        insert caseObj;  
        System.debug('Case : '+caseObj.Id +', Case : '+caseObj);
        
        Contact conObj = new Contact();
        conObj.LastName = 'Test Contact';
        conObj.AccountId = accObj.Id; 
        insert conObj;  
        System.debug('Contact : '+conObj.Id +', Contact : '+conObj);
        
        List<Opportunity> opprList = new List<Opportunity>();
        
        Opportunity opprObj1 = new Opportunity();
        opprObj1.CloseDate = Date.newInstance(2014, 11, 11)  ;
		opprObj1.Name = 'Test Opportunity';
    	opprObj1.StageName = 'Closed Won';
        opprObj1.AccountId = accObj.Id; 
        opprList.add(opprObj1);  
         
        Opportunity opprObj2 = new Opportunity();
        opprObj2.CloseDate = Date.newInstance(2014, 11, 11)  ;
		opprObj2.Name = 'Test Opportunity';
    	opprObj2.StageName = 'Closed Lost';
        opprObj2.AccountId = accObj.Id; 
        opprList.add(opprObj2);  
        
        Opportunity opprObj3 = new Opportunity();
        opprObj3.CloseDate = Date.newInstance(2014, 11, 11)  ;
		opprObj3.Name = 'Test Opportunity';
    	opprObj3.StageName = 'Qualification';
        opprObj3.AccountId = accObj.Id; 
        opprList.add(opprObj3);  
        
        Opportunity opprObj4 = new Opportunity();
        opprObj4.CloseDate = Date.newInstance(2014, 11, 11)  ;
		opprObj4.Name = 'Test Opportunity';
    	opprObj4.StageName = 'Closed Won'; 
        opprList.add(opprObj4);  
        
        Opportunity opprObj5 = new Opportunity();
        opprObj5.CloseDate = Date.newInstance(2014, 11, 11)  ;
		opprObj5.Name = 'Test Opportunity';
    	opprObj5.StageName = 'Closed Lost'; 
        opprList.add(opprObj5);  
        
        Opportunity opprObj6 = new Opportunity();
        opprObj6.CloseDate = Date.newInstance(2014, 11, 11)  ;
		opprObj6.Name = 'Test Opportunity';
    	opprObj6.StageName = 'Qualification';
        opprObj6.AccountId = accObj.Id; 
        opprList.add(opprObj6);  
        
        insert opprList;
        
        Test.startTest(); 
         	aggrHandler.syncPrevious(10);
        Test.stopTest();   
	}
     
}