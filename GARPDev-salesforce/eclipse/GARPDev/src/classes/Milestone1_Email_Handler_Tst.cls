@isTest
private class Milestone1_Email_Handler_Tst {
    //Test 1 Task created for valid email without attachments
    static testMethod void testEmailWithoutAttachments()
    {
        
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
        
        //We cannot create Users without using licenses, so query and grab first active user
        List<User> users = [Select Id, Email from User where isActive = true limit 1];
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'Unit Test Body: ' + Date.today();
        email.fromAddress = users.get(0).Email;
        email.toAddresses = new List<String>{users.get(0).Email};
        email.subject = ms1.Alias__c + ' --- UNIT TEST EMAIL 123XXXYYYZZZ';
        
        Milestone1_Email_Handler emailHandler = new Milestone1_Email_Handler();
        Messaging.InboundEmailResult testResult = emailHandler.handleInboundEmail(email, env);
        
        List<Milestone1_Task__c> createdTasks = [Select Id, Name, Description__c, Assigned_To__c from Milestone1_Task__c where Project_Milestone__c = :ms1.Id];
        
        system.assert(createdTasks != null);
        system.assert(testResult.success);
        system.assert(createdTasks.size() == 1);
        system.assert(createdTasks.get(0).Assigned_To__c == users.get(0).Id);
    }
    
    
    //Test 1 Task created for valid email with 2 attachments, 1 Text and 1 Binary
    static testMethod void testEmailWithAttachments()
    {
        
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
        
        //We cannot create Users without using licenses, so query and grab first active user
        List<User> users = [Select Id, Email from User where isActive = true limit 1];
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Messaging.Inboundemail.Binaryattachment binaryAttachment = new Messaging.Inboundemail.Binaryattachment();
        binaryAttachment.body = Blob.valueOf('UNIT TEST BINARY ATTACHMENT');
        binaryAttachment.fileName = 'A_UnitTest.gif';
        email.binaryAttachments = new List<Messaging.Inboundemail.Binaryattachment>{binaryAttachment};
        
        Messaging.Inboundemail.Textattachment textAttachment = new Messaging.Inboundemail.Textattachment();
        textAttachment.body = 'Unit Test XYZ ABC 123';
        textAttachment.fileName = 'B_UnitTest.txt';
        email.textAttachments = new List<Messaging.Inboundemail.Textattachment>{textAttachment};
        
        email.plainTextBody = 'Unit Test Body: ' + Date.today();
        email.fromAddress = users.get(0).Email;
        email.toAddresses = new List<String>{users.get(0).Email};
        email.subject = ms1.Alias__c + ' --- UNIT TEST EMAIL 123XXXYYYZZZ';
        
        Milestone1_Email_Handler emailHandler = new Milestone1_Email_Handler();
        Messaging.InboundEmailResult testResult = emailHandler.handleInboundEmail(email, env);
        
        List<Milestone1_Task__c> createdTasks = [Select Id, Name, Description__c, Assigned_To__c from Milestone1_Task__c where Project_Milestone__c = :ms1.Id];
        
        system.assert(createdTasks != null);
        system.assert(testResult.success);
        system.assert(createdTasks.size() == 1);
        system.assert(createdTasks.get(0).Assigned_To__c == users.get(0).Id);
        
        List<Attachment> attachments = [Select Id, Name from Attachment where parentId = :createdTasks.get(0).Id order by Name];
        system.assert(attachments.size() == 2);
        system.assert(attachments.get(0).Name == 'A_UnitTest.gif');
        system.assert(attachments.get(1).Name == 'B_UnitTest.txt');
        
    }
    
    
    static testMethod void testEmailNoUsersFound()
    {
        
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'Unit Test Body: ' + Date.today();
        email.fromAddress = 'nomatchemail_invalid@fake123.com';
        email.toAddresses = new List<String>{'nomatchemail_invalid@fake123.com'};
        email.subject = ms1.Alias__c + ' --- UNIT TEST EMAIL 123XXXYYYZZZ';
        
        Milestone1_Email_Handler emailHandler = new Milestone1_Email_Handler();
        Messaging.InboundEmailResult testResult = emailHandler.handleInboundEmail(email, env);
        
        List<Milestone1_Task__c> createdTasks = [Select Id, Name, Description__c, Assigned_To__c from Milestone1_Task__c where Project_Milestone__c = :ms1.Id];
        
        system.assert(createdTasks.size() == 0);
        system.assert(!testResult.success);
    }
    
    static testMethod void testEmailNoAlias()
    {
        
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
        
        //We cannot create Users without using licenses, so query and grab first active user
        List<User> users = [Select Id, Email from User where isActive = true limit 1];
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'Unit Test Body: ' + Date.today();
        email.fromAddress = users.get(0).Email;
        email.toAddresses = new List<String>{users.get(0).Email};
        
        Milestone1_Email_Handler emailHandler = new Milestone1_Email_Handler();
        Messaging.InboundEmailResult testResult = emailHandler.handleInboundEmail(email, env);
        
        List<Milestone1_Task__c> createdTasks = [Select Id, Name, Description__c, Assigned_To__c from Milestone1_Task__c where Project_Milestone__c = :ms1.Id];
        
        system.assert(createdTasks.size() == 0);
        system.assert(!testResult.success);
        system.assert(testResult.message == Milestone1_Email_Handler.ERROR_SUBJECT_MISSING_ALIAS);
    }
    
    static testMethod void testEmailAliasNotFound()
    {
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
        
        //We cannot create Users without using licenses, so query and grab first active user
        List<User> users = [Select Id, Email from User where isActive = true limit 1];
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'Unit Test Body: ' + Date.today();
        email.fromAddress = users.get(0).Email;
        email.toAddresses = new List<String>{users.get(0).Email};
        // Testing Alias #9XZ$@%? which should not exist. If it exists change to some crazy random alias that doesn't match.
        email.subject = '#9XZ$@%?' + ' --- UNIT TEST EMAIL 123XXXYYYZZZ';
        
        Milestone1_Email_Handler emailHandler = new Milestone1_Email_Handler();
        Messaging.InboundEmailResult testResult = emailHandler.handleInboundEmail(email, env);
        
        List<Milestone1_Task__c> createdTasks = [Select Id, Name, Description__c, Assigned_To__c from Milestone1_Task__c where Project_Milestone__c = :ms1.Id];
        
        system.assert(createdTasks.size() == 0);
        system.assert(!testResult.success);
        system.assert(testResult.message == Milestone1_Email_Handler.ERROR_ALIAS_NOT_FOUND);
    }
    
    static testMethod void testReplyEmailWithoutAttachmentsCreateNote()
    {
        
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
        
        Milestone1_Task__c msTask1 = Milestone1_Test_Utility.sampleTask(ms1.Id);
        msTask1.Name = 'Unit Test Email Notes 123';
        msTask1.Email_GUID__c = 'UNIQUE_TEST123' + Date.today();
        insert msTask1;
        
        //We cannot create Users without using licenses, so query and grab first active user
        List<User> users = [Select Id, Email from User where isActive = true limit 1];
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'Unit Test Body: ' + Date.today();
        email.fromAddress = users.get(0).Email;
        email.inReplyTo = msTask1.Email_GUID__c;
        email.toAddresses = new List<String>{users.get(0).Email};
        email.subject = ms1.Alias__c + ' --- UNIT TEST EMAIL 123XXXYYYZZZ';
        
        Milestone1_Email_Handler emailHandler = new Milestone1_Email_Handler();
        Messaging.InboundEmailResult testResult = emailHandler.handleInboundEmail(email, env);
        
        List<Note> notes = [Select Id,Title from Note where parentId =:msTask1.Id];
        system.assert(notes != null);
        system.assertEquals(1,notes.size());
        system.assertEquals(email.subject,notes.get(0).Title);
        system.assert(testResult.success);
    }

    static testMethod void testReplyEmailWithoutAttachmentsCreateNoteFail()
    {
        
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
        
        Milestone1_Task__c msTask1 = Milestone1_Test_Utility.sampleTask(ms1.Id);
        msTask1.Name = 'Unit Test Email Notes 123';
        msTask1.Email_GUID__c = 'UNIQUE_TEST123' + Date.today();
        insert msTask1;
        
        //We cannot create Users without using licenses, so query and grab first active user
        List<User> users = [Select Id, Email from User where isActive = true limit 1];
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'Unit Test Body: ' + Date.today();
        email.fromAddress = users.get(0).Email;
        email.inReplyTo = 'This does not match a email guid';
        email.toAddresses = new List<String>{users.get(0).Email};
        email.subject = ms1.Alias__c + ' --- UNIT TEST EMAIL 123XXXYYYZZZ';
        
        Milestone1_Email_Handler emailHandler = new Milestone1_Email_Handler();
        Messaging.InboundEmailResult testResult = emailHandler.handleInboundEmail(email, env);
        
        List<Note> notes = [Select Id,Title from Note where parentId =:msTask1.Id];
        system.assert(notes != null);
        system.assertEquals(0,notes.size());
        system.assertEquals(false,testResult.success);
    }
    
}