/**********************************************************************************************************************
*  Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*  [2015] Market Traders Institute
*  All Rights Reserved
*
*  NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*  suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*  Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*  protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*  is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*  Date Created:   4/6/2015
*  Author:        Asha Calderon
*  Last Modified:    7/15/2015
*  Last Modified By:  Asha Calderon
*
*   
*   
**********************************************************************************************************************/
@istest
public class Test_SharedLoginCallout{

    /**************************************
    * @method testschedulablecallout
    *
    * @description
    * tests the schedulable context for the UCS callout - scheduledBatchSharedLogin
    * 
    *
    **/  
public static testmethod void testschedulablecallout(){

//setup test objects

          Map<String, ID> recmapacct = recTypeIDAccount();
            account accs = new account(
            salutation = 'Mr.',
            firstname = 'John',
            lastname = 'Sandbox1',
            PersonEmail = 'testsl@mti.com',
              ForexTips_Username__c  = 'testsl@mti.com', 
// removed 2015-06-02              Moodle_Username__c = 'testsl@mti.com',
              Moodle_Username_College__c = 'testsl@mti.com',
              UCS_User_Password__c = 'testpswrd',
              UCS_Username__c = 'testsl@mti.com' ,
            recordtypeid = recmapacct.get('Person Account')
        );

      insert accs;
      
// Schedule the test job
      String jobId = System.schedule('testScheduledSharedLogin', scheduledBatchSharedLogin.CRON_EXP, new scheduledBatchSharedLogin());
         
// Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

Test.startTest();
      System.assertEquals(scheduledBatchSharedLogin.CRON_EXP, ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
      

Test.stopTest();
}


    /**************************************
    * @method testcallout
    *
    * @description
    * tests the UCS callout with 10 account records
    * uses HttpCalloutMock as mock callout with data in static resource 
    *
    **/  
public static testmethod void testcallout(){

//setup test objects


      List<Account> listofaccts = new List<Account>();
      Account a = new Account();
      Map<String, ID> recmapacct = recTypeIDAccount();
      Account accs;
        SharedLoginInfo__c cscredential1 = new SharedLoginInfo__c();
       cscredential1.name = 'UCS';
       cscredential1.type__c = '0';
       cscredential1.url__c = 'http://api.markettraders.com/shared-login/';
       cscredential1.version__c = '1.2.1.0';
       insert cscredential1;

    //aac added country code conversion to allow users to get country to ucs backoffice which works on 2letter code
    UCSCountryCodes__c cscountrycode1 = new UCSCountryCodes__c();
    cscountrycode1.name = 'United States of America';
    cscountrycode1.CountryCode__c = 'US' ;   
    insert cscountrycode1;

    UCSCountryCodes__c cscountrycode2 = new UCSCountryCodes__c();
    cscountrycode2.name = 'Zimbabwe';
    cscountrycode2.CountryCode__c = 'ZW';    
    insert cscountrycode2;    
    

      for(Integer i = 0 ; i < 10 ; i++){       
            accs = new Account();
            accs.salutation = 'Mr.';
            accs.firstname = 'John';
            accs.lastname = 'Sandbox1';
            accs.Country_List__c = 'Zimbabwe'; //aac added 7.15.15 for country code conversion
            accs.PersonEmail = 'testsl' + i + '@mti.com';
            accs.ForexTips_Username__c  = 'testsl'+i+'@mti.com'; 
// removed 2015-06-02            accs.Moodle_Username__c = 'testsl'+i+'@mti.com';
            accs.Moodle_Username_College__c = 'testsl'+i+'@mti.com';
            accs.UCS_User_Password__c = 'testpswrd'+i;
            accs.UCS_Username__c = 'testsl'+i+'@mti.com';
            accs.recordtypeid = recmapacct.get('Person Account');
           
           listofaccts.add(accs); 
       }
       System.debug('@@@ list of accts size: ' + listofaccts.size());        
        
      insert listofaccts;
        
     
     Test.startTest();


// removed 2015-06-02 (removed Moodle_Username__c)      List<Account> returnedaccounts = [Select id, name,FirstName, LastName, Country_List__c,Phone,  PersonEmail,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, ForexTips_Username__c, Moodle_Username__c, Moodle_Username_College__c , UCS_User_Password__c from Account];
      List<Account> returnedaccounts = [Select id, name,FirstName, LastName, Country_List__c,Phone, PersonEmail,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, ForexTips_Username__c, Moodle_Username_College__c, Sub_End_Ultimate_Charting_Pro_Forex__pc, Client_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, Client_Ultimate_Charting_Pro_Stocks__pc, UCS_User_Password__c from Account];
      System.assertequals(10, returnedaccounts.size());

          StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
          mock.setStatusCode(200);
          mock.setstaticresource('sharedloginmockres');
          Test.setMock(HttpCalloutMock.class, mock);
          SharedLoginCallout logincallout = new SharedLoginCallout();
          String strurl = 'http://api.markettraders.com/shared-login/';
          String type = 'UCS';
          HttpResponse calloutres = logincallout.sharedLoginEndpoint(strurl, type , returnedaccounts[0]);
          //System.assertequals();
      Test.stopTest();

  }
  
  
    /**************************************
    * @method testcallout
    *
    * @description
    * tests the UCS callout with an error
    * uses HttpCalloutMock as mock callout with data in static resource 
    *
    **/    
  public static testmethod void testcallouterror(){
//custom setting
    //aac added country code conversion to allow users to get country to ucs backoffice which works on 2letter code
    UCSCountryCodes__c cscountrycode1 = new UCSCountryCodes__c();
    cscountrycode1.name = 'United States of America';
    cscountrycode1.CountryCode__c = 'US';    
    insert cscountrycode1;

    UCSCountryCodes__c cscountrycode2 = new UCSCountryCodes__c();
    cscountrycode2.name = 'Zimbabwe';
    cscountrycode2.CountryCode__c = 'ZW';    
    insert cscountrycode2;   


//setup test objects
            Map<String, ID> recmapacct = recTypeIDAccount();
      account accs = new account(
            salutation = 'Mr.',
            firstname = 'John',
            lastname = 'Sandbox1',
            PersonEmail = 'testsl@mti.com',
                        
              ForexTips_Username__c  = 'testsl@mti.com', 
// removed 2015-06-02              Moodle_Username__c = 'testsl@mti.com',
              Moodle_Username_College__c = 'testsl@mti.com',
              UCS_User_Password__c = 'testpswrd',
              UCS_Username__c = 'testsl@mti.com' ,
            recordtypeid = recmapacct.get('Person Account')
        );
      accs.Country_List__c = 'Zimbabwe'; //aac added 7.15.15 for country code conversion
      insert accs;

// removed 2015-06-02           List<Account> returnedaccounts = [Select id, name,FirstName, LastName, Country_List__c,Phone,  PersonEmail, ForexTips_Username__c,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, Moodle_Username__c, Moodle_Username_College__c , UCS_User_Password__c from Account];
      List<Account> returnedaccounts = [Select id, name,FirstName, LastName, Country_List__c,Phone,  PersonEmail, ForexTips_Username__c,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, Moodle_Username_College__c , Sub_End_Ultimate_Charting_Pro_Forex__pc, Client_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, Client_Ultimate_Charting_Pro_Stocks__pc, UCS_User_Password__c from Account];
      System.assertequals(1, returnedaccounts.size());
      
      Test.startTest();
          StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
          mock.setStatusCode(400);
          mock.setstaticresource('sharedloginmockres'); //change to moodle static resource test data
          Test.setMock(HttpCalloutMock.class, mock);
          SharedLoginCallout logincallout = new SharedLoginCallout();
          String strurl = 'http://dev.api.markettraders.com/app_dev.php/v1/ucsapp/users';
          String type = 'UCS';
          HttpResponse  calloutres = logincallout.sharedLoginEndpoint(strurl, type , returnedaccounts[0]);
      Test.stopTest();

  }
  
  
     /**************************************
    * @method testcalloutGet
    *
    * @description
    * tests the UCS callout Get function
    * uses HttpCalloutMock as mock callout with data in static resource 
    *
    **/     
  public static testmethod void testcalloutGet(){
//custom setting
    //aac added country code conversion to allow users to get country to ucs backoffice which works on 2letter code
    UCSCountryCodes__c cscountrycode1 = new UCSCountryCodes__c();
    cscountrycode1.name = 'United States of America';
    cscountrycode1.CountryCode__c = 'US';    
    insert cscountrycode1;

    UCSCountryCodes__c cscountrycode2 = new UCSCountryCodes__c();
    cscountrycode2.name = 'Zimbabwe';
    cscountrycode2.CountryCode__c = 'ZW';    
    insert cscountrycode2;
    
//setup test objects
      List<Account> listofaccts = new List<Account>();
      Account a = new Account();
      Map<String, ID> recmapacct = recTypeIDAccount();
      Account accs;
      for(Integer i = 0 ; i < 10 ; i++){       
            accs = new Account();
            accs.salutation = 'Mr.';
            accs.firstname = 'John';
            accs.lastname = 'Sandbox1';
            accs.Country_List__c = 'Zimbabwe'; //aac added 7.15.15 for country code conversion         
            accs.PersonEmail = 'testsl' + i + '@mti.com';
            accs.ForexTips_Username__c  = 'testsl'+i+'@mti.com'; 
// removed 2015-06-02                 accs.Moodle_Username__c = 'testsl'+i+'@mti.com';
            accs.Moodle_Username_College__c = 'testsl'+i+'@mti.com';
            accs.UCS_User_Password__c = 'testpswrd'+i;
            accs.UCS_Username__c = 'testsl'+i+'@mti.com';
            accs.recordtypeid = recmapacct.get('Person Account');
           
           listofaccts.add(accs); 
       }
       System.debug('@@@ list of accts size: ' + listofaccts.size());        
        
      insert listofaccts;
        
     
     Test.startTest();


// removed 2015-06-02           List<Account> returnedaccounts = [Select id, name, FirstName, LastName, Country_List__c,Phone,  PersonEmail, ForexTips_Username__c,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, Moodle_Username__c, Moodle_Username_College__c , UCS_User_Password__c from Account];
      List<Account> returnedaccounts = [Select id, name, FirstName, LastName, Country_List__c,Phone,  PersonEmail, ForexTips_Username__c,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, Moodle_Username_College__c , Sub_End_Ultimate_Charting_Pro_Forex__pc, Client_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, Client_Ultimate_Charting_Pro_Stocks__pc, UCS_User_Password__c from Account];
      System.assertequals(10, returnedaccounts.size());

          StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
          mock.setStatusCode(200);
          mock.setHeader('Content-Type', 'application/json');
          mock.setstaticresource('sharedloginmockres'); //change to moodle static resource test data
          Test.setMock(HttpCalloutMock.class, mock);
          SharedLoginCallout logincallout = new SharedLoginCallout();
          String strurl = 'http://dev.api.markettraders.com/app_dev.php/v1/ucsapp/users';
          String token = 'testtoken';
          String calloutres = logincallout.sharedLoginPullBack(strurl, token , returnedaccounts[0]);
          //System.assertequals();
      Test.stopTest();

  }
  
     /**************************************
    * @method testcalloutGETerror
    *
    * @description
    * tests the UCS callout Get function with an error
    * uses HttpCalloutMock as mock callout with data in static resource 
    *
    **/    
    public static testmethod void testcalloutGETerror(){
//custom setting
    //aac added country code conversion to allow users to get country to ucs backoffice which works on 2letter code
    UCSCountryCodes__c cscountrycode1 = new UCSCountryCodes__c();
    cscountrycode1.name = 'United States of America';
    cscountrycode1.CountryCode__c = 'US';    
    insert cscountrycode1;

    UCSCountryCodes__c cscountrycode2 = new UCSCountryCodes__c();
    cscountrycode2.name = 'Zimbabwe';
    cscountrycode2.CountryCode__c = 'ZW';    
    insert cscountrycode2;
    
//setup test objects
     Map<String, ID> recmapacct = recTypeIDAccount();
        Account accs = new Account();  
        accs.salutation = 'Mr.';
        accs.firstname = 'John';
        accs.lastname = 'Sandbox1';
        accs.PersonEmail = 'testsl@mti.com';
        accs.Country_List__c = 'Zimbabwe'; //aac added 7.15.15 for country code conversion
        accs.ForexTips_Username__c  = 'testsl@mti.com'; 
// removed 2015-06-02             accs.Moodle_Username__c = 'testsl@mti.com';
        accs.Moodle_Username_College__c = 'testsl@mti.com';
        accs.UCS_User_Password__c = 'testpswrd';
        accs.UCS_Username__c = 'testsl@mti.com';
        accs.recordtypeid = recmapacct.get('Person Account');
       insert accs;

// removed 2015-06-02                List<Account> returnedaccounts = [Select id, name,FirstName, LastName, Country_List__c,Phone,  PersonEmail, ForexTips_Username__c,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, Moodle_Username__c, Moodle_Username_College__c , UCS_User_Password__c from Account];
      List<Account> returnedaccounts = [Select id, name,FirstName, LastName, Country_List__c,Phone,  PersonEmail, ForexTips_Username__c,PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c, Moodle_Username_College__c , Sub_End_Ultimate_Charting_Pro_Forex__pc, Client_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, Client_Ultimate_Charting_Pro_Stocks__pc, UCS_User_Password__c from Account];
      System.assertequals(1, returnedaccounts.size());
      
      Test.startTest();
          StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
          mock.setStatusCode(400);
          mock.setHeader('Content-Type', 'application/json');
          mock.setstaticresource('sharedloginmockres'); //change to moodle static resource test data
          Test.setMock(HttpCalloutMock.class, mock);
          SharedLoginCallout logincallout = new SharedLoginCallout();
          String strurl = 'http://dev.api.markettraders.com/app_dev.php/v1/ucsapp/users';
          String token = 'testtoken';
          String calloutres = logincallout.sharedLoginPullBack(strurl, token , returnedaccounts[0]);
          //System.assertequals(true, logincallout.err);
      Test.stopTest();

  }
  
    /**************************************
    * @method testcalloutqueueable1
    *
    * @description
    * tests the UCS callout queueable function - SharedLoginToQueue
    * uses HttpCalloutMock as mock callout with data in static resource 
    *
    **/  
      public static testmethod void testcalloutqueueable1(){
//custom setting
    //aac added country code conversion to allow users to get country to ucs backoffice which works on 2letter code
    UCSCountryCodes__c cscountrycode1 = new UCSCountryCodes__c();
    cscountrycode1.name = 'United States of America';
    cscountrycode1.CountryCode__c = 'US';    
    insert cscountrycode1;

    UCSCountryCodes__c cscountrycode2 = new UCSCountryCodes__c();
    cscountrycode2.name = 'Zimbabwe';
    cscountrycode2.CountryCode__c = 'ZW';    
    insert cscountrycode2;
    
//setup test objects
      Map<String, ID> recmapacct = recTypeIDAccount();
      List<Account> listofaccts = new List<Account>();
      Account accs;
      for(Integer i = 0 ; i < 10 ; i++){       
            accs = new Account();
            accs.salutation = 'Mr.';
            accs.firstname = 'John';
            accs.lastname = 'Sandbox1';
            accs.Country_List__c = 'Zimbabwe'; //aac added 7.15.15 for country code conversion        
            accs.PersonEmail = 'testsl' + i + '@mti.com';
            accs.ForexTips_Username__c  = 'testsl'+i+'@mti.com'; 
// removed 2015-06-02            accs.Moodle_Username__c = 'testsl'+i+'@mti.com';
            accs.Moodle_Username_College__c = 'testsl'+i+'@mti.com';
            accs.UCS_User_Password__c = null;
            accs.UCS_Username__c = null;
            accs.recordtypeid = recmapacct.get('Person Account');
           accs.PB_SubEnd_UCSForex__c = date.today().adddays(90);
           accs.PB_SubEnd_UCSStocks__c = date.today().adddays(90);
          // accs.PB_SubEnd_UCSALL__c = date.today().adddays(90);
           listofaccts.add(accs); 
       }
       
       insert listofaccts;
     
      Map<ID,Account> returnedaccounts = new Map<ID,Account>([Select id,FirstName, LastName, Country_List__c,Phone,  PersonEmail,PB_SubEnd_UCSForex__c , PB_SubEnd_UCSStocks__c, Sub_End_Ultimate_Charting_Pro_Forex__pc, Client_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, Client_Ultimate_Charting_Pro_Stocks__pc from Account where id in :listofaccts ]);
      System.assertnotequals(null,returnedaccounts);
      System.assertequals(true, returnedaccounts.size() >0 ); 
       
       //change the date which triggers the UCS callouts
      List<account> retaccts = returnedaccounts.values();
     retaccts[0].PB_SubEnd_UCSStocks__c = date.today().adddays(80);
     retaccts[1].PB_SubEnd_UCSStocks__c = date.today().adddays(80);
     update retaccts;
     Map<ID,Account> returnedaccounts2 = new Map<id, account>([Select id,FirstName, LastName, Country_List__c,Phone,  PersonEmail,PB_SubEnd_UCSForex__c , PB_SubEnd_UCSStocks__c, Sub_End_Ultimate_Charting_Pro_Forex__pc, Client_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, Client_Ultimate_Charting_Pro_Stocks__pc from Account ]);
    List<ID> acctids = new list<id>();
    acctids.add(retaccts[0].id);
    acctids.add(retaccts[1].id);

            
      Test.startTest();

          StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
          mock.setStatusCode(200);
          mock.setHeader('Content-Type', 'application/json');
          mock.setstaticresource('sharedloginmockres'); //change to moodle static resource test data
          Test.setMock(HttpCalloutMock.class, mock);
          SharedLoginToQueue.testchanged = true;
          SharedLoginToQueue.queueCallouts(returnedaccounts  ,returnedaccounts2  );
          System.assertequals(null,retaccts[0].UCS_Username__c);
          System.assertequals(null,retaccts[0].UCS_User_Password__c );          
          System.enqueueJob(new SharedLoginQueueable(acctids));  

      Test.stopTest();
    Map<ID,Account> returnedaccounts3 = new Map<id, account>([Select id,PB_SubEnd_UCSForex__c ,UCS_Username__c,UCS_User_Password__c , PB_SubEnd_UCSStocks__c, Sub_End_Ultimate_Charting_Pro_Forex__pc, Client_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, Client_Ultimate_Charting_Pro_Stocks__pc from Account ]);
          System.assertnotequals(null,returnedaccounts3.get(retaccts[0].id).UCS_Username__c);
          System.assertnotequals(null,returnedaccounts3.get(retaccts[0].id).UCS_User_Password__c );    

  }

  
  
     /**************************************
    * @method recTypeIDAccount
    *
    * @description
    * gets the record type info for Accounts from the schemna
    * 
    **/   
      public static Map<String, ID> recTypeIDAccount(){
        
        Map<String, ID> newmap = new Map<String, ID>();
        Schema.DescribeSObjectResult describeopp = Schema.SObjectType.Account;
        List<Schema.RecordTypeInfo> rtInfos = describeopp.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
            newmap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
        }
        
        return newmap;
    }
  
  
  
  
  
  
  
}