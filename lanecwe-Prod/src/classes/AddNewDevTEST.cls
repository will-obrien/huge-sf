@isTest
private class AddNewDevTEST{

  static testMethod void createSaveTest() {
        //Create a case new dev can be attached to
        Case newCase = new Case(Subject = 'Super Cool Case');
        insert newCase;
        
        //Setup page parameters for testing
        Test.setCurrentPageReference(new PageReference('Page.addDevToCasePage')); 
    ApexPages.currentPage().getParameters().put('id', newCase.id);
    
    Test.startTest();
    //Instantiate controller, contructor will run
    AddDevtoCase controller = new AddDevtoCase();
    
    //Create new request
    controller.NewDev();
    
    //Set Name on request
    controller.devs[0].API_Name__c = 'request1';
    
    //Save Requests
    controller.save();
    
    //Cancel Requests
    controller.cancel();
    
    Test.stopTest();
    
    //Assert that customer request record was attached to account.
    Development__c development = [select Id, API_Name__c from Development__c where Case__c = :newCase.Id];
    system.assertEquals(development.API_Name__c,'request1');
    }
}