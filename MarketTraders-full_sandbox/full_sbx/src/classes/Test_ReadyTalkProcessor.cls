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
*   Date Created:       7/27/2015
*   Author:             Asha Calderon
*   Last Modified:      7/27/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/

@isTest
private class Test_ReadyTalkProcessor {

  /***************************
  * @method: unitTest
  * - Create mock Ready Talk meeting members
  * - Create mock Webinar
  *
  * - run the configuration file for the processor
  * - run the parse of data from the mock csv file based on the USC processor format
  * - run the batch process for the deserializing of JSON data and creating webinar attendance records
  *
  *
  **/ 
    private static testMethod void unitTest(){

        
        
        Webinar__c webinar = new Webinar__c();
        webinar.Webinar_Id__c = '257867952';
        webinar.Platform__c = 'ReadyTalk';
        webinar.Event_Date_Time__c = DateTime.now();
        webinar.StampType__c = 'USC Sales';
        Database.insert(webinar);
        
        RT1__ReadyTalkMeeting__c newmeeting = new RT1__ReadyTalkMeeting__c();
        newmeeting.NAME = 'MTI Test #1';
        newmeeting.CURRENCYISOCODE = 'USD';
        newmeeting.RT1__ACCESSCODE__C = '7400900';
        newmeeting.RT1__ALLOWOTHERSTOINVITE__C=FALSE;
        newmeeting.RT1__BATCHID__C ='7071100000Ydc0GAAR';
        newmeeting.RT1__CCMEETINGSTATUS__C ='Closed';
        newmeeting.RT1__CAMPAIGNSYNCSTARTED__C =FALSE;
        newmeeting.RT1__CREATENEWLEADS__C = TRUE;
        newmeeting.RT1__CURRENTSYNCSTARTED__C=Datetime.now().adddays(-10);
        newmeeting.RT1__DURATION__C ='60 minutes';
        newmeeting.RT1__ENCODEDMEETINGID__C  ='52kn93en7hxo';
        newmeeting.RT1__HOSTNAME__C = 'Aaron Hunziker';
        newmeeting.RT1__LASTSYNCCOMPLETED__C = Datetime.now().adddays(-10).addminutes(10);
        newmeeting.RT1__LASTSYNCSTARTED__C  =Datetime.now().adddays(-10);
        newmeeting.RT1__LEADASSIGNMENTBEHAVIOR__C  ='Assign to another user';
        newmeeting.RT1__LEADASSIGNMENTRULEID__C  ='01Q60000000EwoVEAS';
        newmeeting.RT1__LEADOWNERID__C ='00560000000mIAOAA2';
        newmeeting.RT1__LEADSOURCE__C  ='Webinar';
        newmeeting.RT1__MEETINGDATETIME__C =Datetime.now().adddays(-10);
        newmeeting.RT1__MEETINGID__C    = '257867952';
        newmeeting.RT1__MEETINGTIMENATIVE__C = 'September 17, 2015 10:00 AM EDT';
        newmeeting.RT1__MEETINGTYPE__C = 'WEB_AND_AUDIO';
        newmeeting.RT1__MEETINGURL__C = 'https://cc.readytalk.com/cc/past/postEventAction.do?id=52kn93en7hxo';
        newmeeting.RT1__MEETING_TYPE__C =   'Webinar';
        newmeeting.RT1__PASSCODE__C = '9029';
        newmeeting.RT1__POLLQUESTIONIDS__C ='null:null:null:null:null';
        newmeeting.RT1__REGISTRATIONURL__C ='https://cc.readytalk.com/r/27iuq9vgan7m';
        newmeeting.RT1__SCHEDULEDFORIMPORT__C=  FALSE;
        newmeeting.RT1__TIMEZONEDB__C ='America/New_York';
        newmeeting.RT1__UPDATEEXISTINGPEOPLE__C  = FALSE;
        insert newmeeting;
        
        List<Lead> leadlist = new List<lead>();
        
        for(integer i=0;i<10;i++){
            Lead newrtlead = new Lead();
            newrtlead.FirstName = 'testfname'+i;
            newrtlead.LastName = 'testlname'+i;
            newrtlead.leadSource = 'Newspaper';
            newrtlead.Email = 'testmti'+i+'@mti.com';
            leadlist.add(newrtlead);
        }
        insert leadlist;
        
        list<RT1__ReadyTalkMeetingMember__c> listrtmem = new list<RT1__ReadyTalkMeetingMember__c>();
       /* batch process when inserting readytalk members causes issue running test - unable to run more than 1 per test class 
        for(integer i=0;i<10;i++){
            RT1__ReadyTalkMeetingMember__c newreadytalkmember = new RT1__ReadyTalkMeetingMember__c();            
            newreadytalkmember.RT1__Lead__c = leadlist[i].id;
            newreadytalkmember.RT1__RegistrationFirstName__c = 'testfname'+i;
            newreadytalkmember.RT1__RegistrationLastName__c= 'testlname'+i;
            newreadytalkmember.RT1__EntryTime__c = Datetime.now().adddays(-10);
            newreadytalkmember.RT1__ExitTime__c = Datetime.now().adddays(50);
            newreadytalkmember.RT1__DurationMinutes__c = 50;
            newreadytalkmember.RT1__Status__c = (i>7)? 'Confirmed' :'Attended';
            newreadytalkmember.RT1__ReadyTalkMeeting__c = newmeeting.id;
            listrtmem.add(newreadytalkmember);
        }
        insert listrtmem;
        */
        String webinarid = '257867952';
        test.startTest();
        
            ReadyTalkProcessor processor = new ReadyTalkProcessor();
            processor.configure();
            processor.parseData(webinarid);

            processor.updateWebinar();
            webinar = [SELECT id FROM Webinar__c];
            
            processor.preprocess();
            processor.run();
            processor.getOpportunities();
            processor.getWebinarAttendanceComponent();
            
            //return list of webinars for select options on page
            List<SelectOption> webinarOptions = processor.getWebinars();
            system.assertEquals(webinarOptions.size(),2);
            
            processor.getOpportunities();
        
        test.stopTest();

    }
    
}