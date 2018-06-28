global class UpdateAccountSync implements Database.Batchable<sObject>,Database.StateFul{
    
	public String mode;  
    global UpdateAccountSync (String mode){
        this.mode = mode;
    }
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      
      Date dtToday = system.today();
      String mode = this.mode;
      if(mode == 'null')
          return Database.getQueryLocator('select Id, Name, AccountId, Last_Account_Sync__c from Contact where Last_Account_Sync__c != null ');
      else if(mode=='date')
          return Database.getQueryLocator('select Id, Name, AccountId, Last_Account_Sync__c from Contact where Last_Account_Sync__c !=: dtToday ');
      else  
          return Database.getQueryLocator('select Id, Name, AccountId, Last_Account_Sync__c from Contact where Id =: mode');
   }

   global void execute(Database.BatchableContext BC, List<Contact> scope){
        List<Id> ids = new List<Id>();
        List<Contact> clist = new List<Contact>();
        for(Contact con : scope) {
            ids.add(con.AccountId);
            clist.add(con);
        }
        
        for(Contact con : clist)
            con.Last_Account_Sync__c = date.today();
        update clist;
    }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}