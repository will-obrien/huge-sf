public with sharing class OpportunityWrapper {
	
	public Opportunity opportunity {get;set;}
	public boolean selected {get;set;}
	public String selectedOwnerId {get;set;}
	public String firstName {get;set;}
	public String lastName {get;set;}
	public String email {get;set;} 
	public String isNew {get;set;}
	public map<String,String> opportunityOwnersMap {get;set;}
	public boolean isUpdateable {get;set;}
	
	public OpportunityWrapper(Opportunity opportunity,map<String,String> opportunityOwnersMap){
		this.opportunity = opportunity;
		this.opportunityOwnersMap = opportunityOwnersMap;
		this.selected = false;
		this.selectedOwnerId = opportunity.OwnerId;
	}
	
	public OpportunityWrapper(map<String,String> opportunityOwnersMap){
		this.opportunityOwnersMap = opportunityOwnersMap;
		this.selected = false;
	}
	
	public void setOpportunity(Opportunity opportunity){
		this.opportunity = opportunity;
	}
	
	public list<SelectOption> getOwners(){
		list<SelectOption> options = new list<SelectOption>();
		for(String ownerId : opportunityOwnersMap.keySet()){
			options.add(new SelectOption(ownerId,opportunityOwnersMap.get(ownerId)));
		}
		return options;
	}
	
	public void setOpportunityOwnerId(){
		this.opportunity.OwnerId = this.selectedOwnerId;
	}
	
}