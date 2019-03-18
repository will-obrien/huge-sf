@isTest
public with sharing class AttachmentTest {
    static testMethod void testConManContractAttachment(){
        Test.startTest();
        User testUser = PGITestUtilities.getTestUser();
        testUser.FirstName = 'eCommerce';
        testUser.LastName = 'Customer';
        insert testUser;
        
        system.runAs(testUser){
	        Account testAcc = PGITestUtilities.getAccountDetails();
	        testAcc.SlesgatewayID__c = 'abc';
	        insert testAcc;
	        Opportunity testOpp = PGITestUtilities.getOpportunityDetails();
	        insert testOpp;
	        CONMAN_Contract__c testConManContract = PGITestUtilities.getConManContractDetails(testAcc.Id,testOpp.Id);
	        testConManContract.z_source__c = 'Salesgateway';
	        insert testConManContract;
	        Attachment testAtt = PGITestUtilities.createAttachment(testConManContract.Id);
	        insert testAtt;
	        
	        testAtt.Name = 'test attachment';
	        update testAtt;
	        
	        CONMAN_Contract__c conManContractResult = [SELECT Contract_Status__c FROM CONMAN_Contract__c WHERE Id =: testConManContract.Id];
	        system.assertEquals(conManContractResult.Contract_Status__c, 'Customer Accepted');
        }
        
        Test.stopTest(); 
    }
    
    static testMethod void testQuoteAttachment(){
    	Test.startTest();
    	Account testAcc = PGITestUtilities.getAccountDetails();
    	insert testAcc;
    	Contact testContact = PGITestUtilities.getContactDetails(testAcc.Id);
    	insert testContact;
    	Opportunity testOpp = PGITestUtilities.getOpportunityDetails();
	   	insert testOpp;
    	Quote testQuote = PGITestUtilities.getQuoteDetails(testAcc.Id, testContact.Id, testOpp.Id);
    	insert testQuote;
    	Attachment testAtt = PGITestUtilities.createAttachment(testQuote.Id);
	    insert testAtt;
	    delete testAtt;
	    undelete testAtt;
	    
	    testQuote.Status = 'Submitted Contract- Customer Approval';
	    update testQuote;
	    try{
	    	delete testAtt;
	    	system.assert(false);
	    }
	    catch(Exception ex){
	    	system.assert(true);
	    }
    	
    	Test.stopTest();
    }
}