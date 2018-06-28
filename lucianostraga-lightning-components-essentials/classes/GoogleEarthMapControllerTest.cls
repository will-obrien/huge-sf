@isTest
private class GoogleEarthMapControllerTest {

    static testMethod void doTest(){
        Account acc = new Account(Name = 'Test', Coordinates__Latitude__s = 1.23, Coordinates__Longitude__s = 5.5);
        insert acc;
        
        Test.setCurrentPageReference(new PageReference('Page.GoogleEarthIframe')); 
		System.currentPageReference().getParameters().put('id', acc.Id);
        
        
        Test.startTest();
        
        GoogleEarthMappController cont = new GoogleEarthMappController();
       
        Test.stopTest();
    }
    
    static testMethod void doTest2(){
        
        Test.startTest();
        
        GoogleEarthMappController.getSalesforceBaseURL();
       
        Test.stopTest();
    } 
}