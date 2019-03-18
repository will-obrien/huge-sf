public class test_insertTaskTeam{

  public static testMethod void test_insertTaskTeam() {
  
  
  
  Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678');
  insert acc;
  Contact c=new Contact(FirstName='Sobia', LastName='Khan', Account=acc, Phone='3125551234');
  insert c;
  recordtype prjRecType=[select id from recordtype where sobjecttype='Project__c' 
  and name='Hourly Recurring'];
  Project__c prj=new Project__c(recordtypeid=prjRecType.Id,Description__c='test',
  Account__c=acc.Id,Allocated_Resource__c=c.Id);
  insert prj;
  
  
  
  
  
 }



}