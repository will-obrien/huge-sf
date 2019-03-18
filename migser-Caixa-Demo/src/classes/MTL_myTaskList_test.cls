/*
	MTL_myTaskList_test.cls - Unit tests for the My Task List package to cover:
		- MTL_myTaskList.page Visualforce page
		- MTL_myTaskListController.cls Apex class (controller extension for Visualforce page)
		- MTL_myTaskListUtilities.cls Apex class (utility functions for My Task List package)
	Author: Mike Hineline
	
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
private class MTL_myTaskList_test {

	/*
    	CreateTasks - utility method to create test Tasks and return them in a List
    	Inputs:
    		basename = beginnging of task.Subject string, to be concatenated with an incrementing integer
    		objectCount = number of test records to be created
    	Output:
    		List<Task> = list containing the records created
   	*/
    public static List<Task> CreateTasks(String basename, Integer objectCount) {
        // List to hold the Task sObjects
        List<Task> newTasks = new List<Task>();
        
        // Fill the list with test records with names initialized based on basename
        for(Integer i=0; i<objectCount; i++) {
            newTasks.add(new Task(Subject = basename + String.valueof(i)));
        }
        
        // Return the list of records created
        return newTasks;
    }

	/*
		myTaskListTestMethod - main test class for the My Task List package components
	*/
    static testMethod void myTaskListTestMethod() {
        // Create a test opportunity for the WhatId field
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity',CloseDate=Date.today()+365,StageName='Prospecting');
        insert testOpportunity;
        
        // Create a test contact for the WhoId field
        Contact testContact = new Contact(LastName='TestContact');
        insert testContact;

        // Initialize test data and add test data for required fields
        final Integer NUM_TEST_TASKS = 20;
        List<Task> testTasks = CreateTasks('TestTask_',NUM_TEST_TASKS);
        for(Task thisTask: testTasks) {
			thisTask.OwnerID = UserInfo.getUserId();
			thisTask.Status = 'In Progress';
			thisTask.WhatId = testOpportunity.Id;
			thisTask.WhoId = testContact.Id;
			thisTask.Priority = 'Normal';
        }
        // Set the 2nd task Priority to high
        insert testTasks;
        
        // Set Visualforce page
        PageReference page = new PageReference('myTaskList');
        Test.setCurrentPage(page); 
        
        /*
        	Test query and aloha formatting
        */
        // Set the controller
        MTL_myTaskListController controller = new MTL_myTaskListController();
        // Test that <NUM_TEST_TASKS> of TaskContainers were added to myTaskList
        System.assertEquals(controller.myTaskList.size(),NUM_TEST_TASKS); 
        // Test aloha link formatting
        System.assertEquals(controller.pageFormat,'aloha');

        /*
        	Test console formatting
        */
        ApexPages.CurrentPage().getparameters().put('isdtp', 'nv');
        // Set the controller
        controller = new MTL_myTaskListController();
        // Test console link formatting
        System.assertEquals(controller.pageFormat,'console');

        /*
        	Test mobile formatting
        */
        ApexPages.CurrentPage().getparameters().put('isdtp', 'p1');
        // Set the controller
        controller = new MTL_myTaskListController();
        // Test Salesforce1 link formatting
        System.assertEquals(controller.pageFormat,'mobile');
        
        /*
        	Test the updateTask remote static action - modify Status to completed
        	Test data was all created with Status = 'In Progress' so updating Status to Completed
        		should result in IsClosed = true for the passed task
        */
        Task updatedTask = MTL_myTaskListController.updateTask(testTasks[0].Id,'Status','Completed');
        System.assertEquals(updatedTask.IsClosed,true);

        /*
        	Test the updateTask remote static action - modify Priority to high
        */
        Task updatedTask2 = MTL_myTaskListController.updateTask(testTasks[0].Id,'Priority','High');
        System.assertEquals(updatedTask2.Priority,'High');

        /*
        	Test the updateTask remote static action - query only
        	The test class should return the sObject and make no modifications to it
        */
		Task originalTask = [SELECT LastModifiedDate from Task where Id = :testTasks[1].Id];
        DateTime originalDate = originalTask.LastModifiedDate;
        Task updatedTask3 = MTL_myTaskListController.updateTask(testTasks[1].Id,null,null);
		originalTask = [SELECT LastModifiedDate from Task where Id = :testTasks[1].Id];
        DateTime newDate = originalTask.LastModifiedDate;
        // Validate record was returned
        System.assertEquals(updatedTask3.Id,testTasks[1].Id);
        // Validate record was not modified
        System.assertEquals(originalDate,newDate);

        /*
        	Test the sorting functionality
        	The tests force sort order and check the filter script and set the filter and test the sort script
        */
        Integer testSearch;
        // Set the sort order and then test the filter string to ensure the sort order is set correctly
        ApexPages.CurrentPage().getparameters().put('so', 'dateASC');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskFilterAllOpenScript.indexOf('so=dateASC');
        System.assertNotEquals(-1, testSearch);

        // Set the sort order and then test the filter string to ensure the sort order is set correctly
        ApexPages.CurrentPage().getparameters().put('so', 'dateDESC');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskFilterAllOpenScript.indexOf('so=dateDESC');
        System.assertNotEquals(-1, testSearch);

        // Set the sort order and then test the filter string to ensure the sort order is set correctly
        ApexPages.CurrentPage().getparameters().put('so', 'priorityASC');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskFilterAllOpenScript.indexOf('so=priorityASC');
        System.assertNotEquals(-1, testSearch);
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'overdue');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=overdue');
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'today');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=today');
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'todayplusoverdue');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=todayplusoverdue');
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'tomorrow');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=tomorrow');
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'next7days');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=next7days');
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'next7daysplusoverdue');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=next7daysplusoverdue');
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'thismonth');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=thismonth');
        
        // Set the filter and then test the sort order string to ensure the filter is set correctly
        ApexPages.CurrentPage().getparameters().put('flt', 'allopen');
        controller = new MTL_myTaskListController();
        testSearch = controller.taskSortDateASCScript.indexOf('flt=allopen');
    }
    
	/*
		myTaskListEmailTestMethod - test class for My Task List package component
			that requires running as a test user
	*/
    static testMethod void myTaskListUserTestMethod() {
        // Set up test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='test@mailinator.com',
				EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p.Id,
        		TimeZoneSidKey='America/Chicago', UserName='standarduser@mytasklist.testuser');
        // Test emailTask
        System.runAs(u) {
	        // Create a test opportunity for the WhatId field
    	    Opportunity testOpportunity = new Opportunity(Name='Test Opportunity',CloseDate=Date.today()+365,StageName='Prospecting');
       		insert testOpportunity;
        
       		// Create a test contact for the WhoId field
        	Contact testContact = new Contact(LastName='TestContact');
        	insert testContact;

        	// Initialize test data and add test data for required fields
        	final Integer NUM_TEST_TASKS = 1;
        	List<Task> testTasks = CreateTasks('TestTask_',NUM_TEST_TASKS);
        	for(Task thisTask: testTasks) {
				thisTask.OwnerID = UserInfo.getUserId();
				thisTask.ActivityDate = Date.today();
				thisTask.Status = 'In Progress';
				thisTask.WhatId = testOpportunity.Id;
				thisTask.WhoId = testContact.Id;
				thisTask.Priority = 'Normal';
				thisTask.Type = 'Other';
				thisTask.Description = 'Test\nTest';
        	}
        	insert testTasks;

	        // Set Visualforce page
    	    PageReference page = new PageReference('myTaskList');
        	Test.setCurrentPage(page); 
        
        	// Set the controller
        	MTL_myTaskListController controller = new MTL_myTaskListController();
        
	        /*
    	    	Test the emailTask remote static action
        		The emailTask class should return true
        	*/
        	Boolean sendResult = MTL_myTaskListController.emailTask(testTasks[0].Id);
	        System.assertEquals(true,sendResult);
        }
    }
    
	/*
		myTaskListPushTopicTestMethod - test class for My Task List package component
			that tests adding and removing pushTopics
	*/
    static testMethod void myTaskListPushTopicTestMethod() {
    	// Initialize the controller
        MTL_myTaskListUtilities controller = new MTL_myTaskListUtilities();

        // Use a new test topic name to avoid conflicts with the production push topic
        //	and reset the pushTopicEnabled flag to allow us to re-add the test listener
        //	This is necessary due to push topic names needing to be unique even in test classes
        MTL_myTaskListUtilities.pushTopicName = 'myTaskListUpdatesTEST1';
        MTL_myTaskListUtilities.pushTopicEnabled = false;

    	// Try to add the push topic
    	Boolean addResultPositive;
    	addResultPositive = MTL_myTaskListUtilities.addPushTopic();
    	// Test that the push topic was added successfully
    	System.assertEquals(true,addResultPositive);
    	// Test that the pushTopicEnabled flag was set to true
    	System.assertEquals(true,MTL_myTaskListUtilities.pushTopicEnabled);
    	
    	// Test that the testForPushTopic() function indicates the push topic is added
    	// 	if the flag is cleared but the topic is in the DB
    	MTL_myTaskListUtilities.pushTopicEnabled = false;
    	System.assertEquals(true,MTL_myTaskListUtilities.testForPushTopic());
    	// Test that the testforPushTopic() function also correctly reset the flag to true
    	System.assertEquals(true,MTL_myTaskListUtilities.pushTopicEnabled);

    	// With the pushTopicEnabled flag true, try to re-add the topic
    	Boolean addResultPositive2;
    	addResultPositive2 = MTL_myTaskListUtilities.addPushTopic();
    	// Test that the push topic addition succeeded
    	System.assertEquals(true,addResultPositive2);
    	// Test that the pushTopicEnabled flag is still true
    	System.assertEquals(true,MTL_myTaskListUtilities.pushTopicEnabled);
    	
    	// Add the pushTopic via the action method
    	PageReference addPageResult = new PageReference('about:blank');
    	addPageResult = MTL_myTaskListUtilities.addPushTopicAction();
    	// Verify we got a null PageReference returned
    	System.assertEquals(null,addPageResult);
    	// The add should pass
		System.assertEquals(true,MTL_myTaskListUtilities.pushTopicEnabled);

    	// Now try to delete the push topic
    	Boolean deleteResultPositive;
    	deleteResultPositive = MTL_myTaskListUtilities.deletePushTopic();
    	// Test that the push topic was deleted successfully
    	System.assertEquals(true,deleteResultPositive);
    	// Test that the pushTopicEnabled flag was set to false
    	System.assertEquals(false,MTL_myTaskListUtilities.pushTopicEnabled);
    	
    	// With the push topic deleted, try to delete again
    	Boolean deleteResultNegative;
    	deleteResultNegative = MTL_myTaskListUtilities.deletePushTopic();
    	// Test that the push topic was not found/deleted
    	System.assertEquals(false,deleteResultNegative);
    	// Test that the pushTopicEnabled flag is still false
    	System.assertEquals(false,MTL_myTaskListUtilities.pushTopicEnabled);

    	// Delete the pushTopic via the action method
    	// First add the push topic since it was previously deleted
    	PageReference deletePageResult = new PageReference('about:blank');
    	deletePageResult = MTL_myTaskListUtilities.deletePushTopicAction();
    	// Verify we got a null PageReference returned
    	System.assertEquals(null,deletePageResult);
    	// Since this delete should fail (listener was already deleted)
    	//	verify that a warning message was generated 
    	List<ApexPages.Message> allMessages = ApexPages.getMessages();
		Boolean messageDeleteFail = false;
		for (ApexPages.Message thisMessage : allMessages) {
    		if (thisMessage.getDetail().contains('listener was not deleted')) {
				messageDeleteFail = true;
			}
		}
		System.assertEquals(true,messageDeleteFail);
    }
}