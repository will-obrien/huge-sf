Public Class test_createPhaseCategories {

public static testMethod void test_createPhaseCategories() {

    Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678');
    insert acc;
    Account accVen=new Account(Name='Test Acount',Type = 'Partner',Account_Number__c='2345678');
    insert accVen;
    Contact c=new Contact(FirstName='Sobia', LastName='Khan', Account=acc, Phone='3125551234');
    insert c;
    User u=[Select ContactId,ID ,NAme from User limit 1];//new User(FirstName='Sobia',LastName='Khan',ContactId=c.Id,Email='sobia@spyrel.com');
     
    recordtype prjRecType=[select id from recordtype where sobjecttype='Project__c' 
    and name='Hourly Recurring'];
    
    Project__c prj=new Project__c(recordtypeid=prjRecType.Id,Description__c='test',Allocated_Hours__c=44,
    Account__c=acc.Id,Start_Date__c=system.today()-30, Stop_Date__c=system.today()+30,
    Allocated_Resource__c=c.Id,Next_Bill_Date__c = system.today()-1,Is_Active__c = True);
    insert prj;
    
    
    Delete prj;
    
    }
    
    }