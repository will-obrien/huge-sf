@isTest(SeeAllData=true)
private class WorkFeedbackTest {
	
	@isTest static void runTest() {
		testFeedback();
		testFeedbackRequest();
	}

	private static void testFeedback()
	{
		User u = WorkFeedbackActionGlobalCtrl.fetchMyUserInfo();
		List<User> users = WorkFeedbackActionGlobalCtrl.fetchAllUsers();
		User u2 = WorkFeedbackActionGlobalCtrl.fetchRecordInfoById([select id from Opportunity limit 1].Id);
		User u3 = WorkFeedbackActionGlobalCtrl.fetchRecordInfoById([select id from WorkGoal limit 1].Id);
		User u4 = WorkFeedbackActionGlobalCtrl.fetchRecordInfoById([select id from WorkPerformanceCycle limit 1].Id);
		List<User> u5 = WorkFeedbackActionGlobalCtrl.fetchFilteredUsers('Henry');
		//'feedbackObj.subjectid', 'feedbackObj.giverid', 'feedbackObj.feedbacktype', 'feedbackObj.feedbacktext', 'feedbackObj.relatedObjectId'
		String[] params = new String[]{'005C0000006BXYK', UserInfo.getUserId(), 'UnsolicitedToUserandManager', 'test',''}; 
		WorkFeedbackActionGlobalCtrl.saveFeedback(params);
		params = new String[]{'005C0000006BXYK', UserInfo.getUserId(), 'UnsolicitedToUserandManager', 'test',[select id from Opportunity limit 1].Id}; 
		WorkFeedbackActionGlobalCtrl.saveFeedback(params);
		WorkFeedbackActionGlobalCtrl.saveFeedback(params);
	}
	private static void testFeedbackRequest()
	{
		List<WorkFeedbackRequest> requests = WorkFeedbackActionGlobalCtrl.fetchMyFeedbackRequest();
		List<WorkFeedback> feedbacks = WorkFeedbackActionGlobalCtrl.fetchMyFeedbacks(requests[0].Id);
		List<WorkFeedbackQuestion> questions = WorkFeedbackActionGlobalCtrl.fetchMyFeedbackReqQues(requests[0].QuestionSetId);
		feedbacks = [select id,RequestId from WorkFeedback Limit 1];
		WorkFeedbackActionGlobalCtrl.saveDraftFeedbacks(feedbacks);
		WorkFeedbackActionGlobalCtrl.submitFeedbacks(feedbacks);
	}
	
	
}