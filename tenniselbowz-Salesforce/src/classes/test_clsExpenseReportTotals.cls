Public Class test_clsExpenseReportTotals{

public static testMethod void test_ExpenseReportTotals() {


    PageReference pageRef = Page.vf_ExpenseTotals;  
    Test.setCurrentPage(pageRef);
    
    Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678');
    insert acc;
    Contact c=TestingUtils.createContacts(1, acc.Id, true)[0];

    User u=[Select ContactId,ID ,NAme from User limit 1];//new User(FirstName='Sobia',LastName='Khan',ContactId=c.Id,Email='sobia@spyrel.com');
     //u.ContactId=c.Id;
     //update u;
    recordtype prjRecType=[select id from recordtype where sobjecttype='Project__c' 
    and name='Hourly Recurring'];
    
    Project__c prj=new Project__c(recordtypeid=prjRecType.Id,Description__c='test',Allocated_Hours__c=44,
    Account__c=acc.Id,Start_Date__c=system.today()-30, Stop_Date__c=system.today()+30,
    Allocated_Resource__c=c.Id);
    insert prj;
    List<Project__c> plist=new List<Project__c>();
    plist.add(prj);
    recordtype prjTeamRecType=[select id,Name from recordtype where sobjecttype='Project_Member__c' 
    and  Name='Project Team Member' ];
    
    recordtype taskRecType=[select id,Name from recordtype where sobjecttype='Project_Member__c' 
    and Name='Task Team Member'];

    Project_Member__c projMember=new Project_Member__c();
    ProjMember.recordtypeId=prjTeamRecType.Id;
    projMember.Contact__c=prj.Allocated_Resource__c ;
    projMember.Project__c=prj.Id;
    
    insert projMember;
    
    Project_Task__c t=new Project_Task__c();
    
    t.Allocated_Hours__c=prj.Allocated_Hours__c;
    t.Start_Date__c=prj.Start_Date__c;
    t.Due_Date__c=prj.Stop_Date__c;
    t.Name__c='Test Task';
    t.Project__c=prj.Id;
    insert t;
    
    Project_Member__c taskMember=new Project_Member__c();
    
    taskMember.recordtypeId=taskRecType.Id;
    taskMember.Contact__c=prj.Allocated_Resource__c ;
    taskMember.tasks__c=t.Id;
    
    insert taskMember;
    
    Expense_Report__C e=new Expense_Report__C();
    e.Start_Of_Week__c=system.Today();
    e.Tasks__c=t.Id;
    e.Project__c=prj.Id;
    e.Description__c='abc';
     e.Project_Team_member__c=taskMember.Id;
    insert e;
    
        
    ApexPages.standardController controller = new ApexPages.standardController(e);
    ApexPages.currentPage().getParameters().put('Id',e.Id);
     cls_ExpenseReportTotals controllerExt = new  cls_ExpenseReportTotals(controller);
     
     controllerExt.setMonday('abc');
     controllerExt.setTuesday('abc');
     controllerExt.setwEDNESDAY('abc');
     controllerExt.setThursday('abc');
     controllerExt.setFriday('abc');
     controllerExt.setSaturday('abc');
     controllerExt.setSunday('abc');
     
     controllerExt.getMonday();
     controllerExt.getTuesday();
     controllerExt.getwEDNESDAY();
     controllerExt.getThursday();
     controllerExt.getFriday();
     controllerExt.getSaturday();
     controllerExt.getSunday();
     
     
     }
     
     }