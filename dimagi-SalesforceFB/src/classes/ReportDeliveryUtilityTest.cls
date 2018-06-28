@isTest(SeeAllData='true')
private class ReportDeliveryUtilityTest {
	
	
	static testMethod void testDeliverReport() {
		
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

	 	Report report = [SELECT Id, DeveloperName, ownerId FROM Report limit 1];
	 	
	 	Contact opp1 = new Contact(FirstName='Nicolas', LastName='Sapokas', Email='nicolas.sapokas@modelitsoftware.com', Phone = '1234567');
	 	insert opp1;
	 	Contact opp2 = new Contact(FirstName='Diego', LastName='Febles', Email='diego.febles@modelitsoftware.com', Phone = '7654321');
	 	insert opp2;
	 	Contact opp3 = new Contact(FirstName='Pablo', LastName='Vigil', Email='pablo.vigil@modelitsoftware.com', Phone = '1237654');
	 	insert opp3;
	 	
	 	controller.folderId = report.OwnerId;
	 	controller.reportId = report.Id;
	 	controller.filterId = 'CREATED';
	 	controller.EmailSubject='Test';
	 	controller.otherRecipient = 'nicolas.sapokas@modelitsoftware.com';
	 	
	 	controller.scheduleReport();
	 	
	 	Report_Delivery_Info__c deliveryInfo = [SELECT id,name, Job_Id__c , Report_Id__c, Email_Recipients__c, Field_Id__c FROM Report_Delivery_Info__c WHERE Report_Id__c=: report.Id];
	 	
	 	String jobId = deliveryInfo.Job_Id__c;
	 	
	 	ReportDeliveryUtility.deliverReport(jobId);	
		
	}
	

}