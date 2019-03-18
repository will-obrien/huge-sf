/********************************************************************************
Name:  PGINewQuoteController()
Copyright © 2012  PGI 
======================================================
======================================================
Purpose:
-------
This class used to create new Quote
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  8/10/2012        Added
********************************************************************************/  
public with sharing class PGINewQuoteController {
        public Quote quote {get;set;}
        list<Opportunity>oppList=new list<Opportunity>();
        list<Quote>quoteList=new list<Quote>();
        public string quoteId {get; set;}
        public Quote updateQuote{get;set;}
        public Boolean isMinimum { get; set; }
        public String teslaComapnyObjectPrefix{get; set;}
        public String masterContractObjectPrefix {get; set;}
        public String contactObjectPrefix {get; set;}
        public String deleteNotAllowedQuoteStatus
        {
        	get
        	{
	        	if (deleteNotAllowedQuoteStatus == null || deleteNotAllowedQuoteStatus.equals(''))
	        	{
	        		deleteNotAllowedQuoteStatus = deleteNotAllowedQuoteStatus 
	        									+ QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedContractInternalApproval.name()).StatusValue__c
	        									+ QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractDocumentGenerated.name()).StatusValue__c
	        									+ QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c
	        									+ 'Submitted quote-Approval';
	        	}
	        	return deleteNotAllowedQuoteStatus;
        	}
        	private set;
        }
       
        public PGINewQuoteController (ApexPages.StandardController controller){
             try{
             	 quote = new Quote();
                 isMinimum=false;
                 if(apexpages.currentPage().getParameters().get('id')!=null)
                 quoteId=apexpages.currentPage().getParameters().get('id');
                 teslaComapnyObjectPrefix = Company__c.sObjectType.getDescribe().getKeyPrefix();
                 masterContractObjectPrefix = PGI_Contract__c.sObjectType.getDescribe().getKeyPrefix();
                contactObjectPrefix = Contact.sObjectType.getDescribe().getKeyPrefix();
                 //system.debug('####QuoteId'+quoteId);
                 if(quoteId==null){
                     isMinimum=true;
                     this.quote = (Quote)controller.getRecord();
                     String oppid=apexpages.currentPage().getParameters().get('oppId');
                     oppList=[ Select Type,Status__c,Id,CloseDate,Description__c,AccountId From Opportunity where Id=:oppid]; 
                     for(Opportunity opp:oppList){
                        quote.OpportunityId=opp.Id;
                        quote.Account__c=opp.AccountId;
                        quote.ExpirationDate=opp.CloseDate;
                        quote.Quote_Type__c=opp.Type;
                        //quote.Status=opp.Status__c;
                        quote.Status=QCStatusValues__c.getInstance(PGIQuoteStatusEnum.Draft.name()).StatusValue__c;
                        quote.InterestPenaltyPercent__c=string.valueof(1.5);
                        quote.Name='Do Not Edit';
                    }
                }
                else{
                    quoteList=[Select q.TESLA_CompanyID__c, q.ContractType__c,q.IsMinimumContractType__c,q.Status, q.Rejected_Reason__c, q.Quote_Type__c, q.Name, q.Master_Contract_ID__c, q.Id, q.ExpirationDate, q.Contract_Company_name__c, q.ContactId, q.Company_Tax__c, q.Account__c From Quote q where q.Id=:quoteId];
                    
                     for(Quote edQuote:quoteList){
                        
                        if(edQuote.ContractType__c=='Customer Service Order(with Minimum Commitment)'||edQuote.ContractType__c=='Customer Service Order(without Minimum Commitment)')
                        {
                             isMinimum=false;
                        }
                        else
                        {
                             isMinimum=true;
                             
                        }
                        
                       //this.quote =edQuote;
                       system.debug('#quote '+quote );
                     }
                     this.quote = (Quote)controller.getRecord();
                }
        }catch(Exception e){
            System.debug('newQuote'+e);
        } 
    }
    
    public pageReference onSave(){
    	try{
    		Boolean isError = false;
	    	 if(quote.BillingName == null){
	    	 	quote.BillingName.addError('You must enter a value');
	    	 	isError = true;
	    	 } 
	    	  if(quote.BillingStreet == null){
	    	 	quote.BillingStreet.addError('You must enter a value');
	    	 	isError = true;
	    	 } 
	    	 if(quote.BillingCity == null){
	    	 	quote.BillingCity.addError('You must enter a value');
	    	 	isError = true;
	    	 }
	    	 if(quote.BillingState == null){
	    	 	quote.BillingState.addError('You must enter a value');
	    	 	isError = true;
	    	 }
	    	 if(quote.BillingPostalCode == null){
	    	 	quote.BillingPostalCode.addError('You must enter a value');
	    	 	isError = true;
	    	 }
	    	 if(quote.BillingCountry == null){
	    	 	quote.BillingCountry.addError('You must enter a value');
	    	 	isError = true;
	    	 }
	    	 if(quote.Phone == null){
	    	 	quote.Phone.addError('You must enter a value');
	    	 	isError = true;
	    	 }
	    	 if(quote.ContactId == null){
	    	 	quote.ContactId.addError('You must enter a value');
	    	 	isError = true;
	    	 }
	    	 if(quote.Sales_Rep_Id__c == null){
	    	 	quote.Sales_Rep_Id__c.addError('You must enter a value');
	    	 	isError = true;
	    	 }
	    	 
	    	 if(isError)
	    	 	return null;
	    	 	
	    	 update quote;
    	}
    	catch(Exception e){
            System.debug('#onSave '+e);
            return null;
        } 
    	return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));	
    }
    
    //Test Method for PGINewQuoteController
    public static testMethod void TestPGINewQuoteController(){
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.Opp_Stage__c = 'Proposal/Price Quote';
         insert testopp;
         List<Opportunity> testlistopp = new List<Opportunity>();
         testlistopp.add(testopp);
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.status = 'Awaiting Co-Signature from VP';
         insert testquote;
         
         test.startTest();
         //case 1: +ve
         //Set Page Params
         PGITestUtilities.setTestParameter('id',testquote.id);        
         PGINewQuoteController testCase1PGIConst= new PGINewQuoteController(PGITestUtilities.getStandardController(testquote));
                
         //Case 2: -ve Quote Id null
         PGITestUtilities.setTestParameter('id',Null);         
         PGINewQuoteController testCase2PGIConst=new PGINewQuoteController(PGITestUtilities.getStandardController(testquote));
                 
         //Case 3: -ve QuoteId is invalid 
         PGITestUtilities.setTestParameter('id','test123'); 
         PGINewQuoteController testCase3PGIConst=new PGINewQuoteController(PGITestUtilities.getStandardController(testquote));
                 
         //case 4: -ve with oppId with value and Id Null-quote data
         PGITestUtilities.setTestParameter('id',Null);  
         PGITestUtilities.setTestParameter('oppId',testopp.id);
         PGINewQuoteController testCase4PGIConst=new PGINewQuoteController(PGITestUtilities.getStandardController(testquote));
                 
         //case 5: -ve with oppId value and Id null  - no quote data
         PGITestUtilities.setTestParameter('Id',Null);  
         PGITestUtilities.setTestParameter('oppId',testopp.Id);
         Quote testnewquote=new Quote();
         PGINewQuoteController testCase5PGIConst=new PGINewQuoteController(PGITestUtilities.getStandardController(testnewquote));
                 
         //case 6: -ve test onSave method
         PGITestUtilities.setTestParameter('id',testquote.id);        
         PGINewQuoteController testCase6PGIConst= new PGINewQuoteController(PGITestUtilities.getStandardController(testquote));
         testCase6PGIConst.quote.BillingName = null;
         PageReference pageRefCase6 = testCase6PGIConst.onSave();
                 
         //case 7: test onSave method
         PGITestUtilities.setTestParameter('id',testquote.id);        
         PGINewQuoteController testCase7PGIConst= new PGINewQuoteController(PGITestUtilities.getStandardController(testquote));
         testCase7PGIConst.quote.BillingName = 'test';
         testCase7PGIConst.quote.BillingStreet = 'test';
         testCase7PGIConst.quote.BillingCity = 'test';
         testCase7PGIConst.quote.BillingState = 'test';
         testCase7PGIConst.quote.BillingPostalCode = 'test';
         testCase7PGIConst.quote.BillingCountry = 'test';
         testCase7PGIConst.quote.Phone = 'test';
         testCase7PGIConst.quote.ContactId = testcon.Id;
         testCase7PGIConst.quote.Sales_Rep_Id__c = 'test';
         PageReference pageRefCase7 = testCase7PGIConst.onSave();        
         test.stopTest();
         
         //Case 1:
         system.assertEquals(testCase1PGIConst.quoteId,testquote.Id);
         //Case 2:
         system.assertEquals(testCase2PGIConst.oppList.size(),0);
         //case 3:
         system.assertEquals(testCase3PGIConst.quoteList.size(),0);
         //case 4:
         system.assertEquals(testCase4PGIConst.quote.OpportunityId,testquote.OpportunityId);
         //case 5:
         system.assertEquals(testCase5PGIConst.quote.OpportunityId,testquote.OpportunityId);
         //case 6:
         system.assertEquals(pageRefCase6,null);
         //case 7:
         system.assertNotEquals(pageRefCase7,null);
    }   
   
}