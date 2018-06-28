//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Controller Class for VF Component GivingOther. Created For Task T-251565.
//                  
// Original : February 27, 2014  : KapiL Choudhary(Appirio India) 
// Updated  :
//      
//          
// ***************************************************************************/

public class GivingOtherController {
	public string accountId {get;set;}
	public string contactId {get;set;}
	string OtherRecTypeId;
	public string givingIdToDelete{get;set;}
	public list<Opportunity> OthersList{get;set;}
	public boolean isMore {get;set;}
	public integer recCount{get;set;}
	public GivingOtherController(){
		OtherRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		OthersList = new list<Opportunity>();
		recCount=0;
		accountId = '';
		contactId = '';
		string currentId = ApexPages.currentPage().getParameters().get('id');
		if(currentId != null && currentId != ''){
			//Fech records for related account.
			if(currentId.startsWith('001')){
				fetchOthers();
			}
			//Fech records for related contact.
			if(currentId.startsWith('003')){
				fetchOthersForContacts();
			}
		}
	}

	public void fetchOthers() {
		// system.debug('accountId>>> '+accountId);
		 OthersList = new list<Opportunity>();
		 accountId = ApexPages.currentPage().getParameters().get('id');
	        String query = 'SELECT ';
	        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.GivingOther.getFields()) {
	            query += f.getFieldPath() + ', ';
	        }
	        query += 'Id,rC_Giving__GAU__r.name, RecordType.Name FROM Opportunity Where AccountId =\''+accountId+'\'and RecordTypeId != \''+OtherRecTypeId +'\'';
	        query += ' order by CloseDate desc'; 
	        recCount =0;
	        for(Opportunity opp :Database.query(query)){
	        	recCount+=1;
	        	if(recCount<=5){
	        		OthersList.add(opp);
	        	}
	        	
	        }
	        //system.debug('OthersList>>> '+OthersList);
    }
    
    public void fetchOthersForContacts() {
		// system.debug('accountId>>> '+accountId);
		 OthersList = new list<Opportunity>();
		 contactId = ApexPages.currentPage().getParameters().get('id');
	        String query = 'SELECT ';
	        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.GivingOther.getFields()) {
	            query += f.getFieldPath() + ', ';
	        }
	        query += 'Id,rC_Giving__GAU__r.name, RecordType.Name FROM Opportunity Where Donor_Contact__c =\''+contactId+'\'and RecordTypeId != \''+OtherRecTypeId +'\'';
	        query += ' order by CloseDate desc'; 
	        system.debug('query >>>> '+query);
	        recCount =0;
	        for(Opportunity opp :Database.query(query)){
	        	recCount+=1;
	        	if(recCount<=5){
	        		OthersList.add(opp);
	        	}
	        	
	        }
	        system.debug('OthersList>>> '+OthersList);
    }
    
    public void deleteGiving(){
    	if(givingIdToDelete != null && givingIdToDelete != ''){
    		Opportunity opp = new Opportunity(id=givingIdToDelete);
    		try{
    					delete opp;
    					fetchOthers();
    					
    				}
		    		catch(exception ex){
		    			//system.debug('Exception :::'+ex);
		    			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));	
		    		}
    		
    	}
    }
}