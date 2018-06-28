//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Controller Class for VF Component GivingProposals. Created For Task T-251565.
//                  
// Original : February 22, 2014  : KapiL Choudhary(Appirio India) 
// Updated  :
//      
//          
// ***************************************************************************/
public class GivingProposalsController {
	public string accountId {get;set;}
	public string contactId {get;set;}
	public string cntAccId{get;set;}
	string ProposalRecTypeId;
	public string givingIdToDelete{get;set;}
	public list<Opportunity> ProposalsList{get;set;}
	public boolean isMore {get;set;}
	public integer recCount{get;set;}
	public givingProposalsController(){
		ProposalRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		ProposalsList = new list<Opportunity>();
		recCount=0;
		contactId = '';
		string currentId = ApexPages.currentPage().getParameters().get('id');
		if(currentId != null && currentId != ''){
			//Fech records for related account.
			if(currentId.startsWith('001')){
				fetchProposals();
			}
			//Fech records for related contact.
			if(currentId.startsWith('003')){
				fetchProposalsForContacts();
			}
		}
	}

	private void fetchProposalsForContacts(){
		 //system.debug('accountId>>> '+accountId);
		 ProposalsList = new list<Opportunity>();
		 contactId = ApexPages.currentPage().getParameters().get('id');
		 for(Contact cnt : [Select AccountId From Contact Where Id =: contactId]) {
		 	 cntAccId = cnt.AccountId;
		 }
	        
	        String query = 'SELECT ';
	        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.GivingProposals.getFields()) {
	            query += f.getFieldPath() + ', ';
	        }
	        query += 'Id, Name FROM Opportunity Where Donor_Contact__c =\''+contactId+'\'and RecordTypeId= \''+ProposalRecTypeId +'\'';
	        query += ' order by CloseDate desc'; 
	        recCount =0;
	        for(Opportunity opp :Database.query(query)){
	        	recCount+=1;
	        	if(recCount<=5){
	        		ProposalsList.add(opp);
	        	}
	        	
	        }
	        //ProposalsList = Database.query(query);
	        //system.debug('ProposalsList>>> '+ProposalsList);
	}
	public void fetchProposals() {
		 //system.debug('accountId>>> '+accountId);
		 ProposalsList = new list<Opportunity>();
		 accountId = ApexPages.currentPage().getParameters().get('id');
		if(accountId != null && accountId != ''){
	        String query = 'SELECT ';
	        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.GivingProposals.getFields()) {
	            query += f.getFieldPath() + ', ';
	            system.debug('::::: ' + f.getFieldPath());
	        }
	        query += 'Id, Name FROM Opportunity Where AccountId =\''+accountId+'\'and RecordTypeId= \''+ProposalRecTypeId +'\'';
	        query += ' order by CloseDate desc'; 
	        recCount =0;
	        for(Opportunity opp :Database.query(query)){
	        	recCount+=1;
	        	if(recCount<=5){
	        		ProposalsList.add(opp);
	        	}
	        	
	        }
	        //ProposalsList = Database.query(query);
	        //system.debug('ProposalsList>>> '+ProposalsList);
		}
    }
    
    public void deleteGiving(){
    	if(givingIdToDelete != null && givingIdToDelete != ''){
    		Opportunity opp = new Opportunity(id=givingIdToDelete);
    		try{
    					delete opp;
    					fetchProposals();
    					
    				}
		    		catch(exception ex){
		    			//system.debug('Exception :::'+ex);
		    			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));	
		    		}
    		
    	}
    }
}