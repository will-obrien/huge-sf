@isTest
private class iPadAppTest{
    // Test iPad App controller
    static testMethod void testIPadAppInstantiation(){
        PageReference pageRef = Page.iPadApp;
        Test.setCurrentPageReference(pageRef);
        iPadAppMaker__c app = new iPadAppMaker__c (name='testApp');
        insert app;
        ApexPages.StandardController sc = new ApexPages.standardController(app);
        iPadAppController appExt = new iPadAppController(sc);
        iPadAppMaker__c instance = appExt.instance;
        System.assertEquals(app.Id, instance.Id);
        
        iPadAppMaker__c appInstance = appExt.getAppInstance();
        System.assertEquals(appInstance.Id, app.Id);
    }
    
    // Test iPad app admin page controller
    static testMethod void testIPadAppAdmin(){
        PageReference pageRef = Page.iPadApp;
        Test.setCurrentPageReference(pageRef);
        iPadAppMaker__c app = new iPadAppMaker__c (name='testApp');
        insert app;
        ApexPages.StandardController sc = new ApexPages.standardController(app);
        iPadAppAdminExt appAdminExt = new iPadAppAdminExt(sc);
        iPadAppMaker__c instance = appAdminExt.instance;
        System.assertEquals(app.Id, instance.Id);
        
        String nextPage = appAdminExt.goToTheApp().getUrl();
        System.assertEquals('/apex/iPadApp?id=' + app.Id, nextPage);
        
        nextPage = appAdminExt.switchAppAdmin().getUrl();
        System.assertEquals('/apex/iPadAppAdmin?id=' + app.Id, nextPage);
       
    }
}