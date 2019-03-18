Public Class test_view_revisions_controller {

public static testMethod void test_view_revisions_controller() {

    Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678');
    insert acc;
    Account accVen=new Account(Name='Test Acount',Type = 'Partner',Account_Number__c='2345678');
    insert accVen;
    Contact c=new Contact(FirstName='Sobia', LastName='Khan', Account=acc, Phone='3125551234');
    insert c;
    User u=[Select ContactId,ID ,NAme from User limit 1];//new User(FirstName='Sobia',LastName='Khan',ContactId=c.Id,Email='sobia@spyrel.com');
     
    recordtype prjRecType=[select id from recordtype where sobjecttype='Project__c' 
    and name='Hourly Recurring'];
    
    Project__c prj=new Project__c(recordtypeid=prjRecType.Id,Description__c='test',Stage__c='Turnover',Allocated_Hours__c=44,
    Account__c=acc.Id,Start_Date__c=system.today()-30, Stop_Date__c=system.today()+30,
    Allocated_Resource__c=c.Id,Next_Bill_Date__c = system.today()-1,Is_Active__c = True);
    insert prj;
    List<Project__c> plist=new List<Project__c>();
    plist.add(prj);
    recordtype prjTeamRecType=[select id,Name from recordtype where sobjecttype='Project_Member__c' 
    and  Name='Project Team Member' ];
    
    recordtype taskRecType=[select id,Name from recordtype where sobjecttype='Project_Member__c' 
    and Name='Task Team Member'];

    Contact c1=new Contact(FirstName='Sobia', LastName='Khan', Account=accVen, Phone='3125551234');
    insert c1;
    User u1=[Select ContactId,ID ,NAme from User limit 1];//new User(FirstName='Sobia',LastName='Khan',ContactId=c.Id,Email='sobia@spyrel.com');
     
    Project_Member__c projMember=new Project_Member__c();
    ProjMember.recordtypeId=prjTeamRecType.Id;
    ProjMember.Hourly_Bill_Rate__c = 50.00;

    projMember.Contact__c=c1.Id ;
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
    taskMember.Project__c = prj.Id;
    taskMember.Hourly_Bill_Rate__c = 50.00;
    taskMember.recordtypeId=taskRecType.Id;
    taskMember.Contact__c=c1.Id ;
    taskMember.tasks__c=t.Id;
    
    insert taskMember;

   Revisions__c r= new Revisions__c();
   r.Gantt_Data__c='test';
   r.Revision_Name__c='test';
   r.SObject_Id__c=prj.Id;
   r.Project__c=prj.Id;
   r.Version__c=4.0;
   insert r;
   // pageRef.getParameters().put('cId',c.Id);
    ApexPages.standardController controller = new ApexPages.standardController(r);
    
     view_revisions_controller controllerExt = new   view_revisions_controller(controller);
    
    Map<String, Schema.sObjectField> fields_map;
    fields_map = Schema.SObjectType.Check_List_Header__c.fields.getMap();
    List<SelectOption> options = new List<SelectOption>();
    List<String> categories=new List<String>();
    
    for (Schema.PicklistEntry p : fields_map.get('Stage__c').getDescribe().getPicklistValues()) {
    
    options.add(new SelectOption(p.getValue(), p.getLabel()));
    categories.add(p.getValue());
    }
    
   
    
  
  controllerExt.selected_version='4.0';
  controllerExt.refresh_data();
  controllerExt.back_project();
    
    //check_list_controller cnt = new  check_list_controller(controller);
    //cnt.check_list_wrapper();// cw=new  controllerExt.check_list_wrapper();
    
  }
  
  
  
  
  }