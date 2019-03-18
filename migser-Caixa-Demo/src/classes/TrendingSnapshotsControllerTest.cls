@isTest
private class TrendingSnapshotsControllerTest {
    
    @istest
    static void testTrendingSnapshotsController() {
        
        //Create Test Data
        List<Data_Extract__c> dataExtracts = new List<Data_Extract__c>();
        
        Data_Extract__c soqlDataExtract = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 
                                                                                                             'SOQLDataExtract', '1', 'Overwrite', '',
                                                                                                             '', 'Monthly', '', '1:00 AM', 'SOQL',
                                                                                                             Datetime.now(), false);
        
        dataExtracts.add(soqlDataExtract);
        
        Data_Extract__c oDataDataExtract = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 
                                                                                                              'oDataDataExtract', '1', 'Overwrite', '',
                                                                                                              '', 'Monthly', '', '1:00 AM', 'oData',
                                                                                                              Datetime.now(), false);
        
        oDataDataExtract.oData_Object__c = 'Invoice';
        oDataDataExtract.oData_URL__c = 'http://services.odata.org/V4/Northwind/Northwind.svc/';
        dataExtracts.add(oDataDataExtract);
        
        Data_Extract__c reportDataExtract = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 
                                                                                                               'ReportDataExtract', '1', 'Overwrite', '',
                                                                                                               '', 'Monthly', '', '1:00 AM', 'Report',
                                                                                                               Datetime.now(), false);
        
        dataExtracts.add(reportDataExtract);
        
        Data_Extract__c reportDataExtract1 = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 
                                                                                                                'ReportDataExtract', '1', 'Overwrite', '',
                                                                                                                '', 'Monthly', '', '1:00 AM', 'Report',
                                                                                                                Datetime.now(), false);
        
        dataExtracts.add(reportDataExtract1);
        
        Data_Extract__c reportDataExtract2 = TrendingSnapshotsControllerTestUtility.createDataExtract(true, 
                                                                                                                'ReportDataExtract', '1', 'Overwrite', '',
                                                                                                                '', 'Monthly', '', '1:00 AM', 'Report',
                                                                                                                Datetime.now(), false);
        
        dataExtracts.add(reportDataExtract2);
        
        insert dataExtracts;
        
        //Set DataExtractTool page
        PageReference pageRef = Page.TrendingSnapshots;
        Test.setCurrentPage(pageRef);
        
        //Initialize DataExtractToolController
        TrendingSnapshotsController controller = new TrendingSnapshotsController();
        String orgURL = controller.orgURL;
        orgURL = 'https://c.gus.visual.force.com';
        
        System.assertNotEquals(null, TrendingSnapshotsController.getDataExtract('All', orgURL));
        System.assertNotEquals(null, TrendingSnapshotsController.getDataExtract('SOQL', orgURL));        
        System.assertNotEquals(null, TrendingSnapshotsController.getDataExtract('Report', orgURL));
        System.assertNotEquals(null, TrendingSnapshotsController.getDataExtract('oData', orgURL));
        System.assertNotEquals(null, TrendingSnapshotsController.scheduledBatch('12:00 AM', 'Daily', null, dataExtracts.get(0).Id, dataExtracts.get(0).Id));
        
        System.assert(TrendingSnapshotsController.disableExtract(dataExtracts.get(0).Id));         
        System.assertNotEquals(null, TrendingSnapshotsController.scheduledBatch('1:00 PM', 'Monthly', '31', dataExtracts.get(1).Id, dataExtracts.get(1).Id));
        
        System.assert(TrendingSnapshotsController.disableExtract(dataExtracts.get(1).Id));
        System.assertNotEquals(null, TrendingSnapshotsController.scheduledBatch('1:00 PM', 'Monthly', '1', dataExtracts.get(4).Id, dataExtracts.get(4).Id));
        
        System.assert(TrendingSnapshotsController.disableExtract(dataExtracts.get(4).Id));
        System.assertNotEquals(null, TrendingSnapshotsController.scheduledBatch('12:00 PM', 'Weekly', 'MON', dataExtracts.get(2).Id, dataExtracts.get(2).Id));
        
        System.assert(TrendingSnapshotsController.disableExtract(dataExtracts.get(2).Id));
        System.assertNotEquals(null, TrendingSnapshotsController.deleteExtract(dataExtracts.get(3).Id));
        System.assertNotEquals(null, TrendingSnapshotsController.getAllDataExtract(orgURL));
        System.assertNotEquals(null, TrendingSnapshotsController.getReportList(orgURL));
        System.assertEquals(null, TrendingSnapshotsController.addValuesTooDataObjectList(null));
        System.assertNotEquals(null, TrendingSnapshotsController.addValuesTooDataObjectList(orgURL));
        System.assertNotEquals(null, TrendingSnapshotsController.getSOQLRowResponse('SELECT Type__c, Last_Run__c, Id, CreatedBy.Name FROM Data_Extract__c limit 10', orgURL));
        
        TrendingSnapshotsMockSOQLResponse.isJson = true;
        System.assertNotEquals(null, TrendingSnapshotsController.getoData('http://services.odata.org/V4/Northwind/Northwind.svc/', 'Invoice'));
        
        TrendingSnapshotsMockSOQLResponse.isJson = false;
        System.assertNotEquals(null, TrendingSnapshotsController.getoData('http://services.odata.org/V4/Northwind/Northwind.svc/', 'Invoice'));
        System.assertNotEquals(null, TrendingSnapshotsController.getExternalObjectMetaData('Invoice', 'http://services.odata.org/V4/Northwind/Northwind.svc/', 'Invoice'));
        System.assertNotEquals(null, TrendingSnapshotsController.getReportRowResponse('TestId', orgURL));
        
        System.assertNotEquals(null, TrendingSnapshotsController.saveDataExtract('SELECT Type__c, Last_Run__c, Id FROM Data_Extract__c limit 10', 'Test',
                                                                                 'Test', 'Daily', '1', 'Owerwrite', '1:00 PM', 'TestReport', 'TestId', 'TestURL', 'Test', 'Test', 'Report', dataExtracts.get(2).Id));
        
        System.assertNotEquals(null, TrendingSnapshotsController.saveDataExtract('SELECT Type__c, Last_Run__c, Id FROM Data_Extract__c limit 10', 'Test',
                                                                                 'Test', 'Daily', '1', 'Owerwrite', '1:00 PM', 'TestReport', 'TestId', 'TestURL', 'Test', 'Test', 'Report', null));
        
        System.assertNotEquals(null, TrendingSnapshotsController.saveDataExtract('SELECT Type__c, Last_Run__c, Id FROM Data_Extract__c limit 10', 'Test',
                                                                                 'Test', 'Daily', '1', 'Owerwrite', '1:00 PM', 'TestReport', 'TestId', 'TestURL', 'Test', 'Test', 'SOQL', dataExtracts.get(2).Id));
        
        System.assertNotEquals(null, TrendingSnapshotsController.saveDataExtract('SELECT Type__c, Last_Run__c, Id FROM Data_Extract__c limit 10', 'Test',
                                                                                 'Test', 'Daily', '1', 'Owerwrite', '1:00 PM', 'TestReport', 'TestId', 'TestURL', 'Test', 'Test', 'oData', dataExtracts.get(2).Id));
        
        System.assertEquals(null, TrendingSnapshotsController.testQuery(null, orgURL));
        System.assertEquals(null, TrendingSnapshotsController.testQuery('SELECT Type__c, Last_Run__c, Id, (SELECT ID FROM Account) FROM Data_Extract__c limit 10', orgURL));
        System.assertEquals(null, TrendingSnapshotsController.testQuery('SELECT Type__c, Last_Run__c, Id, CreatedBy.Name FROM Data_Extract__c limit 10', orgURL));

        System.assertNotEquals(null, TrendingSnapshotsController.testReportQuery('Test', orgURL));        
        System.assertNotEquals(null, TrendingSnapshotsController.getSelectedDataExtract(dataExtracts.get(2).Id));
        System.assertNotEquals(null, TrendingSnapshotsController.validateDataExtract(null, null, null, null, null, null, true));
        System.assertNotEquals(null, TrendingSnapshotsController.validateDataExtract('1test_test', null, null, null, null, null, true));
        System.assertNotEquals(null, TrendingSnapshotsController.validateDataExtract('testtest', null, null, null, null, null, true));
        System.assertNotEquals(null, TrendingSnapshotsController.validateDataExtract('testtest', 'metadataName', null, null, null, null, true));
        System.assertNotEquals(null, TrendingSnapshotsController.validateDataExtract('testtest', 'metadataName', 'Overwrite', null, null, null, true));
        System.assertNotEquals(null, TrendingSnapshotsController.validateDataExtract('testtest', 'metadataName', 'Overwrite', 'Daily', null, null, true));
        System.assertNotEquals(null, TrendingSnapshotsController.validateDataExtract('testtest', 'metadataName', 'Overwrite', 'Monthly', '1:00 PM', null, true));
        System.assertEquals(null, TrendingSnapshotsController.validateDataExtract('testtest', 'metadataName', 'Overwrite', 'Monthly', '1:00 PM', '1', true));
        
        try {
            System.assert(TrendingSnapshotsController.getSobjectList().size() != 0);  
        } catch(Exception e) {
        }
        
        try {
            System.assert(TrendingSnapshotsController.getSobjectDetail('Account').size() != 0);   
        } catch(Exception e) {
        }
        
        System.assert(TrendingSnapshotsController.generateMetaData('Account', new List<String>(), 'gs0').length() > 0);
    }
}