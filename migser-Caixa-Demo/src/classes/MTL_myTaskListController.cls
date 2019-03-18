/*
	MTL_myTaskListController.cls - controller for myTaskList.page Visualforce page
		Provides a list of open tasks owned by the logged in user and methods to modify them
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
global with sharing class MTL_myTaskListController {
	// Static variable to limit SOQL query results in task queries
	private static final Integer TASK_QUERY_LIMIT = 50;

	// Static variable to hold the list of required fields for this package
	public static Set<String> packageRequiredFields = new Set<String>{'Id','OwnerId','ActivityDate','Subject','Priority','Status','WhoId','Who.Name','WhatId','What.Name','IsClosed','IsArchived','IsDeleted','IsRecurrence','IsReminderSet'};
	// Static variable to hold the list of required fields for this package for the PushTopic listener (excluding REFERENCE & TEXTAREA fields)
	public static Set<String> pushTopicRequiredFields = new Set<String>{'Id','OwnerId','ActivityDate','Subject','Priority','Status','WhoId','WhatId','IsClosed'};
    // Static variables to hold Task card field information
    public static String taskFieldQuery {get; private set;}
    public static String taskFieldPushTopicQuery {get; private set;}
    public static List<FieldContainer> taskCardRequiredFields {get; private set;}
    public static List<FieldContainer> taskCardHeaderFields {get; private set;}
    public static List<FieldContainer> taskCardDetailsFields {get; private set;}
	
	// Static variable to hold the list of unsafe data types that require XSS protection
	public static final Set<String> unsafeTypes = new Set<String>{'STRING','TEXTAREA','URL','COMBOBOX','EMAIL','ENCRYPTEDSTRING','MULTIPICKLIST','PHONE','PICKLIST'};

	// Member variable to hold the list of Tasks and related info
	public List<TaskContainer> myTaskList {get; private set;}

	// Member variables to hold task sorting onClick scripts
	public String orgHost {get; private set;}
	public String taskSortDateASCScript {get; private set;}
	public String taskSortDateDESCScript {get; private set;}
	public String taskSortPriorityScript {get; private set;}
    public String taskFilterAllOpenScript {get; private set;}
    public String taskFilterOverdueScript {get; private set;}
    public String taskFilterTodayScript {get; private set;}
    public String taskFilterTodayPlusOverdueScript {get; private set;}
    public String taskFilterTomorrowScript {get; private set;}
    public String taskFilterNext7DaysScript {get; private set;}
    public String taskFilterNext7DaysPlusOverdueScript {get; private set;}
    public String taskFilterThisMonthScript {get; private set;}

   	// pageFormat will store the type of page rendered and affect how URLs work
   	//	aloha [default] => aloha (standard) UI with standard hyperlinks
   	//	mobile = Salesforce1 browser => standard hyperlinks
   	//	console = sales/service cloud console => console javascript used to open hyperlinks
    public String pageFormat {get; private set;}
    
	/*
		Constructor to initialize the Task list including member variables and the list of Task sObjects
	*/
    public MTL_myTaskListController()
    {
    	/*
    		Initialize the page format to determine if this is the console, Salesforce1 mobile, or Aloha UI
    	*/
    	// Determine the page rendering location (default to aloha)
    	String pageisdtp = 'aloha';
    	if (ApexPages.currentPage() != null) {
			pageisdtp = ApexPages.currentPage().getParameters().get('isdtp');
    	}
		if (pageisdtp == 'nv' || pageisdtp == 'vw') {
			pageFormat = 'console';
		} else if (pageisdtp == 'p1') {
			pageFormat = 'mobile';	
		} else {
			pageFormat = 'aloha';
		}

    	/*
    		Initialize the sort and filter onClick scripts
    	*/
    	// Get the current task sort order and filter from the page GET parameters
    	String getSortOrder;
    	if (ApexPages.currentPage() != null) {
    		getSortOrder = ApexPages.currentPage().getParameters().get('so');
    	}
    	if (getSortOrder == '' || getSortOrder == null) getSortOrder = 'dateASC';
    	String getFilter;
    	if (ApexPages.currentPage() != null) {
    		getFilter = ApexPages.currentPage().getParameters().get('flt');
    	}
    	if (getFilter == '' || getFilter == null) getFilter = 'allopen';
		// Set the base URL for this page
		orgHost = calculateOrgHost();
        String thisPage = orgHost + System.URL.getCurrentRequestUrl().getPath();
    	// Initialize the sort onClick scripts
    	taskSortDateASCScript = 'https://' + thisPage + '?so=dateASC&flt=' + getFilter + '&isdtp=' + pageisdtp;
    	taskSortDateDESCScript = 'https://' + thisPage + '?so=dateDESC&flt=' + getFilter + '&isdtp=' + pageisdtp;
    	taskSortPriorityScript = 'https://' + thisPage + '?so=priorityDESC&flt=' + getFilter + '&isdtp=' + pageisdtp;
    	// Initialize the filter onClick scripts
        taskFilterAllOpenScript ='https://' + thisPage + '?flt=allopen&so=' + getSortOrder + '&isdtp=' + pageisdtp;
        taskFilterOverdueScript ='https://' + thisPage + '?flt=overdue&so=' + getSortOrder + '&isdtp=' + pageisdtp;
        taskFilterTodayScript ='https://' + thisPage + '?flt=today&so=' + getSortOrder + '&isdtp=' + pageisdtp;
        taskFilterTodayPlusOverdueScript ='https://' + thisPage + '?flt=todayplusoverdue&so=' + getSortOrder + '&isdtp=' + pageisdtp;
        taskFilterTomorrowScript ='https://' + thisPage + '?flt=tomorrow&so=' + getSortOrder + '&isdtp=' + pageisdtp;
        taskFilterNext7DaysScript ='https://' + thisPage + '?flt=next7days&so=' + getSortOrder + '&isdtp=' + pageisdtp;
        taskFilterNext7DaysPlusOverdueScript ='https://' + thisPage + '?flt=next7daysplusoverdue&so=' + getSortOrder + '&isdtp=' + pageisdtp;
        taskFilterThisMonthScript ='https://' + thisPage + '?flt=thismonth&so=' + getSortOrder + '&isdtp=' + pageisdtp;

    	// Default to ascending by activity date (i.e. due date) (to put closest due dates on top)
    	// 	and then ascending by priority (to put high on top)
    	String taskSortOrder;
    	if (getSortOrder == 'dateDESC') {
    		taskSortOrder = 't.ActivityDate DESC, t.Priority DESC';
    	} else if (getSortOrder == 'priorityDESC') {
    		taskSortOrder = 't.Priority DESC, t.ActivityDate ASC';
    	} else {
    		taskSortOrder = 't.ActivityDate ASC, t.Priority DESC';
    	}
    	// Get the task filter from the page GET parameters
    	// Default to all open
    	String taskFilter;
    	if (getFilter == 'overdue') {
    		taskFilter = ' AND t.ActivityDate < TODAY';
    	} else if (getFilter == 'today') {
    		taskFilter = ' AND t.ActivityDate = TODAY';
    	} else if (getFilter == 'todayplusoverdue') {
    		taskFilter = ' AND t.ActivityDate <= TODAY';
    	} else if (getFilter == 'tomorrow') {
    		taskFilter = ' AND t.ActivityDate = TOMORROW';
    	} else if (getFilter == 'next7days') {
    		taskFilter = ' AND t.ActivityDate = NEXT_N_DAYS:7';
    	} else if (getFilter == 'next7daysplusoverdue') {
    		taskFilter = ' AND (t.ActivityDate < TODAY OR t.ActivityDate = NEXT_N_DAYS:7)';
    	} else if (getFilter == 'thismonth') {
    		taskFilter = ' AND t.ActivityDate = THIS_MONTH';
    	} else {
    		// default all open
    		taskFilter = '';
    	}
    	
    	/*
    		Initialize the list of tasks
    	*/
    	// Initialize the task field lists
    	if (taskFieldQuery == null) {
    		MTL_initializeTaskFields();
    	}
    	
        // Create a activity wrapper sObject to contain the Task + Account info
    	myTaskList = new List<TaskContainer>();

    	// Generate a list of all Tasks assigned to (via OwnerId) the logged in user
    	String myTaskQueryString = 'SELECT ';
		myTaskQueryString += taskFieldQuery;
        myTaskQueryString += ' FROM Task t';
		myTaskQueryString += ' WHERE t.IsClosed = false';
		myTaskQueryString += ' AND t.OwnerID = \'' + UserInfo.getUserId() + '\'';
		myTaskQueryString += taskFilter;
		myTaskQueryString += ' ORDER BY ' + taskSortOrder;
		myTaskQueryString += ' LIMIT ' + TASK_QUERY_LIMIT;
		List<Task> myTasks = new List<Task>(); 
		try {
			myTasks = Database.query(myTaskQueryString);
		} catch (DmlException e) {
			System.debug(LoggingLevel.ERROR, e.getMessage());
			return;
		}
		
        // Fill member variable myTaskList with the user's events
        if (myTasks.size() > 0) {
        	for(Task t : myTasks) {
        		myTaskList.add( new TaskContainer(t,this) );
        	}
        }
    }

	/*
		TaskContainer - class for storing Task sObject & related information
	*/
    public class TaskContainer {
    	// Getter/Setter for the contained Task sObject
        public Task taskSObject {get; private set;}
        // Member variable for the header CSS class addition of a card when the priority is high
        public String priorityPanelClass {get; private set;}
        // Member variable for the header CSS class addition of a card when the priority is high
        public String priorityIconClass {get; private set;}
        // Member variable for the CSS class addition to highlight the task due date
        public String dueDateStyle {get; private set;}

        // Overloaded constructor to initialize the date when given an Task
        public TaskContainer(Task t, MTL_myTaskListController theController) {
            taskSObject = t;
			/*
				Initialize various UI features such as formatting options for this task
			*/
            // Define the CSS class addition for the panel based on case priority; by default, no modification is made
            priorityPanelClass = '';
            // Define the CSS class addition based on case priority; by default, the priority icon is hidden
            priorityIconClass = 'hidden';
            // Define the CSS class addition based on due date; by default, no modification is made
            dueDateStyle = '';

            if (t.Priority == 'High') {
	            // If priority is high, apply Bootstrap CSS class for a red panel header
            	priorityPanelClass = ' panel-danger';
	            // If priority is high, do not apply the hidden class
            	priorityIconClass = '';
            }
            if (t.ActivityDate <= System.Date.today()) {
	            // If the ActivityDate is <= today, apply Bootstrap CSS class text class for red text
            	dueDateStyle = 'text-danger';
            }
        }
    }

	/*
		FieldContainer - class for storing Task field info for use in the VisualForce page
	*/
    public class FieldContainer {
    	// Field's label
    	public String fieldLabel {get; private set;}
    	// Field's Apex data type
    	public Schema.DisplayType fieldType {get; private set;}
    	// Field's name
    	public String fieldName {get; private set;}
    	// Needs JSENCODING - true if this is a text type field; false if this is a 'safe' type of field
    	public Boolean needsEncoding {get; private set;} 
    	
        // Overloaded constructor to initialize the field information when given an admin requested field (FieldSetMember)
        public FieldContainer(Schema.FieldSetMember f) {
			if (f != null) {
	        	fieldLabel = f.getLabel();
    	    	fieldType = f.getType();
        		fieldName = f.getFieldPath();
        		setNeedsEncoding(fieldType);
			}
        }
        
        // Overloaded constructor to initialize the field information when given a required field (SObjectField)
		public FieldContainer(Schema.SObjectField f) {
			if (f != null) {
	        	fieldLabel = f.getDescribe().getLabel();
    	    	fieldType = f.getDescribe().getType();
        		fieldName = f.getDescribe().getName();
        		setNeedsEncoding(fieldType);
			}
		}
		
		// Determine if a field will need JSENCODE in Visualforce based on the field type 
		//	This is a means of protecting against XSS vulerabilities
		//	JSENCODE cannot be applied to all fields and throws an error if it does not receive a text field
		private void setNeedsEncoding(Schema.DisplayType fieldType) {
			String fieldTypeString = fieldType.name().toUpperCase();
			if (unsafeTypes.contains(fieldTypeString)) {
				needsEncoding = true;
			} else {
				needsEncoding = false;
			}
		}
    }

	/*
		calculateOrgHost - return the Salesforce host name (POD.salesforce.com or MYDOMAIN.my.salesforce.com)
		Inputs: none
		Returns: String thisOrgHost
	*/
	static String calculateOrgHost() {
		String thisOrgHost;
		String baseURLHost = System.URL.getSalesforceBaseUrl().getHost();
		// Split up the derived hostname using the period as a delimiter
		List<String> urlParts = baseURLHost.replace('-api','').split('\\.');
       	if (urlParts.size() == 3) thisOrgHost = urlParts[0] + '.salesforce.com';  // Salesforce base URL
       	else if (urlParts.size() == 4 && urlParts[1] == 'my') thisOrgHost = baseURLHost; // MyDomain base URL
       	else if (urlParts.size() == 5 && urlParts[2] == 'my') thisOrgHost = baseURLHost; // Sandbox MyDomain base URL
       	else if (urlParts.size() == 5) thisOrgHost = urlParts[1] + '.salesforce.com'; // Visualforce base URL
        return thisOrgHost;
	}
	
	/*
		MTL_initializeTaskFields - parse the MTL field sets to get field information required
			for processing fields in the Task card header and details, including the SOQL
			field liststring
		Inputs: None
		Returns: None
	*/
	public static void MTL_initializeTaskFields() {
		// Get the admin chosen fields from the MTL card header & detail field sets
		List<Schema.FieldSetMember> adminHeaderFields = new List<Schema.FieldSetMember>();
		if (Schema.SObjectType.Task.fieldSets.getMap().get('MTL_Card_Header') != null) {
			adminHeaderFields = Schema.SObjectType.Task.fieldSets.getMap().get('MTL_Card_Header').getFields();
		}
		List<Schema.FieldSetMember> adminDetailsFields = new List<Schema.FieldSetMember>();
		if (Schema.SObjectType.Task.fieldSets.getMap().get('MTL_Card_Details') != null) {
			adminDetailsFields = Schema.SObjectType.Task.fieldSets.getMap().get('MTL_Card_Details').getFields();
		}

		// Initialize the controller static variables that will hold the header & details field lists
		taskCardRequiredFields = new List<FieldContainer>();
		taskCardHeaderFields = new List<FieldContainer>();
		taskCardDetailsFields = new List<FieldContainer>();
		

		/*
			Add the package required and admin chosen (field set) fields to the controller static variables
			Also, collect them into a Set in preparation for SOQL query string creation
		 	Seed the Set with the fields required by this application for the SOQL search
			Also, collect the non-relationship fields into a Set in preparation for pushTopic creation
		*/
    	taskFieldQuery = '';
		taskFieldPushTopicQuery = '';
		Set<String> queryFields = new Set<String>(packageRequiredFields);
		Set<String> pushTopicFields = new Set<String>(pushTopicRequiredFields);
		// Add required fields to the controller static Set
		Map<String, Schema.SObjectField> allTaskFields = Schema.SObjectType.Task.fields.getMap(); 
		for (String rf: packageRequiredFields) {
			Schema.SObjectField thisTaskField = allTaskFields.get(rf);
			if(thisTaskField != null ) {
				taskCardRequiredFields.add( new FieldContainer(thisTaskField) );
			}
		}

		// Add optional (push topic) header fields to the temporary Set and pushTopics SOQL list
		String thisFieldType = '';
		for (Schema.FieldSetMember hf : adminHeaderFields) {
			thisFieldType = hf.getType().name().toUpperCase();
			// Exclude Encrypted fields to eliminate data exposure
			if (thisFieldType != 'ENCRYPTEDSTRING') {
				queryFields.add(hf.getFieldPath());
    	   		taskCardHeaderFields.add( new FieldContainer(hf) );
			}
			// If this is not an unsupported PushTopic field type (references, text area, & relationships),
			// add it to the pushTopic field list
			if (thisFieldType != 'REFERENCE' && thisFieldType != 'TEXTAREA' && !hf.getFieldPath().contains('.')) {
				pushTopicFields.add(hf.getFieldPath());
			}
		}
		// Add optional (push topic) details fields to the temporary Set and pushTopics SOQL list
		for (Schema.FieldSetMember df : adminDetailsFields) {
			thisFieldType = df.getType().name().toUpperCase();
			if (thisFieldType != 'ENCRYPTEDSTRING') {
				// Exclude Encrypted fields to eliminate data exposure
				queryFields.add(df.getFieldPath());
    	   		taskCardDetailsFields.add( new FieldContainer(df) );
			}
			// If this is not an unsupported PushTopic field type (references, text area, & relationships),
			// add it to the pushTopic field list
			if (thisFieldType != 'REFERENCE' && thisFieldType != 'TEXTAREA' && !df.getFieldPath().contains('.')) {
				pushTopicFields.add(df.getFieldPath());
			}
		}
		
		// Add the required and field set fields to the SOQL query string
		for (String qf : queryFields) {
			taskFieldQuery += qf + ',';
		}
		// Add required and field set fields to the pushTopic SOQL string
		for (String ptqf : pushTopicFields) {
			taskFieldPushTopicQuery += ptqf + ',';
		}
		// Strip the trailing commas (,)
		taskFieldQuery = taskFieldQuery.removeEnd(',');
		taskFieldPushTopicQuery = taskFieldPushTopicQuery.removeEnd(',');
	}
	
	/*
		Remoting method to update a Task record
		Inputs:
		- ID recordID - ID of the record to update
		- String targetField - API name of the field to update (null if just getting the updated task from the DB)
		- String newValue - new value to store in targetField (null if just getting the updated task from the DB)
		Returns:
		- Task - the updated Task sObject
	*/
	@RemoteAction
	global static Task updateTask(ID recordID, String targetField, String newValue) {
		// Get the sObject from the input recordID
    	if (taskFieldQuery == null) {
    		MTL_initializeTaskFields();
    	}
    	String thisTaskQueryString = 'SELECT ';
		thisTaskQueryString += taskFieldQuery;
		thisTaskQueryString += ' FROM Task t';
		thisTaskQueryString += ' WHERE t.Id = \'' + recordID + '\'';
		thisTaskQueryString += ' LIMIT 1';
		thisTaskQueryString += ' ALL ROWS';
		Task thisTask;
		try {
			thisTask = Database.query(thisTaskQueryString);
		} catch (DmlException e) {
			System.debug(LoggingLevel.ERROR, e.getMessage());
			return null;
		}

		// Determine if we should perform the DML update operation; by default, do not unless we get a valid targetField
		Boolean performDML = false;
		// Determine if the record needs to be requeried when finished; by default, it will not be
		Boolean reQueryRecord = false;
		
		// Update the appropriate targetField
		if (targetField == 'Status') {
			thisTask.Status = newValue;
			// Trigger the DML update
			performDML = true;
			// Trigger querying the sObject again to ensure calculated field IsClosed is up to date
			reQueryRecord = true;
		} else if (targetField == 'Priority') {
			thisTask.Priority = newValue;
			// Trigger the DML update
			performDML = true;
		} else if (targetField == null || targetField == '') {
			// Reiterate no DML update and no requery; just passing the object back
			performDML = false;
			reQueryRecord = false;
		} else {
			System.debug(LoggingLevel.ERROR, 'ERROR: Unknown targetField was passed');
			return null;
		}
		
		// Perform the DML update
		if (performDML) {
			try {
				update thisTask;	
			} catch (DmlException e) {
				System.debug(LoggingLevel.ERROR, e.getMessage());
				return null;
			}
		}

		// Get the sObject again to ensure calculated fields cush as IsClosed are up to date
		if (reQueryRecord) {
			try {
				thisTask = Database.query(thisTaskQueryString);
			} catch (DmlException e) {
				System.debug(LoggingLevel.ERROR, e.getMessage());
				return null;
			}
		}
		
		// Return the Task sObject
		return thisTask;
	}
	
	/*
		MTL_formatFieldValue - Format the a record's field for text display with consideration for
			URLs, Times, etc.
		Inputs:
			- String fieldLabel - label of the field
			- Object fieldValue - value of the field (from sObject.get(fieldName))
			- String fieldType - Salesforce data type for the field (from sObject.get(fieldName).fieldType.name())
			- String outputStyle:
				- 'EMAILHTML' - format output string for HTML e-mail
				- 'EMAILPLAIN' - format output string for plain text e-mail
		Returns:
			- String - a string to display the field's value
	*/
	public static String MTL_formatFieldValue(String fieldLabel, Object fieldValue, String fieldType, String outputStyle) {
		// Initial cleanup
		outputStyle = outputStyle.toUpperCase();

		// Ensure fieldType is all caps for comparison purposes
		fieldType = fieldType.toUpperCase();
		// Initialize the return string
		String returnString = '';

		// Get the base URL for object links
		String orgHost = calculateOrgHost();
		String baseURL = 'https://' + orgHost + '/';

		// Set the field label styling
		String fieldLabelPrefix = '';
		String fieldLabelSuffix = ': ';
		String lineSuffix = '\n';
		if(outputStyle == 'EMAILHTML') {
			fieldLabelPrefix = '<b>';
			fieldLabelSuffix = ':</b> ';
			lineSuffix = '<br />\n';
		}
		String fieldValuePrefix = '';
		String fieldValueSuffix = '';
		
		// Perform XSS protection on unsafe fields
		if (unsafeTypes.contains(fieldType)) {
			String fieldValueClean = (String)fieldValue;
			fieldValueClean = fieldValueClean.replace('<','&lt;');
			fieldValueClean = fieldValueClean.replace('>','&gt;');
			fieldValueClean = fieldValueClean.replace('"','&quot;');
			fieldValueClean = fieldValueClean.replace('\'','&#39;');
			fieldValue = fieldValueClean;
		}
		
		// Clean up field type values as necessary and add to e-mail body
		if (fieldType == 'TEXTAREA') {
			// Convert carriage returns in TEXTAREA fields to HTML line breaks
			String thisTextAreaClean = (String)fieldValue;
			if (outputStyle == 'EMAILHTML') {
				thisTextAreaClean = thisTextAreaClean.replace('\r','<br />');
			}
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + thisTextAreaClean + fieldValueSuffix + lineSuffix;
		} else if (fieldType == 'DATE') {
			// Format date for User's locale
			Date thisDate = (Date)fieldValue;
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + thisDate.format() + fieldValueSuffix + lineSuffix;
		} else if (fieldType == 'DATETIME') {
			// Format datetime for User's locale
			Datetime thisDate = (Datetime)fieldValue;
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + thisDate.format() + fieldValueSuffix + lineSuffix;
		} else if (fieldType == 'EMAIL') {
			// Add a mailto link to e-mail fields
			if (outputStyle == 'EMAILHTML') {
				fieldValuePrefix = '<a href="mailto:' + fieldValue + '">';
				fieldValueSuffix = '</a>';
			}
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + fieldValue + fieldValueSuffix + lineSuffix;
		} else if (fieldType == 'URL') {
			// Add a hyperlink to URL fields
			if (outputStyle == 'EMAILHTML') {
				fieldValuePrefix = '<a href="' + baseURL + fieldValue + '">';
				fieldValueSuffix = '</a>';
			}
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + fieldValue + fieldValueSuffix + lineSuffix;
		} else if (fieldType == 'REFERENCE') {
			// Add a hyperlink to Lookup (Reference) fields
			if (outputStyle == 'EMAILHTML') {
				fieldValuePrefix = '<a href="' + baseURL + fieldValue + '">';
				fieldValueSuffix = '</a>';
			}
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + fieldValue + fieldValueSuffix + lineSuffix;
		} else if (fieldType == 'PERCENT') {
			// Add a percent sign (%) to percent fields
			fieldValueSuffix = '%';
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + fieldValue + fieldValueSuffix + lineSuffix;
		} else if (fieldType == 'ENCRYPTEDSTRING') {
			// Intentionally skip encrypted fields to prevent export of encrypted data
		} else {
        	returnString = fieldLabelPrefix + fieldLabel + fieldLabelSuffix + fieldValuePrefix + fieldValue + fieldValueSuffix + lineSuffix;
		}

		return returnString;
	}

	/*
		emailTask - Remoting method to send a task to the logged in User via e-mail
		Inputs:
		- ID recordID - ID of the record to send
		Returns:
		- Boolean success - true if the mail send was successful / false if there is a sending exception
	*/
	@RemoteAction
	global static Boolean emailTask(ID recordID) {
		// Get the sObject from the input recordID
    	if (taskFieldQuery == null) {
    		MTL_initializeTaskFields();
    	}
    	String thisTaskQueryString = 'SELECT ';
		thisTaskQueryString += taskFieldQuery;
		thisTaskQueryString += ' FROM Task t';
		thisTaskQueryString += ' WHERE t.Id = \'' + recordID + '\'';
		thisTaskQueryString += ' LIMIT 1';
		thisTaskQueryString += ' ALL ROWS';
		Task thisTask;
		try {
			thisTask = Database.query(thisTaskQueryString);
		} catch (DmlException e) {
			System.debug(LoggingLevel.ERROR, e.getMessage());
			return false;
		}

		// If the task was not found, return false
		if(thisTask == null) {
			return false;
		}

		// Get the base URL for object links
		String orgHost = calculateOrgHost();
		String thisTaskBaseURL = 'https://' + orgHost + '/';

		/*
			Construct the e-mail reminder message
		*/
		// Send the message to the current user and set appropriate messaging defaults
		// use setTargetObjectId instead of setToAddressses to avoid SingleEmailMessage governer limit
		Messaging.SingleEmailMessage thisMail = new Messaging.SingleEmailMessage();
        thisMail.setTargetObjectId(UserInfo.getUserId());
        thisMail.setSaveAsActivity(false);
        thisMail.setUseSignature(false);
		// Set the e-mail subject
        String thisSubject = 'REMINDER: ' + thisTask.Subject;
        thisMail.setSubject(thisSubject);
        // Construct the e-mail HTML and Plain Text bodies

		// Mail task header section
        String thisHTMLBody = 'Reminder for task: <a href="' + thisTaskBaseURL + thisTask.Id + '">' + thisTask.Subject + '</a><br /><br />\n';
        String thisPlainTextBody = 'Reminder for task: ' + thisTask.Subject + ' (' + thisTaskBaseURL + thisTask.Id + ')\n\n';
        if (thisTask.ActivityDate != null) {
        	thisHTMLBody += '<b>Due:</b> ' + thisTask.ActivityDate.format() + '<br />\n';
        	thisPlainTextBody += 'Due: ' + thisTask.ActivityDate.format() + '\n';
        }
        if (thisTask.whatId != null) {
        	thisHTMLBody += '<b>RE:</b> <a href="' + thisTaskBaseURL + thisTask.WhatId + '">' + thisTask.What.Name + '</a><br />';
        	thisPlainTextBody += 'RE: ' + thisTask.What.Name + ' (' + thisTaskBaseURL + thisTask.WhatId + ')\n';
        }
        // Additional, optional (field set) task card header fields
		for (FieldContainer fh: taskCardHeaderFields) {
			// Test for and skip relationship fields (Object.Field)
			Integer thisDotLocation = fh.fieldName.indexOf('.');
			if (thisDotLocation == -1) {
				if (thisTask.get(fh.fieldName) != null) {
					thisHTMLBody += MTL_formatFieldValue(fh.fieldLabel, thisTask.get(fh.fieldName), fh.fieldType.name(), 'EMAILHTML');
					thisPlainTextBody += MTL_formatFieldValue(fh.fieldLabel, thisTask.get(fh.fieldName), fh.fieldType.name(), 'EMAILPLAIN');
				}
			}
		}
		// Separator for the header & details section
		thisHTMLBody += '<br />\n';
		thisPlainTextBody += '\n';
		
		// Mail task details section
		if (thisTask.WhoId != null) {
        	thisHTMLBody += '<b>Who:</b> <a href="' + thisTaskBaseURL + thisTask.WhoId + '">' + thisTask.Who.Name + '</a><br />\n';
        	thisPlainTextBody += 'Who: ' + thisTask.Who.Name + ' (' + thisTaskBaseURL + thisTask.WhoId + ')\n';
		}
        // Additional, optional (field set) task card details fields
		for (FieldContainer fd: taskCardDetailsFields) {
			// Test for and skip relationship fields (Object.Field)
			Integer thisDotLocation = fd.fieldName.indexOf('.');
			if (thisDotLocation == -1) {
				if (thisTask.get(fd.fieldName) != null) {
					thisHTMLBody += MTL_formatFieldValue(fd.fieldLabel, thisTask.get(fd.fieldName), fd.fieldType.name(), 'EMAILHTML');
					thisPlainTextBody += MTL_formatFieldValue(fd.fieldLabel, thisTask.get(fd.fieldName), fd.fieldType.name(), 'EMAILPLAIN');
				}
			}
		}
        // Assemble the mail
        thisMail.setHtmlBody(thisHTMLBody);
        thisMail.setPlainTextBody(thisPlainTextBody);
        // Send the mail
        try {
        	Messaging.SendEmailresult[] mailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { thisMail }); 
        } catch (System.EmailException e) {
        	System.Debug('The following error has occurred: ' + e.getMessage());
        	return false;
        }
		
		return true;
	}
}