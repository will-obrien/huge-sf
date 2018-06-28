/*
Copyright (c) 2011, salesforce.com, Inc.
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

global with sharing class WorkFeedbackActionGlobalCtrl {

	//return the current user info
    @RemoteAction
    global static User fetchMyUserInfo(){
        List<User> user = [ select id, name, SmallPhotoUrl, ManagerId
                            from User 
                            where Id = :UserInfo.getUserId() LIMIT 1];
        if(user.isEmpty())
            return null;
        else
            return user[0];
    }

    /************ Only Support Goal, Performance Cycle, and Opportunity ***********/
    //get the owner id of the record
    @RemoteAction
    global static User fetchRecordInfoById(String recordId){
        List<User> owner;
        if(recordId.substring(0,3) == '0WE') //Goal
        {
        	WorkGoal goal = [ select OwnerId
	                        	from WorkGoal 
	                        	where Id = :recordId LIMIT 1];
        	owner = [select Id, Name, FirstName FROM User WHERE id = :goal.OwnerId LIMIT 1];
        }
        else if(recordId.substring(0,3) == '0W7') //Performance Cycle
        {
        	WorkPerformanceCycle cycle = [ select OwnerId
				                        	from WorkPerformanceCycle 
				                        	where Id = :recordId LIMIT 1];
        	owner = [select Id, Name, FirstName FROM User WHERE id = :cycle.OwnerId LIMIT 1];
        }
        else if(recordId.substring(0,3) == '006') //Opportunity
		{
			Opportunity oppty = [ select OwnerId
		                        	from Opportunity 
		                        	where Id = :recordId LIMIT 1];
        	owner = [select Id, Name, FirstName FROM User WHERE id = :oppty.OwnerId LIMIT 1];
		}
  		//else if(recordId.substring(0,3) == '005') //User
		//{
		//owner = [select Id, Name, FirstName FROM User WHERE id = :recordId LIMIT 1];
		//}

        if(owner == null || owner.isEmpty())
            return null;
        else
            return owner[0];
    }


    @RemoteAction
    global static List<User> fetchAllUsers()
    {
        List<User> allUsers =  [select Id, Name, FirstName, SmallPhotoUrl, ManagerId
								from User 
								where isActive = true
								order by Name ASC];
        if(allUsers.isEmpty())
            return null;
        else
            return allUsers;
    }

    @RemoteAction
    global static List<User> fetchFilteredUsers(String searchText)
    {
    	String condition = searchText+'%';
        List<User> allUsers =  [select Id, Name, FirstName, SmallPhotoUrl, ManagerId 
								from User 
								where isActive = true
								and Name like :condition
								and id != :UserInfo.getUserId()
								order by Name ASC
								LIMIT 1000];
        if(allUsers.isEmpty())
            return null;
        else
            return allUsers;
    }

    @RemoteAction
    global static void saveFeedback(List<String> param)
	{
		String subjectid = param[0];
		String giverId = param[1];
		String feedbackType = param[2];
		String feedbackText = param[3];
		String relatedObjId = param[4];

		//if user typed out the name, then do a lookup
		if(subjectid != null && subjectid != '')
		{	
			WorkFeedbackQuestionSet questionSet = new WorkFeedbackQuestionSet();
			questionSet.OwnerId = giverId;
			questionSet.Name = 'Direct Feedback '+System.Now()+' '+subjectid;
			
			if(Schema.sObjectType.WorkFeedbackQuestionSet.fields.OwnerId.isCreateable() && Schema.sObjectType.WorkFeedbackQuestionSet.fields.Name.isCreateable())
			{	
				try{
					insert questionSet;
				} catch (DmlException e) {
					// Process exception here
				}
			}
			else
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
			}
			WorkFeedbackRequest request = new WorkFeedbackRequest();
			request.OwnerId = giverId; //whoever created the feedback;
			request.RecipientId = giverId; //whoever requested the feedback
			request.SubjectId = subjectid;
			request.feedbackType = feedbackType;
			request.FeedbackRequestState = 'Draft';
			request.QuestionSetId = questionSet.Id;
			if( relatedObjId != '' && (relatedObjId.substring(0,3) == '0WE' || relatedObjId.substring(0,3) == '0W7' || relatedObjId.substring(0,3) == '006') )//if there is a related object and it's either goal, performance cycle, or opportunty
				request.RelatedObjectId = relatedObjId;
			
			if( Schema.sObjectType.WorkFeedbackRequest.fields.OwnerId.isCreateable() && Schema.sObjectType.WorkFeedbackRequest.fields.RecipientId.isCreateable() &&
				Schema.sObjectType.WorkFeedbackRequest.fields.SubjectId.isCreateable() && Schema.sObjectType.WorkFeedbackRequest.fields.feedbackType.isCreateable() &&
				Schema.sObjectType.WorkFeedbackRequest.fields.FeedbackRequestState.isCreateable() && Schema.sObjectType.WorkFeedbackRequest.fields.QuestionSetId.isCreateable() &&
				Schema.sObjectType.WorkFeedbackRequest.fields.RelatedObjectId.isCreateable())
			{	
				try{
					insert request;
				} catch (DmlException e) {
					// Process exception here
				}
			}

			WorkFeedback feedback = new WorkFeedback();
			feedback.OwnerId = giverId; //ownerid is whoever created the feedback;
			System.debug(request.id);
			feedback.RequestId = request.id;
			feedback.Feedback = feedbackText;
			if( Schema.sObjectType.WorkFeedback.fields.OwnerId.isCreateable() && Schema.sObjectType.WorkFeedback.fields.RequestId.isCreateable() &&
				Schema.sObjectType.WorkFeedback.fields.Feedback.isCreateable() )
			{	
				try{
					insert feedback;
				} catch (DmlException e) {
					// Process exception here
				}
			}

			List<SObject> sharingRules = new List<SObject>();
			//sharing feedback question set, feedback request, feedback
			if(request.feedbackType == 'UnsolicitedToManager' || request.feedbackType == 'UnsolicitedToUserandManager') //if share with manager
			{
				
				//grab manager user id
				List<User> manager = [select ManagerId from User where Id = :subjectId Limit 1];
				if(!manager.isEmpty()) //if there is a manager, then share
				{
					if(manager[0].ManagerId != giverId) //if manager is not myself, giver id
	                {
						//share feedback question set
						WorkFeedbackQuestionSetShare quesSet = new WorkFeedbackQuestionSetShare();
						quesSet.ParentId = questionSet.Id;
						quesSet.AccessLevel = 'Read';
						quesSet.UserOrGroupId = manager[0].ManagerId;
						sharingRules.add(quesSet);
						//dataInsert(quesSet);

						//share feedback request
						WorkFeedbackRequestShare newRequestShare = new WorkFeedbackRequestShare();
						newRequestShare.ParentId = request.Id;
						newRequestShare.AccessLevel = 'Read';
						newRequestShare.UserOrGroupId = manager[0].ManagerId;
						sharingRules.add(newRequestShare);
						//dataInsert(newRequestShare);

						//share feedback
						WorkFeedbackShare newFeedbackShare = new WorkFeedbackShare();
						newFeedbackShare.ParentId = feedback.Id;
						newFeedbackShare.AccessLevel = 'Read';
						newFeedbackShare.UserOrGroupId = manager[0].ManagerId;
						sharingRules.add(newFeedbackShare);
						//dataInsert(newFeedbackShare);
					}
				}
			}
			if(request.feedbackType == 'UnsolicitedToUser' || request.feedbackType == 'UnsolicitedToUserandManager') //if share with user
			{
				//share feedback question set
				WorkFeedbackQuestionSetShare quesSet = new WorkFeedbackQuestionSetShare();
				quesSet.ParentId = questionSet.Id;
				quesSet.AccessLevel = 'Read';
				quesSet.UserOrGroupId = request.SubjectId;
				sharingRules.add(quesSet);
				//dataInsert(quesSet);

				//share feedback request
				WorkFeedbackRequestShare newRequestShare = new WorkFeedbackRequestShare();
				newRequestShare.ParentId = request.Id;
				newRequestShare.AccessLevel = 'Read';
				newRequestShare.UserOrGroupId = request.SubjectId;
				sharingRules.add(newRequestShare);
				//dataInsert(newRequestShare);

				//share feedback
				WorkFeedbackShare newFeedbackShare = new WorkFeedbackShare();
				newFeedbackShare.ParentId = feedback.Id;
				newFeedbackShare.AccessLevel = 'Read';
				newFeedbackShare.UserOrGroupId = request.SubjectId;
				sharingRules.add(newFeedbackShare);
				//dataInsert(newFeedbackShare);
			}
			if(!sharingRules.isEmpty())
				dataInsert(sharingRules);
			//update to sumbitted since can't insert feedback after request is in "submitted state"
			request.FeedbackRequestState = 'Submitted';
			if( Schema.sObjectType.WorkFeedbackRequest.fields.FeedbackRequestState.isUpdateable() )
			{
				try{
					update request;
				} catch (DmlException e) {
					// Process exception here
				}
			}

		}
	}
	
	private static boolean dataInsert(List<SObject> myObjects)
	{
		boolean allSuccess = true;
		List<Database.SaveResult> srList = Database.insert(myObjects,false);
		
		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
		    if (sr.isSuccess()) {
		        // Operation was successful, so get the ID of the record that was processed
		        System.debug('Successfully sharing rule: ' + sr.getId());
		    }
		    else {
		        // Operation failed, so get all errors                
		        for(Database.Error err : sr.getErrors()) {
		            // Check if the error is related to trival access level.
					// Access levels equal or more permissive than the object's default 
					// access level are not allowed. 
					// These sharing records are not required and thus an insert exception is acceptable. 
					if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  err.getMessage().contains('AccessLevel')){
						// Indicates success.
						//return true;
					}
					else{
						// Indicates failure.
						System.Assert(false,'error! ' + err.getMessage());
						allSuccess = false;
					}
		        }
		    }
		}
		return allSuccess;
	}


	/************************************* FEEDBACK REQUEST SECTION ****************************************/
	@RemoteAction
	global static List<WorkFeedbackRequest> fetchMyFeedbackRequest()
	{
		List<WorkFeedbackRequest> myRequests =[ select Id, SubjectId, Subject.Name, Subject.Firstname, Subject.SmallPhotoUrl, QuestionSetId, 
														PerformanceCycleId, PerformanceCycle.Name, FeedbackType, RelatedObjectId, RelatedObject.Name,
														Owner.Name, CreatedDate, QuestionSet.DueDate
												from WorkFeedbackRequest
												where RecipientId = :UserInfo.getUserId()
												and FeedbackRequestState = 'Draft'];
		if(myRequests.isEmpty())
			return null;
		else
			return myRequests;
	}

	@RemoteAction
	global static List<WorkFeedback> fetchMyFeedbacks(String requestId)
	{
		
		List<WorkFeedback> feedback = [	select Feedback, Id, QuestionId, RequestId, Question.Number 
										from WorkFeedback
										where RequestId = :requestId
										order by Question.Number ASC];
		if(feedback.isEmpty())
			return null;
		else
			return feedback;
	}

	@RemoteAction
	global static List<WorkFeedbackQuestion> fetchMyFeedbackReqQues(String questionSetId)
	{
		
		List<WorkFeedbackQuestion> myReqQues = [	select id, Number, Text, Choices, Type
													from WorkFeedbackQuestion
													where QuestionSetId = : questionSetId
													ORDER BY Number ASC];
		if(myReqQues.isEmpty())
			return null;
		else
			return myReqQues;
	}


	@RemoteAction
	//attr is feedback from number 1~X in order
	global static void submitFeedbacks(List<WorkFeedback> feedbacks)
	{
		Set<String> requestIds = new Set<String>();
		System.Debug(feedbacks);
		if( Schema.sObjectType.WorkFeedback.fields.Feedback.isUpdateable() )
		{
			//get a list of feedback request this feedback is for, it should just be 1, but writing good to to check just in case :D
			for(WorkFeedback wfeedback : feedbacks)
				if(!requestIds.contains(wfeedback.RequestId))
					requestIds.add(wfeedback.RequestId);
			try{
				//update feedbacks
				update feedbacks;

				//update feedback request to submit
				List<WorkFeedbackRequest> reqs = [select id, SubjectId, FeedbackRequestState, SubmittedDate from WorkFeedbackRequest where Id in :requestIds limit 2000];
				if( Schema.sObjectType.WorkFeedbackRequest.fields.FeedbackRequestState.isUpdateable() && Schema.sObjectType.WorkFeedbackRequest.fields.SubmittedDate.isUpdateable())
				{
					for(WorkFeedbackRequest wfeedRequest : reqs)
					{
						wfeedRequest.FeedbackRequestState = 'Submitted';
						wfeedRequest.SubmittedDate = System.Now();
					}
					try{
						update reqs;

						//share the feedback with the subject
						List<SObject> sharingRules = new List<SObject>();
						for(WorkFeedbackRequest req : reqs)
							for(WorkFeedback f : feedbacks)
							{
								//share feedback
								WorkFeedbackShare newFeedbackShare = new WorkFeedbackShare();
								newFeedbackShare.ParentId = f.Id;
								newFeedbackShare.AccessLevel = 'Read';
								newFeedbackShare.UserOrGroupId = req.SubjectId;
								System.Debug(newFeedbackShare);
								sharingRules.add(newFeedbackShare);
							}

						dataInsert(sharingRules); //share!

					} catch (DmlException e) {
						System.Debug(e);
					}
				}

			} catch (DmlException e) {
				System.Debug(e);
			}
		}
	}

	@RemoteAction
	//attr is feedback from number 1~X in order
	global static void saveDraftFeedbacks(List<WorkFeedback> feedbacks)
	{
		if( Schema.sObjectType.WorkFeedback.fields.Feedback.isUpdateable() )
		{
			System.Debug(feedbacks);
			try{
				update feedbacks;
			} catch (DmlException e) {
				System.Debug(e);
			}
		}
	}
}