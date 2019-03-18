Public Class test_Stakeholder {

public static testMethod void test_Stakeholder() {

    Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678');
    insert acc;
    Account accVen=new Account(Name='Test Acount',Type = 'Partner',Account_Number__c='2345678');
    insert accVen;
    Contact c=TestingUtils.createContacts(1, acc.Id, true)[0];
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
    
    Stakeholder__c s=new Stakeholder__c();
    s.Contact__c=c.id;
    
    s.Project__c=prj.Id;
    s.Stakeholder_Role__c='Architect';
    
    insert s;
     
    recordtype taskRecType=[select id,Name from recordtype where sobjecttype='Project_Member__c' 
    and Name='Task Team Member'];
     
     
     ApexPages.standardController controller = new ApexPages.standardController(prj);
    cls_Stakeholder controllerExt=new cls_Stakeholder(controller) ;
     controllerExt.setselected_role('Architect');
     controllerExt.getselected_role();
     controllerExt.getdelIndex();
     controllerExt.setdelIndex(1);
     controllerExt.getstakeholder_Records();
     controllerExt.Save();
     controllerExt.AddRow();
     controllerExt.DeleteRow();
     controllerExt.navigatetoContact();
     
     
     
     }
     
     
     }