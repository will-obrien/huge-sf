/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       ???
*   Author:             ???
*   Last Modified:      6/9/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
@isTest
private class Test_Batch_UpdateWebinars {

/****************************************
*  @description:
*   uses HTTPMockCallout class to test callout to citrix and then creating a webinar 
*   the webinar credentials are setup initially in the test method and the custom setting
*   used to populate the webinar_type__c field is create initially too with some mock data
*   
*
**/
    static testMethod void myUnitTest() {
        //aac added custom settings for referencing webinars
        List<WebinarType_Credential__c> list_custsetting_credential = new List<WebinarType_Credential__c>();
         
         WebinarType_Credential__c cscredential1 = new  WebinarType_Credential__c();
         cscredential1.name = 'test';
         cscredential1.Webinar_Type__c = 'Talkpoint';
         list_custsetting_credential.add(cscredential1);
         
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
        credentials.Provider__c = 'Talkpoint';
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
            Batch_UpdateWebinars updateWebinars = new Batch_UpdateWebinars();
            List<Webinar__c> webinarsreturned = updateWebinars.getWebinarsToUpsert(credentials.Credentials_ID__c,credentials.Mnemonic__c,webinars);
            System.assert(webinarsreturned.size()  > 0, '@asha: @debug: Error: webinars returned not larger than 0.');
            System.assertequals('Talkpoint', webinarsreturned[0].Webinar_Type__c);
            updateWebinars.parseUpcomingCitrixWebinars('123123123','asdfadfasdfadfaf');
        test.stopTest();

    }
                
}