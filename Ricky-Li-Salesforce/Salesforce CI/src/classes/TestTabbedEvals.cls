@isTest(SEEALLDATA = true)
 Public Class TestTabbedEvals{
    static testmethod void TestEvals(){
       List <Tour_Evaluation__c> listTE = new List <Tour_Evaluation__c> ();
       List <Tour_Evaluation_Historical_Summary__c> listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
       List <Tour_Evaluation_Leader__c> listTEL = new list <Tour_Evaluation_Leader__c>();   
       TabbedEvals te = new TabbedEvals();
       Test.startTest();
               te.getTextData();
               te.getSearchItems();
               te.clear();
               te.textData = '504695';
               te.SearchCriteria = 'bookingNumber';
                   te.SearchText();
               te.textData = 'GPEETAT121007-O1';
               te.SearchCriteria = 'TripCode';
                   te.SearchText();
               te.textData = 'Liza Villabolos';
               te.SearchCriteria = 'CEOName';
                   te.SearchText();
               te.textData = '2012-10-10';
               te.SearchCriteria = 'dateEvalSent';
                   te.SearchText();
               te.textData = '2012-10-10';
               te.SearchCriteria = 'dateEvalCompleted';
                   te.SearchText();
               te.textData = '2012-10-10';
               te.SearchCriteria = 'ServiceFinishDate';
                   te.SearchText();
               te.textData = 'Maria';
               te.SearchCriteria = 'TravellerName';
                   te.SearchText();
               te.textData = 'India';
               te.SearchCriteria = 'ServiceName';
                   te.SearchText();
               te.textData = 'Asia';
               te.SearchCriteria = 'Region';
                   te.SearchText();
               
       Test.stopTest();
   } 
 }