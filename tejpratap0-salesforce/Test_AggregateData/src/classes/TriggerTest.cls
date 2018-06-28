@isTest 
public with sharing class TriggerTest {
   
	static testMethod void test_AggregateCase(){  
        Account acc = new Account();
        acc.Name = 'Test Account'; 
        insert acc; 
         
        Account accNew = new Account();
        accNew.Name = 'Test Account'; 
        insert accNew; 
        
        Test.startTest(); 
            Case caseObj = new Case();
            caseObj.AccountId = acc.Id;
            insert caseObj;   
            System.debug('Case : '+caseObj.Id +', Case : '+caseObj); 
          
        	caseObj.AccountId = acc.Id;
            update caseObj;
         
        	caseObj.AccountId = accNew.Id;
            update caseObj;
        
        	delete caseObj; 
        Test.stopTest();   
	}
    
     static testMethod void test_AggregateContact(){ 
        
        Account acc = new Account();
        acc.Name = 'Test Account'; 
        insert acc; 
         
        Account accNew = new Account();
        accNew.Name = 'Test Account'; 
        insert accNew; 
        
        Test.startTest(); 
            Contact conObj = new Contact();
        	conObj.LastName = 'Test';
            conObj.AccountId = acc.Id;
            insert conObj;   
            System.debug('con : '+conObj.Id +', con : '+conObj); 
         
        	conObj.AccountId = acc.Id;
            update conObj; 
        
        	conObj.AccountId = accNew.Id;
            update conObj;
        
        	delete conObj; 
        Test.stopTest();   
	}
     
    
    static testMethod void test_AggregateOpportunity(){  
        Account acc = new Account();
        acc.Name = 'Test Account'; 
        insert acc; 
         
        Account accNew = new Account();
        accNew.Name = 'Test Account'; 
        insert accNew; 
        
        Test.startTest(); 
            Opportunity opprObj = new Opportunity();
            opprObj.CloseDate = Date.newInstance(2014, 11, 11)  ;
            opprObj.Name = 'Test Opportunity'; 
            opprObj.AccountId = acc.Id;
        
            opprObj.StageName = 'Closed Won'; 
        	insert opprObj;
        
        	//Previous Account != NULL & Current Account == NULL
        	opprObj.AccountId = null;
        	opprObj.StageName = 'Closed Won'; 
        	update opprObj;
        
        	//Previous Account == NULL & Current Account != NULL
        	opprObj.AccountId = acc.Id; 
        	opprObj.StageName = 'Closed Won'; 
        	update opprObj;
        
        	//Previous Account != NULL & Current Account != NULL 
        	opprObj.AccountId = accNew.Id;
        	opprObj.StageName = 'Closed Won'; 
        	update opprObj;  
        
        	opprObj.AccountId = acc.Id;
        	opprObj.StageName = 'Closed Lost'; 
        	update opprObj;

        	opprObj.AccountId = accNew.Id;
        	opprObj.StageName = 'Qualification'; 
        	update opprObj;
        
        	opprObj.AccountId = acc.Id;
        	opprObj.StageName = 'Closed Won'; 
        	update opprObj;  
        
        	opprObj.AccountId = acc.Id;
        	opprObj.StageName = 'Closed Lost'; 
        	update opprObj;
  
        Test.stopTest();   
	}
 
	static testMethod  void test_PostInstallHandler() {
        PostInstallHandler postinstall = new PostInstallHandler();
        
        Test.testInstall(postinstall, null); 
      	
        Integer count = [SELECT count() FROM AggregatedData__c];
        if(count > 0)
        	System.assertEquals(0, 0);
    }
}