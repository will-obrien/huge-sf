@isTest
public class GeneratedTest {
    
    @isTest static void testGetActivityDate() {

        Case c = new Case(
            Origin = 'Email',
            OwnerId = '00524000000KtJ3AAK',
            Priority = 'Medium',
            Status = 'Working'
        );

        String createdCaseID = c.Id;        
        insert c;

        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID',c.Id);
        System.currentPageReference().getParameters().put('activityDate','20/12/2013');
        Generated generated = new Generated();

        System.assertEquals(generated.getActivityDate(),ApexPages.currentPage().getParameters().get('activityDate'));
    }

    @isTest static void testGetTasks() {

        Case c = new Case(
            Origin = 'Email',
            Priority = 'Medium',
            Status = 'Working',
            SuppliedEmail = 'Very@Unique.Dsc'
        );
        
        insert c;
        
        List<Case> cList = [SELECT Id, AccountId, CaseNumber, ClosedDate, ContactId, Description, IsClosed, LastViewedDate, Origin, OwnerId, Priority, Status, Subject, Type FROM Case WHERE SuppliedEmail = 'Very@Unique.Dsc'];
        
        String createdCaseID = cList.get(0).Id;

        Task t = new Task(
            Description = 'Test Description',
            Priority = 'Normal', 
            Status = 'Inbound Email', 
            Subject = 'Other', 
            IsReminderSet = true, 
            ReminderDateTime = Datetime.newInstanceGmt(2014,6,1,12,1,5),
            ActivityDate = System.Today()-1,
            WhatId = c.Id
        ); 
                    
        insert t;

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('caseID',c.Id);
        System.currentPageReference().getParameters().put('activityDate',System.Today().format());
        Generated generated = new Generated();

        string wrongCaseID = 'wrong ID';
        string wrongDate = 'wrong date';

        System.assertEquals(generated.getTasks(wrongCaseID,wrongDate),NULL);
        System.assertEquals(generated.getTasks(c.Id,generated.getActivityDate()).isEmpty(),true);
    }

    @isTest
    static void testGetCaseData() {

        Case c = new Case(
            Origin = 'Email',
            Priority = 'Medium',
            Status = 'Working',
            SuppliedEmail = 'Very@Unique.Dsc'
        );
        insert c;
        
        List<Case> cList = [SELECT Id, AccountId, CaseNumber, ClosedDate, ContactId, Description, IsClosed, LastViewedDate, Origin, OwnerId, Priority, Status, Subject, Type FROM Case WHERE SuppliedEmail = 'Very@Unique.Dsc'];
        
        String createdCaseID = cList.get(0).Id;
        System.assertNotEquals(c.Id,NULL);

        Task t = new Task(
            Description = 'Test Description',
            Priority = 'Normal', 
            Status = 'Inbound Email', 
            Subject = 'Other', 
            IsReminderSet = true, 
            ReminderDateTime = Datetime.newInstanceGmt(2014,6,1,12,1,5),
            ActivityDate = System.Today()+1,
            WhatId = c.Id
        ); 
                    
        insert t;

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('caseID',c.Id);
        System.currentPageReference().getParameters().put('activityDate',System.Today().format());
        Generated generated = new Generated();
    
        c = cList.get(0);
    
        String result = '<table id="customTable" style="margin: 0 auto; width: 96%;"><tr><th>Id</th><td>' + c.Id + '</td></tr><tr><th>IsClosed</th><td>' + c.IsClosed + '</td></tr><tr><th>AccountId</th><td>' + c.AccountId + '</td></tr><tr><th>CaseNumber</th><td>' + c.CaseNumber + '</td></tr><tr><th>ClosedDate</th><td>' + c.ClosedDate + '</td></tr><tr><th>ContactId</th><td>' + c.ContactId + '</td></tr><tr><th>Description</th><td>' + c.Description + '</td></tr><tr><th>LastViewedDate</th><td>' + c.LastViewedDate + '</td></tr><tr><th>Origin</th><td>' + c.Origin + '</td></tr><tr><th>OwnerID</th><td>' + c.OwnerID + '</td></tr><tr><th>Priority</th><td>' + c.Priority + '</td></tr><tr><th>Status</th><td>' + c.Status + '</td></tr><tr><th>Subject</th><td>' + c.Subject + '</td></tr><tr><th>Type</th><td>' + c.Type + '</td></tr></table>';

        System.assertEquals(generated.getCaseData(),result);
    }

    @isTest static void testGetCaseID() {
        CaseToPdf ctp = new CaseToPdf();

        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID','50024000002GubW');
    
        System.assertEquals(ctp.getCaseID(), '50024000002GubW');
    } 

    @isTest
    public static void testGetTasksData() {

        Case c = new Case(
            Origin = 'Email',
            Priority = 'Medium',
            Status = 'Working',
            SuppliedEmail = 'Very@Unique.Dsc'
        );
        insert c;
        
        List<Case> cList = [SELECT Id, AccountId, CaseNumber, ClosedDate, ContactId, Description, IsClosed, LastViewedDate, Origin, OwnerId, Priority, Status, Subject, Type FROM Case WHERE SuppliedEmail = 'Very@Unique.Dsc'];
        
        String createdCaseID = cList.get(0).Id;
        System.assertNotEquals(c.Id,NULL);

        Task t1 = new Task(
            Description = 'Test Description',
            Priority = 'Normal', 
            Status = 'Inbound Email', 
            Subject = 'Other', 
            IsReminderSet = true, 
            ReminderDateTime = Datetime.newInstanceGmt(2014,6,1,12,1,5),
            ActivityDate = Date.valueOf('2014-06-01'),
            WhatId = c.Id
        );
                    
        insert t1;
        
        Task t2 = new Task(
            Description = 'Test Description',
            Priority = 'Normal', 
            Status = 'Inbound Email', 
            Subject = 'Other', 
            IsReminderSet = true, 
            ReminderDateTime = Datetime.newInstanceGmt(2014,6,1,12,1,5),
            ActivityDate = Date.valueOf('2014-07-05'),
            WhatId = c.Id
        ); 
        insert t2;
        
        Task t1FromDB = [SELECT Id, AccountId, ActivityDate, Description, IsClosed, OwnerId, Priority, Status, Subject, WhatId, WhoId FROM Task WHERE ActivityDate = 2014-06-01];
        Task t2FromDB  = [SELECT Id, AccountId, ActivityDate, Description, IsClosed, OwnerId, Priority, Status, Subject, WhatId, WhoId FROM Task WHERE ActivityDate = 2014-07-05];

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('caseID',c.Id);
        System.currentPageReference().getParameters().put('activityDate','20/12/9999');
        Generated generated = new Generated();

        string wrongCaseID = 'wrong ID';
        string wrongDate = 'wrong date';

        String result = '<table id="customTable" style="margin: 0 auto; width: 96%;"><tr><th>Id</th><td>' + c.Id + '</td></tr><tr><th>IsClosed</th><td>' + c.IsClosed + '</td></tr><tr><th>AccountId</th><td>' + c.AccountId + '</td></tr><tr><th>CaseNumber</th><td>' + c.CaseNumber + '</td></tr><tr><th>ClosedDate</th><td>' + c.ClosedDate + '</td></tr><tr><th>ContactId</th><td>' + c.ContactId + '</td></tr><tr><th>Description</th><td>' + c.Description + '</td></tr><tr><th>LastViewedDate</th><td>' + c.LastViewedDate + '</td></tr><tr><th>Origin</th><td>' + c.Origin + '</td></tr><tr><th>OwnerID</th><td>' + c.OwnerID + '</td></tr><tr><th>Priority</th><td>' + c.Priority + '</td></tr><tr><th>Status</th><td>' + c.Status + '</td></tr><tr><th>Subject</th><td>' + c.Subject + '</td></tr><tr><th>Type</th><td>' + c.Type + '</td></tr></table>';

        System.assertEquals(generated.getTasksData(),'no tasks');
        
        System.currentPageReference().getParameters().put('activityDate','20/12/2013');
        
        string expected = '<hr/><table id="customTable" style="margin: 15px auto; width: 96%;"><tr><th>Id</th><td>' + t1FromDB.Id + '</td></tr><tr><th>AccountId</th><td>null</td></tr><tr><th>ActivityDate</th><td>2014-06-01 00:00:00</td></tr><tr><th>Description</th><td>Test Description</td></tr><tr><th>IsClosed</th><td>false</td></tr><tr><th>OwnerId</th><td>';
        expected = expected + t1FromDB.OwnerId + '</td></tr><tr><th>Priority</th><td>Normal</td></tr><tr><th>Status</th><td>Inbound Email</td></tr><tr><th>Subject</th><td>Other</td></tr><tr><th>WhatId</th><td>';
        expected = expected + t1FromDB.WhatId + '</td></tr><tr><th>WhoId</th><td>' + t1FromDB.WhoId + '</td></tr></table><hr/><table id="customTable" style="margin: 15px auto; width: 96%;"><tr><th>Id</th><td>' + t2FromDB.Id;
        expected = expected + '</td></tr><tr><th>AccountId</th><td>null</td></tr><tr><th>ActivityDate</th><td>2014-07-05 00:00:00</td></tr><tr><th>Description</th><td>Test Description</td></tr><tr><th>IsClosed</th><td>false</td></tr><tr><th>OwnerId</th><td>' + t2FromDB.OwnerId;
        expected = expected + '</td></tr><tr><th>Priority</th><td>Normal</td></tr><tr><th>Status</th><td>Inbound Email</td></tr><tr><th>Subject</th><td>Other</td></tr><tr><th>WhatId</th><td>' + t2FromDB.WhatId + '</td></tr><tr><th>WhoId</th><td>' + t1FromDB.WhoId + '</td></tr></table>';

        System.assertEquals(generated.getTasksData(),expected);
    }
}