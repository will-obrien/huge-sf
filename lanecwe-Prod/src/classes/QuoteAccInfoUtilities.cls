/********************************************************************************
Name:  QuoteAccInfoUtilities()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to create and edit PGIProduct data  
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  7/10/2012        Added 
********************************************************************************/ 
public class  QuoteAccInfoUtilities{
    
    public static QuoteAccount getQuoteAccInfo(string QuoteId){  
           QuoteAccount quoteAcc;
           if(QuoteId!=null){           
            Quote objQuote= [Select Id,Comment_For_Approver__c,Status,Name,Quote_Owner__c, QuoteNumber,Contact.Name ,Email,Total_Annual_value__c,Total_Contract_Value__c,Total_MRR__c,TotalPrice__c,Total_Margin__c,Quote_Currency__c,Sales_Rep_Id__c,Quote_Type__c,Signer_Contact_Name__r.Name,Signer_Contact_Name__c,opportunity.type From Quote where Id=:QuoteId];
           
            Opportunity objAccount = [Select Id,Account.Name,Account.phone,AccountId,Is_RFP__c From Opportunity  where Id in (select q.OpportunityId From Quote q where q.id=:QuoteId )];
             quoteAcc= new QuoteAccount(objQuote,objAccount);
        }
        return quoteAcc;
    }
    //Test Method for getQuoteAccInfo 
    @istest (seeAlldata=false) 
    private static void test_getQuoteAccInfo() { 
        test.startTest();
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote.Name='test123';
        insert testQuote;
        QuoteAccount quoteAcc=getQuoteAccInfo(testQuote.Id);
        //Assert
     //   system.assertEquals(quoteAcc.quoteName,'test123');
        test.stopTest();
    }
}