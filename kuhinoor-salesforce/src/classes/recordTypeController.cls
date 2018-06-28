public class recordTypeController{
public String recordname{get;set;}

    public list<recordtype__c> record{get;set;}
     public list<RecordType> dropdown{get;set;}
      public list<SelectOption> picklist{get;set;}
    
    public recordTypeController(){
       dropdown = new list<RecordType>();
       picklist = new list<SelectOption>();
       record = new list<recordtype__c>();
       dropdown = [select id,name from RecordType where sobjectType='recordType__c'];
       for(RecordType r : dropdown)
       {
          picklist.add(new selectoption(r.id,r.name));
       }
       system.debug('recordname='+recordname);
    }
    public void send(){
    system.debug('recordname='+recordname);
   
   // String query='select recordtypeid,firstname__c,lastname__c,email__c,phone__c,address__c from recordtype__c where recordtypeid=:recordname';
    //system.debug('query'+query);
   // record=database.query(query);
     record = [select recordtypeid,firstname__c,lastname__c,email__c,phone__c,address__c from recordtype__c where recordtypeid=:recordname];
     system.debug('record ='+record );
     
    }
    
    
}