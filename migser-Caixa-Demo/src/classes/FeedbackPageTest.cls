@isTest(SeeAllData=true)
private class FeedbackPageTest 
{
	@isTest static void runTest() 
	{
		ConvertFeedbackCtrl myFeedbackCtrl = new ConvertFeedbackCtrl();
		WorkFeedbackRequest req = new WorkFeedbackRequest(FeedbackType = 'UnsolicitedToUser');
		insert req;
		WorkFeedback feedback = new WorkFeedback(Feedback='1234 hello world');
		feedback.RequestId = req.id;
        insert feedback;
        
        

		Test.startTest();
        myFeedbackCtrl.convert();
        if(myFeedbackCtrl.jobDetailId == null) // no job scheduled, then schedule one
		{	
			myFeedbackCtrl.toggleScheduleJob();
			CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
					         FROM CronTrigger 
					         WHERE id = :myFeedbackCtrl.jobDetailId];
			// Verify the job has not run
			System.assertEquals(0, ct.TimesTriggered);
			SchedulableContext sc;
			ScheduleConvertWorkFeedback scheduleConv = new ScheduleConvertWorkFeedback();
			scheduleConv.execute(sc);
			
			SchConvertFeedbackBatch schConvertFeedbackBatch = new SchConvertFeedbackBatch(UserInfo.getUserEmail());
			Database.BatchableContext bc;
			List<sObject> feeds = [select Id, Feedback, stringValue__c, numericValue__c,FeedBackLastConvertDate__c From WorkFeedback Limit 10];
			schConvertFeedbackBatch.execute(bc, feeds);
		}

		//turn it off  after it's scheduled
		myFeedbackCtrl.toggleScheduleJob();
		Test.stopTest();
	}
}