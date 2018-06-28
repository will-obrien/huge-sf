global class Milestone1_Email_Handler implements Messaging.InboundEmailHandler 
{ 
    /*
    Email to Apex Class. Milestone Task Created with following mapping: 
    To -> Assigned, 
    Subject -> Brief, 
    TextBody -> Description, 
    Attachments -> Attachments
    
    Parent Milestone is looked up based on Milestone Alias provided in Subject. 
    */
    
    public static String ERROR_USERS_NOT_FOUND = 'The User seaches for Assignment (To Address) and/or Ownership (From Address) did not find matches to users in Salesforce.';
    public static String ERROR_SUBJECT_MISSING_ALIAS = 'The subject line did not contain a milestone alias.';
    public static String ERROR_ALIAS_NOT_FOUND = 'The alias provided in subject line did not match a milestone alias in Salesforce.';
    public static String ERROR_FROM_USER_NOT_FOUND = 'The email sender did not match a user in Salesforce.';
    public static String ERROR_TO_USER_NOT_FOUND = 'The list of recipients did not have any matches to a user in Salesforce.';
    public static String ERROR_TASK_NOT_FOUND = 'A matching task was not found for this Email thread in Salesforce. Salesforce was unable to attach this email to the notes for a task.';
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        if(email.inReplyTo != null && email.inReplyTo.length() > 0)
        {
            result = processReplyEmail(email);
        }else
        {
            result = processNewEmail(email);
        }
        
        return result;
    }
    
    public static Messaging.InboundEmailResult processReplyEmail(Messaging.InboundEmail email)
    {
        system.debug('Process a Reply Email. Reply ID ' + email.inReplyTo);
        system.debug('plainTextBodyIsTruncated == ' + email.plainTextBodyIsTruncated);
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        List<Milestone1_Task__c> matchingTasks = [Select Id from Milestone1_Task__c where Email_GUID__c =:email.inReplyTo limit 1];
        if(matchingTasks == null || matchingTasks.size() == 0)
        {
            result.message = ERROR_TASK_NOT_FOUND;
            result.success = false;
        }else
        {
            Milestone1_Email_Handler.insertNote(matchingTasks.get(0),email);
            Milestone1_Email_Handler.insertAttachments(matchingTasks.get(0),email);
            Milestone1_Email_Handler.updateMilestoneTask(matchingTasks.get(0),email);
            result.success = true;
        }
        return result;
    }
    
    public static Messaging.InboundEmailResult processNewEmail(Messaging.InboundEmail email)
    {
        system.debug('Process a new Email');
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Milestone1_Milestone__c parentMilestone;
        system.debug('Email In Reply To: ' + email.inReplyTo);
        system.debug('Email Message Id: ' + email.messageId);
        List<User> fromUsers = [Select Id from User where isActive = true and Email = :email.fromAddress];
        String firstEmail;
        if(email.toAddresses != null && email.toAddresses.size() > 0)
        {
            firstEmail = Milestone1_Email_Handler.parseAddress(email.toAddresses.get(0));
            system.debug('First Email == ' + firstEmail);
        }
        List<User> toUsers = [Select Id from User where isActive = true and Email = :firstEmail];
        
        if(fromUsers.size() == 0)
        {
            result.message = ERROR_FROM_USER_NOT_FOUND;
            result.success = false;
        }else if(toUsers.size() == 0)
        {
            result.message = ERROR_TO_USER_NOT_FOUND;
            result.success = false;         
        }else
        {
            List<String> processedSubjectLine = Milestone1_Email_Handler.processSubject(email.subject);
            if(processedSubjectLine == null || processedSubjectLine.size() < 1)
            {
                //Reject code here as there is no subject line, and thus no Milestone Alias
                result.message = ERROR_SUBJECT_MISSING_ALIAS;
                result.success = false;
            }else
            {
                System.debug('Find the Milestone for Alias: ' + processedSubjectLine[0]); 
                List<Milestone1_Milestone__c> milestones = [Select Id From Milestone1_Milestone__c where alias__c = :processedSubjectLine[0].trim() limit 1];
                if(milestones == null || milestones.size() == 0)
                {
                    //Reject code here as the alias was not found.
                    result.message = ERROR_ALIAS_NOT_FOUND;
                    result.success = false;
                }else 
                {
                    Milestone1_Task__c newTask = Milestone1_Email_Handler.insertMilestoneTask(toUsers,milestones,email,processedSubjectLine);
                    Milestone1_Email_Handler.insertAttachments(newTask,email);
                    result.success = true;
                }
            }
        }
        return result;
    }
    
    public static Milestone1_Task__c insertMilestoneTask(List<User> toUsers, List<Milestone1_Milestone__c> milestones, Messaging.InboundEmail email, List<String> processedSubjectLine)
    {
        Milestone1_Task__c newTask = new Milestone1_Task__c();
        newTask.Assigned_To__c = toUsers.get(0).Id;
        newTask.Project_Milestone__c = milestones.get(0).Id;
        
        String nameString = processedSubjectLine[1];
        if(nameString.length() > 80)
        {
            newTask.Description__c = nameString + '\n' + email.plainTextBody;   
        }else
        {
            newTask.Description__c =  email.plainTextBody;
        }
        nameString = Milestone1_General_Utility.processTaskName(nameString.trim());
        newTask.Name = nameString;
        newTask.Email_GUID__c = email.messageId;
        newTask.Last_Email_Received__c = Datetime.now();
        insert newTask;
        system.debug('New Task ID == ' + newTask.Id);
        return newTask;
    }
    
    public static Milestone1_Task__c updateMilestoneTask(Milestone1_Task__c msTask, Messaging.InboundEmail email)
    {
        msTask.Email_GUID__c = email.messageId;
        msTask.Complete__c = false;
        msTask.Last_Email_Received__c = Datetime.now();
        update msTask;
        system.debug('The task ReplyTo chain: ' + msTask.Email_GUID__c);
        return msTask;
    }
    
    public static Note insertNote(Milestone1_Task__c msTask, Messaging.InboundEmail email)
    {
        Note newNote = new Note();
        newNote.parentId = msTask.Id;
        newNote.title = email.subject;
        newNote.body = email.plainTextBody;
        insert newNote;
        system.debug('New Note ID == ' + newNote.Id);
        return newNote;
    }
    
    public static String parseAddress(String emailAddress)
    {
        String[] addressTokens = emailAddress.split(' ');
        String returnEmail = '';
        if(addressTokens != null && addressTokens.size() > 1)
        {
            String buildName = '';
            for(Integer x = 0; x < addressTokens.size() - 1; x++)
            {
                buildName = buildName + addressTokens[x] + ' ';
            }
            buildName = buildName.subString(0,buildName.length() - 1);
            System.debug('Build Name = ' + buildName);
        }
        
        returnEmail = addressTokens[addressTokens.size() -1];
        returnEmail = returnEmail.replace('<','');
        returnEmail = returnEmail.replace('>','');
        system.debug('To adddress email == ' + returnEmail);
        return returnEmail;
    }
    
    public static List<String> processSubject(String subject)
    {
        if(subject == null)
        {
            return new List<String>();
        }
        return subject.split('---',0);
    }
    
    //Insert the Email's attached files as SFDC Attachment Object on the Milestone Task Object.skh Binary and Text Attachments.
    public static void insertAttachments(Milestone1_Task__c newTask, Messaging.InboundEmail email)
    {
        system.debug('Insert Attachments....');
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = email.binaryAttachments;
        Messaging.InboundEmail.Textattachment[] textAttachments = email.textAttachments;
        List<Attachment> insertAttachments = new List<Attachment>();
        if(binaryAttachments != null)
        {
            system.debug('Binary Attachments != null');
            for(Messaging.InboundEmail.BinaryAttachment currentBinaryAttachment : binaryAttachments)
            {
                if(currentBinaryAttachment.body != null && currentBinaryAttachment.fileName != null)
                {
                    Attachment newAttachment = new Attachment(Name = currentBinaryAttachment.fileName, body = currentBinaryAttachment.body, parentId = newTask.Id );
                    insertAttachments.add(newAttachment);
                }
            }
        }
        if(textAttachments != null)
        {
            system.debug('Text Attachments != null');
            for(Messaging.InboundEmail.Textattachment currentTextAttachment : textAttachments)
            {
                if(currentTextAttachment.body != null && currentTextAttachment.fileName != null)
                {
                    Attachment newAttachment = new Attachment(Name = currentTextAttachment.fileName, body = blob.valueOf(currentTextAttachment.body), parentId = newTask.Id );
                    insertAttachments.add(newAttachment);
                }
            }
        }
        system.debug('Insert the Attachments. Number is ' + insertAttachments.size());
        if(insertAttachments.size() > 0)
        {
            insert insertAttachments;
        }
    }       
}