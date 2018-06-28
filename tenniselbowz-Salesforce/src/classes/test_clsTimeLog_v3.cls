Public Class test_clsTimeLog_v3{

public static testMethod void test_clsTimeLog_v3() {


    PageReference pageRef = Page.vf_TimeLog_v2;  
    Test.setCurrentPage(pageRef);
    
    Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678');
    insert acc;
    Contact c=new Contact(FirstName='Sobia', LastName='Khan', Account=acc, Phone='3125551234');
    insert c;
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

    Time_Log__c timeRec=new Time_Log__c(Short_Description__c='test1',Week_Start_Date__c=system.today(),
    Tasks__c=t.Id,MOnday_Hours__c=4.0,Project_member__C=taskMember.Id);
    insert timeRec;
    
    Time_Log__c timeRec2=new Time_Log__c(Short_Description__c='test2',Week_Start_Date__c=system.today(),
    Tasks__c=t.Id,MOnday_Hours__c=4.0,Status__c='New', Project_member__C=taskMember.Id);
    insert timeRec2;
    
    Time_Log__c timeRec3=new Time_Log__c(Short_Description__c='test3',Week_Start_Date__c=system.today(),
    Tasks__c=t.Id,MOnday_Hours__c=4.0,Status__c='New',Project_member__C=taskMember.Id);
    insert timeRec3;

    
    timeRec3.Status__c='Submitted';
    update timeRec3;
    
    pageRef.getParameters().put('cId',c.Id);
    ApexPages.standardController controller = new ApexPages.standardController(timeRec);
    
    cls_TimeLog_v3 controllerExt = new cls_TimeLog_v3(controller);
    
    Set<Id> contactId=new Set<Id>();
    contactId.add(c.Id);
    cls_TimeLog_v3.prj_time pt=new cls_TimeLog_v3.prj_time(timeRec,plist,contactId);

    controllerExt.setCurrContact(c.Id);
    controllerExt.setSelectedDate(system.today());
    controllerExt.getSelectedDate(); 
    controllerExt.setSelectedDate(system.today()-7);
    controllerExt.changeDate();
    PageReference p;
    controllerExt.addrow();
    p=controllerExt.getSelectedTimeRecordsForApproval();
    pt.setIndexRow(1);
    pt.getIndexRow();
    controllerExt.setdelIndex(1);
    controllerExt.getdelIndex();
    controllerExt.showTimeEntryGrid();
    controllerExt.getapprovedtimeLog_recs();
    controllerExt.gettimeLog_recs();
  
    pt.setSelectedProject(prj.Id);
    pageRef.getParameters().put('cId',c.Id);
        //pt.getTasks();
    pt.setSelectedTask(t.Id);
    pt.getSelectedProject();
    pt.getSelectedTask();
    pt.getrowTotalHours();
   // p=controllerExt.Save();
    p=controllerExt.DeleteRow();
    controllerExt.Close();
    //controllerExt.getsumOfAllRows();
    
    //******************************* Testing The Dummy Code ********************8
    
    controllerExt.DummyMethod();
    
  
    
        
    controllerExt.setLastName('lastname');
    controllerExt.setFirstName('firstname');
    controllerExt.setCompany('acme');
    controllerExt.setEmail('firstlast@acme.com');
    controllerExt.getLastName();           
          
    controllerExt.getFirstName();
    controllerExt.getCompany();
    controllerExt.getEmail();
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