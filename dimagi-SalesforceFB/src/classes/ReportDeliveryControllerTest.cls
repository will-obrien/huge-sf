@isTest(SeeAllData='true')
private class ReportDeliveryControllerTest {
	
	private static Id folderId = null;
	
	private static void initData() {
		
		// select a folder with reports
		Map<Id, Folder> foldersMap =  new Map<Id, Folder>([select Id from Folder where (Type = 'Report' and Name != null) order by name]);
		
		List<Report> reports = [SELECT Id, OwnerId FROM Report WHERE OwnerId =: foldersMap.keySet() limit 1];
		System.assertEquals(1, reports.size());
		
		folderId = reports.get(0).OwnerId;	
	}
	
	static testMethod void testSendReportErrors() {
		
		initData();
		
		ReportDeliveryController controller = new ReportDeliveryController();
		
		//Send report with none of the required data
		controller.jobName = '';
		controller.otherRecipient = '';
		List<String> days = new List<String>();
		controller.preferredTime = 'None'; 
	 	controller.frequencyMonthly = '';
	 	controller.theMonth = '';
	 	controller.theMonthDay = '';
	 	controller.folderId = null;
	 	controller.reportId = null;
	 	controller.filterId = null;
	 	controller.otherRecipient = 'incorrectEmail';
	 	
	 	//select a stanrdar report
	 	Report report = [SELECT Id, DeveloperName, ownerId FROM Report limit 1];
	 	//insert data in the report
	 	Contact opp1 = new Contact(FirstName='Nicolas', LastName='Sapokas', Email='nicolas.sapokas@modelitsoftware.com', Phone = '1234567');
	 	insert opp1;
	 	Contact opp2 = new Contact(FirstName='Diego', LastName='Febles', Email='diego.febles@modelitsoftware.com', Phone = '7654321');
	 	insert opp2;
	 	Contact opp3 = new Contact(FirstName='Pablo', LastName='Vigil', Email='pablo.vigil@modelitsoftware.com', Phone = '1237654');
	 	insert opp3;
	 	
	 	controller.scheduleReport();
	 	
		System.assertEquals(controller.errorMsgs.get(0), controller.JOB_NAME_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(1), controller.PREFERRED_TIME_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(2), controller.FOLDER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(3), controller.REPORT_IS_REQUIRED_ERROR); 
		System.assertEquals(controller.errorMsgs.get(4), controller.FILTER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(5), controller.WEEKLY_FREQUENCY_REQUIRED_ERROR);
		//System.assertEquals(controller.errorMsgs.get(6), controller.OTHER_RECIPIENT_ERROR);
		
		//send the report with only job name of the required
		controller.jobName = 'testJob1234567';
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0), controller.PREFERRED_TIME_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(1), controller.FOLDER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(2), controller.REPORT_IS_REQUIRED_ERROR); 
		System.assertEquals(controller.errorMsgs.get(3), controller.FILTER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(4), controller.WEEKLY_FREQUENCY_REQUIRED_ERROR);
		
		//add the preferred time
		controller.preferredTime = '10';
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0), controller.FOLDER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(1), controller.REPORT_IS_REQUIRED_ERROR); 
		System.assertEquals(controller.errorMsgs.get(2), controller.FILTER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(3), controller.WEEKLY_FREQUENCY_REQUIRED_ERROR);
		
		//add folder
		controller.folderId = folderId;
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0), controller.REPORT_IS_REQUIRED_ERROR); 
		System.assertEquals(controller.errorMsgs.get(1), controller.FILTER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(2), controller.WEEKLY_FREQUENCY_REQUIRED_ERROR);
		
		//add report
		controller.reportId = report.Id;
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0), controller.FILTER_IS_REQUIRED_ERROR);
		System.assertEquals(controller.errorMsgs.get(1), controller.WEEKLY_FREQUENCY_REQUIRED_ERROR);
		
		//add filter
		controller.filterId = 'CREATED';
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0), controller.WEEKLY_FREQUENCY_REQUIRED_ERROR);
		
		//remove job name and add weekly frequency
		controller.jobName = '';
		days.add('1');
		days.add('2');
		controller.weeklyFrequency = days;
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0),controller.JOB_NAME_IS_REQUIRED_ERROR);
		
		//add job remove preferred time
		controller.jobName = 'testJob1234567';
		controller.preferredTime = 'none';
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0),controller.PREFERRED_TIME_IS_REQUIRED_ERROR);
		
		//add preferred time remove folder
		controller.preferredTime = '10';
		controller.folderId = null;
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0),controller.FOLDER_IS_REQUIRED_ERROR);
		
		//add folder remove report
		controller.folderId = report.OwnerId;
		controller.reportId = null;
		
		controller.scheduleReport();
		
		System.assertEquals(controller.errorMsgs.get(0),controller.REPORT_IS_REQUIRED_ERROR);
		
		//add report remove filter
		controller.reportId = report.Id;
		controller.filterId = null;
		
		controller.scheduleReport();
		System.assertEquals(controller.errorMsgs.get(0),controller.FILTER_IS_REQUIRED_ERROR); 
		 
		 
	} 
	
	
	static testMethod void testSendReport() {
		
		initData();
		
		ReportDeliveryController controller = new ReportDeliveryController();
		
		controller.jobName = 'testJob1234567';
		controller.otherRecipient = '';
		List<String> days = new List<String>();
		days.add('1');
		days.add('2');
		controller.weeklyFrequency = days;
		controller.preferredTime = '10'; 
	 	controller.frequencyMonthly = '';
	 	controller.theMonth = '';
	 	controller.theMonthDay = '';
	 	
	 	//select a stanrdar report
	 	Report report = [SELECT Id, DeveloperName, ownerId FROM Report limit 1];
	 	//insert data in the report
	 	Contact opp1 = new Contact(FirstName='Nicolas', LastName='Sapokas', Email='nicolas.sapokas@modelitsoftware.com', Phone = '1234567');
	 	insert opp1;
	 	Contact opp2 = new Contact(FirstName='Diego', LastName='Febles', Email='diego.febles@modelitsoftware.com', Phone = '7654321');
	 	insert opp2;
	 	Contact opp3 = new Contact(FirstName='Pablo', LastName='Vigil', Email='pablo.vigil@modelitsoftware.com', Phone = '1237654');
	 	insert opp3;
	 	
	 	System.debug('### folder: ' + folderId);
	 	controller.folderId = folderId;
	 	controller.reportId = report.Id;
	 	controller.filterId = 'CREATED';
	 	controller.EmailSubject='Test';
	 	controller.otherRecipient = 'nicolas.sapokas@modelitsoftware.com';
	 	
	 	controller.scheduleReport();
	 	System.debug('### errors: ' + controller.errorMsgs);
	 	System.assertEquals(controller.errorMsgs.size(), 0);
		
		Report_Delivery_Info__c deliveryInfo = [SELECT id,name, Job_Id__c , Report_Id__c, Email_Recipients__c, Field_Id__c FROM Report_Delivery_Info__c WHERE Report_Id__c=: report.Id];
	
		System.assertEquals(deliveryInfo.Report_Id__c, report.Id);
		System.assertNotEquals(deliveryInfo.Job_Id__c, null);
		System.assertEquals(deliveryInfo.Email_Recipients__c, 'nicolas.sapokas@modelitsoftware.com');
		//System.assertEquals(deliveryInfo.Field_Id__c, 'CREATED');
		
	}
	
	static testMethod void testGetFrequencySelectList() {
		ReportDeliveryController controller = new ReportDeliveryController();
		controller.getFrequencySelectList();
	}
	
	static testMethod void testGetFrequencyMonthlySelectList() {
		ReportDeliveryController controller = new ReportDeliveryController();
		controller.getFrequencyMonthlySelectList();
	}
	
	static testMethod void testGetWeeklyFrequencySelectedList() {
		ReportDeliveryController controller = new ReportDeliveryController();
		controller.getWeeklyFrequencySelectedList();
	}
	
	static testMethod void testGetTheMonthList() {
		ReportDeliveryController controller = new ReportDeliveryController();
		controller.getTheMonthList();
	}
	
	static testMethod void testGetMonthlyFrequencySelectedList() {
		ReportDeliveryController controller = new ReportDeliveryController();
		controller.getMonthlyFrequencySelectedList();
	}
	
	static testMethod void testGetPreferredTimeSelectedList() {
		ReportDeliveryController controller = new ReportDeliveryController();
		controller.getPreferredTimeSelectedList();
	}
	
	static testMethod void testGetFolderSelectList(){
		ReportDeliveryController controller = new ReportDeliveryController();
		controller.getFolderSelectList();
	}

}