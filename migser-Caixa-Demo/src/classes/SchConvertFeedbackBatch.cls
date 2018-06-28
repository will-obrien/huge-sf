global class SchConvertFeedbackBatch implements Database.Batchable<sObject>, Database.Stateful
{
	global final String query;
	global final String adminEmail;
	global final String[] specialChars;
	global Integer numRecConverted;

	global SchConvertFeedbackBatch(String email){
		query = 'select id, numericValue__c, stringValue__c, FeedBackLastConvertDate__c, feedback, LastModifiedDate, needConverting__c '+ 
                 'from WorkFeedback '+
                 'where needConverting__c = true '+
                 'and requestId in ( '+
                                    'SELECT Id '+
                                    'FROM WorkFeedbackRequest '+
                                    'WHERE FeedbackRequestState = \'Submitted\' '+
                                ')';
		adminEmail = email;
		specialChars = new String[]{' ','.','-','=','~','>',')','}','_','|'};
		numRecConverted = 0;
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> feeds)
	{
		List<WorkFeedback> feedbacks = new List<WorkFeedback>();
		Integer batchSumRecordProcessed = 0;
		for(Sobject sobj : feeds)
		{
			WorkFeedback f = (WorkFeedback)sobj;
			
			//do stuff
			List<Integer> indexsOfSpecialChar = new List<Integer>();
            String numText;
            Double numValue;
            if(f.feedback != null)
            {
                //if whole feedback is a number
                if(f.feedback.isNumeric())
                {
                	f.numericValue__c = Integer.valueOf(f.feedback); //convert number
                }
                else
                {
                    //get all the indexs of special characters
                    for(String s : specialChars) 
                        if(f.feedback.indexOf(s) != -1)
                            indexsOfSpecialChar.add(f.feedback.indexOf(s));
                    //look at string before each special character and see if it's a number
                    for(Integer index : indexsOfSpecialChar)
                    {
                        numText = f.feedback.substring(0,index);
                        if(numText.isNumeric())
                        {
                            numValue = Integer.valueOf(numText);
                            break; //exit out of for loop when first number is found
                        }
                    }
                    //converted Number
                    f.numericValue__c = numValue; //either have a double or null
                }
                //convert to String
                if(f.feedback.length() > 255)
                    f.stringValue__c = f.feedback.substring(0,255); //assign string value to feedback
                else
                    f.stringValue__c = f.feedback;
            }
            else
            {
                f.stringValue__c = null;
                f.numericValue__c = null;
            }
            //add converted date
            f.FeedBackLastConvertDate__c = System.now();
            batchSumRecordProcessed++;
            feedbacks.add(f);
		}
		if(batchSumRecordProcessed>0)
    		update feedbacks;
    	numRecConverted += batchSumRecordProcessed; //total number of records for all batches
	}

	global void finish(Database.BatchableContext BC){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String messageBody = 'Batch Process for processing feedback has completed! Total number of feedback processed: ' + numRecConverted;

		mail.setToAddresses(new String[] { adminEmail });
		mail.setReplyTo('henry.liu@salesforce.com');
		mail.setSenderDisplayName('Batch Processing Feedback');
		mail.setSubject('Feedback Batch Process Completed');
		mail.setPlainTextBody(messageBody);

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

	}


	/** other methods**/

}