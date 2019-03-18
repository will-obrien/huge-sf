/*
    RC_ContentSearch_test.cls - Unit tests to cover:
    - RC_RelevantContentConsole Visualforce page
    - RC_ContentSearchComponent Visualforce Component (referenced in RC_RelevantContentConsole.page, RC_RelevantContentOpportunity.page, et. al.)
    - RC_ContentSearch Apex class (controller for Visualforce pages)
    
    Copyright (c) 2013, salesforce.com, Inc.
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without modification, 
    are permitted provided that the following conditions are met:
    
        * Redistributions of source code must retain the above copyright notice, 
        this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright notice, 
        this list of conditions and the following disclaimer in the documentation 
        and/or other materials provided with the distribution.
        * Neither the name of the salesforce.com, Inc. nor the names of its contributors 
        may be used to endorse or promote products derived from this software 
        without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
    IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
    INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
    LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
    OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
    OF THE POSSIBILITY OF SUCH DAMAGE.
*/
@isTest
private class RC_ContentSearch_test {
    // Test User who creates & reads records through the tests
	//   This is to ensure that records created can also be accessed even with private OWD
	public static User testUser = CreateUser();
	
	/*
    	CreateUser - utility method to create test User and return the User record
    		This user has access to CRM Content
    	Inputs:
    		none
    	Output:
    		User = new User record with access to CRM Content
    */
    public static User CreateUser() {
        // Set up positive test user with access to CRM Content
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User uTest = new User(Alias = 'standt', Email='upositive@mailinator.com',
                EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Chicago', UserName='utest@relevantcontent.testuser',
                UserPermissionsSFContentUser = true);
        insert uTest;
		return uTest;
    }

	/*
    	CreateContent - utility method to create test Content and return them in a List
    	Inputs:
    		basename = beginnging of ContentVersion.Title string, to be concatenated with an incrementing integer
    		objectCount = number of test records to be created
    		contentType:
    			C = Try to create Content, if possible
    			H = Try to create Files
    	Output:
    		List<ContentVersion> = list containing the records created
    */
    public static List<ContentVersion> CreateContent(String basename, Integer objectCount, String contentType) {
        // List to hold the Task sObjects
        List<ContentVersion> newContent = new List<ContentVersion>();
        
        // Create a blob to represent the file
        Blob testBlob = Blob.valueof('TestFileBlob');

        // Set the appropriate Content type (Content or File)
        String contentOrigin = 'C';
        Boolean contentAvailableContentTest = RC_ContentSearch.contentAvailableCheck();
        if (contentType == 'C' && contentAvailableContentTest == true) {
            // Content is requested and available, set origin to 'C' (Content)
            contentOrigin = 'C';
        } else {
            // Content is not available or not requested, set origin to 'H' (File)
            contentOrigin = 'H';
        }
        
        // Fill the list with test records with names initialized based on basename
        for(Integer i=0; i<objectCount; i++) {
            // Create the Content/File
            newContent.add(new ContentVersion(
                Title = basename + String.valueof(i),
                Origin = contentOrigin,
                PathOnClient = basename + String.valueof(i),
                VersionData = testBlob)
            );
        }
        
        // Return the list of records created
        return newContent;
    }

	/*
    	RC_ContentSearchUtil - utility method to perform the bulk of the unit test logic when given a test record
    	Inputs:
    		sObject = record on which to run the tests
    		String = sObject type of the test record
    	Output:
    		none
    */
    public static void RC_ContentSearchUtil(sObject testRecord,String sObjectType) {
        // Determine if content is available for the org - this will determine if Content or Files is used for tests
        Boolean contentAvailableTest = RC_ContentSearch.contentAvailableCheck();
        
        // Initialize first batch test data by adding test data for required fields and inserting
        //  This content contains the word 'Test' and should match the RC_Keywords__c which will include the keyword 'Test'
        final Integer NUM_TEST_CONTENT_1 = 20;
        List<ContentVersion> testContentPos = CreateContent('Test Content ',NUM_TEST_CONTENT_1,'C');
        for(ContentVersion thisContentPos: testContentPos) {
            thisContentPos.Description = 'Test';
        }
        insert testContentPos;

        // Initialize second batch test data by adding test data for required fields and inserting
        //  This content does not contain any words relevant to RC_Keywords__c which will include the keyword 'Test'
        final Integer NUM_TEST_CONTENT_2 = 10;
        List<ContentVersion> testContentNeg = CreateContent('Irrelevant',NUM_TEST_CONTENT_2,'C');
        for(ContentVersion thisContentNeg: testContentNeg) {
            thisContentNeg.Description = 'Irrelevant';
        }
        insert testContentNeg;

        /*
            Constructor test
                Test the member variables and query resulting from the initialization of the search using RC_Keywords__c
        */
        // Since SOSL queries return an empty set, force the addition of the first batch of test data
        //  to the SOSL results
        Map<Id, ContentVersion> searchById = new Map<Id, Contentversion>([SELECT Id FROM ContentVersion WHERE Description='Test']);
        List<Id> searchResults = new List<id>(searchById.keySet());
        Test.setFixedSearchResults(searchResults);

        // Set Visualforce page
        PageReference page = new PageReference('RC_RelevantContentConsole?id='+testRecord.Id);
        Test.setCurrentPage(page); 
        // Ensure CONTENT_ONLY is set to false for tests
        RC_ContentSearch.CONTENT_ONLY = false;
        // Set the controller
        RC_ContentSearch controller = new RC_ContentSearch();
        
        // Ensure the sObject type is detected correctly
        System.AssertEquals(sObjectType,controller.thisObjectType);

        // If the RC_Keywords__c field exists on the Object, ensure it is holding the 'Test' keyword
        if (controller.hasKeywordsField) {
        	// Query the test record to get the calculated value of the RC_Keywords__c formula field
        	String thisRecordQueryString = 'SELECT ID, RC_Keywords__c FROM ';
        	thisRecordQueryString += controller.thisObjectType;
        	thisRecordQueryString += ' WHERE ID=\'' + testRecord.Id + '\''; 
        	sObject thisRecordTemp;
			try {
				thisRecordTemp = Database.query(thisRecordQueryString);
			} catch (DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); return; }
        	// Ensure the Keyword__c includes 'Test' (from the Opportunity.Name)
            String recordKeywordString = String.valueOf(thisRecordTemp.get('RC_Keywords__c'));
        	System.assert(recordKeywordString.contains('Test'));
        }
        
        // Test that NUM_TEST_CONTENT_1 of ContentVersion were added to recordContentAll and totalResults
        System.assert(controller.recordSearchString.contains('Test'));
        System.assertEquals(NUM_TEST_CONTENT_1,controller.recordContentAll.size());
        System.assertEquals(NUM_TEST_CONTENT_1,controller.totalResults); 
        // Test that recordContentAll only contains <= RESULTS_PER_PAGE
        System.assert(controller.recordContentAll.size() <= controller.RESULTS_PER_PAGE);

        /*
            Test the cleanFileType and getIconFilename methods
            Send in known and unknown values and test results
        */
        // Test that cleanFileType and getIconFilename handled a known value correctly
        String fileTypeTest = 'EXCEL_X';
        String fileNameTest = 'test.xlsx';
        String fileTypeTestOutput = RC_ContentSearch.cleanFileType(fileTypeTest,fileNameTest);
        System.assertEquals('xlsx',fileTypeTestOutput);
        String filenameTestOutput = RC_ContentSearch.getIconFilename(fileTypeTestOutput);
        System.assertEquals('excel.svg',filenameTestOutput);
        // Test that cleanFileType and getIconFilename handled an unknown value with no file extension correctly
        fileTypeTest = 'UNKNOWN_FILE_TYPE_STRING_TEST';
        fileNameTest = 'unknownfile';
        fileTypeTestOutput = RC_ContentSearch.cleanFileType(fileTypeTest,fileNameTest);
        System.assertEquals('unknown_file_type_string_test',fileTypeTestOutput);
        filenameTestOutput = RC_ContentSearch.getIconFilename(fileTypeTestOutput);
        System.assertEquals('unknown.svg',filenameTestOutput);
        // Test that cleanFileType and getIconFilename handled an unknown value with a file extension correctly
        fileTypeTest = 'UNKNOWN_FILE_TYPE_STRING_TEST';
        fileNameTest = 'unknownfile.wmv';
        fileTypeTestOutput = RC_ContentSearch.cleanFileType(fileTypeTest,fileNameTest);
        System.assertEquals('wmv',fileTypeTestOutput);
        filenameTestOutput = RC_ContentSearch.getIconFilename(fileTypeTestOutput);
        System.assertEquals('video.svg',filenameTestOutput);
        
        /*
            Test the updateSearch method - test for Irrelevant
            Search for 'Irrelevant' and NUM_TEST_CONTENT_2 should be found
        */
        // Since SOSL queries return an empty set, force the addition of the second batch of test data
        //  to the SOSL results
        searchById = new Map<Id, Contentversion>([SELECT Id FROM ContentVersion WHERE Description='Irrelevant']);
        searchResults = new List<id>(searchById.keySet());
        Test.setFixedSearchResults(searchResults);
        controller.recordSearchString = 'Irrelevant';
        controller.updateSearch();
        System.assertEquals(NUM_TEST_CONTENT_2,controller.recordContentAll.size()); 
        System.assertEquals(NUM_TEST_CONTENT_2,controller.totalResults);
        
        /*
            Test for User access to Content
            Check outputs set by the contentAvailableCheck() method
        */
        // Set test user with no access to CRM Content
		testUser.UserPermissionsSFContentUser = false;
		update testUser;
        // Instantiate the controller as the negative test user and test 
		System.runAs(testUser) {
            // Set the controller
            controller = new RC_ContentSearch();
            // Ensure contentAvailable is set to false for the user
            System.assertequals(false,controller.contentAvailable);
            // Ensure contentType is set correctly for the user
            if (RC_ContentSearch.CONTENT_ONLY == false) {
                // Ensure content Type is set to 'Files' for the user
                System.assertequals('File',controller.contentType);
            } else {
                // No results can be returned with CONTENT_ONLY = true and no access to Content
                // Ensure RESULTS_PER_PAGE = 0
                System.assertequals(0,controller.RESULTS_PER_PAGE);    
            }
        }

        // Set test user with no access to CRM Content
		testUser.UserPermissionsSFContentUser = true;
		update testUser;
        // Instantiate the controller as the positive test user and test 
		System.runAs(testUser) {
            if (contentAvailableTest == true) {
                // Set the controller
                controller = new RC_ContentSearch();
                // Ensure contentAvailable is set to false for the user
                System.assertequals(true,controller.contentAvailable);
                // Ensure contentType is set to 'Content' for the user
                System.assertequals('Content',controller.contentType);
            }
        }
    }
    
    // Test to ensure constructor fails gracefully if not given a record (e.g. during new record creation)
    static testMethod void RC_ContentSearchTestMethod_Negative() {
        // Set Visualforce page with no recordID
        PageReference page = new PageReference('RC_RelevantContentConsole');
        Test.setCurrentPage(page); 
        // Set the controller
        RC_ContentSearch controller = new RC_ContentSearch();
        // Test that controller.showForm is set to false
        System.assertEquals(false,controller.showForm);
        // Test that controller.thisRecord is not initalized
        System.assertEquals(null,controller.thisRecord);
    }
    
    // Test the myTaskList page and controller using an Opportunity record
    static testMethod void RC_ContentSearchTestMethod_Opportunity() {
        // Create a test opportunity which will contain the RC_Keywords__c formula field
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity',CloseDate=Date.today()+365,StageName='Prospecting');
        insert testOpportunity;
        // Specify the test record sObject type
        String testSObjectType = 'Opportunity';
        // Call the utility function to run the tests on the Opportunity
		RC_ContentSearchUtil(testOpportunity,testSObjectType);
    }

    // Test the myTaskList page and controller using a Account record
    static testMethod void RC_ContentSearchTestMethod_Account() {
        // Create a test record which should contain the RC_Keywords__c formula field
        Account testRecord = new Account(Name='Test Record');
        insert testRecord;
        // Specify the test record sObject type
        String testSObjectType = 'Account';
        // Call the utility function to run the tests on the Opportunity
		RC_ContentSearchUtil(testRecord,testSObjectType);
    }

    // Test the myTaskList page and controller using a Lead record
    static testMethod void RC_ContentSearchTestMethod_Lead() {
        // Create a test record which should contain the RC_Keywords__c formula field
        Lead testRecord = new Lead(LastName='Test Record',Company='thisCompany');
        insert testRecord;
        // Specify the test record sObject type
        String testSObjectType = 'Lead';
        // Call the utility function to run the tests on the Opportunity
		RC_ContentSearchUtil(testRecord,testSObjectType);
    }

    // Test the myTaskList page and controller using a Case record
    static testMethod void RC_ContentSearchTestMethod_Case() {
        // Create a test record which should contain the RC_Keywords__c formula field
        Case testRecord = new Case(Subject='Test Record');
        insert testRecord;
        // Specify the test record sObject type
        String testSObjectType = 'Case';
        // Call the utility function to run the tests on the Opportunity
		RC_ContentSearchUtil(testRecord,testSObjectType);
    }
    
    // Test the myTaskList page and controller using an Task record
    static testMethod void RC_ContentSearchTestMethod_Task() {
        // Create a test record which should contain the RC_Keywords__c formula field
        Task testRecord = new Task(OwnerId=testUser.Id,Subject='Test Record',Status='New',Priority='High');
        insert testRecord;
        // Specify the test record sObject type
        String testSObjectType = 'Task';
        // Call the utility function to run the tests on the Opportunity
		RC_ContentSearchUtil(testRecord,testSObjectType);
    }

    // Test the postFileToFeed webservice
    //  Reading from OpportunityFeed requires seeAllData = true
    @isTest(seeAllData = true)
    static void RC_FeedPostTestMethod() {
        // Create a test opportunity which will contain the RC_Keywords__c formula field
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity',CloseDate=Date.today()+365,StageName='Prospecting');
        insert testOpportunity;
        // Query the test opportunity to get the calculated value of the RC_Keywords__c formula field
        testOpportunity = [SELECT ID, Name, RC_Keywords__c from Opportunity WHERE ID = :testOpportunity.id];
        // Ensure the Keyword__c includes 'Test' (from the Opportunity.Name)
        System.assert(testOpportunity.RC_Keywords__c.contains('Test'));
        
        // Create a File for testing attachment
        //  This content contains the word 'Test' and should match the RC_Keywords__c which includes the opportunity Title of 'Test Opportunity'
        Integer numTestContent = 3;
        List<ContentVersion> testContentPos = CreateContent('Test Content ',numTestContent,'H');
        for(ContentVersion thisContentPos: testContentPos) {
            thisContentPos.Description = 'Test';
        }
        insert testContentPos;

        // Since SOSL queries return an empty set, force the addition of the first batch of test data
        //  to the SOSL results
        Map<Id, ContentVersion> searchById = new Map<Id, Contentversion>([SELECT Id FROM ContentVersion WHERE Description='Test']);
        List<Id> searchResults = new List<id>(searchById.keySet());
        Test.setFixedSearchResults(searchResults);
        
        // Set Visualforce page
        PageReference page = new PageReference('RC_RelevantContentConsole?id='+testOpportunity.Id);
        Test.setCurrentPage(page); 

        // Ensure CONTENT_ONLY is set to false for tests
        RC_ContentSearch.CONTENT_ONLY = false;
        
        // Set the controller
        RC_ContentSearch controller = new RC_ContentSearch();
        
        /*
            Test the postFileToFeed remote static action
        */
        // Test adding content with a comment
        String testComment = 'This is a test comment';
        // Call the postFileToFeed remote method and ensure it returns true
        Boolean postResult = RC_ContentSearch.postFileToFeed(testContentPos[0].Id,testOpportunity.Id,testComment);
        System.assertEquals(true,postResult);
        // Query the inserted record (there will only be one feed item at this point in this test data)
        OpportunityFeed[] testFeedItems = [Select Id,RelatedRecordId,Type,Body,ParentId From OpportunityFeed WHERE ParentId = :testOpportunity.Id ORDER BY CreatedDate DESC LIMIT 1];
        // Validate FeedItem was added
        System.assertEquals(testContentPos[0].Id,testFeedItems[0].RelatedRecordId);
        System.assertEquals(testOpportunity.Id,testFeedItems[0].ParentId);
        System.assertEquals(testComment,testFeedItems[0].Body);
        System.assertEquals('ContentPost',testFeedItems[0].Type);

        // Test adding content without a comment
        testComment = null;
        // Call the postFileToFeed remote method and ensure it returns true
        postResult = RC_ContentSearch.postFileToFeed(testContentPos[1].Id,testOpportunity.Id,testComment);
        System.assertEquals(true,postResult);
        // Query the inserted record (there will only be one feed item at this point in this test data)
        testFeedItems = [Select Id,RelatedRecordId,Type,Body,ParentId From OpportunityFeed WHERE ParentId = :testOpportunity.Id ORDER BY CreatedDate DESC LIMIT 1];
        // Validate FeedItem was added
        System.assertEquals(testContentPos[1].Id,testFeedItems[0].RelatedRecordId);
        System.assertEquals(testOpportunity.Id,testFeedItems[0].ParentId);
        System.assertEquals(testComment,testFeedItems[0].Body);
        System.assertEquals('ContentPost',testFeedItems[0].Type);

        // Test adding content with an invalid Content ID
        testComment = 'test';
        // Call the postFileToFeed remote method and ensure it returns true
        postResult = RC_ContentSearch.postFileToFeed('068F00000000000',testOpportunity.Id,testComment);
        // Ensure function returns false
        System.assertEquals(false,postResult);
    }
}