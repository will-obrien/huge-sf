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
public class Test_BatchFrontEndPreProcessor {
    static testMethod void myUnitTest() {
    
       Map<String, ID> acctrectypemap = recTypeID();
       Account testaccount1 = new Account();
       testaccount1.FirstName = 'Tarek';
       testaccount1.LastName = 'Aboushakka';
       testaccount1.PersonEmail = 'tarektrade@icloud.com';
       testaccount1.Alternate_Email__c = 'tarektrade@icloud.com';
       testaccount1.RecordTypeID = acctrectypemap.get('Person Account');

        insert testaccount1;
        
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
        
        Webinar__c webinar = new Webinar__c();
        webinar.Webinar_Id__c = '257867952';
        webinar.Webinar_Credentials__c = credentials.id;
        webinar.Event_Date_Time__c = DateTime.now().addminutes(-240);
        webinar.Name= 'Attendee Report:,"$121,300* Trading Plans Revealed - MTIs 4X Trading Prediction';
        webinar.Platform__c = 'Citrix';
        webinar.PrimaryPresenter__c = 'Josh Martinez';
        webinar.Actual_Duration__c =  211;
        webinar.Actual_Start_Time__c = DateTime.now().addminutes(-241);
        webinar.Time_at_Close__c = DateTime.now().addminutes(-30);
        //webinar.Type_of_Webinar__c =          
        Database.insert(webinar);
        
        String mockCSV = 'Attendee Report:,"$121,300* Trading Plans Revealed - MTIs 4X Trading Prediction",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Report Generated:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += '2/2/15 3:30 PM EST,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Webinar ID,Actual Start Date/Time,Duration,# Registered,# Attended,Clicked Registration Link,Opened Invitation,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += '257-867-952,2/2/15 11:56 AM EST,3 hours 31 minutes,960,430,14,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Attendee Details,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Attended,Interest Rating,Last Name,First Name,Email Address,Registration Date/Time,Join Time,Leave Time,Time in Session,Phone,Unsubscribed,Webinar Question 1,Webinar Response 1,Webinar Question 2,Webinar Response 2,Webinar Question 3,Webinar Response 3,Webinar Question 4,Webinar Response 4,Webinar Question 5,Webinar Response 5,Webinar Question 6,Webinar Response 6,Webinar Question 7,Webinar Response 7,Webinar Question 8,Webinar Response 8,Webinar Question 9,Webinar Response 9,Webinar Question 10,Webinar Response 10,Webinar Question 11,Webinar Response 11,Webinar Question 12,Webinar Response 12,Webinar Question 13,Webinar Response 13,Webinar Question 14,Webinar Response 14,Webinar Question 15,Webinar Response 15,Webinar Question 16,Webinar Response 16,Webinar Question 17,Webinar Response 17,Webinar Question 18,Webinar Response 18,Webinar Question 19,Webinar Response 19,Webinar Question 20,Webinar Response 20,Webinar Question 21,Webinar Response 21,Webinar Question 22,Webinar Response 22,Webinar Question 23,Webinar Response 23,Webinar Question 24,Webinar Response 24,Webinar Question 25,Webinar Response 25,Webinar Question 26,Webinar Response 26,Webinar Question 27,Webinar Response 27,Webinar Question 28,Webinar Response 28,\n';
        mockCSV += 'Yes,56,Aboushakka,Tarek,tarektrade@icloud.com,2/2/15 1:05 PM EST,2/2/15 1:07 PM EST,2/2/15 1:57 PM EST,50 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,31,Abraham,Temu,,abraham.temu@t3tradinggroup.com,2/2/15 11:18 AM EST,2/2/15 1:44 PM EST,2/2/15 2:24 PM EST,39 minutes,9179546091,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,60,Ade,Adetoks,charlesafonzo@yahoo.co.uk,2/2/15 1:50 PM EST,2/2/15 1:52 PM EST,2/2/15 3:23 PM EST,3 hours 2 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,55,Adu,Ennada,ennadaadu@gmail.com,2/2/15 11:23 AM EST,2/2/15 12:47 PM EST,2/2/15 3:15 PM EST,2 hours 27 minutes,17047654321,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,47,Ali,Hassan,hassan_ali757@hotmail.com,2/2/15 1:03 PM EST,2/2/15 1:04 PM EST,2/2/15 1:39 PM EST,5 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n'; 
       // mockCSV += 'last line of text,,,,,,,,,,';   
        
        test.startTest();
        
            FrontEndProcessor processor = new FrontEndProcessor();          
            processor.configure();
            processor.parseData(mockCSV);
            webinar = [SELECT id,Event_Date_Time__c,Name,Webinar_ID__c,Platform__c,PrimaryPresenter__c,SecondaryPresenter__c,Down_Payment__c,Actual_Duration__c,Actual_Start_Time__c,Additional_Discount_Offer__c,Time_at_Close__c,Type_of_Webinar__c,People_at_Price__c,Attentive_Rate_at_Close__c,Promotion__c,DiscountPercent__c,DiscountDollar__c,Discount_Type__c FROM Webinar__c LIMIT 1];
            Processor_Log__c processorlog = [Select id,Number_Of_New_Opps__c,Number_of_New_Deals__c,Number_of_Updated_Opps__c,Number_of_Untouched_Opps__c,Number_of_Failed_Converted_Leads__c,Number_of_Converted_Leads__c,Number_of_Webinar_Attendance_Found__c,Number_of_Webinar_Attendance_Created__c,Number_of_Tasks_Created__c,Number_of_Tasks_Found__c,Webinar__c from Processor_Log__c where Webinar__c = :webinar.id];
            List<Attachment> attachquery =[SELECT id, body FROM Attachment WHERE Name = 'Processor Records' AND ParentId = : processorlog.Id ];
            System.AssertEquals(true, attachquery.size() > 0);
            System.AssertNotEquals(null,attachquery.size());
            //System.debug('@asha: @debug: Test_BatchFrontEndPreProcessor: Attachments ' + Blob.toString(attachquery[0].body));
        
            ProcessorConfiguation configuration = new ProcessorConfiguation();        
             /* Configure Processor Data Options */
            configuration.csv = true;
            configuration.api = false;
            configuration.manualWebinarSelection = false;
            configuration.manualDateSelection = false;        
            /* Configure Processor Settings Options */
            configuration.showPresenter = true;
            configuration.showSecondaryPresenter = true;
            configuration.showDiscount = true;
            configuration.showDownPayment = true;
            configuration.showActualStarttime = true;
            configuration.showActualDuration = true;
            configuration.showWebinarType = true;
            configuration.showTimeAtClose = true;
            configuration.showPeopleAtPrice = true;
            configuration.showAttentiveRate = true;
            configuration.showPromotion = true;
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
            configuration.taskActivityType = 'Webinar Attendance';
     
            
            Batch_FrontEndPreProcess batchedProcess = new Batch_FrontEndPreProcess(processorlog,configuration,webinar);
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