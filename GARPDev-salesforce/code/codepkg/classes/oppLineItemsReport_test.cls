@isTest
public class oppLineItemsReport_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        oppLineItemsReport report = new oppLineItemsReport();
        report.bIsTax = false;
        report.bIsRegular = false;
        report.bIsGRA = false;
        report.bIsGARP = false;
        report.generateCSV();
        test.stopTest();
    }
}