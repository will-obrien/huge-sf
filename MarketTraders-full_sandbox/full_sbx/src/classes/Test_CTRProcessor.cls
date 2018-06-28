@isTest
private class Test_CTRProcessor{

    static testmethod void unitTest() {
        Webinar__c webinar = new Webinar__c();
        webinar.name = 'test webinar';
        webinar.Webinar_Id__c = '257867952x';
        webinar.Event_Date_Time__c = datetime.parse('2/2/2015 11:56 AM'); 
        webinar.Webinar_Type__c = 'CE Classes';
        webinar.PrimaryPresenter__c = 'Josh Martinez';
        webinar.Promotion__c = 'test';
        webinar.People_at_Price__c = 55;
        webinar.Price_Presented__c = 3000;
        webinar.Attentive_Rate_at_Close__c = 27;
        webinar.Actual_Start_Time__c =datetime.parse('2/2/2015 11:56 AM');
        webinar.Time_at_Close__c = datetime.parse('2/2/2015 3:27 PM');
        webinar.Actual_Duration__c = 271;
        webinar.StampType__c = 'CE Classes';
        Database.insert(webinar);
        
       Map<String, ID> acctrectypemap = recTypeID();
        
       
       Account testaccount = new Account();
       testaccount.FirstName = 'Ade';
       testaccount.LastName = 'Adetoks';
       testaccount.PersonEmail = 'charlesafonzo@yahoo.co.uk';
       testaccount.Alternate_Email__c = 'charlesafonzo@yahoo.co.uk';
       testaccount.RecordTypeID = acctrectypemap.get('Person Account');
        insert testaccount;
        
        Account retrievedacct = [Select id, PersonContactID, Firstname, LastName, OwnerID from Account where id =: testaccount.id];
       
        User testuser = [select id, name from User where name ='Next Step Financial Holdings'];
       
        Task testtask = new Task();
        testtask.WhoID = retrievedacct.PersonContactid;
        testtask.Priority = 'Normal';
        testtask.OwnerID = testuser.id;
        testtask.Status = 'Complete';   
        testtask.Activity_Type__c = 'Webinar Attendance';             
        testtask.Event_Date_Time__c = datetime.parse('2/2/2015 11:56 AM');
        testtask.Webinar_Discount_Offer_Percent__c = .20;
        testtask.Webinar_Presenter__c = 'Josh Martinez';
        testtask.Join_Time__c = '2/2/2015 11:56 AM';
        testtask.Duration__c = 271;
        testtask.Attended__c = true;
        testtask.Event_Name__c = 'test webinar';
        testtask.Webinar_Type__c = 'CE Classes';
        Database.insert(testtask);
        
        String mockCSV = 'test webinar",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Report Generated:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += '2/2/15 3:30 PM EST,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Webinar ID,Actual Start Date/Time,Duration,# Registered,# Attended,Clicked Registration Link,Opened Invitation,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += '257867952x,2/2/15 11:56 AM EST,3 hours 31 minutes,960,430,14,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Attendee Details,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Attended,Interest Rating,Last Name,First Name,Email Address,Registration Date/Time,Join Time,Leave Time,Time in Session,Phone,Unsubscribed,Webinar Question 1,Webinar Response 1,Webinar Question 2,Webinar Response 2,Webinar Question 3,Webinar Response 3,Webinar Question 4,Webinar Response 4,Webinar Question 5,Webinar Response 5,Webinar Question 6,Webinar Response 6,Webinar Question 7,Webinar Response 7,Webinar Question 8,Webinar Response 8,Webinar Question 9,Webinar Response 9,Webinar Question 10,Webinar Response 10,Webinar Question 11,Webinar Response 11,Webinar Question 12,Webinar Response 12,Webinar Question 13,Webinar Response 13,Webinar Question 14,Webinar Response 14,Webinar Question 15,Webinar Response 15,Webinar Question 16,Webinar Response 16,Webinar Question 17,Webinar Response 17,Webinar Question 18,Webinar Response 18,Webinar Question 19,Webinar Response 19,Webinar Question 20,Webinar Response 20,Webinar Question 21,Webinar Response 21,Webinar Question 22,Webinar Response 22,Webinar Question 23,Webinar Response 23,Webinar Question 24,Webinar Response 24,Webinar Question 25,Webinar Response 25,Webinar Question 26,Webinar Response 26,Webinar Question 27,Webinar Response 27,Webinar Question 28,Webinar Response 28,\n';
        mockCSV += 'Yes,56,Aboushakka,Tarek,tarektrade@icloud.com,2/2/15 1:05 PM EST,2/2/15 1:07 PM EST,2/2/15 1:57 PM EST,50 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,31,Abraham,Temu,abraham.temu@t3tradinggroup.com,2/2/15 11:18 AM EST,2/2/15 1:44 PM EST,2/2/15 2:24 PM EST,39 minutes,9179546091,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,60,Ade,Adetoks,charlesafonzo@yahoo.co.uk,2/2/15 1:50 PM EST,2/2/15 1:52 PM EST,2/2/15 3:23 PM EST,3 hours 2 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,55,Adu,Ennada,ennadaadu@gmail.com,2/2/15 11:23 AM EST,2/2/15 12:47 PM EST,2/2/15 3:15 PM EST,2 hours 27 minutes,17047654321,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,47,Ali,Hassan,hassan_ali757@hotmail.com,2/2/15 1:03 PM EST,2/2/15 1:04 PM EST,2/2/15 1:39 PM EST,5 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n'; 
        Test.startTest();
        
        ProcessorController processorcontr = new ProcessorController();
        processorcontr.loadProcessorHomePage();
        processorcontr.getProcessors();
        processorcontr.getTableSizeOptions();
        processorcontr.getPromotions();
        processorcontr.getPreviewOptions();
        processorcontr.setProcessorRecordsetController();
        processorcontr.selectedProcessor ='15';
        processorcontr.loadProcessorDataPage();         

        processorcontr.loadProcessorVerifyWebinarPage();     
        processorcontr.loadProcessorSettingsPage(); 
        processorcontr.loadProcessorPreviewPage(); 
        processorcontr.loadProcessorResults();
        //test individual items
        CTRProcessor processor = new CTRProcessor();    
         processor.configure();
         processor.parseData(mockCSV);
         processor.updateWebinar();
         processor.run();
         processor.getOpportunities();
         processor.getWebinarAttendanceComponent();
         processor.getWebinars();            
        processor.getOpportunities();  
            
        processor.preprocess();         
        Test.stopTest();
        list<Attachment> testattachment = [Select id,name from attachment where name =  'Processor Records'];
        System.assertequals(1, testattachment.size());
        list<webinar_attendance__c> testwebinarattend = [Select id from Webinar_attendance__c where Webinar_Id__c = '257867952x' ];
        System.assertequals(5, testwebinarattend.size());
    }
 
     static testmethod void unitTest2() {
        Webinar__c webinar = new Webinar__c();
        webinar.name = 'test webinar';
        webinar.Webinar_Id__c = '257867952x';
        webinar.Event_Date_Time__c = datetime.parse('2/2/2015 11:56 AM'); 
        webinar.Webinar_Type__c = 'CE Classes';
        webinar.PrimaryPresenter__c = 'Josh Martinez';
        webinar.Promotion__c = 'test';
        webinar.People_at_Price__c = 55;
        webinar.Price_Presented__c = 3000;
        webinar.Attentive_Rate_at_Close__c = 27;
        webinar.Actual_Start_Time__c =datetime.parse('2/2/2015 11:56 AM');
        webinar.Time_at_Close__c = datetime.parse('2/2/2015 3:27 PM');
        webinar.Actual_Duration__c = 271;
        webinar.StampType__c = 'CE Classes';
        Database.insert(webinar);
        
       Map<String, ID> acctrectypemap = recTypeID();
        
       
       Account testaccount = new Account();
       testaccount.FirstName = 'Ade';
       testaccount.LastName = 'Adetoks';
       testaccount.PersonEmail = 'charlesafonzo@yahoo.co.uk';
       testaccount.Alternate_Email__c = 'charlesafonzo@yahoo.co.uk';
       testaccount.RecordTypeID = acctrectypemap.get('Person Account');
        insert testaccount;
        
        Account retrievedacct = [Select id, PersonContactID, Firstname, LastName, OwnerID from Account where id =: testaccount.id];
       
        User testuser = [select id, name from User where name ='Next Step Financial Holdings'];
       
        Task testtask = new Task();
        testtask.WhoID = retrievedacct.PersonContactid;
        testtask.Priority = 'Normal';
        testtask.OwnerID = testuser.id;
        testtask.Status = 'Complete';   
        testtask.Activity_Type__c = 'Webinar Attendance';             
        testtask.Event_Date_Time__c = datetime.parse('2/2/2015 11:56 AM');
        testtask.Webinar_Discount_Offer_Percent__c = .20;
        testtask.Webinar_Presenter__c = 'Josh Martinez';
        testtask.Join_Time__c = '2/2/2015 11:56 AM';
        testtask.Duration__c = 271;
        testtask.Attended__c = true;
        testtask.Event_Name__c = 'test webinar';
        testtask.Webinar_Type__c = 'CE Classes';
        Database.insert(testtask);
        
        String mockCSV = 'test webinar",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Report Generated:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += '2/2/15 3:30 PM EST,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Webinar ID,Actual Start Date/Time,Duration,# Registered,# Attended,Clicked Registration Link,Opened Invitation,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += '257867952x,2/2/15 11:56 AM EST,3 hours 31 minutes,960,430,14,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Attendee Details,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Attended,Interest Rating,Last Name,First Name,Email Address,Registration Date/Time,Join Time,Leave Time,Time in Session,Phone,Unsubscribed,Webinar Question 1,Webinar Response 1,Webinar Question 2,Webinar Response 2,Webinar Question 3,Webinar Response 3,Webinar Question 4,Webinar Response 4,Webinar Question 5,Webinar Response 5,Webinar Question 6,Webinar Response 6,Webinar Question 7,Webinar Response 7,Webinar Question 8,Webinar Response 8,Webinar Question 9,Webinar Response 9,Webinar Question 10,Webinar Response 10,Webinar Question 11,Webinar Response 11,Webinar Question 12,Webinar Response 12,Webinar Question 13,Webinar Response 13,Webinar Question 14,Webinar Response 14,Webinar Question 15,Webinar Response 15,Webinar Question 16,Webinar Response 16,Webinar Question 17,Webinar Response 17,Webinar Question 18,Webinar Response 18,Webinar Question 19,Webinar Response 19,Webinar Question 20,Webinar Response 20,Webinar Question 21,Webinar Response 21,Webinar Question 22,Webinar Response 22,Webinar Question 23,Webinar Response 23,Webinar Question 24,Webinar Response 24,Webinar Question 25,Webinar Response 25,Webinar Question 26,Webinar Response 26,Webinar Question 27,Webinar Response 27,Webinar Question 28,Webinar Response 28,\n';
        mockCSV += 'Yes,56,Aboushakka,Tarek,tarektrade@icloud.com,2/2/15 1:05 PM EST,2/2/15 1:07 PM EST,2/2/15 1:57 PM EST,50 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,31,Abraham,Temu,abraham.temu@t3tradinggroup.com,2/2/15 11:18 AM EST,2/2/15 1:44 PM EST,2/2/15 2:24 PM EST,39 minutes,9179546091,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,60,Ade,Adetoks,charlesafonzo@yahoo.co.uk,2/2/15 1:50 PM EST,2/2/15 1:52 PM EST,2/2/15 3:23 PM EST,3 hours 2 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,55,Adu,Ennada,ennadaadu@gmail.com,2/2/15 11:23 AM EST,2/2/15 12:47 PM EST,2/2/15 3:15 PM EST,2 hours 27 minutes,17047654321,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n';
        mockCSV += 'Yes,47,Ali,Hassan,hassan_ali757@hotmail.com,2/2/15 1:03 PM EST,2/2/15 1:04 PM EST,2/2/15 1:39 PM EST,5 minutes,,No,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n'; 
        Test.startTest();
        
        ProcessorController processorcontr = new ProcessorController();
        processorcontr.loadProcessorHomePage();
        processorcontr.getProcessors();
        processorcontr.getTableSizeOptions();
        processorcontr.getPromotions();
        processorcontr.getPreviewOptions();
        processorcontr.setProcessorRecordsetController();
        processorcontr.selectedProcessor ='17';
        processorcontr.loadProcessorDataPage();         

        processorcontr.loadProcessorVerifyWebinarPage();     
        processorcontr.loadProcessorSettingsPage(); 
        processorcontr.loadProcessorPreviewPage(); 
        processorcontr.loadProcessorResults();
        //test individual items
        CTRProcessor processor = new CTRProcessor();    
         processor.configure();
         processor.parseData(mockCSV);
         processor.updateWebinar();
         processor.run();
         processor.getOpportunities();
         processor.getWebinarAttendanceComponent();
         processor.getWebinars();            
        processor.getOpportunities();  
            
        processor.preprocess();         
        Test.stopTest();
        list<Attachment> testattachment = [Select id,name from attachment where name =  'Processor Records'];
        System.assertequals(1, testattachment.size());
        list<webinar_attendance__c> testwebinarattend = [Select id from Webinar_attendance__c where Webinar_Id__c = '257867952x' ];
        System.assertequals(5, testwebinarattend.size());
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