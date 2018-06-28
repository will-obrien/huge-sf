@isTest
private class Test_LMFSProcessor {

    private static testMethod void unitTest(){

        Webinar_Credentials__c credentials = new Webinar_Credentials__c();

        credentials.Name = 'LMFS';       
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
        webinar.Event_Date_Time__c = DateTime.now();
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
  
        
        test.startTest();
        
            LMFSProcessor processor = new LMFSProcessor();
            processor.configure();
            processor.parseData(mockCSV);

            processor.updateWebinar();
            webinar = [SELECT id FROM Webinar__c];
            
            processor.preprocess();
            processor.run();
            processor.getOpportunities();
            processor.getWebinarAttendanceComponent();
            
            List<SelectOption> webinarOptions = processor.getWebinars();
            system.assertEquals(webinarOptions.size(),2);
            
            processor.getOpportunities();
        
        test.stopTest();

    }
    
}