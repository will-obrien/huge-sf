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
*   Last Modified:      12/19/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
@isTest
public class Test_Batch_TalkpointProcess{
    static testMethod void myUnitTest() {
    
    List<TalkpointColMap__c> list_custsetting_credential = new List<TalkpointColMap__c>();
    TalkpointColMap__c talkpointcs1 = new TalkpointColMap__c();
    talkpointcs1.name = 'eventidrow';
    talkpointcs1.col__c = 1;
    list_custsetting_credential.add(talkpointcs1);
    
        TalkpointColMap__c talkpointcs2 = new TalkpointColMap__c();
    talkpointcs2.name = 'eventidcol';
    talkpointcs2.col__c = 0; 
    list_custsetting_credential.add(talkpointcs2);
    
        TalkpointColMap__c talkpointcs3 = new TalkpointColMap__c();
    talkpointcs3.name = 'datarow';
    talkpointcs3.col__c = 0;  
    list_custsetting_credential.add(talkpointcs3);
    
        TalkpointColMap__c talkpointcs4 = new TalkpointColMap__c();
    talkpointcs4.name = 'emailcol';
    talkpointcs4.col__c =  7;
    list_custsetting_credential.add(talkpointcs4);
    
        TalkpointColMap__c talkpointcs5 = new TalkpointColMap__c();
    talkpointcs5.name = 'lastnamecol';
    talkpointcs5.col__c =  5;
    list_custsetting_credential.add(talkpointcs5);
    
    TalkpointColMap__c talkpointcs7 = new TalkpointColMap__c();
    talkpointcs7.name = 'registeredoncol';
    talkpointcs7.col__c =  3;
    list_custsetting_credential.add(talkpointcs7);
    
        TalkpointColMap__c talkpointcs8 = new TalkpointColMap__c();
    talkpointcs8.name = 'phonecol'; 
    talkpointcs8.col__c = 15 ;
    list_custsetting_credential.add(talkpointcs8);
    
        TalkpointColMap__c talkpointcs9 = new TalkpointColMap__c();
    talkpointcs9.name = 'numsessionscol';
    talkpointcs9.col__c =  22;
    list_custsetting_credential.add(talkpointcs9);
    
        TalkpointColMap__c talkpointcs10 = new TalkpointColMap__c();
    talkpointcs10.name = 'insessiondurationcol';
    talkpointcs10.col__c =  26;
    list_custsetting_credential.add(talkpointcs10);
    
        TalkpointColMap__c talkpointcs11 = new TalkpointColMap__c();
    talkpointcs11.name = 'firstnamecol';
    talkpointcs11.col__c =  4;
    list_custsetting_credential.add(talkpointcs11);
    
      insert list_custsetting_credential;
         
         
        Lead lead = new Lead();
        lead.FirstName = 'Clark';
        lead.LastName = 'Kent';
        lead.leadSource = 'Newspaper';
        lead.Email = 'clark.kent@smallville.com';
        //Database.insert(lead);
        
        Account account = new Account();
        account.FirstName = 'Bruce';
        account.LastName = 'Wayne';
        account.PersonEmail = 'bruce.wayne@gotham.com';
        account.Country_List__c = 'United States of America';
        account.RecordTypeId = '012600000005CeK';
       //Database.insert(account);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'UTP OnDemand (' + String.valueOf(Date.today()) + ')';
        opp.RecordTypeId = '012600000005Cwx';
        opp.AccountId = account.id;
        opp.CloseDate = Date.today();
        opp.StageName = 'Closed Won';
        opp.Sub_Stage__c = 'Paid';
        opp.Product__c = 'UTP OnDemand';
        opp.LeadSource = 'CC-Motley';
        opp.Sale_Down_Payment_1_of_4_DESIRED__c = 500;
        opp.Sale_Down_Payment_1_of_4_Date__c = Date.today().addDays(1);
        opp.Sale_Invoice_Qty_Payments_After_Down__c = 1;
        opp.Sale_Invoice_First_Date_After_Down__c = Date.today().addDays(30);
        //Database.insert(opp);
        
        Webinar_Credentials__c credentials = new Webinar_Credentials__c();
        credentials.API_Key__c = 'test';
        credentials.Credentials_ID__c = '0';
        credentials.Mnemonic__c = 'test';
        credentials.Org_ID__c = '654564654';
        credentials.Password__c = 'test';
        credentials.Provider__c = 'Talkpoint';
        credentials.Token__c = '123123';
        credentials.Username__c = 'test';
        Database.insert(credentials);
        
        Webinar__c webinar = new Webinar__c();
        webinar.Name = '1027486';
        webinar.Webinar_Id__c = '1027486';
        webinar.Webinar_Credentials__c = credentials.id;
        webinar.Event_Date_Time__c = DateTime.now();
        Database.insert(webinar);
        
     /*   
        String mockCSV = 'OD Report\n';
        mockCSV += '\n';
        mockCSV += 'Report For :Forex Trader Shares Trading Strategies and Pro Tools Demonstration\n';
        mockCSV += 'Event#: '+webinar.Webinar_Id__c+'\n';
        mockCSV += 'First Published: 03/05/2014 21:32:25\n';
        mockCSV += 'Event Expiration: 03/05/2014 21:32:25\n';
        mockCSV += 'Duration: 01:02:55\n';
        mockCSV += '\n';
        mockCSV += 'Total Sessions,Total Registrants,No Shows,Total Conversion Rate,Live Sessions,Unique Live Viewers,Registrants at Live Event Conclusion,Live Event Conversion Rate,On-Demand Sessions,Unique On-Demand Viewers,SimLive Sessions,Unique SimLive Viewers\n';
        mockCSV += '194,150,1,99.3%,0,0,0,0,194,149,0,0\n';
        mockCSV += '"Registered On","First Name","Last Name","Email","Company","Title","Address 1","Address 2","City","State","Country","Postal Code","Phone Number","Mobile Number","Fax Number","Source Track Id","Live Sessions","On-Demand Sessions","SimLive Sessions","Total Sessions","Live Duration","On-Demand Duration","SimLive Duration","Total Duration","Question","Answer","Question","Answer","Question","Answer","Question","Answer","Question","Answer","Question","Answer"\n';
        mockCSV += '"03/05/2014 21:32:25","","","emilworx@gmail.com","","","","","","","","","","","","","0","1","0","1","00:00:00","00:30:37","00:00:00","00:30:37","","","","","","","","","","","","",\n';
        mockCSV += '"03/05/2014 21:32:25","","","olcasunxx@yahoo.com","","","","","","","","","","","","","0","2","0","2","00:00:00","00:01:00","00:00:00","00:01:00","","","","","","","","","","","","",\n';
        mockCSV += '"03/05/2014 21:32:25","","","simoningramgillson@gmail.com","","","","","","","","","","","","","0","1","0","1","00:00:00","00:02:10","00:00:00","00:02:10","","","","","","","","","","","","",\n';
        mockCSV += '"03/05/2014 21:32:25","","","ruedur@aol.com","","","","","","","","","","","","","0","1","0","1","00:00:00","00:00:30","00:00:00","00:00:30","","","","","","","","","","","","",\n';
        mockCSV += '"03/05/2014 21:32:25","","","bouddha5704@gmail.com","","","","","","","","","","","","","0","1","0","1","00:00:00","00:06:20","00:00:00","00:06:20","","","","","","","","","","","","",\n';
        mockCSV += '"03/05/2014 21:32:25","","","bouddha5704@gmail.com","","","","","","","","","","","","","0","1","0","1","00:00:00","00:06:20","00:00:00","00:06:20","","","","","","","","","","","","",\n';
        mockCSV += '"03/05/2014 21:32:25","","","bouddha5704gmail.com","","","","","","","","","","","","","0","1","0","1","00:00:00","00:06:20","00:00:00","00:06:20","","","","","","","","","","","","",\n';
        mockCSV += '"03/05/2014 21:32:25","","","chrisscot43@yahoo.com","","","","","","","","","","","","","0","1","0","1","00:00:00","00:33:37","00:00:00","00:33:37","What\'s my next.  Step to take now","","","","","","","","","","","",\n';
        */
        
        String  mockCSV = '';
        mockCSV +='Event Id,Event Title,Cost Center,Registered On,First Name,Last Name,Company,Email,Title,Address 1,Address 2,City,State,Country,Postal Code,Phone Number,Mobile Number,Fax Number,Source Track ID,Live Sessions,On-Demand Sessions,SimLive Sessions,Total Sessions,Live Duration,On-Demand Duration,SimLive Duration,Total Duration,Question 1,Answer 1\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,4/26/2014 10:40,,,,richertvanimpe@yahoo.com,,,,,,,,,,,,0,1,0,1,0:00:00,1:42:10,0:00:00,1:42:10,,\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,5/16/2014 13:58,,,,almarkovic@gmail.com,,,,,,,,,,,,0,1,0,1,0:00:00,42:09:38,0:00:00,42:09:38,,\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,5/19/2014 14:48,,,,jwrichmond@kinect.co.nz,,,,,,,,,,,,0,1,0,1,0:00:00,0:00:36,0:00:00,0:00:36,,\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,5/20/2014 4:55,,,,tnogaro@hotmail.com,,,,,,,,,,,,0,1,0,1,0:00:00,82:35:46,0:00:00,82:35:46,,\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,6/12/2014 8:15,basmal,basmal,,basmalfx@gmail.com,,,,,,,,,,,,0,1,0,1,0:00:00,0:04:23,0:00:00,0:04:23,,\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,6/30/2014 6:56,kalman,golan,,kamago64@walla.com,,,,,,,,,,,,0,1,0,1,0:00:00,0:02:08,0:00:00,0:02:08,,\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,7/22/2014 20:51,Ronnie,NA,,ronnieho168@hotmail.com,,,,,,,,,,,,0,1,0,1,0:00:00,0:02:26,0:00:00,0:02:26,,\n';
        mockCSV +='1027486,Forex Trader Shares Trading Strategies and Pro Tools Demonstration,,9/21/2014 12:45,,,,actavivgroup@gmail.com,,,,,,,,,,,,0,1,0,1,0:00:00,1:00:59,0:00:00,1:00:59,,\n';
        
        
        test.startTest();
            TalkpointProcessor processor = new TalkpointProcessor();
            processor.configure();
            processor.parseData(mockCSV);
            
            //retrieve data for batch job
            webinar = [SELECT id,Event_Date_Time__c,Name,Webinar_ID__c,Platform__c,PrimaryPresenter__c,SecondaryPresenter__c,Down_Payment__c,Actual_Duration__c,Actual_Start_Time__c,Additional_Discount_Offer__c,Time_at_Close__c,Type_of_Webinar__c,People_at_Price__c,Attentive_Rate_at_Close__c,Promotion__c,DiscountPercent__c,DiscountDollar__c,Discount_Type__c FROM Webinar__c LIMIT 1];
            Processor_Log__c processorlog = [Select id,Number_Of_New_Opps__c,Number_of_New_Deals__c,Number_of_Updated_Opps__c,Number_of_Untouched_Opps__c,Number_of_Failed_Converted_Leads__c,Number_of_Converted_Leads__c,Number_of_Webinar_Attendance_Found__c,Number_of_Webinar_Attendance_Created__c,Number_of_Tasks_Created__c,Number_of_Tasks_Found__c,Webinar__c from Processor_Log__c where Webinar__c = :webinar.id];
           
           //verify attachments created
            List<Attachment> attachquery =[SELECT id, body FROM Attachment WHERE Name = 'Processor Records' AND ParentId = : processorlog.Id ];
            System.AssertEquals(true, attachquery.size() > 0);
            System.AssertNotEquals(null,attachquery.size());
            //System.debug('@asha: @debug: Test_Batch_TalkpointProcess: Attachments ' + Blob.toString(attachquery[0].body));
        
        //create configuration file
            ProcessorConfiguation configuration = new ProcessorConfiguation();        
           /* Configure Processor Data Options */
        configuration = new ProcessorConfiguation();
        
        /* Configure Processor Data Options */
        configuration.csv = true;
        configuration.api = false;
        configuration.manualWebinarSelection = false;
        configuration.manualDateSelection = true;
        
        /* Configure Processor Settings Options */
        configuration.skipSettings = true;

        /* Configure Opportunity Details */
        configuration.opportunityRecordTypeId = '012600000005Cwx';
        configuration.opportunityRecordTypeName = 'Education';
        configuration.opportunityName = 'UTP OnDemand (' + String.valueOf(Date.today()) + ')';
        configuration.opportunityProduct = 'UTP OnDemand';
        configuration.opportunityStageName = 'New Deal';
        configuration.opportunitySubStage = null;
        configuration.paymentPlan = null;
        configuration.opportunityCloseDate = ProccessorHelperMethods.getEndOfQuarterDate(Date.today());
        
        configuration.opportunityOwnersMap = processor.getOpportunityOwners();
        configuration.setOpportunityOwnerAssignmentVariables();
        
        configuration.leadRecordTypeId = '012600000005Cwi';
        
        configuration.taskWebinarType = 'UTP OnDemand';
        configuration.taskActivityType = 'OnDemand Webinar';
     
     
        Opportunity  primaryOpportunity = ProccessorHelperMethods.createOpportunity(configuration.opportunityName,configuration.opportunityRecordTypeId,configuration.opportunityCloseDate,configuration.opportunityStageName,configuration.opportunitySubStage,configuration.paymentPlan,configuration.opportunityProduct,account.id); 
         
        insert primaryOpportunity;
            
            
            Batch_TalkpointProcess batchedProcess = new Batch_TalkpointProcess(processorlog,configuration,webinar);
            Id processId = Database.executeBatch(batchedProcess,1);
            test.stopTest();

        
        
    }   
     public static Map<String, ID> recTypeID(){
        
        Map<String, ID> newmap = new Map<String, ID>();
        Schema.DescribeSObjectResult describeacct = Schema.SObjectType.Account;
        List<Schema.RecordTypeInfo> rtInfos = describeacct.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
            newmap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
        }
        
        return newmap;
    }
    
}