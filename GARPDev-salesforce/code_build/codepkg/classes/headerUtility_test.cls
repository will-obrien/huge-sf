@isTest
public class headerUtility_test {

    static testMethod void unitTest_1(){
        test.startTest();
        ApexPages.currentPage().getHeaders().put('USER-AGENT','test');
        //ApexPages.currentPage().getHeaders().put('CipherSuite','test');
        ApexPages.currentPage().getHeaders().put('X-Salesforce-Forwarded-To','test');
        ApexPages.currentPage().getHeaders().put('USER-AGENT','test');
        headerUtility utility = new headerUtility();
        utility.redirect();
        test.stopTest();
    }
}