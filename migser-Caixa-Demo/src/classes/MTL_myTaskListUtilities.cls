/*
	MTL_myTaskListUtilities.cls - utility class for configuration of the My Task List package
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
public with sharing class MTL_myTaskListUtilities {

    // Static variables for the Streaming API push topic
    public static String pushTopicName = 'MTL_myTaskListUpdates';
    public static Boolean pushTopicEnabled {get; set;} 
    
    /* Constructor */
    public MTL_myTaskListUtilities() {
    	// Test the status of the push topic to set the pushTopicEnabled flag
    	testForPushTopic();
    }
    
   	/*
		testForPushTopic - determine if the Streaming API push topic is already set
		Inputs: none
		Returns: Boolean
			- true if push topic exists
			- false if push topic does not exist
	*/
	public static Boolean testForPushTopic() {
		if (pushTopicEnabled == true) {
			// If the pushTopicEnabled flag is already set, return true
			return true;
		} else {
			// Check to see if the push topic is already in the DB and update the pushTopicEnabled flag
			List<PushTopic> oldMyTaskListPushTopics = new List<PushTopic>();
			oldMyTaskListPushTopics = Database.Query('SELECT p.Id, p.Name from PushTopic p where p.Name = :pushTopicName');
			if (oldMyTaskListPushTopics.size() > 0) {
				pushTopicEnabled = true;
				return true;
			}
		}
		// The push topic was not found
		pushTopicEnabled = false;
		return false;
	}

	/*
		addPushTopic - set up the Streaming API push topic if it is not already set
		Inputs: none
		Returns: Boolean
			- true if topic was added
			- false if topic was not added
	*/
	public static Boolean addPushTopic() {
		// If checks show that the push topic exists, remove it before re-creating the push topic
		if (testForPushTopic() == true) {
			deletePushTopic();
		}
		// Get the current list of task fields being used for monitoring
		// 	and assemble the query string
		MTL_myTaskListController.MTL_initializeTaskFields();
    	String pushTopicQueryString = 'SELECT ';
		pushTopicQueryString += MTL_myTaskListController.taskFieldPushTopicQuery;
        pushTopicQueryString += ' FROM Task';
		
		PushTopic myTaskListPushTopic = new PushTopic();
		myTaskListPushTopic.Name = pushTopicName;
		myTaskListPushTopic.Query = pushTopicQueryString;
		myTaskListPushTopic.ApiVersion = 30.0;
		myTaskListPushTopic.NotifyForOperationCreate = true;
		myTaskListPushTopic.NotifyForOperationUpdate = true;
		myTaskListPushTopic.NotifyForOperationUndelete = true;
		myTaskListPushTopic.NotifyForOperationDelete = true;
		myTaskListPushTopic.NotifyForFields = 'Referenced';
		try {
			insert myTaskListPushTopic;
		} catch (DmlException e) {
			// Push topic could not be added
	       	System.Debug('The following error has occurred: ' + e.getMessage());
			return false;
		}
			
		// Set the pushTopicEnabled flag and return true
		pushTopicEnabled = true;
		return true;
	}

	/*
		deletePushTopic - utility to remove the Streaming API push topic
			This function is not currently used, but is here in case removal is required
		Inputs: none
		Returns: Boolean
			- true if topic was deleted
			- false if topic was not found/deleted
	*/
	public static Boolean deletePushTopic() {
		List<PushTopic> oldMyTaskListPushTopics = new List<PushTopic>();
		oldMyTaskListPushTopics = Database.Query('SELECT p.Id, p.Name from PushTopic p where p.Name = :pushTopicName');
		if (oldMyTaskListPushTopics.size() > 0) {
			try {
				// Delete the old push topic(s)
				delete oldMyTaskListPushTopics;
				pushTopicEnabled = false;
				return true;
			} catch (DmlException e) {
				// Push topic could not be deleted
	        	System.Debug('The following error has occurred: ' + e.getMessage());
				return false;
			}
		}
		// The topic was not found/deleted, return false
		return false;
	}

	/*
		addPushTopicAction - action for commandButton to call to add the push topic
		Inputs: none
		Returns: PageReference null
	*/
	public static PageReference addPushTopicAction() {
		// Add the push topic
		Boolean pushStatus = addPushTopic();
		
		// Set a page message
		ApexPages.Message pushStatusMsg;
		if (pushStatus == true) {
			pushStatusMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Task listener was successfully added.');
		} else {
			pushStatusMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Task listener was not added.');
		}
        ApexPages.addMessage(pushStatusMsg);
        
		// Return null to stay on the same page
		return null;
	}
	
	/*
		deletePushTopicAction - action for commandButton to call to delete the push topic
		Inputs: none
		Returns: PageReference null
	*/
	public static PageReference deletePushTopicAction() {
		// Add the push topic
		Boolean pushStatus = deletePushTopic();
		
		// Set a page message
		ApexPages.Message pushStatusMsg;
		if (pushStatus == true) {
			pushStatusMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Task listener was successfully deleted.');
		} else {
			pushStatusMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Task listener was not deleted.');
		}
        ApexPages.addMessage(pushStatusMsg);
        
		// Return null to stay on the same page
		return null;
	}
	
}