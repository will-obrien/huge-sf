@isTest
public class ChartController_Test {

   
    static testMethod void unitTest_1(){
        
        test.startTest();
        ChartController cntrlr = new ChartController();
        cntrlr.ERPData();
        cntrlr.FRMOneData();
        cntrlr.FRMOneAndTwoData();
        cntrlr.FRMOneRegStatusData();
        cntrlr.FRMTwoData();
        cntrlr.FRMTwoRegStatusData();
         
        cntrlr.ERPRegStatusData();
        cntrlr.CandidateByCountryData();
        test.stopTest();
    }
    
}