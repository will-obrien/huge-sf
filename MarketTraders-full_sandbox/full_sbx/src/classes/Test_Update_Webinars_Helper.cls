/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
Private class Test_Update_Webinars_Helper{

 static testMethod void myUnitTest() {
        //aac added custom settings for referencing webinars
        List<WebinarType_Credential__c> list_custsetting_credential = new List<WebinarType_Credential__c>();
         
         WebinarType_Credential__c cscredential1 = new  WebinarType_Credential__c();
         cscredential1.name = 'test';
         cscredential1.Webinar_Type__c = 'Talkpoint';
         list_custsetting_credential.add(cscredential1);
         
         WebinarType_Credential__c cscredential3 = new  WebinarType_Credential__c();
         cscredential3.name = 'test3';
         cscredential3.Webinar_Type__c = 'Citrix';
         list_custsetting_credential.add(cscredential3);
     
     
         WebinarType_Credential__c cscredential2 = new  WebinarType_Credential__c();
         cscredential2.name = 'test2';
         cscredential2.Webinar_Type__c = 'Options';      
         list_custsetting_credential.add(cscredential2);
         insert list_custsetting_credential;
     
        
         
        Webinar_Credentials__c credentials = new Webinar_Credentials__c();
        credentials.API_Key__c = 'test';
        credentials.Credentials_ID__c = '1';
        credentials.Mnemonic__c = 'test';
        credentials.Org_ID__c = '654564654';
        credentials.Password__c = 'test';
        credentials.Provider__c = 'Citrix';
        credentials.Token__c = '123123';
        credentials.Username__c = 'test';
        //Database.insert(credentials);
        
        list<CitrixWebinarTimes> webinarTimes = new list<CitrixWebinarTimes>();
        CitrixWebinarTimes webinarTime = new CitrixWebinarTimes();
        webinarTime.startTime = '2016-03-26T17:00:00Z';
        webinarTime.endTime = '2016-03-26T18:00:00Z';
        webinarTimes.add(webinarTime);
        
        list<CitrixWebinar> webinars = new list<CitrixWebinar>();
        for(integer x = 0; x < 200; x++){
            CitrixWebinar webinar = new CitrixWebinar();
            webinar.subject = 'Test Webinar';
            webinar.description = 'This is a test webinar';
            webinar.timeZone = 'America/New_York';
            webinar.webinarKey = String.valueOf(x);
            webinar.organizerKey = '12345';
            webinar.times = webinarTimes;
            webinars.add(webinar);
        }
        
        test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('citrix_response');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json'); 
            Test.setMock(HttpCalloutMock.class, mock);
            Batch_UpdateWebinars updateWebinars = new Batch_UpdateWebinars();
            Database.executeBatch(updateWebinars,1);
        test.stopTest();

    }
    
    static testMethod void testMethods() {
        //aac added custom settings for referencing webinars
        List<WebinarType_Credential__c> list_custsetting_credential = new List<WebinarType_Credential__c>();
         
         WebinarType_Credential__c cscredential1 = new  WebinarType_Credential__c();
         cscredential1.name = 'test';
         cscredential1.Webinar_Type__c = 'Talkpoint';
         list_custsetting_credential.add(cscredential1);
        
        WebinarType_Credential__c cscredential3 = new  WebinarType_Credential__c();
         cscredential3.name = 'test3';
         cscredential3.Webinar_Type__c = 'Citrix';
         list_custsetting_credential.add(cscredential3);
         
         WebinarType_Credential__c cscredential2 = new  WebinarType_Credential__c();
         cscredential2.name = 'test2';
         cscredential2.Webinar_Type__c = 'Options';      
         list_custsetting_credential.add(cscredential2);
         insert list_custsetting_credential;
        
        
         
        Webinar_Credentials__c credentials = new Webinar_Credentials__c();
        credentials.API_Key__c = 'test';
        credentials.Credentials_ID__c = '1';
        credentials.Mnemonic__c = 'test';
        credentials.Org_ID__c = '654564654';
        credentials.Password__c = 'test';
        credentials.Provider__c = 'Citrix';
        credentials.Token__c = '123123';
        credentials.Username__c = 'test';
        Database.insert(credentials);
        
        list<CitrixWebinarTimes> webinarTimes = new list<CitrixWebinarTimes>();
        CitrixWebinarTimes webinarTime = new CitrixWebinarTimes();
        webinarTime.startTime = '2011-04-26T17:00:00Z';
        webinarTime.endTime = '2011-04-26T18:00:00Z';
        webinarTimes.add(webinarTime);
        
        list<CitrixWebinar> webinars = new list<CitrixWebinar>();
        for(integer x = 0; x < 200; x++){
            CitrixWebinar webinar = new CitrixWebinar();
            webinar.subject = 'Test Webinar';
            webinar.description = 'This is a test webinar';
            webinar.timeZone = 'America/New_York';
            webinar.webinarKey = String.valueOf(x);
            webinar.organizerKey = '12345';
            webinar.times = webinarTimes;
            webinars.add(webinar);
        }
        
        test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('citrix_response');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json'); 
            Test.setMock(HttpCalloutMock.class, mock);
           //  Batch_UpdateWebinars updateWebinars = new Batch_UpdateWebinars();
            
            Update_Webinars_Helper.updateWebinar(credentials.id);
            List<Webinar__c> webinarsreturned = Update_Webinars_Helper.getWebinarsToUpsert(credentials.Credentials_ID__c,credentials.Mnemonic__c,webinars);
            System.assert(webinarsreturned.size()  > 0, '@: @debug: Error: webinars returned not larger than 0.');
            System.assertequals('Talkpoint', webinarsreturned[0].Webinar_Type__c);
            Update_Webinars_Helper.parseUpcomingCitrixWebinars('123123123','asdfadfasdfadfaf');
        test.stopTest();

    }
                



}