global with sharing class AccountRemoter {

    public String accountName { get; set; }
    public static Account account { get; set; }
    public AccountRemoter() { } // empty constructor
    
    global class appData {
        public string name { get; set; }
        public string phone { get; set; }
    }
    
    
    global class returnData {
        public List<sObject> recordData { get; set; }
        public List<sObject> objectData { get; set; }
    }    
  
  
  
  
   
    @RemoteAction
    global static string fetchPanel(String recordId) {
    
    
    
        //List<sObject> L = Database.query('SELECT Id, Name FROM contact WHERE Id = :recordId');
        
        //system.debug('* * * In Account Remoter ...'+L);
        
       return ObjectDescribe.get_ObjectInfo(recordId);
    }
   
    @RemoteAction
    global static Account getAccount(String accountName) {
        account = [SELECT Id, Name, Phone, Type, NumberOfEmployees 
                   FROM Account WHERE Name = :accountName];
        system.debug('* * * In Account Remoter ...'+account);
        return account;
    }
    

    @RemoteAction
    global static String getUserName(appData data) {
    
        System.Debug('data:' + data.name);
        System.Debug('data:' + data.phone);
        
        Schema.DescribeFieldResult fieldResult =
         Contact.Membership_Type__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
         Schema.PicklistEntry fSave;
        
           for( Schema.PicklistEntry f : ple)
           {
              fSave = f;
              System.Debug('pick:' + f.getLabel() + ':' + f.getValue());
           }               
                
     Contact c = new Contact();
     
     c.Membership_Type__c = fSave.getValue();
     c.FirstName = data.name;
     c.Email = 'bob@garp.com';

      
     //insert c; // inserts the new record into the database


        
              
    
        Id userId=userinfo.getUserId();
        String userName=[Select Id,Name from User where Id=:userId].Name;
        system.debug('* * * In UserName Remoter ...'+userName);
        return userName;
    }

    @RemoteAction
    global static string getMembershipTypeFieldMetaData() {
        Schema.DescribeFieldResult F = Contact.Membership_Type__c.getDescribe(); 
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        list<string> peList = new list<string> () ;
        string peString ;
        for( Schema.PicklistEntry pe : P ) {
          peString = pe.getValue() ;
          peList.add(peString) ;
        }
         return JSON.serialize(peList);

       // system.debug('* * * In getMembershipTypeFieldMetaData Remoter ...');
       // return 'rob';
    }  
  
    public String[] getMemeberShip()
    {
        
        Schema.DescribeFieldResult F = Contact.Membership_Type__c.getDescribe(); 
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        list<string> peList = new list<string> () ;
        string peString ;
        for( Schema.PicklistEntry pe : P ) {
          peString = pe.getValue() ;
          peList.add(peString) ;
        }
        return peList;      
    }
}