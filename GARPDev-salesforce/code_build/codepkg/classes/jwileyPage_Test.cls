@isTest
public class jwileyPage_Test {

    static testMethod void myUnitTest() {
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        jwileyPage pg = new jwileyPage();
        
        ApexPages.currentPage().getParameters().put('sku','123');
        pg.save();
    }
}