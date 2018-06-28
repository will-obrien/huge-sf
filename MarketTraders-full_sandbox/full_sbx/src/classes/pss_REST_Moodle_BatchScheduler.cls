//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// class to select all the partner user records which have unchecked sync'd with moodle flag 
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
global with sharing class pss_REST_Moodle_BatchScheduler  implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts, Database.Stateful
{
     global List<pss_Moodle_Account_Sync.MoodleResponse> responses;
     
     global class MoodleBatchException extends Exception {}      // MSM
    
     global void execute(SchedulableContext ctx) {
     
        Map<String, PB_Course__c> mcs = PB_Course__c.getAll();
        string cols='';
        for(PB_Course__c pbCourse : mcs.values())
        {
             cols += pbCourse.Course_API_Name__c.trim() + ',';
        }
        String userQuery ='SELECT ID' +
                            ',FirstName' +                            
                            ', LastName' +
                            ', PersonEmail,LMS_Password__c,' +
                            cols + 
                            ' LMS_Insert__c' +                            
                            ' from Account' +
                            /*' ContactId != null' +*/
                            ' where LMS_Insert__c=true';
        if (Test.isRunningTest())
        {
            userQuery += ' Limit 1';
        }            
        system.debug('userQuery::::'+userQuery);
        Database.executebatch(new pss_REST_Moodle_BatchScheduler(userQuery),10);

        Datetime sysTime = System.now();
//        String period= Label.LMS_Client_Push_Period;
//        if (pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c!=null && pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c.intValue()!=0)
        {
            sysTime = sysTime.addMinutes(5);
            String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            system.debug(chron_exp);
            pss_REST_Moodle_BatchScheduler moodleScheduler = new pss_REST_Moodle_BatchScheduler();
            System.schedule('LMS User Sync Scheduler' + System.now(),chron_exp, moodleScheduler);
        }
        Id cronTrigId = ctx.getTriggerId();
        System.abortJob(cronTrigId);

   }

    global final string query;

    global pss_REST_Moodle_BatchScheduler ()
    {
        responses = new List<pss_Moodle_Account_Sync.MoodleResponse>();
    }

    global pss_REST_Moodle_BatchScheduler (String q)
    {
        responses = new List<pss_Moodle_Account_Sync.MoodleResponse>();
        query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Decimal errorCount = 0;
        Decimal recordCount = 2001;
        List<Account> usersForUpdate = new List<Account>();
        List<Account> usersToPass = new List<Account>();
        Set<String> users = new Set<String>();        
        try
        {
            System.debug(Logginglevel.DEBUG,'started with: '+BC.getJobID());
            //get all process step in stage for mll and status initializing - could be any other

            System.debug(Logginglevel.DEBUG,scope);
        
            pss_Moodle_Account_Sync client = new pss_Moodle_Account_Sync();

            for(sObject userRecordObject: scope)
            {
                
                Account userRecord = (Account) userRecordObject;              
                usersToPass.add(userRecord);
                users.add(userRecord.id);
                /*
                pss_Moodle_Account_Sync.MoodleResponse result = new pss_Moodle_Account_Sync.MoodleResponse();
                System.debug(Logginglevel.DEBUG,'user - '+userRecordObject);
                System.debug(Logginglevel.DEBUG,'execute - '+result);
                if (userRecord.pss_moodle_user_id__c!=null)
                {
                    result = client.updateUserInMoodle(userRecord);         
                }
                else
                {
                    result = client.createUserInMoodle(userRecord);         
                }
                System.debug(Logginglevel.DEBUG,'execute - '+result);
                if(!result.isError || (result.debugInfo!=null && result.debugInfo.contains('Email address already exists')))
                {           
                    if (Schema.sObjectType.Contact.fields.pss_Needs_Moodle_Update__c.isUpdateable())
                    {
                        userRecord.pss_Needs_Moodle_Update__c = false;
                    }

                    if (result.id!=null && result.id!='') 
                    {
                        if (Schema.sObjectType.Contact.fields.pss_moodle_user_id__c.isUpdateable())
                        {
                            userRecord.pss_moodle_user_id__c = String.valueOf(result.id);
                        } 
                    }
                    usersForUpdate.add(userRecord);                                           
                 
                }
                


                responses.add(result);              
                */
            }
            pss_Moodle_Account_Sync.User_Info_Collection result = client.createUserInMoodle(usersToPass);
            System.Debug('@@@ result: ' + result);
            System.Debug('@@@ result: ' + result.data); 
            System.Debug('@@@ result: size' + result.data.size());
            System.Debug('@@@ result: 0' + result.data[0]);
            System.Debug('@@@ result: 1' + result.data[1]);
            System.Debug('@@@ result: 2' + result.data[2]);
            System.Debug('@@@ result: 3' + result.data[3]);
            System.Debug('@@@ result: 4' + result.data[4]);  
            
            //MoodleBatchException bex = new MoodleBatchException();
            //bex.setMessage('@@@ result: ' + result);
            //throw bex;
            
            List<Enrollment__c> cEnrolls = [Select Id,Account__c,Course__c,LMS_Unique_Key__c,Active__c,Last_Login_Date__c,Completed__c,Progress__c,score__c From Enrollment__c where Account__c in : users];
            //if (cEnrolls!=null && cEnrolls.size()>0)
            //    delete cEnrolls;
            Map<String,Enrollment__c> myEnrollMap = new Map<String,Enrollment__c>();
            for(Enrollment__c e : cEnrolls) {
                if (!myEnrollMap.containsKey(e.LMS_Unique_Key__c))                
                {    
                     myEnrollMap.put(e.LMS_Unique_Key__c,e);                   
                }
            }
            /*    
            if (this.student.pss_Moodle_User_ID__c==null)
            {
                this.student.pss_Moodle_User_ID__c = result.iduser;
                update this.student;
            }
            */
            Map<String,String> myCourseMap = new Map<String,String>();
            List<Enrollment__c> enrolls= new List<Enrollment__c>();
            Set<String> delCourses=new Set<String>();
            List<Course__c> courses= [Select Id,Course_API_Name__c From Course__c];
            for(Course__c a : courses) {
                if (!myCourseMap.containsKey(a.Course_API_Name__c))
                {    
                  System.debug(LoggingLevel.ERROR, '@@@ Adding course to course map: ' + a.Course_API_Name__c);
                     myCourseMap.put(a.Course_API_Name__c,a.id);                   
                }
            }
            for(pss_Moodle_Account_Sync.MoodleResponse res:result.data)
            {
                system.debug('@@@' + res ); 
                if (String.isNotBlank(res.idcourses) && String.isNotBlank(res.sfid))
                {
                  System.debug(LoggingLevel.ERROR, '@@@ processing account with id: ' + res.sfid);                   
                    List<String> parts = res.idcourses.split(',');
                    system.debug('parts:::::'+parts);
                    
                    for(String cid : parts)
                    {
                        if (myCourseMap.containsKey(cid.trim()))
                        {
                            delCourses.add(res.sfid+'_'+myCourseMap.get(cid.trim()));
                            if (!myEnrollMap.containsKey(myCourseMap.get(cid.trim())))
                                enrolls.add(new Enrollment__c(Course__c=myCourseMap.get(cid),Active__c = true, Account__c=res.sfid, LMS_Unique_Key__c=res.sfid+'_'+myCourseMap.get(cid.trim())));
                        }
                    }
                    usersForUpdate.add(new Account(id=res.sfid,LMS_Insert__c=false));
                }
                else if (String.isNotBlank(res.sfid)&& res.done=='true')
                {
                    //List<Enrollment__c> dEnrolls = [Select Id,Course__c,Is_Completed__c,Last_Login__c,Moodle_Unique_Key__c,Progress__c,score__c From Enrollment__c where User__c=: student.id];
                    //if (dEnrolls!=null && dEnrolls.size()>0)
                    //delete dEnrolls;
                    usersForUpdate.add(new Account(id=res.sfid,LMS_Insert__c=false));
                }    
            }
            if (enrolls.size()>0)
            {
                system.debug('enrolls:::::'+enrolls);
                upsert enrolls LMS_Unique_Key__c;
            }
            
            if (usersForUpdate.size()>0)
            {
                system.debug('usersForUpdate:::::'+usersForUpdate);
                upsert usersForUpdate;
            }
            List<Enrollment__c> dEnrolls = [Select Id,Active__c From Enrollment__c where Account__c in : users and LMS_Unique_Key__c not in :delCourses];
            system.debug('delCourses:::::'+delCourses);
            system.debug('dEnrolls:::::'+dEnrolls);
            if (dEnrolls!=null && dEnrolls.size()>0)
            {
                for(Enrollment__c e : dEnrolls)
                {
                    e.Active__c = false;
                }
                //delete dEnrolls;
                upsert dEnrolls;
            }                    
        }
        catch(Exception ex)
        {
            sendErrorEmail(ex);
            System.debug(Logginglevel.ERROR,'execute - ERROR: '+ex);
        }
        finally
        {
            //update usersForUpdate;
        }
    }

    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob moodleJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :BC.getJobId()];
        System.debug(Logginglevel.INFO,'The batch Apex job processed ' + moodleJob.TotalJobItems + ' batches with '+ moodleJob.NumberOfErrors + ' failures.');
        //if(responses.size() > 0)sendResultEmail(moodleJob);
        
        
        
    }
    
    private void sendResultEmail(AsyncApexJob job)
    {
        String synchroResultError = '';
        String synchroResultSuccess = '';
        integer errorCount = 0;
        integer successCount = 0;
        /* ////
        if(pss_Moodle_Settings__c.getInstance().Email_Report_From_Address__c != null )
        {
            boolean isDebugModeEnabled = pss_moodle_settings__c.getInstance().Debug_Mode__c;  
            for(pss_Moodle_Account_Sync.MoodleResponse mResponse : responses)
            {
                if(mResponse.isError)
                {
                    synchroResultError += mResponse + '\n';
                    errorCount++;
                }
                else if(isDebugModeEnabled)
                {
                    synchroResultSuccess += mResponse + '\n';
                    successCount++;
                }
            }
            Messaging.reserveSingleEmailCapacity(1);
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {pss_Moodle_Settings__c.getInstance().Email_Report_Address__c};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo(pss_Moodle_Settings__c.getInstance().Email_Report_From_Address__c);
        
            mail.setSenderDisplayName('LMS synchronisation');
            mail.setSubject('User synchronization report');
            
            // Specify the text content of the email.
            string bodyText = '';
            bodyText = 'Results of user synchronization for job: '+job.Id + '\nTotal processed: '+ responses.size();
            if(isDebugModeEnabled){
                bodyText += '\nNumber of successfull transfers: '+ successCount;
                bodyText += '\n\nSuccess:\n' + synchroResultSuccess;
            }

            bodyText += '\nNumber of errors: '+ errorCount;
            bodyText += '\n\nDetails\nErrors:\n' + synchroResultError;
            mail.setplainTextBody (bodyText);
            
            if (errorCount>0 || (isDebugModeEnabled && successCount>0))
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        //// */ 
    }
    public void sendErrorEmail(Exception ex)
    {
        String message = '';
        /* ////
        if(ex != null)
        {   
            message = 'Error Message:' + ex.getMessage();
            message += '\nError Line:' + ex.getLineNumber();
            message += '\nStack Trace:' + ex.getStackTraceString();
            message += '\nError Type:' + ex.getTypeName();                        
            Messaging.reserveSingleEmailCapacity(1);
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {pss_Moodle_Settings__c.getInstance().Email_Report_Address__c};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo(pss_Moodle_Settings__c.getInstance().Email_Report_From_Address__c);
        
            mail.setSenderDisplayName('LMS Error');
            mail.setSubject('Job Error Report');
            
            // Specify the text content of the email.
            mail.setplainTextBody(message);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
                //// */ 
    }
}