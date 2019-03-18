/*
This test class will be used to test the following classes
WebcartScheduled
WebcartHelper
*/
@isTest
private class Test_Webcart {
    
    @isTest static void testWebcartScheduled(){
        WebcartHelper.addWebCartCustomSetting();
        WebcartHelper.addPricebookEntries();
        Test.startTest();
        String jobId = System.schedule('WebcartScheduled', '0 0 0 3 9 ? 2052', 
                new WebcartScheduled());
        Test.stopTest(); 
    }

    @isTest static void testWebcartScheduledDeclines(){
        WebcartHelper.addWebCartCustomSetting();
        WebcartHelper.addPricebookEntries();
        Test.startTest();
        String jobId = System.schedule('WebcartScheduled', '0 0 0 3 9 ? 2052', 
                new WebcartScheduledDeclines());
        Test.stopTest(); 
    }

    @isTest static void testWebcartBatch(){
        WebcartHelper.addWebCartCustomSetting();
        WebcartHelper.addPricebookEntries();
        Test.startTest();
        WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_PAYMENTS);
        database.executebatch(b, 1);
        Test.stopTest();
        list<Webcart_Payment__c> wpList = new list<Webcart_Payment__c>();
        wpList = [Select ID from Webcart_Payment__c];
        system.assertNotEquals(0, wpList.size());
    }

    @isTest static void testWebcartBatchDeclines(){
        WebcartHelper.addWebCartCustomSetting();
        WebcartHelper.addPricebookEntries();
        Account a = new Account();
        //a.Name = 'Test Account XYZ 1234X';
        a.LastName = 'Test Last';
        a.FirstName = 'Test First';
        a.Personemail = 'test@test.com';
        RecordType personAccountRecordType =  [SELECT Id 
                                                    FROM RecordType 
                                                    WHERE Name = 'Person Account' and SObjectType = 'Account'];
        a.RecordTypeID = personAccountRecordType.ID;
        insert a;
        Test.startTest();
        WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_DECLINES);
        database.executebatch(b, 1);
        Test.stopTest();
        //list<Webcart_Payment__c> wpList = new list<Webcart_Payment__c>();
        //wpList = [Select ID from Webcart_Payment__c];
        //system.assertNotEquals(0, wpList.size());
    }

    @isTest static void testWebcartHelper_getWebCartBatchSize(){
        integer testMe;

        testMe = WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartPassword(){
        string testMe;

        testMe = WebcartHelper.getWebCartPassword(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartPassword(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartUsername(){
        string testMe;

        testMe = WebcartHelper.getWebCartUsername(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartUsername(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartRedirectURI(){
        string testMe;

        testMe = WebcartHelper.getWebCartRedirectURI(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartRedirectURI(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartClientID(){
        string testMe;

        testMe = WebcartHelper.getWebCartClientID(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartClientID(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartClientSecret(){
        string testMe;

        testMe = WebcartHelper.getWebCartClientSecret(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartClientSecret(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartAuthorizationCode(){
        string testMe;

        testMe = WebcartHelper.getWebCartAuthorizationCode(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartAuthorizationCode(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartAccessToken(){
        string testMe;

        testMe = WebcartHelper.getWebCartAccessToken(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartAccessToken(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartRefreshToken(){
        string testMe;

        testMe = WebcartHelper.getWebCartRefreshToken(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartRefreshToken(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartPaymentsReportNumber(){
        string testMe;

        testMe = WebcartHelper.getWebCartPaymentsReportNumber(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartPaymentsReportNumber(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartPaymentsReportUserID(){
        string testMe;

        testMe = WebcartHelper.getWebCartPaymentsReportUserID(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartPaymentsReportUserID(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartDeclinesReportNumber(){
        string testMe;

        testMe = WebcartHelper.getWebCartDeclinesReportNumber(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartDeclinesReportNumber(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testWebcartHelper_getWebCartDeclinesReportUserID(){
        string testMe;

        testMe = WebcartHelper.getWebCartDeclinesReportUserID(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
        WebcartHelper.addWebCartCustomSetting();
        testMe = WebcartHelper.getWebCartDeclinesReportUserID(WebcartHelper.INFUSIONSOFT);
        system.assertNotEquals(null, testMe);
    }

    @isTest static void testaccessTokenItems(){
        WebcartHelper.accessTokenItems ati = new WebcartHelper.accessTokenItems();
        ati.valueToShow = 'testMe';
        ati.accessToken = '';
        ati.refreshToken = 'rt1';
        ati.expiresIn = 'e1';
        ati.scope = 'x';
        ati.bodyResponse = 'resp';
        ati.isError = false;

        ati = WebcartHelper.retrieveWebcartAccessToken('myCode', webcartHelper.INFUSIONSOFT);
        system.assertNotEquals(ati.accessToken, '');
        WebcartHelper.doAccessPointError = true;
        ati.accessToken = '';
        ati = WebcartHelper.retrieveWebcartAccessToken('myCode', webcartHelper.INFUSIONSOFT);
        system.assertEquals(ati.accessToken, null);
        system.assertNotEquals(ati.valuetoShow, '');
    }

    @isTest static void testaccessTokenItemsviaRefresh(){
        WebcartHelper.accessTokenItems ati = new WebcartHelper.accessTokenItems();
        ati = WebcartHelper.retrieveWebcartAccessTokenViaRefreshToken(webcartHelper.INFUSIONSOFT);
        system.assertNotEquals(ati.accessToken, '');
        WebcartHelper.doAccessPointError = true;
        ati.accessToken = '';
        ati = WebcartHelper.retrieveWebcartAccessTokenViaRefreshToken(webcartHelper.INFUSIONSOFT);
        system.assertEquals(ati.accessToken, null);
        system.assertNotEquals(ati.valuetoShow, '');
    }

    @isTest static void testgetXMLRoutines(){
        string testXML = '';
        testXML = WebcartHelper.getPaymentXMLRequest('apiKey');
        system.assertNotEquals(testXML, '');
        testXML = WebcartHelper.getSavedFilterXMLRequest('apiKey');
        system.assertNotEquals(testXML, '');
        testXML = WebcartHelper.getDeclinesXMLRequest('apiKey', webcartHelper.INFUSIONSOFT, '0');
        system.assertNotEquals(testXML, '');
        testXML = WebcartHelper.getAllReportColumns('apiKey', '148', '1');
        system.assertNotEquals(testXML, '');
        testXML = WebcartHelper.getInvoiceXMLRequest('apiKey');
        system.assertNotEquals(testXML, '');
        testXML = WebcartHelper.getExampleSavedFilterXMLResult();
        system.assertNotEquals(testXML, '');
        testXML = WebcartHelper.getExamplePaymentXMLResult2();
        system.assertNotEquals(testXML, '');
        testXML = WebcartHelper.getExampleInvoiceXMLResult();
        system.assertNotEquals(testXML, '');
    }


    @isTest static void testretrieveListBySplit(){
        list<string> testList;
        testList = WebcartHelper.retrieveListBySplit('', '');
        system.assertEquals(testList.size(), 0);
        testList = WebcartHelper.retrieveListBySplit('', '', '');
        system.assertEquals(testList.size(), 0);
    }
/*
    @isTest static void testinsertForEmail(){
        WebcartHelper.insertForEmail('body', 'subject', 'email1@email.com', 'email2@email.com');
        list<Email_Request__c> erList = [Select ID From Email_Request__c];
        system.assertNotEquals(0, erlist.size());
    }
*/  
    @isTest static void testWebcartController(){
        WebcartController wc = new WebcartController();
        PageReference pr;
        pr = wc.doAPICall();
        system.assertEquals(pr, null);
        pr = wc.oAuthGo();
        system.assertNotEquals(pr, null);
        pr = wc.startAction();
        system.assertEquals(pr, null);
        string testXML = WebcartHelper.getExamplePaymentXMLResult();
        testXML = wc.showPaymentItemsFromMaps(testXML);
        system.assertNotEquals('', testXML);

    }

    @isTest static void testWebcartControllerWithCode(){
        PageReference c1Page;
        c1Page = new PageReference('/apex/WebcartIntegration'); 
        c1Page.getParameters().put('code', 'myCode');
        test.setCurrentPage(c1Page);
        //Must set the controller after setCurrentPage if a Query String Parameter is grabbed in the constructor
        WebcartController wc = new WebcartController();
        PageReference pr;
        pr = wc.startAction();
        system.assertEquals(pr, null);
        WebcartHelper.addWebCartCustomSetting();
        pr = wc.startAction();
        system.assertEquals(pr, null); 
    }

    @isTest static void testcreateBatchList(){
        list<integer> intList = new list<integer>();
        intList = webcartHelper.createBatchList(0);
        for(integer i : intList){
            system.assert(i >= 0 && i <= 9); 
        }
        intList = webcartHelper.createBatchList(1);
        for(integer i : intList){
            system.assert(i >= 10 && i <= 19);
        }
        intList = webcartHelper.createBatchList(2);
        for(integer i : intList){
            system.assert(i >= 20 && i <= 29);
        }
    }

    @isTest static void testConvertWebCartStringToDate(){
        date dateTemp = webcartHelper.convertWebCartStringToDate('20150302T09:43:07');
        system.assertEquals(dateTemp.day(), 2);
        system.assertEquals(dateTemp.month(), 3);
        system.assertEquals(dateTemp.year(), 2015);
    }
    
    @isTest static void testconvertWebCartStringToDateTime(){
        DateTime dtValue;
        dtValue = WebcartHelper.convertWebCartStringToDateTime('20150301T14:20:18');
        system.assertNotEquals(dtValue, null);
        system.assertEquals(dtValue.year(), 2015);
        system.assertEquals(dtValue.month(), 3);        

    }

    @isTest static void testWebcartBatchBadInput(){
        Test.startTest();
        WebcartBatchProcess b = new WebcartBatchProcess('Bad Option');
        database.executebatch(b, 1);
        Test.stopTest();
    }

    @isTest static void testWebcartBatchProcessingKickOffDecline(){
        WebcartHelper.addWebCartCustomSetting();
        WebcartHelper.addPricebookEntries();
        Test.startTest();
        WebcartBatchProcess b = new WebcartBatchProcess(WebcartHelper.TBL_SAVED_PAYMENTS);
        b.startDeclineJob = true;
        database.executebatch(b, 1);
        Test.stopTest();
        list<Webcart_Payment__c> wpList = new list<Webcart_Payment__c>();
        wpList = [Select ID from Webcart_Payment__c];
        system.assertEquals(0, wpList.size());
    }

    @isTest static void testsetWebCartProcessingValues(){
        Webcart_Payment__c wpItem = new Webcart_Payment__c ();
        WebcartBatchProcess b = new WebcartBatchProcess('Bad Option');
        wpItem = b.setWebCartProcessingValues('My Error', true, wpItem);
        system.assertEquals(wpItem.Processing_Error__c, 'My Error');
    }

    @isTest static void testWebcartBatchProcessingUpdateOpp(){
        WebcartHelper.addWebCartCustomSetting();
        WebcartHelper.addPricebookEntries();
		WebcartHelper.addOppRecTypeCustomSetting();

        
        
        Account a = new Account();
        //a.Name = 'Test Account XYZ 1234X';
        a.LastName = 'Test Last';
        a.FirstName = 'Test First';
        a.Personemail = 'test@test.com'; //This must match the email address in 
        RecordType personAccountRecordType =  [SELECT Id 
                                                    FROM RecordType 
                                                    WHERE Name = 'Person Account' and SObjectType = 'Account'];
        a.RecordTypeID = personAccountRecordType.ID;
        insert a;

        Opportunity o = new Opportunity();
        o.Name = 'xx';
        o.Pricebook2ID = webCartHelper.test_pricebookID;
        o.AccountID = a.ID;
        o.RecordTypeId = '012600000005Cwx';
        o.Product__c = WebcartHelper.test_prod.Product_List__c;
        o.Stagename = 'Pending Charge';
        o.CloseDate = date.Today();
        o.Sub_Stage__c = 'Paid';
        o.LeadSource = 'CC-Motley';
        //o.Sale_Down_Payment_1_of_4_DESIRED__c = 500;
        //o.Sale_Down_Payment_1_of_4_Date__c = Date.today().addDays(1);
        o.Sale_Invoice_Qty_Payments_After_Down__c = 1;
        o.Sale_Invoice_First_Date_After_Down__c = Date.today().addDays(30);
        o.Subscription_Next_Scheduled_Amount__c = 147;
        o.Subscription_Next_Scheduled_Quantity__c = 1;
        o.UTP_Webinar_Presenter_when_Closed_Won__c = '';
        o.ContEd_Web_Presenter_when_Closed_Won__c = '';
        o.AOD_Free_Trial_Active__c = false;
        o.Charting_Package__c = '1 month';
        o.Charting_Start__c = o.CloseDate;
        //Sale_Down_Payment_1_of_4_DESIRED__c > Sale_TOTAL_Amount_To_Be_Invoiced__c , 
           //Sale_TOTAL_Down_Payment__c + Sale_TOTAL_Invoices_After_Down_Payment__c
                //(Sale_Invoice_Qty_Payments_After_Down__c, Sale_Invoice_Amount_Due_Per__c(Sale_Invoice_Qty_Payments_After_Down__c ) )
        //Sale_TOTAL_Invoices_After_Down_Payment__c > Sale_TOTAL_Amount_To_Be_Invoiced__c
        insert o;

        o.Stagename = 'Closed Won';
        update o;

        WebcartBatch b2 = new WebcartBatch(0, WebcartHelper.TBL_SAVED_DECLINES);
        list<integer> scope = new list<integer>();
        scope.add(0);
        b2.doWorkDeclines(scope);
        //string xmlDecline = WebcartHelper.getExampleDeclineXMLResult();
        Test.startTest();
        system.debug('Before Batch Process Declines');
        WebcartBatchProcess b = new WebcartBatchProcess(WebcartHelper.TBL_SAVED_DECLINES);
        database.executebatch(b, 1);
        Test.stopTest();
        list<Webcart_Decline__c> wpList = new list<Webcart_Decline__c>();
        wpList = [Select ID, Opportunity__c from Webcart_Decline__c];
        system.assertEquals(1, wpList.size());
        system.assertNotEquals(null, wpList[0].Opportunity__c);
    }

	@isTest static void testXmlToKeyValues() {
		Test.startTest();
		Webcart_Payment__c wp = new Webcart_Payment__c();
		wp.Payment_XML__c = '<member><name>Id</name><value><i4>72332</i4></value></member><member><name>ContactId</name><value><i4>31740</i4></value></member><member><name>Company</name><value></value></member><member><name>FirstName</name><value>John</value></member><member><name>LastName</name><value>Doe</value></member><member><name>FullName</name><value>John Doe</value></member><member><name>Phone</name><value></value></member><member><name>BatchEmailAddress</name><value>jdoe@test.com</value></member><member><name>AddressType</name><value></value></member><member><name>Address2Street1</name><value>123 Main Street</value></member><member><name>Address2Street2</name><value></value></member><member><name>City2</name><value>New York</value></member><member><name>State2</name><value>NY</value></member><member><name>PostalCode2</name><value>10012</value></member><member><name>Country2</name><value>United States</value></member><member><name>ReferralPartner</name><value>BE Webinars </value></member><member><name>ReferralPartnerId</name><value>28</value></member><member><name>PromoCode</name><value></value></member><member><name>ProductIds</name><value>374</value></member><member><name>SaleTotal</name><value><double>399</double></value></member><member><name>PayType</name><value>Credit Card</value></member><member><name>DateSent</name><value></value></member><member><name>Date</name><value><dateTime.iso8601>20160219T14:02:37</dateTime.iso8601></value></member><member><name>PaymentId</name><value>12345</value></member><member><name>PayAmt</name><value><double>399</double></value></member><member><name>Country</name><value>United States</value></member>';
		List<Webcart_Payment__c> wcList = new List<Webcart_Payment__c>();
		wcList.add(wp);
		WebcartHelper.xmlBodyToKeyValuePairs(wcList);
		test.stopTest();
		System.assert(!String.isBlank(wp.Webcart_Keys_and_Values__c));
	}
}