public with sharing class ConvertFeedbackCtrl
{
    public List<WorkFeedbackRequest> feedbackRequests {get;set;}
    public List<WorkFeedback> feeds {get;set;}
    public Integer feedsCount {get;set;}
    public boolean userClickedProcessNow {get;set;}
    public Integer numRecConverted {get;set;}
    public boolean scheduleToRun {get;set;}
    public String jobDetailId {get;set;}
    String[] specialChars = new String[]{' ','.','-','=','~','>',')','}','_','|'};
        
    public ConvertFeedbackCtrl()
    {
        //inner select = get all feedrequest that's submitted and from the past 365 days
        //get all feedbacks under the selected feed requests
        //needConverting__c formula field covers if there has been modification after last conversion
        refreshFeed();

        jobDetailId = findCronJobDetail('Scheduled WorkFeedback Conversion');
		if(jobDetailId == null)
            scheduleToRun = false;
        else
            scheduleToRun = true;
        numRecConverted = -1;
        userClickedProcessNow = false;
	}
    public void refreshFeed()
    {
        feeds = [select id, numericValue__c, stringValue__c, FeedBackLastConvertDate__c, feedback, LastModifiedDate,needConverting__c 
                 from WorkFeedback
                 where needConverting__c = true
                 and requestId in (
                                    SELECT Id
                                    FROM WorkFeedbackRequest 
                                    WHERE FeedbackRequestState = 'Submitted'
                                    //AND SubmittedDate >= LAST_N_MONTHS:12
                                )
                ];
        feedsCount = feeds.size();
    }
    public void convert()
    {   
        SchConvertFeedbackBatch schConvertFeedbackBatch = new SchConvertFeedbackBatch(UserInfo.getUserEmail());
        ID batchprocessid = Database.executeBatch(schConvertFeedbackBatch);
        userClickedProcessNow = true;
        /*
        numRecConverted = 0;
        for(WorkFeedback f : feeds)
        {
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
            numRecConverted++;
        }
        if(numRecConverted > 0 )
            update feeds;

        refreshFeed();//reset feed count
        */
    }
    
    /************** for scheduling convert **********/
    public String calculateScheduleTimeStr(DateTime myDateTime)
    {
        DateTime schDateTime = myDateTime.addSeconds(10);
        String scheduleStr = '';
        scheduleStr = '0 0 0 * * ? *'; //every day at 12am
        //scheduleStr = schDateTime.format('s m H d M')+ ' ? '+schDateTime.format('yyyy');
        return scheduleStr;
    }
    public String findCronJobDetail(String jobName)
    {
        //find CronJobDetailId
        List<CronJobDetail> cronJob = [SELECT Id,JobType,Name 
                                 FROM CronJobDetail
                                 WHERE Name = :jobName Limit 1
                                ];
        if(cronJob.isEmpty())
            return null;
        else
            return cronJob[0].id;
    }
    public PageReference toggleScheduleJob()
    {
        //find CronJobDetailId of 'Scheduled WorkFeedback Conversion'
        jobDetailId = findCronJobDetail('Scheduled WorkFeedback Conversion');
        if(jobDetailId !=null) //if there is a job running, abort it
        {
            //find CronTrigger id of 'Scheduled WorkFeedback Conversion'
            CronTrigger crontrig = [SELECT CronJobDetailId,EndTime,Id,NextFireTime,PreviousFireTime,StartTime,State,TimesTriggered 
                                    FROM CronTrigger
                                    WHERE CronJobDetailId = :jobDetailId
                                   ];
            //Abortion
            system.abortJob(crontrig.Id);
        }
        else //if no job, schedule one
        {
            ScheduleConvertWorkFeedback schConvertFeed = new ScheduleConvertWorkFeedback();
            String schDateTime = calculateScheduleTimeStr(System.now()); //right now is hardcoded to everyday at 12am
            jobDetailId = system.schedule('Scheduled WorkFeedback Conversion', schDateTime, schConvertFeed); //SCHEDULED!!!
        }
        return null;
    }
}