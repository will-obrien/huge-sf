public with sharing class MassAssignOpportunityController {
        
    public Opportunity tempOpp {get;set;}
    
    public MassAssignOpportunityController(){
       tempOpp = new Opportunity();
    }
    

    
    public list<String> convertToList(String oppIDs){
        list<String> oppIDList = oppIDs.split(','); 
        return oppIDList;
    }
    
    
    public String getRetVal(){
        String retVal = apexpages.currentpage().getparameters().get('retVal'); 
        return retVal;
    }
      
      
      
    public PageReference saveOpportunities() {
    	if(tempOpp.ownerid == null){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a person to assign the Opportunity to'));
        	return null;
        }
        list<String> oppIDList = convertToList(apexpages.currentpage().getparameters().get('opportunityIDs'));
        list<Opportunity> oppList;   
        oppList = [SELECT id, ownerid FROM Opportunity WHERE id IN :oppIDList];
        for(Opportunity opp: oppList){   
        	opp.ownerid=tempOpp.ownerid;
        	
        }
        update oppList; 
		PageReference pageRef = new PageReference(getRetVal());
        return pageRef;
    }
    
    public PageReference cancelAndReturn() {
        PageReference pageRef = new PageReference(getRetVal());
        return pageRef;
    
    }

}