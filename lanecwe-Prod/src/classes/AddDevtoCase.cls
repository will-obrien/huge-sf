public class AddDevtoCase{

    public Case currentCase {get; set;}
    public List<Development__c> devs {get; set;}
    
    //Constructor
    public AddDevToCase(){
        currentCase = [select Id, Subject from Case where Id = :ApexPages.currentPage().getParameters().get('id')];
        devs = new List<Development__c>();
    }
    
    public void NewDev(){
        devs.add(new Development__c(Case__c = currentCase.Id));
    }
    
    public PageReference save(){
        insert devs;
        PageReference p = new PageReference('/'+currentCase.Id);
        p.setRedirect(true);
        return p;
    }
    public PageReference cancel(){ 
        PageReference pr = new PageReference('/'+currentCase.Id);
        pr.setRedirect(true);
        return pr;
    }
    
}