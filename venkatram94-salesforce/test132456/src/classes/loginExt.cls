public with sharing class loginExt {
    
    public login__c l{get;set;}
    public PageReference pref;
    
    public loginExt(ApexPages.StandardController controller) {
        l=(login__c)controller.getRecord();
    }
    
    public PageReference submit() {
       List<login__c> loginList = [select Name,Password__c from login__c];
        for(login__c lc:loginList) {
            if(l.name == lc.name && l.Password__c == lc.Password__c) {
                pref = new PageReference('/a0l/o');  
                 return pref;
            
            }
            else  { 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid UserName or Password'));
                
            }
           
        }
         return null;
    }

}