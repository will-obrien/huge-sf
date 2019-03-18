/*


 ********************************************************************************
Name:  PGIAllQuotesInAccountController()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to show all Quotes in Account which status is not "Contract signed by Customer"
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  11/12/2012        Added 
******************************************************************************* 
*/
public with sharing class PGIAllQuotesInAccountController 
{
    
    public String accId{get; set;}
    public list<Quote> allAccQuotes {get; set;}
     public PGIAllQuotesInAccountController(ApexPages.StandardController controller) 
        {
            try
            {
                accId = Apexpages.currentPage().getParameters().get('Id');
                allAccQuotes = new list<Quote>();
                if(accId != null)
                {
                allAccQuotes = [Select  q.Name, q.Id, q.ExpirationDate, q.CreatedDate,q.Total_Contract_Value__c,q.Total_MRR__c,q.Total_Annual_value__c,q.Status,
                                    q.CreatedById From Quote q where account__c =: accId and Quote.Status !=:QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c  ]; 
                                     }
            }catch(Exception ex)  
           {     
                system.debug('test error'+ex);
           }
        
    }   
    
    //Test Method for PGIQuoteCloneController
        @istest (seeAlldata = true)
    public static  void testPGIAllQuotesInAccountController()
    {
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.Opp_Stage__c = 'Proposal/Price Quote';
         insert testopp;
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.status = QCStatusValues__c.getInstance(PGIQuoteStatusEnum.Approved.name()).StatusValue__c;
         insert testquote;
         //case 1: +ve
                 //Set Page Params
                 PGITestUtilities.setTestParameter('id',testacc.id);        
                 PGIAllQuotesInAccountController testCase1PGIConst= new PGIAllQuotesInAccountController(PGITestUtilities.getStandardController(testacc));
         //case 2: +ve
                 //Set Page Params
                 PGITestUtilities.setTestParameter('id',testquote.id);        
                 PGIAllQuotesInAccountController testCase2PGIConst= new PGIAllQuotesInAccountController(PGITestUtilities.getStandardController(testquote));
         test.startTest(); 
        
         //Case 1:
                 system.assertEquals(testCase1PGIConst.accId,testacc.id);
                 //Case 2:
                
                  test.stopTest();
                 
    }   
}