global class batchJob implements Database.Batchable<sObject>,Database.StateFul{
    
    public String mode;  
    global batchJob (String mode){
        this.mode = mode;
    }
     
   global Database.QueryLocator start(Database.BatchableContext BC){  
       return Database.getQueryLocator('select Id, Name from Contact where KPI_Last_Updated_Date__c = Today');
       //if(mode == 'wiley')
       //		return Database.getQueryLocator('select Id, Name from Opportunity where Wiley__c != null');
       //else if(mode == 'exams')
       //    return Database.getQueryLocator('select Id, Name from Opportunity where Exam_Emails__c != null');
       //else return Database.getQueryLocator('select Id, Name from Opportunity where Exam_Emails__c != null');
   }

   global void execute(Database.BatchableContext BC, List<Contact> scope){

       	
        //List<Opportunity> lstOpp = [select Id, Name from Opportunity where Id in :scope];
        for(Contact c :scope)
            c.KPI_Last_Updated_Date__c = null;
        update scope;
       
    }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}