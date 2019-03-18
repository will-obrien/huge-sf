public class CreateTeam {
    public Team__c CreateTeam{get;set;}
    public Team__c ct;
    
    public CreateTeam(ApexPages.StandardController controller) {
        ct=(Team__c)Controller.getrecord();

    }
    
    public pagereference Save(){
        insert ct;
        pagereference refer= new pagereference ('/apex/success');
        return refer;
    }
    
    public pagereference Cancel(){
       
        return null;
    }
}