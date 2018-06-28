@isTest 
private class triggerFromTaskToLeadTestClass {
    static testMethod void testTriggerFromTaskToLead() {

       // create lead
       Lead l = new Lead(Lastname='TestPerson', Company='TestCompany', Status='Passive - Unqualified');
       System.debug('Email count before adding a new email : ' + l.Individual_Email_Count__c);

       // Insert lead
       insert l;
    
       // create tasks
       Task t1 = new Task(Subject='Email: Test Email',WhoId=l.Id,type='Email', status='Completed');
       Task t2 = new Task(Subject='Mass Email: Test Email',WhoId=l.Id,type='Email', status='Completed');
       Task t3 = new Task(Subject='Form submitted: Test Form',WhoId=l.Id,type='Email', status='Completed');
       Task t4 = new Task(Subject='Call with Kunal Jain',WhoId=l.Id,type='Call', status='Completed');
       Task t5 = new Task(Subject='→ Email: Test Email',WhoId=l.Id,type='Email', status='Completed');
       
       // insert task
       insert t1;
       insert t2;
       insert t3;
       insert t4;
       insert t5;
    
       // Retrieve the new Lead
       l = [SELECT Individual_Email_Count__c FROM Lead WHERE Id =:l.Id];
       System.debug('Email count after adding a new email: ' + l.Individual_Email_Count__c);

       // Test that the trigger correctly updated the price
       System.assertEquals(3, l.Individual_Email_Count__c);
    }
}