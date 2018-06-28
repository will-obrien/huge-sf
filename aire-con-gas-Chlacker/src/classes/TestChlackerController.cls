@isTest
private class TestChlackerController {
    @isTest
    static void redirectToAuthorizationUrl() {
        PageReference testPage = Page.chlacker;
        testPage.getParameters().put('slack', '1');
        ChlackerController ctrl = new ChlackerController();
        System.assertNotEquals(null, ctrl.redirectToSlacker());
    }
   
    @isTest
    static void redirectFromCallbackWithInvalidOrNoStateParam() {
        PageReference testPage = Page.chlacker;
        testPage.getParameters().put('callback', '1');
        ChlackerController ctrl = new ChlackerController();
        System.assertEquals(null, ctrl.redirectToSlacker());
    }
    
    @isTest
    static void redirectFromCallbackWithStateParam() {
        PageReference testPage = Page.chlacker;
       
        Slack_Client_settings__c slackSettings = Slack_Client_settings__c.getInstance('FinancialForce');
        String clientId = slackSettings.Client_ID__c; 
        
        testPage.getParameters().put('callback', '1');
        testPage.getParameters().put('state', 'abc123');
        ChlackerController ctrl = new ChlackerController();
       
        System.assertEquals(null, ctrl.redirectToSlacker());
        System.assertEquals(1, [SELECT Id FROM Token_Manager__c WHERE Service_Name__c = 'slack' AND Client_ID__c = :clientId].size());
    }
    
    @isTest
    static void noRedirection() {
        
    }
    
}