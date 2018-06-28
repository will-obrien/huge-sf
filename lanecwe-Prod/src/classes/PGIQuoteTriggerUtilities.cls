/********************************************************************************
Name:  PGIQuoteTriggerUtilities()  
Copyright © 2012  PGI   
======================================================
======================================================
Purpose:
-------    
Utility class containing methods to perform various 
trigger related functionalities
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - Nagendra          09/10/2012         Initial Development 
********************************************************************************/  
public  class PGIQuoteTriggerUtilities {
     /*******************************************************************
    Purpose      : To Create OpportunitySolution related list in Quote  
    Parameters   : A list of Opportunity
    Returns      : 
    ********************************************************************/
    /*public static void createOppSolution(list<Opportunity> opplst){
        try
        {
            system.debug('opplst'+opplst);
            set<Id>OpportunityId=new set<Id>();
            list<OpportunitySolution__c> oppSolutionToUpdate=new list<OpportunitySolution__c>();
             Map<Id,Id> oppQuoteId = new Map<Id,Id>();
            for(Opportunity oppObj:opplst){
                if(oppObj.Id!=null){
                     OpportunityId.add(oppObj.Id);
                }
            }
            if(!OpportunityId.isEmpty()){
                for(Quote quote :[Select id,OpportunityId From Quote where OpportunityId=:OpportunityId]){
                    if(quote!=null){
                        oppQuoteId.put(quote.OpportunityId,quote.id);
                    }
                }
                List<OpportunitySolution__c> OppSolutionEntries = [Select Quote__c,Opportunity__c,Id From OpportunitySolution__c where Opportunity__c=:OpportunityId];
                    for(OpportunitySolution__c oppsol:OppSolutionEntries){
                            oppsol.Quote__c = oppQuoteId.get(oppsol.Opportunity__c);
                            oppSolutionToUpdate.add(oppsol);
                    }
                if(!oppSolutionToUpdate.isEmpty()){
                    update oppSolutionToUpdate;
                }
            }
        }
        catch(Exception ex){
            PGIErrorUtilities.logPgiError('PGIQuoteTriggerUtilities:createOppSolution()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
            system.debug(LoggingLevel.ERROR,'Error When updating Opportunity solution '+ex.getMessage());
        }   
    }*/
    /*******************************************************************
    Purpose      : Opportunity to Quote 1:1 validation  
    Parameters   : A list of Quote
    Returns      : 
    ********************************************************************/
    /*public static void oppQuoteOneToOneValidation(list<Quote> quotelst){
        List <Id> oppIds=New list<Id>();
        for(Quote quoteobj: quotelst){
            system.debug('quoteobj.OpportunityId'+quoteobj.OpportunityId);
            if(quoteobj.OpportunityId!=null){
                oppIds.add(quoteobj.OpportunityId);
            }   
        }
        system.debug('oppIds'+oppIds);
        if(!oppIds.isEmpty()){
                List<sObject> CountOfQuoteList = new List<sObject>();
                CountOfQuoteList = [Select Count(Id) CountResult, OpportunityId Parent From Quote  Where OpportunityId=: oppIds  Group By OpportunityId];
                Map<Id,Integer> CountOfQuoteMap = new Map<Id,Integer>(); 
                if(!CountOfQuoteList.isEmpty()){
                      for (sObject countQ : CountOfQuoteList){
                        Id parentId= Id.valueOf(string.valueOf(countQ.get('Parent')));
                        Integer count = Integer.valueOf(countQ.get('CountResult'));                                 
                        if(count >= 1){
                         CountOfQuoteMap.put(parentId,count);
                         }
                     }    
                    for(Quote q : quotelst){
                         Integer Count = CountOfQuoteMap.get(q.OpportunityId);
                    if(Count !=null && Count >=1 ){
                        q.addError('Quote record aleady exists');
                   
                     } 
                 }
            }
        }
    }*/
    public static void quoteCancelContract(list<Quote> quotelst){
        try{
        	 
            set<Id> quoteIds= new set<Id>();
            list<Quote>updateQuoteLst=new list<Quote>();
                for(Quote quoteObj:quotelst){
                    if((quoteObj.Envelope_Status__c=='Voided' || quoteObj.Envelope_Status__c=='Declined') && !quoteObj.isCancelContract__c){
                        quoteObj.Status=QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c;
                        quoteObj.isCancelContract__c=true;
                        quoteObj.DocuSign_Status__c = null;
                        quoteObj.CountofQuote__c = 0;
                        quoteIds.add(quoteObj.Id);
                        
                    }
            }
                if(!quoteIds.isEmpty()){
                    list<Attachment> quoteAttach= new list<Attachment>([Select Id,ParentId  From Attachment where ParentId=:quoteIds]);
                    if(quoteAttach.size()>0){
                    	// setting this boolean value will allow the deletion of attachments without checking the quote status.
                    	PGIAppConstants.CHECK_QUOTE_STATUS = false;
                    	// setting this boolean value allow not updating the quote in Quote count trigger.
                    	PGIAppConstants.FROM_CANCEL_CONTRACT_TRIGGER = true;
                        delete quoteAttach;
                    }
                }
            
        }
        catch(Exception e){
            system.debug('exceptionCancelContract'+e);
        }
        
    }
     /*******************************************************************
    Purpose      : Assigning standard pricebook to QuotelineItem  
    Parameters   : A list of Quote
    Returns      : 
    ********************************************************************/
    public static void assignStandardPriceBookToQuote(list<Quote> quotelst){ 
        list<quote> allQuoteDetails= quotelst;
        Pricebook2 stdPb=new Pricebook2();
        try
        {
        	Set<Id> opportunityIds = new Set<Id>();
        	for (Quote quote : quotelst)
        	{
        		opportunityIds.add(quote.OpportunityId);
        	}
        	if (!opportunityIds.isEmpty())
        	{
	        	Map<Id, Opportunity> opporutnityMap = new Map<Id, Opportunity>([select Id, Pricebook2Id from Opportunity where Id IN:opportunityIds]);
		        for(quote quote: quotelst){
		        	Opportunity opp = opporutnityMap.get(quote.OpportunityId);
		        	quote.Pricebook2Id=opp.Pricebook2Id;
		        }
        	}
         }
         catch(Exception ex){
            PGIErrorUtilities.logPgiError('PGIQuoteTriggerUtilities:assignStandardPriceBookToQuote()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When Assigning standard pricebook to QuotelineItem '+ex.getMessage());
        }
    }
    //Test Method for createOppSolution
    /*@istest (seeAlldata=false) 
    private static void test_createOppSolution() {
        Account test1Acc= PGITestUtilities.getAccountDetails();
        insert test1Acc;
        Opportunity test1Opp= PGITestUtilities.getOpportunityDetails();     
        insert test1Opp;  
        Contact cont1= PGITestUtilities.getContactDetails(test1Acc.Id); 
        insert cont1;
        Quote test1Quote= PGITestUtilities.getQuoteDetails(test1Acc.Id, cont1.Id ,test1Opp.Id); 
        insert test1Quote; 
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        OpportunitySolution__c oppsol1=PGITestUtilities.getOpportunitySolution(test1Opp.Id,test1Quote.Id,testSoln.Id);
        insert oppsol1;
      
        
        Account test2Acc= PGITestUtilities.getAccountDetails();
        insert test2Acc;
        Opportunity test2Opp= PGITestUtilities.getOpportunityDetails();     
        insert test2Opp;
        Contact cont2= PGITestUtilities.getContactDetails(test2Acc.Id); 
        insert cont2;
        Quote test2Quote= PGITestUtilities.getQuoteDetails(test2Acc.Id, cont2.Id ,test2Opp.Id); 
        insert test2Quote;  
        
        OpportunitySolution__c oppsol2=PGITestUtilities.getOpportunitySolution(test2Opp.Id,test2Quote.Id,testSoln.Id);
        insert oppsol2;
        
        //Case1:creating opportunity solution
        list<OpportunitySolution__c>  test1oppsollst=[Select Opportunity__c from OpportunitySolution__c where Quote__c=:test1Quote.Id ];
        system.assertEquals(test1oppsollst.size(),1);
        //Case2:insert  opportunity solution with exiting opportunity Id
        
        OpportunitySolution__c oppsol3=PGITestUtilities.getOpportunitySolution(test1Opp.Id,test2Quote.Id,testSoln.Id);
        insert oppsol3;
         
        list<OpportunitySolution__c>  test2oppsollst=[Select Opportunity__c from OpportunitySolution__c where Quote__c=:test1Quote.Id ];
        system.assertEquals(test2oppsollst.size(),1);
        for(OpportunitySolution__c oppsol:test2oppsollst)
        system.assertEquals(oppsol.Opportunity__c,test1Opp.Id); 
        
    }*/
     //Test Method for assignStandardPriceBookToQuote 
    @istest (seeAlldata=true) 
    private static void test_assignStandardPriceBookToQuote() {
        //Test Data
        Test.startTest();  
        Account test1Acc= PGITestUtilities.getAccountDetails();
        insert test1Acc;
        Opportunity test1Opp= PGITestUtilities.getOpportunityDetails();     
        insert test1Opp;  
        Contact cont1= PGITestUtilities.getContactDetails(test1Acc.Id); 
        insert cont1;
        Quote test1Quote= PGITestUtilities.getQuoteDetails(test1Acc.Id, cont1.Id ,test1Opp.Id); 
        insert test1Quote; 
        Id pricebookId = Test.getStandardPricebookId();
        List<Quote> retQuote = [SELECT Pricebook2Id FROM Quote WHERE Id =: test1Quote.Id];
        system.assertEquals(retQuote[0].Pricebook2Id, pricebookId); 
        Test.stopTest(); 
     }
     
    @istest
    private static void test_quoteCancelContract() {
        Test.startTest();  
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();     
        insert testOpp;  
        Contact testCont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert testCont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, testCont.Id, testOpp.Id); 
        insert testQuote; 
        Attachment testAttachment = PGITestUtilities.createAttachment(testQuote.Id);
        insert testAttachment;
        dsfs__DocuSign_Status__c testDS = new dsfs__DocuSign_Status__c(dsfs__Envelope_Status__c = 'Voided');
        insert testDS;
        testQuote.DocuSign_Status__c = testDS.Id;
        update testQuote;
        List<Quote> retQuote = [SELECT isCancelContract__c FROM Quote WHERE Id =: testQuote.Id];
        system.assert(retQuote.size()>0);
        system.assertEquals(retQuote[0].isCancelContract__c, true);
        List<Attachment> retAtt = [SELECT id FROM Attachment WHERE Id =: testAttachment.Id];
        system.assert(retAtt.size()==0);
        Test.stopTest(); 
     }
     
    //Test Method for oppQuoteOneToOneValidation 
    /*@istest (seeAlldata=true) 
    private static void test_oppQuoteOneToOneValidation() {
        //Test Data
        Test.startTest();  
        Account test1Acc= PGITestUtilities.getAccountDetails();
        insert test1Acc;
        Opportunity test1Opp= PGITestUtilities.getOpportunityDetails();     
        insert test1Opp;  
        Contact cont1= PGITestUtilities.getContactDetails(test1Acc.Id); 
        insert cont1;
        Quote test1Quote= PGITestUtilities.getQuoteDetails(test1Acc.Id, cont1.Id ,test1Opp.Id); 
        insert test1Quote; 
        test1Quote= PGITestUtilities.getQuoteDetails(test1Acc.Id, cont1.Id ,test1Opp.Id); 
        list<Quote> quolst=new list<Quote>();
        quolst.add(test1Quote);
        //Checking wheather one to one relationship is established
         oppQuoteOneToOneValidation(quolst);
       }*/
}