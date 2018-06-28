@isTest
private class CommunicationSummaryReportControllerTest {

  static testmethod void testSurveyReport() {
   
    // intialize the class which has the test data
    SurveyTestingUtil testUtil = new SurveyTestingUtil();

    PageReference pageRef = Page.CommunicationSummaryReport;

    // set the survey id as one of the page parameters, this is used by the controller class 
    pageRef.getParameters().put('CommunicationId', testUtil.getSurveyId());  

    
    // set the current page reference
    Test.setCurrentPage(pageRef); 
 
    // initialize the controller class 
    CommunicationSummaryReportController commSummReportController= new CommunicationSummaryReportController();
 }

}