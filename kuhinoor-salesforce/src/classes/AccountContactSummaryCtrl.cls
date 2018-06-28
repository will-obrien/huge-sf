public class  AccountContactSummaryCtrl{
   list<String> headerLst{get;set;}
   public list<String> contact3recordtype {get;set;}
   public  list<String> storeRecrdtype{get;set;}
    public AccountContactSummaryCtrl(){
        
        headerLst = new  list<String>();
        contact3recordtype = new  list<String>();
        storeRecrdtype = new  list<String>();
    
        map<String,decimal>  conMap = new map<String,decimal>();
        list<Contact> conlist = [select id,lastname,lightingprefix__Timesheet_Date__c,lightingprefix__Days__c from contact where Accountid='0019000001gVS7c'];
        //Id contact3RecordType= Schema.SObjectType.contact.getRecordTypeInfosByName().get('Contact3').getRecordTypeId();
        for(contact c : conlist){           
           String key = contact3RecordType+'' + c.lightingprefix__Timesheet_Date__c;
           if(conMap.containskey(key)){
               decimal count = conmap.get(key);
               count = count+c.lightingprefix__Days__c;
               conmap.put(key,c.lightingprefix__Days__c);
           }else{
              conmap.put(key,c.lightingprefix__Days__c);
           }
        }
        system.debug('####'+conmap);
        
       
        for(contact con : conlist){
             String key = con.recordTypeid+'' + con.lightingprefix__Timesheet_Date__c;
             if(conmap.containskey(key)){
               String temp =''+ conmap.get(key);
               contact3recordtype.add(temp );  
             }else{
                 contact3recordtype.add('0');  
             }
        }
        
    }
}