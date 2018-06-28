@isTest
private class JRA_LegislativeDataUpdates_TESTS{

@testSetup
private static void SetupTestData() {

List<jrsbd__JR_Advocacy_Settings__c> GeneralSettings = new List<jrsbd__JR_Advocacy_Settings__c> ();
GeneralSettings.add(new jrsbd__JR_Advocacy_Settings__c(Name = 'ZipCodeField', jrsbd__String_Value__c = 'MailingPostalCode'));
GeneralSettings.add(new jrsbd__JR_Advocacy_Settings__c(Name = 'APIEndpoint', jrsbd__String_Value__c = 'Sandbox'));
insert GeneralSettings;

jrsbd__JRA_Advocacy_Endpoint_Settings__c authSettings = new jrsbd__JRA_Advocacy_Endpoint_Settings__c();
authSettings.Name = 'Sandbox';
authSettings.jrsbd__Client_Id__c = '123';
authSettings.jrsbd__Client_Secret__c = '456';
authSettings.jrsbd__Endpoint__c = 'https://advocacy-staging.gospringboard.io/api/v1';
insert authSettings;

}

@isTest
private static void ContactTriggerTESTS() {

List<Contact> cons = new List<Contact>();
cons.add (new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130-2220'));//Success
cons.add (new Contact (LastName = 'Test2', FirstName = 'TestF', MailingPostalCode = '22206'));//Partial
cons.add (new Contact (LastName = 'Test3', FirstName = 'TestF'));//No Zip

insert cons;

List<Contact> consConfirm = [Select Id, Legislator_Data_Status__c from Contact WHERE Id IN :cons Order by LastName ASC];

system.assertequals('Ready to Process', consConfirm[0].Legislator_Data_Status__c);
system.assertequals('Invalid ZipCode Format', consConfirm[1].Legislator_Data_Status__c);
system.assertequals('No ZipCode to Process', consConfirm[2].Legislator_Data_Status__c);
}


@isTest
private static void SingleContactSuccessSync() {

Contact testc = new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130-2220');
insert testc;

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/oauth/access-token', 'JRA_TESTTokenJSON');
multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/targets/legislators?zip=92130-2220', 'JRA_TestDataSuccess');
multimock.setStatusCode(200);

test.setMock(HttpCalloutMock.class, multimock);

test.StartTest();
JRA_ContactUpdateService jrac = new JRA_ContactUpdateService();
jrac.executecallout (new List<Contact> {testc});
jrac.executeupdate();

test.StopTest();

Contact cConfirm = [Select Id,
Sr_Federal_Senator_Facebook__c,
Sr_Federal_Senator_Twitter__c,
Sr_Federal_Senator_Webform__c,
Governor_Facebook__c,
Governor_Twitter__c,
Governor_Webform__c 
FROM Contact WHERE Id = :testc.Id];

system.assertequals('http://www.facebook.com/SenatorFeinstein', cConfirm.Sr_Federal_Senator_Facebook__c);
system.assertequals('http://twitter.com/SenFeinstein', cConfirm.jrsbd__Sr_Federal_Senator_Twitter__c);
system.assertequals('http://www.facebook.com/jerrybrown', cConfirm.jrsbd__Governor_Facebook__c);
system.assertequals('http://twitter.com/JerryBrownGov', cConfirm.jrsbd__Governor_Twitter__c);


}

@isTest
private static void SingleContactSuccessaSync() {

//Enable Future Setting by default for these tests
jrsbd__JRA_Trigger_Settings__c jrasyncsetting = new jrsbd__JRA_Trigger_Settings__c();
jrasyncsetting.jrsbd__Enable_aSync_Update__c = TRUE;
insert jrasyncsetting;

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/oauth/access-token', 'JRA_TESTTokenJSON');
multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/targets/legislators?zip=92130-2220', 'JRA_TestDataSuccess');
multimock.setStatusCode(200);

test.setMock(HttpCalloutMock.class, multimock);

test.StartTest();
Contact testc = new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130-2220');
insert testc;
test.StopTest();

Contact cConfirm = [Select Id,
Sr_Federal_Senator_Facebook__c,
Sr_Federal_Senator_Twitter__c,
Sr_Federal_Senator_Webform__c,
Governor_Facebook__c,
Governor_Twitter__c,
Governor_Webform__c 
FROM Contact WHERE Id = :testc.Id];

system.assertequals('http://www.facebook.com/SenatorFeinstein', cConfirm.Sr_Federal_Senator_Facebook__c);
system.assertequals('http://twitter.com/SenFeinstein', cConfirm.jrsbd__Sr_Federal_Senator_Twitter__c);
system.assertequals('http://www.facebook.com/jerrybrown', cConfirm.jrsbd__Governor_Facebook__c);
system.assertequals('http://twitter.com/JerryBrownGov', cConfirm.jrsbd__Governor_Twitter__c);


}

@isTest
private static void SingleContactErrorSync() {

Contact testc = new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130-2220');
insert testc;

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/oauth/access-token', 'JRA_TESTTokenJSON');
multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/targets/legislators?zip=92130-2220', 'JRA_TestDataSuccess');
multimock.setStatusCode(200);

test.setMock(HttpCalloutMock.class, multimock);

test.StartTest();
JRA_ContactUpdateService jrac = new JRA_ContactUpdateService();

//Force error on save
testc.LastName = NULL;
jrac.executecallout (new List<Contact> {testc});
jrac.executeupdate();
test.StopTest();

jrsbd__JRA_Error_Log__c eConfirm = [Select Id, jrsbd__Error_Message__c, jrsbd__Record_Id__c FROM jrsbd__JRA_Error_Log__c];
system.assertequals(testc.Id, eConfirm.jrsbd__Record_Id__c);
system.assertNotEquals(NULL, eConfirm.jrsbd__Error_Message__c);


}

@isTest
private static void SingleContactBadZip() {

Contact testc = new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130-2220');
insert testc;

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/oauth/access-token', 'JRA_TESTTokenJSON');
multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/targets/legislators?zip=92130-2220', 'JRA_TestDataSuccess');
multimock.setStatusCode(500);

test.setMock(HttpCalloutMock.class, multimock);

test.StartTest();
JRA_ContactUpdateService jrac = new JRA_ContactUpdateService();
jrac.executecallout (new List<Contact> {testc});
test.StopTest();

//Contact cConfirm = [Select Id from 


}

@isTest
private static void SingleContactPartialZip() {

Contact testc = new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130');
insert testc;

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/oauth/access-token', 'JRA_TESTTokenJSON');
multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/targets/legislators?zip=92130-2220', 'JRA_TestDataSuccess');
multimock.setStatusCode(500);

test.setMock(HttpCalloutMock.class, multimock);

test.StartTest();
JRA_ContactUpdateService jrac = new JRA_ContactUpdateService();
jrac.executecallout (new List<Contact> {testc});
test.StopTest();

//Contact cConfirm = [Select Id from 


}

@isTest
private static void SingleContactUpdateviaButton() {

Contact testc = new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130-2220');
insert testc;

jrsbd__JRA_Advocacy_Endpoint_Settings__c authSettings = jrsbd__JRA_Advocacy_Endpoint_Settings__c.getvalues('Sandbox');
authSettings.jrsbd__Access_Expiration_Date_Time__c = system.now().addminutes(30);
authSettings.jrsbd__Current_Access_Token__c = 'X123';
update authSettings;

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/oauth/access-token', 'JRA_TESTTokenJSON');
multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/targets/legislators?zip=92130-2220', 'JRA_TestDataSuccess');
multimock.setStatusCode(200);

test.setMock(HttpCalloutMock.class, multimock);

test.StartTest();
JRA_ContactLegislatorControllerExt JRAC = new JRA_ContactLegislatorControllerExt(new ApexPages.StandardController(testc) );
JRAC.UpdateLegislators();

test.StopTest();

Contact cConfirm = [Select Id,
Sr_Federal_Senator_Facebook__c,
Sr_Federal_Senator_Twitter__c,
Sr_Federal_Senator_Webform__c,
Governor_Facebook__c,
Governor_Twitter__c,
Governor_Webform__c 
FROM Contact WHERE Id = :testc.Id];

system.assertequals('http://www.facebook.com/SenatorFeinstein', cConfirm.Sr_Federal_Senator_Facebook__c);
system.assertequals('http://twitter.com/SenFeinstein', cConfirm.jrsbd__Sr_Federal_Senator_Twitter__c);
system.assertequals('http://www.facebook.com/jerrybrown', cConfirm.jrsbd__Governor_Facebook__c);
system.assertequals('http://twitter.com/JerryBrownGov', cConfirm.jrsbd__Governor_Twitter__c);


}

@isTest
private static void ContactUpdateviaBatch() {

Contact testc = new Contact (LastName = 'Test1', FirstName = 'TestF', MailingPostalCode = '92130-2220');
insert testc;
Contact cConfirm = [Select Id, Legislator_Data_Status__c FROM Contact WHERE Id = :testc.Id];
system.debug(cConfirm);

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/oauth/access-token', 'JRA_TESTTokenJSON');
multimock.setStaticResource('https://advocacy-staging.gospringboard.io/api/v1/targets/legislators?zip=92130-2220', 'JRA_TestDataSuccess');
multimock.setStatusCode(200);

test.setMock(HttpCalloutMock.class, multimock);

test.StartTest();
String sQuery = 'Select Id, Legislator_Data_Status__c, MailingPostalCode FROM CONTACT WHERE Legislator_Data_Status__c = \'Ready to Process\' ';
JRA_BatchLegislatorUpdate jba = new JRA_BatchLegislatorUpdate();
jba.sQuery = sQuery;
database.executebatch(jba,25);

test.StopTest();
cConfirm = [Select Id, Legislator_Data_Status__c, Federal_District__c FROM Contact WHERE Id = :testc.Id];
system.assertequals('Processed', cConfirm.Legislator_Data_Status__c);
system.assertequals('CA52', cConfirm.jrsbd__Federal_District__c);



}
}