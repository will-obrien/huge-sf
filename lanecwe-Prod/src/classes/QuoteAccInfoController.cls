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
public with sharing class QuoteAccInfoController {

    public static string quoteId {get; set;}
    public QuoteAccount quoteInfo {get; set;}
    
    public QuoteAccInfoController(){
    
        quoteId = apexPages.currentpage().getParameters().get('QuoteId');
        
        quoteInfo= QuoteAccInfoUtilities.getQuoteAccInfo(quoteId);    
    }
    
        //Test Method for getQuoteAccInfo 
    @istest (seeAlldata=false) 
    private static void test_getQuoteAccInfo() { 
        test.startTest();
        Test.setCurrentPage( ApexPages.currentPage());
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote.Name='test123';
        insert testQuote;
        PGITestUtilities.setTestParameter('QuoteId',testQuote.Id);
        QuoteAccInfoController quoteAccInfo=new QuoteAccInfoController();
        //Assert
      //  system.assertEquals(quoteAccInfo.quoteInfo.quoteName,'00035591');
        test.stopTest();
    }
    
}