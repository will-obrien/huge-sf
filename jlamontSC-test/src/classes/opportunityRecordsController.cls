//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Controller Class for VF page opportunityRecords. Created For Task T-251565.
//                  
// Original : February 24, 2014  : KapiL Choudhary(Appirio India) 
// Updated  :
//      
//          
// ***************************************************************************/
public class opportunityRecordsController {
	public string accountId {get;set;}
	public string contactId {get;set;}
	string ProposalRecTypeId;
	public string recordTypeName{get;set;}
	public string accountName {get;set;}
	public list<Opportunity> ProposalsList{get;set;}
	public boolean isMore {get;set;}
	public list<string> fieldSetNameList {get;set;}
	public string contactName{get;set;}
	
	public opportunityRecordsController(){
		fieldSetNameList = new list<string>();
		contactId = '';
		accountId = '';
		string currentRecord = ApexPages.currentPage().getParameters().get('id');
		recordTypeName = ApexPages.currentPage().getParameters().get('recType'); 
		if(currentRecord != null && currentRecord != ''){
			if(currentRecord.startsWith('001')){
				accountId = currentRecord;
			}
			if(currentRecord.startsWith('003')){
				contactId = currentRecord;
			}
		}
		if(recordTypeName != null && recordTypeName != ''){
				ProposalRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		}
		
		ProposalsList = new list<Opportunity>();
		if(recordTypeName == 'Proposal'){
			fetchProposals();
		}
		if(recordTypeName == 'Other'){
				fetchOthers();
		}
	}
	
	private void fetchOthers(){
		
	        String query = 'SELECT ';
	        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.GivingOther.getFields()) {
	            query += f.getFieldPath() + ', ';
	            fieldSetNameList.add(f.getFieldPath());
	        }
	        if(accountId != ''){
	        	query += 'Id ,Account.Name FROM Opportunity Where AccountId =\''+accountId+'\'and RecordTypeId != \''+ProposalRecTypeId +'\'';
	        }
	        if(contactId != ''){
	        	query += 'Id ,Donor_Contact__r.FirstName,Donor_Contact__r.LastName FROM Opportunity Where Donor_Contact__c =\''+contactId+'\'and RecordTypeId != \''+ProposalRecTypeId +'\'';
	        }
	        query += ' order by CloseDate desc'; 
	        ProposalsList = Database.query(query);
	        //ProposalsList = Database.query(query);
	        system.debug('ProposalsList>>> '+ProposalsList);
	        if(!ProposalsList.isEmpty()){
	        	if(accountId != ''){
	        		accountName = ProposalsList[0].Account.Name;
	        	}
	        	if(contactId != ''){
	        		contactName = ProposalsList[0].Donor_Contact__r.FirstName + ' '+ ProposalsList[0].Donor_Contact__r.LastName;
	        	}
	        }
	        
	}
	public void fetchProposals() {
		 system.debug('accountId>>> '+accountId);
		 
	        String query = 'SELECT ';
	        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.GivingProposals.getFields()) {
	            query += f.getFieldPath() + ', ';
	            fieldSetNameList.add(f.getFieldPath());
	        }
	        if(accountId != ''){
	        	query += 'Id, Account.Name, Opportunity.Name FROM Opportunity Where AccountId =\''+accountId+'\'and RecordTypeId= \''+ProposalRecTypeId +'\'';
	        }
	        if(contactId != ''){
	        	query += 'Id, Donor_Contact__r.FirstName,Donor_Contact__r.LastName, Opportunity.Name FROM Opportunity Where Donor_Contact__c =\''+contactId+'\'and RecordTypeId= \''+ProposalRecTypeId +'\'';
	        }
	        
	        query += ' order by CloseDate desc'; 
	        ProposalsList = Database.query(query);
	        //ProposalsList = Database.query(query);
	        system.debug('ProposalsList>>> '+ProposalsList);
	        if(!ProposalsList.isEmpty()){
	        	if(accountId != ''){
	        		accountName = ProposalsList[0].Account.Name;
	        	}
	        	if(contactId != ''){
	        		contactName = ProposalsList[0].Donor_Contact__r.FirstName + ' '+ ProposalsList[0].Donor_Contact__r.LastName;
	        	}
	        }
    }
}