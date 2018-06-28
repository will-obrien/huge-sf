@isTest
private class UploadTrendingSnapshotsBatchTest {
    
    //Test Method to test SOQL DataSet Upload Batch
    static testMethod void testSOQLDatasetBatch() {
        
        String query = 'SELECT Type__c, Timestamp__c, Id, Name, CreatedBy.Manager.Name, CreatedBy.Name FROM Data_Extract__c LIMIT 10';
        
        Data_Extract__c soqlDataExtract = TrendingSnapshotsControllerTestUtility.createDataExtract(true, '"SOQL \nData Extract"', '1', 'Overwrite', '',
                                                                                                             '', 'Monthly', query, '1:00 AM', 'SOQL', Datetime.now(), false);
        
        //set dummy metadata JSON
        soqlDataExtract.Metadata__c = TrendingSnapshotsMockSOQLResponse.getDummyMedataJSON();   
        
        insert soqlDataExtract;
        
        Test.StartTest();
        
        //Create a System Admininstrator User
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User testUser = new User(Alias = 'detest', Email='test@extract.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = adminProfile.Id,
                                 TimeZoneSidKey='America/Chicago', UserName='test345@tesExtractData.com');
        insert testUser;
        System.runAs(testUser) {
            
            ScheduleTrendingSnapshotsBatch sh1 = new ScheduleTrendingSnapshotsBatch();
            String sch = '0 0 23 * * ?'; 
            String jobId = system.schedule('SOQL Data Extract', sch, sh1);
            System.assertNotEquals(null, jobId);
        }
        
        Test.stopTest();
    }
    
    //Test Method to test Report DataSet Upload Batch
    static testMethod void testReportDatasetBatch() {
        
        Data_Extract__c reportDataExtract = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 'Report Data Extract', '1', 'Overwrite', Id.valueOf('001000000000000'),
                                                                                                               '', 'Monthly', '', '1:00 AM', 'Report', Datetime.now(), false);
        
        //set dummy metadata JSON
        reportDataExtract.Metadata__c = TrendingSnapshotsMockSOQLResponse.getDummyMedataJSON();   
        
        insert reportDataExtract;
        
        Test.StartTest();
        
        //Create a System Admininstrator User
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User testUser = new User(Alias = 'detest1', Email='test1@extract.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = adminProfile.Id,
                                 TimeZoneSidKey='America/Chicago', UserName='test3145@tesExtractData.com');
        insert testUser;
        System.runAs(testUser){
            
            ScheduleTrendingSnapshotsBatch sh1 = new ScheduleTrendingSnapshotsBatch();
            String sch = '0 0 23 * * ?'; 
            String jobId = system.schedule('Report Data Extract', sch, sh1);
            System.assertNotEquals(null, jobId);
        }
        
        Test.stopTest();
    }
    
    //Test Method to test JSON oData DataSet Upload Batch
    static testMethod void testJSONoDataDatasetBatch() {
        
        Data_Extract__c oDataDataExtract = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 'oData Data Extract', '1', 'Overwrite', null,
                                                                                                              '', 'Monthly', '', '1:00 AM', 'oData', Datetime.now(), false);
        
        //set dummy metadata JSON
        oDataDataExtract.Metadata__c = TrendingSnapshotsMockSOQLResponse.getDummyJSONoDataMedataJSON();  
        oDataDataExtract.oData_Object__c = 'Invoices';
        oDataDataExtract.oData_URL__c = 'http://services.odata.org/V4/Northwind/Northwind.svc/';
        
        insert oDataDataExtract;
        
        Test.StartTest();
        
        //Create a System Admininstrator User
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User testUser = new User(Alias = 'detest2', Email='test2@extract.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = adminProfile.Id,
                                 TimeZoneSidKey='America/Chicago', UserName='test3245@tesExtractData.com');
        insert testUser;
        System.runAs(testUser) {
            
            TrendingSnapshotsMockSOQLResponse.isJson = true;
            
            ScheduleTrendingSnapshotsBatch sh1 = new ScheduleTrendingSnapshotsBatch();
            String sch = '0 0 23 * * ?'; 
            String jobId = system.schedule('oData Data Extract', sch, sh1);
            System.assertNotEquals(null, jobId);
        }
        
        Test.stopTest();
    }
    
    //Test Method to test XML oData DataSet Upload Batch
    static testMethod void testXMLoDataDatasetBatch() {
        
        Data_Extract__c oDataDataExtract = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 'oData Data Extract', '1', 'Overwrite', null,
                                                                                                              '', 'Monthly', '', '1:00 AM', 'oData', Datetime.now(), false);
        
        //set dummy metadata JSON
        oDataDataExtract.Metadata__c = TrendingSnapshotsMockSOQLResponse.getDummyJSONoDataMedataJSON();  
        oDataDataExtract.oData_Object_href__c = 'Invoices';        
        oDataDataExtract.oData_Object__c = 'Invoices';
        oDataDataExtract.oData_URL__c = 'http://services.odata.org/V4/Northwind/Northwind.svc/';
        
        insert oDataDataExtract;
        
        Test.StartTest();
        
        //Create a System Admininstrator User
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User testUser = new User(Alias = 'detest2', Email='test2@extract.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = adminProfile.Id,
                                 TimeZoneSidKey='America/Chicago', UserName='test3245@tesExtractData.com');
        insert testUser;
        System.runAs(testUser) {
            
            TrendingSnapshotsMockSOQLResponse.isJson = false;
            
            ScheduleTrendingSnapshotsBatch sh1 = new ScheduleTrendingSnapshotsBatch();
            String sch = '0 0 23 * * ?'; 
            String jobId = system.schedule('oData Data Extract', sch, sh1);
            System.assertNotEquals(null, jobId);
        }
        
        Test.stopTest();
    }
    
    static testMethod void testMisc() {
        UploadTrendingSnapshotsBatch batch = new UploadTrendingSnapshotsBatch('', '', '', 0, '', '', '');
        batch.getFieldValue(null, 'string');
        System.assert(UploadTrendingSnapshotsBatch.getFieldType(null) == 'String');
        
        TrendingSnapshotsMockSOQLResponse.getDummyObjectXMLoData();
        TrendingSnapshotsMockSOQLResponse.getDummyXMLoData();
        TrendingSnapshotsMockSOQLResponse.getReportJSON();
        TrendingSnapshotsMockSOQLResponse.getSOQLJSON();
        
        ScheduleTrendingSnapshotsBatch s = new ScheduleTrendingSnapshotsBatch();
        s.execute('12345678');
    }
}