/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class LaunchFormControllerTest {

// NOTE: Need to use the @isTest(SeeAllData=true) annotation on some of the methods because LaunchFormController and Mock classes need access to custom settings

	/* Test setup methods are supported only with the default data isolation mode for a test class.
	* If the test class or a test method has access to organization data by using the @isTest(SeeAllData=true)
	* annotation, test setup methods aren’t supported in this class.
	@testSetup static void setupTestData() {
		// Create test records once and then access them in every test method in the test class
		
	}*/
	
    static testMethod void testActions() {
        // Test that all action radio buttons are available.
        LaunchFormController lfController = new LaunchFormController();
        List<SelectOption> options = new List<SelectOption>();
        options = lfController.getActions();
        for (SelectOption so : options) {
        	if (so.getValue() == 'New') {
        		System.assertEquals('New', so.getValue());
        		System.assertEquals('Create new form', so.getLabel());
        	}
        	else if (so.getValue() == 'Recent') {
        		System.assertEquals('Recent', so.getValue());
        		System.assertEquals('Open most recent form', so.getLabel());
        	}
        	else if (so.getValue() == 'Specific') {
        		System.assertEquals('Specific', so.getValue());
        		System.assertEquals('Open specific date form', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined Action');
        	}
        }
    }
    
    static testMethod void testFormTypes() {
        // Test that all form types are available in the drop-down list.
        LaunchFormController lfController = new LaunchFormController();
        List<SelectOption> options = new List<SelectOption>();
        options = lfController.getFormTypes();
        for (SelectOption so : options) {
        	if (so.getValue() == 'None') {
        		System.assertEquals('None', so.getValue());
        		System.assertEquals('--None--', so.getLabel());
        	}
        	else if (so.getValue() == 'JHA') {
        		System.assertEquals('JHA', so.getValue());
        		System.assertEquals('Job Hazardous Assessment form', so.getLabel());
        	}
        	else if (so.getValue() == 'Inspection') {
        		System.assertEquals('Inspection', so.getValue());
        		System.assertEquals('Inspection form', so.getLabel());
        	}
        	else if (so.getValue() == 'Operations') {
        		System.assertEquals('Operations', so.getValue());
        		System.assertEquals('Operations form', so.getLabel());
        	}
        	else if (so.getValue() == 'Warranty/Startup') {
        		System.assertEquals('Warranty/Startup', so.getValue());
        		System.assertEquals('Warranty/Start Up form', so.getLabel());
        	}
        	else if (so.getValue() == 'Other') {
        		System.assertEquals('Other', so.getValue());
        		System.assertEquals('Other form', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined Form Type');
        	}
        }
    }
    
    static testMethod void testLoginSalesPortal_NotForceDotComSite() {
    	// Test loginSalesPortal method where forceDotComSite is false.
    	// Verify it returns a null PageReference.
        LaunchFormController lfController = new LaunchFormController();
        lfController.forceDotComSite = false;
        PageReference pageRef = lfController.loginSalesPortal();
        System.assertEquals(null, pageRef);
    }
    
    @isTest(SeeAllData=true) static void testLoginSalesPortal_ForceDotComSite_ValidSessionId() {
    	// Test loginSalesPortal method where forceDotComSite is true.
    	// Verify it returns a null PageReference if the session id is valid.
        LaunchFormController lfController = new LaunchFormController();
        lfController.forceDotComSite = true;
        lfController.sessionId = '999999999';
        
        // Set mock callout class
		Test.setMock(HttpCalloutMock.class, new MockSessionIdValidHttpResponse());
		
		// Call method to test.
		// This will cause a fake response to be sent from the class that implements HttpCalloutMock.
        PageReference pageRef = lfController.loginSalesPortal();
        System.assertEquals(null, pageRef);
    }
    
    @isTest(SeeAllData=true) static void testLoginSalesPortal_ForceDotComSite_InvalidSessionId() {
    	// Test loginSalesPortal method where forceDotComSite is true.
    	// Verify it returns Sales Portal page url PageReference if the session id is invalid.
    	JHA_Form_App_Config_Settings__c salesPortalAuthUrl = JHA_Form_App_Config_Settings__c.getInstance('SALES_PORTAL_AUTH_URL');
    	String s1 = salesPortalAuthUrl.App_Config_Setting__c;
    	String s2 = URL.getSalesforceBaseUrl().toExternalForm();
    	String expectedURL = s1 + s2 + '/LaunchForm';
        LaunchFormController lfController = new LaunchFormController();
        lfController.forceDotComSite = true;
        lfController.sessionId = '999999999';
        
        // Set mock callout class
		Test.setMock(HttpCalloutMock.class, new MockSessionIdInvalidHttpResponse());
		
		// Call method to test.
		// This will cause a fake response to be sent from the class that implements HttpCalloutMock.
        PageReference pageRef = lfController.loginSalesPortal();
        String actualUrl = pageRef.getUrl().replace('%3A', ':').replace('%2F', '/');
        System.assertEquals(expectedURL, actualUrl);
    }
    
    @isTest(SeeAllData=true) static void testLoginSalesPortal_ForceDotComSite_NoSessionId() {
    	// Test loginSalesPortal method where forceDotComSite is true.
    	// Verify it returns Sales Portal page url PageReference if no session id is provided.
    	JHA_Form_App_Config_Settings__c salesPortalAuthUrl = JHA_Form_App_Config_Settings__c.getInstance('SALES_PORTAL_AUTH_URL');
    	String s1 = salesPortalAuthUrl.App_Config_Setting__c;
    	String s2 = URL.getSalesforceBaseUrl().toExternalForm();
    	String expectedURL = s1 + s2 + '/LaunchForm';
        LaunchFormController lfController = new LaunchFormController();
        lfController.forceDotComSite = true;
        lfController.sessionId = null;
        PageReference pageRef = lfController.loginSalesPortal();
        String actualUrl = pageRef.getUrl().replace('%3A', ':').replace('%2F', '/');
        System.assertEquals(expectedURL, actualUrl);
    }
    
    static testMethod void testSetdisableFieldFlags() {
    	// Test setdisableFieldFlags method with different values for action.
    	// Verify it sets the disable field flags appropriately based on the action.
        LaunchFormController lfController = new LaunchFormController();
        lfController.action = 'New';
        lfController.setdisableFieldFlags();
        System.assertEquals(null, lfController.jhaForm.Jobsite_Address__c);
        System.assertEquals(null, lfController.jhaForm.Date__c);
        System.assertEquals('', lfController.jobSiteAddress);
        System.assertEquals('', lfController.customerName);
        System.assertEquals(true, lfController.disableCustName);
        System.assertEquals(true, lfController.disableAddrId);
        System.assertEquals(true, lfController.disableDate);
        
        lfController.action = 'Recent';
        lfController.setdisableFieldFlags();
        System.assertEquals(null, lfController.jhaForm.Date__c);
        System.assertEquals(false, lfController.disableCustName);
        System.assertEquals(false, lfController.disableAddrId);
        System.assertEquals(true, lfController.disableDate);
        
        lfController.action = 'Specific';
        lfController.setdisableFieldFlags();
        System.assertEquals(null, lfController.jhaForm.Date__c);
        System.assertEquals(false, lfController.disableCustName);
        System.assertEquals(false, lfController.disableAddrId);
        System.assertEquals(false, lfController.disableDate);
    }
    
    static testMethod void testRetrieveAddressAndAccount_PositivePath() {
    	// Test retrieveAddressAndAccount happy (positive) path.
    	// Verify the correct address and account are retrieved.
    	
    	// First create Address, Account, and Account_Address records for the test
        LaunchFormController lfController = new LaunchFormController();
        Account acctTemp = null;
        Address__c addrTemp = null;
        Account_Address__c acctAddrJunctionObj = null;
        String jobSiteAddressTemp = null;
        
        addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        
        jobSiteAddressTemp = addrTemp.Address_Line_1__c + ' ' + addrTemp.Address_Line_2__c + ' ' + addrTemp.Address_Line_3__c + ' ' +
        	addrTemp.Address_Line_4__c + ' ' + addrTemp.City__c + ' ' + addrTemp.State_Province__c + ' ' + addrTemp.Postal_Code__c + ' ' +
        	addrTemp.Country__c;
        
        acctTemp = new Account();
        acctTemp.Name = 'Test Account Name';
        acctTemp.Physical_Address__c = addrTemp.Id;
        insert acctTemp;
        
        acctAddrJunctionObj = new Account_Address__c();
        acctAddrJunctionObj.Account__c = acctTemp.Id;
        acctAddrJunctionObj.Address__c = addrTemp.Id;
        acctAddrJunctionObj.Active__c = true;
        acctAddrJunctionObj.Physical__c = true;
        insert acctAddrJunctionObj;
        
        lfController.jhaForm.Jobsite_Address__c = addrTemp.Id;
        lfController.retrieveAddressAndAccount();
		System.assertEquals(acctTemp.Id, lfController.jhaForm.Customer_Name__c);
		System.assertEquals(acctTemp.Name, lfController.customerName);
		System.assertEquals(jobSiteAddressTemp, lfController.jobSiteAddress);
    }
    
    static testMethod void testRetrieveAddressAndAccount_NegativePath_NoAddressRecord() {
    	// Test retrieveAddressAndAccount exception (negative) path.
    	// Verify exception thrown if address record does not exist.
    	LaunchFormController lfController = new LaunchFormController();
    	lfController.jhaForm.Jobsite_Address__c = null;
    	lfController.retrieveAddressAndAccount();
    	System.assertEquals('Error: Address does not exist!', lfController.status);
    }
    
    static testMethod void testRetrieveAddressAndAccount_NegativePath_NoAccountAddressJunctionRecord() {
    	// Test retrieveAddressAndAccount exception (negative) path.
    	// Verify exception thrown if account/address junction record does not exist.
    	
    	// First create Address record for the test
    	LaunchFormController lfController = new LaunchFormController();
    	Address__c addrTemp = null;
    	
    	addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        
    	lfController.jhaForm.Jobsite_Address__c = addrTemp.Id;
    	lfController.retrieveAddressAndAccount();
    	System.assertEquals('Warning: No Account exists for this Address!', lfController.status);
    }
    
    static testMethod void testGet_ActionNew() {
    	// Test get method for action=New and different values for formType.
    	// Verify status and formURLName returned are valid and the method returns a null PageReference.
    	String s1 = URL.getSalesforceBaseUrl().toExternalForm();
    	LaunchFormController lfController = new LaunchFormController();
        lfController.action = 'New';
        lfController.formType = 'JHA';
        lfController.forceDotComSite = true;
        lfController.epriseLoginId = 'blowj1';
    	lfController.firstName = 'Joe';
    	lfController.lastName = 'Blow';
    	lfController.email = 'joe.blow@xyz.com';
    	String expectedFormURLName = s1 + '/LaunchForm/JHA_Form' + '?epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        PageReference pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = false;
        expectedFormURLName = '/apex/JHA_Form' + '?epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Inspection';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Create new Inspection form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Operations';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Create new Operations form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Warranty/Startup';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Create new Warranty/Start Up form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Other';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Create new Other form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = '';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Undefined Form Type!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
    }
    
    static testMethod void testGet_ActionRecent() {
    	// Test get method for action=Recent and different values for formType.
    	// Verify status and formURLName returned are valid and the method returns a null PageReference.
    	
    	// First create an Address record and JHA_Form record for the test.
    	Address__c addrTemp = null;
    	JHA_Form__c jhaFormTemp = null;
    	
    	addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        
        jhaFormTemp = new JHA_Form__c();
        jhaFormTemp.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp.Customer_Name__c = null;
        jhaFormTemp.Facility_Type__c = 'Other';
        jhaFormTemp.Date__c = System.today();
        jhaFormTemp.Employee__c = UserInfo.getUserName();
        jhaFormTemp.Evaluation_Type__c = 'First Time Evaluation';
        jhaFormTemp.Special_Comments__c = null;
        jhaFormTemp.Login_Contact__c = null;
        insert jhaFormTemp;
            	
    	String s1 = URL.getSalesforceBaseUrl().toExternalForm();
    	LaunchFormController lfController = new LaunchFormController();
    	lfController.jhaForm.Jobsite_Address__c = addrTemp.Id;
        lfController.action = 'Recent';
        lfController.formType = 'JHA';
        lfController.forceDotComSite = true;
        lfController.epriseLoginId = 'blowj1';
    	lfController.firstName = 'Joe';
    	lfController.lastName = 'Blow';
    	lfController.email = 'joe.blow@xyz.com';
    	String expectedFormURLName = s1 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        PageReference pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = false;
        expectedFormURLName = '/apex/JHA_Form?id=' + jhaFormTemp.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.jhaForm.Jobsite_Address__c = null;
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('No forms exist for the address!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Inspection';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open most recent Inspection form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Operations';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open most recent Operations form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Warranty/Startup';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open most recent Warranty/Start Up form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Other';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open most recent Other form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = '';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Undefined Form Type!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
    }
    
    static testMethod void testGet_ActionSpecific() {
    	// Test get method for action=Specific and different values for formType.
    	// Verify status and formURLName returned are valid and the method returns a null PageReference.
    	
    	// First create an Address record and 4 JHA_Form records for the test (2 of them on the same day).
    	Address__c addrTemp = null;
    	JHA_Form__c jhaFormTemp1 = null;
    	JHA_Form__c jhaFormTemp2 = null;
    	JHA_Form__c jhaFormTemp3 = null;
    	JHA_Form__c jhaFormTemp4 = null;
    	
    	addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        System.Debug('addrTemp.Id = ' + addrTemp.Id);
        
        
        jhaFormTemp1 = new JHA_Form__c();
        jhaFormTemp1.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp1.Customer_Name__c = null;
        jhaFormTemp1.Facility_Type__c = 'Other';
        jhaFormTemp1.Date__c = Date.newinstance(2015, 10, 01);
        jhaFormTemp1.Employee__c = UserInfo.getUserName();
        jhaFormTemp1.Evaluation_Type__c = 'First Time Evaluation';
        jhaFormTemp1.Special_Comments__c = null;
        jhaFormTemp1.Login_Contact__c = null;
        insert jhaFormTemp1;
        //System.Debug('jhaFormTemp1.CreatedDate = ' + jhaFormTemp1.CreatedDate); //null
        //System.Debug('jhaFormTemp1.Id = ' + jhaFormTemp1.Id);
        //System.Debug('jhaFormTemp1.Name = ' + jhaFormTemp1.Name); //null
        //System.Debug('jhaFormTemp1.Jobsite_Address__c = ' + jhaFormTemp1.Jobsite_Address__c);
        //System.Debug('jhaFormTemp1.Date__c = ' + jhaFormTemp1.Date__c);
        JHA_Form__c testJHAForm = [SELECT Id, Name, Jobsite_Address__c, Date__c, CreatedDate FROM JHA_Form__c WHERE Id = :jhaFormTemp1.Id];
        System.Debug('testJHAForm.CreatedDate = ' + testJHAForm.CreatedDate);
        //System.Debug('testJHAForm.Id = ' + testJHAForm.Id);
        //System.Debug('testJHAForm.Name = ' + testJHAForm.Name);
        //System.Debug('testJHAForm.Jobsite_Address__c = ' + testJHAForm.Jobsite_Address__c);
        //System.Debug('testJHAForm.Date__c = ' + testJHAForm.Date__c);


		// Put in a delay so the CreatedDate for jhaFormTemp2 is 1 sec later than jhaFormTemp1,
		// since these 2 records are on the same day
		Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
		Integer delayInMilliseconds = 1000; // 1-second delay
		while (System.now().getTime() - startingTime < delayInMilliseconds) {
			// Do nothing until desired delay has passed
		}


        jhaFormTemp2 = new JHA_Form__c();
        jhaFormTemp2.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp2.Customer_Name__c = null;
        jhaFormTemp2.Facility_Type__c = 'Other';
        jhaFormTemp2.Date__c = Date.newinstance(2015, 10, 01);
        jhaFormTemp2.Employee__c = UserInfo.getUserName();
        jhaFormTemp2.Evaluation_Type__c = 'Contract Renewal/Re-evaluation';
        jhaFormTemp2.Special_Comments__c = 'Most recent record for this day';
        jhaFormTemp2.Login_Contact__c = null;
        insert jhaFormTemp2;
        //System.Debug('jhaFormTemp2.CreatedDate = ' + jhaFormTemp2.CreatedDate); //null
        //System.Debug('jhaFormTemp2.Id = ' + jhaFormTemp2.Id);
        //System.Debug('jhaFormTemp2.Name = ' + jhaFormTemp2.Name); //null
        //System.Debug('jhaFormTemp2.Jobsite_Address__c = ' + jhaFormTemp2.Jobsite_Address__c);
        //System.Debug('jhaFormTemp2.Date__c = ' + jhaFormTemp2.Date__c);
        JHA_Form__c testJHAForm2 = [SELECT Id, Name, Jobsite_Address__c, Date__c, CreatedDate FROM JHA_Form__c WHERE Id = :jhaFormTemp2.Id];
        System.Debug('testJHAForm2.CreatedDate = ' + testJHAForm2.CreatedDate);
        //System.Debug('testJHAForm2.Id = ' + testJHAForm2.Id);
        //System.Debug('testJHAForm2.Name = ' + testJHAForm2.Name);
        //System.Debug('testJHAForm2.Jobsite_Address__c = ' + testJHAForm2.Jobsite_Address__c);
        //System.Debug('testJHAForm2.Date__c = ' + testJHAForm2.Date__c);


		startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
		delayInMilliseconds = 1000; // 1-second delay
		while (System.now().getTime() - startingTime < delayInMilliseconds) {
			// Do nothing until desired delay has passed
		}
		
		
        jhaFormTemp3 = new JHA_Form__c();
        jhaFormTemp3.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp3.Customer_Name__c = null;
        jhaFormTemp3.Facility_Type__c = 'Other';
        jhaFormTemp3.Date__c = Date.newinstance(2015, 11, 01);
        jhaFormTemp3.Employee__c = UserInfo.getUserName();
        jhaFormTemp3.Evaluation_Type__c = 'Contract Renewal/Re-evaluation';
        jhaFormTemp3.Special_Comments__c = null;
        jhaFormTemp3.Login_Contact__c = null;
        insert jhaFormTemp3;
        
        
		startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
		delayInMilliseconds = 1000; // 1-second delay
		while (System.now().getTime() - startingTime < delayInMilliseconds) {
			// Do nothing until desired delay has passed
		}


        jhaFormTemp4 = new JHA_Form__c();
        jhaFormTemp4.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp4.Customer_Name__c = null;
        jhaFormTemp4.Facility_Type__c = 'Other';
        jhaFormTemp4.Date__c = Date.newinstance(2015, 12, 01);
        jhaFormTemp4.Employee__c = UserInfo.getUserName();
        jhaFormTemp4.Evaluation_Type__c = 'Contract Renewal/Re-evaluation';
        jhaFormTemp4.Special_Comments__c = null;
        jhaFormTemp4.Login_Contact__c = null;
        insert jhaFormTemp4;

        
        // Test where date is null
        LaunchFormController lfController = new LaunchFormController();
        lfController.action = 'Specific';
        lfController.formType = 'JHA';
        lfController.jhaForm.Date__c = null;
        String expectedFormURLName = '';
        PageReference pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Invalid date!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // *** Following tests are for forceDotComSite = true ***
        // Test where we have 2 records on the same day
    	String s1 = URL.getSalesforceBaseUrl().toExternalForm();
    	lfController.jhaForm.Jobsite_Address__c = addrTemp.Id;
    	lfController.jhaForm.Date__c = Date.newinstance(2015, 10, 01);
        lfController.forceDotComSite = true;
        lfController.epriseLoginId = 'blowj1';
    	lfController.firstName = 'Joe';
    	lfController.lastName = 'Blow';
    	lfController.email = 'joe.blow@xyz.com';
    	expectedFormURLName = s1 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp2.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where we pick a date where the lower bound is 11/01/15 and upper bound is 12/01/15 and it's closer to the lower bound
        lfController.jhaForm.Date__c = Date.newinstance(2015, 11, 03);
        expectedFormURLName = s1 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp3.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where we pick a date where the lower bound is 11/01/15 and upper bound is 12/01/15 and it's closer to the upper bound
        lfController.jhaForm.Date__c = Date.newinstance(2015, 11, 30);
        expectedFormURLName = s1 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp4.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where we pick a date where there is no lower bound and the upper bound is 10/01/15
        lfController.jhaForm.Date__c = Date.newinstance(2015, 09, 30);
        expectedFormURLName = s1 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp1.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where we pick a date where the lower bound is 12/01/15 and there is no upper bound
        lfController.jhaForm.Date__c = Date.newinstance(2015, 12, 02);
        expectedFormURLName = s1 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp4.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where no forms exist for a given address
        lfController.jhaForm.Jobsite_Address__c = null;
    	lfController.jhaForm.Date__c = Date.newinstance(2015, 01, 01); // set to any date, it doesn't matter here
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('No forms exist for the address!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        
        //--- Other form types
        lfController.forceDotComSite = true;
        lfController.formType = 'Inspection';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open specific date Inspection form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Operations';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open specific date Operations form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Warranty/Startup';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open specific date Warranty/Start Up form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        lfController.forceDotComSite = true;
        lfController.formType = 'Other';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Open specific date Other form not implemented yet!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where formtype is empty
        lfController.forceDotComSite = true;
        lfController.formType = '';
        expectedFormURLName = '';
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Undefined Form Type!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        
        // *** Following tests are for forceDotComSite = false ***
        lfController.forceDotComSite = false;
        lfController.formType = 'JHA';
        lfController.jhaForm.Jobsite_Address__c = addrTemp.Id;
        
        // Test where we pick a date where the lower bound is 11/01/15 and upper bound is 12/01/15 and it's closer to the upper bound
        lfController.jhaForm.Date__c = Date.newinstance(2015, 11, 30);
        expectedFormURLName = '/apex/JHA_Form?id=' + jhaFormTemp4.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where we pick a date where there is no lower bound and the upper bound is 10/01/15
        lfController.jhaForm.Date__c = Date.newinstance(2015, 09, 30);
        expectedFormURLName = '/apex/JHA_Form?id=' + jhaFormTemp1.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
        
        // Test where we pick a date where the lower bound is 12/01/15 and there is no upper bound
        lfController.jhaForm.Date__c = Date.newinstance(2015, 12, 02);
        expectedFormURLName = '/apex/JHA_Form?id=' + jhaFormTemp4.Id + '&epriseLoginId=' + lfController.epriseLoginId + '&email=' + lfController.email + '&firstName=' + lfController.firstName + '&lastName=' + lfController.lastName;
        pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Success', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
    }
    
    static testMethod void testGet_ActionUndefined() {
    	// Test get method where action is undefined
    	// Verify status and formURLName returned are valid and the method returns a null PageReference.
    	LaunchFormController lfController = new LaunchFormController();
        lfController.action = '';
    	String expectedFormURLName = '';
        PageReference pageRef = lfController.get();
        System.assertEquals(null, pageRef);
        System.assertEquals('Undefined Action!', lfController.status);
        System.assertEquals(expectedFormURLName, lfController.formURLName);
    }
    
}