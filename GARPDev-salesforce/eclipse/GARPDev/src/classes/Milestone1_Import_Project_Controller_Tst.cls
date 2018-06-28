@isTest
private class Milestone1_Import_Project_Controller_Tst {
    
    static testMethod void testImportController() {
        
        Document testDoc = new Document();
        testDoc.Name = 'EXPORT UNIT TEST XYZABC' + System.now();
        String body = '<?xml version="1.0"?><export><meta><exportPackage>Milestone1_Project_Export</exportPackage><exportAuthor>Admin+User</exportAuthor><exportOrganization>Force.com+Labs+PM</exportOrganization><exportCreateDate>2010-07-28+21%3A39%3A39</exportCreateDate><exportVersion>1.0</exportVersion></meta><Milestone1_Project__c><Id>a03A0000001PchPIAS</Id><Total_Expense_Estimate__c>1.00</Total_Expense_Estimate__c><Total_Expense_Budget__c>null</Total_Expense_Budget__c><Status__c>null</Status__c><Description__c>abc</Description__c><Description__c>null</Description__c><Milestone1_Milestone__c><Id>a02A0000002UR8YIAW</Id><Deadline__c>2010-07-29+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>15665.37</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>246.59</Hours_Budget__c><Milestone1_Milestone__c><Id>a02A0000002UR8aIAG</Id><Deadline__c>2010-07-25+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME3+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>32904.61</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>454.30</Hours_Budget__c><Name>UNIT+TEST+MILESTONE+NAME3+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Name>UNIT+TEST+MILESTONE+NAME+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Milestone1_Milestone__c><Id>a02A0000002UR8ZIAW</Id><Deadline__c>2010-08-03+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME2+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>823.57</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>352.72</Hours_Budget__c><Name>UNIT+TEST+MILESTONE+NAME2+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Name>UNIT_TEST_NAME_XYZABC</Name></Milestone1_Project__c></export>';
        testDoc.body = Blob.valueOf(body);
        
        List<Document> docs = new List<Document>{testDoc};
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        Milestone1_Import_Project_Controller testController = new Milestone1_Import_Project_Controller(ssc);
        testController.fileBody = testDoc.body;
        testController.fileName = 'UNIT TEST.XML';
        testController.docId = testDoc.Id;
        testController.importTemplateXML();
        
        System.assert(testController.project != null);
        System.assert(testController.project.Name == 'UNIT_TEST_NAME_XYZABC');
        System.assert(testController.project.Id != null);
        
    }
    
    static testMethod void testImportControllerNoFileException() {
        
        //List<Document> docs = [Select Id from Document];
        //delete docs;
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        Milestone1_Import_Project_Controller testController = new Milestone1_Import_Project_Controller(ssc);
        testController.fileBody = null;
        testController.fileName = null;
        testController.docId = null;
        try
        {
            testController.importTemplateXML();
        }catch(Exception e)
        {
            System.assert(testController.project == null);
            Boolean expectedExceptionThrown =  e.getMessage().contains(Milestone1_Import_Exception.ERROR_NO_FILE_SELECTED) ? true : false;
            System.assertEquals(expectedExceptionThrown,true);
        }   
    }
    
    static testMethod void testImportControllerInvalidXML() {
        
        Document testDoc = new Document();
        testDoc.Name = 'EXPORT UNIT TEST XYZABC' + System.now();
        String body = 'This is not an XML file';
        testDoc.body = Blob.valueOf(body);
        testDoc.FolderId = UserInfo.getUserId();
        insert testDoc;
        
        List<Document> docs = new List<Document>{testDoc};
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        Milestone1_Import_Project_Controller testController = new Milestone1_Import_Project_Controller(ssc);
        testController.fileBody = testDoc.body;
        testController.fileName = 'UNIT TEST.XML';
        testController.docId = testDoc.Id;
        testController.importTemplateXML();
        
        System.assert(testController.project == null);
    }
    
    static testMethod void testImportControllerValidFromDocsFolder() {
        
        Document testDoc = new Document();
        testDoc.Name = 'EXPORT UNIT TEST XYZABC' + System.now();
        String body = '<?xml version="1.0"?><export><meta><exportPackage>Milestone1_Project_Export</exportPackage><exportAuthor>Admin+User</exportAuthor><exportOrganization>Force.com+Labs+PM</exportOrganization><exportCreateDate>2010-07-28+21%3A39%3A39</exportCreateDate><exportVersion>1.0</exportVersion></meta><Milestone1_Project__c><Id>a03A0000001PchPIAS</Id><Total_Expense_Estimate__c>1.00</Total_Expense_Estimate__c><Total_Expense_Budget__c>null</Total_Expense_Budget__c><Status__c>null</Status__c><Description__c>abc</Description__c><Description__c>null</Description__c><Milestone1_Milestone__c><Id>a02A0000002UR8YIAW</Id><Deadline__c>2010-07-29+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>15665.37</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>246.59</Hours_Budget__c><Milestone1_Milestone__c><Id>a02A0000002UR8aIAG</Id><Deadline__c>2010-07-25+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME3+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>32904.61</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>454.30</Hours_Budget__c><Name>UNIT+TEST+MILESTONE+NAME3+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Name>UNIT+TEST+MILESTONE+NAME+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Milestone1_Milestone__c><Id>a02A0000002UR8ZIAW</Id><Deadline__c>2010-08-03+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME2+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>823.57</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>352.72</Hours_Budget__c><Name>UNIT+TEST+MILESTONE+NAME2+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Name>UNIT_TEST_NAME_XYZABC</Name></Milestone1_Project__c></export>';
        testDoc.body = Blob.valueOf(body);
        testDoc.FolderId = UserInfo.getUserId();
        insert testDoc;
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        Milestone1_Import_Project_Controller testController = new Milestone1_Import_Project_Controller(ssc);
        testController.docId = testDoc.Id;
        testController.importTemplateXML();
        
        System.assert(testController.project != null);
        System.assert(testController.project.Name == 'UNIT_TEST_NAME_XYZABC');
        System.assert(testController.project.Id != null);
        
    }
}