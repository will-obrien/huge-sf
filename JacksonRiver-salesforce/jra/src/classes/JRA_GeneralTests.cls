@isTest
private class JRA_GeneralTests {
//Test Scheduler, Install script sand other non-specific code

@isTest
static void testInstallationScripts() {
    
        JRA_PostInstallScript postinstall = new JRA_PostInstallScript();
        Test.testInstall(postinstall, null);
        
        Map<String, jrsbd__JRA_Advocacy_Endpoint_Settings__c> authtestsettings1 = jrsbd__JRA_Advocacy_Endpoint_Settings__c.getall();
        system.assertequals('https://advocacy-staging.gospringboard.io/api/v1', authtestsettings1.get('Sandbox').jrsbd__Endpoint__c);
       
        Map<String, jrsbd__JR_Advocacy_Settings__c> generaltestsettings1 = jrsbd__JR_Advocacy_Settings__c.getall();
        system.assertequals('MailingPostalCode', generaltestsettings1.get('ZipCodeField').jrsbd__String_Value__c );
		system.assertequals('Sandbox', generaltestsettings1.get('APIEndpoint').jrsbd__String_Value__c );
      


    }	

 
@isTest
private static void testScheduler() {
JRA_SetupCustomSettings.createSettings();

	Test.StartTest();
		JRA_BatchAdvocacyUpdateScheduler sh1 = new JRA_BatchAdvocacyUpdateScheduler();      
		String sch = '0 0 23 * * ?';
		system.schedule('Test Update', sch, sh1);
	Test.stopTest();
}

	
}