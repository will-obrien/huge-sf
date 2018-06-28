public class login {

    public login log{get;set;}
    
    public login(){
    
    }
    public PageReference submit() {
        List<Admin__c> adminList = [Select Name,Admin_Password__c from Admin__c];
        for(Admin__c ad:adminList) {
          
        } 
        return null;
    }

}