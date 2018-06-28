/*
RecalculateParentOpportunity

If a deleted Opportunity is a Record Type: Donation 
and if it has a parent Opportunity of record Type: Proposal, 
then update the parent to force the recalculation of the Closed Amount. 

Created by:	Mark Maslow
Created on: September, 2014
*/
public with sharing class RecalculateParentOpportunity {
	static Id opportunityDonationTypeId;
	static Id opportunityProposalTypeId;
	
	static {
		opportunityDonationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opportunityProposalTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
	}
	
	public static void recalculate(List<Opportunity> oppList) {
		Set<Id> parentSet = new Set<Id>();
		for(Opportunity opp : oppList) {
			if( (opp.RecordTypeId == opportunityDonationTypeId) && ( ! String.isEmpty(opp.rC_Giving__Parent__c) ) ) {
				parentSet.add(opp.rC_Giving__Parent__c);
			}
		}
		
		List<Opportunity> parentList = new List<Opportunity>([
			SELECT Id FROM Opportunity 
			WHERE Id in :parentSet AND RecordTypeId = :opportunityProposalTypeId  
		]);
		
		if(parentList.size() > 0) {
			List<Opportunity> oppsToUpdate = new List<Opportunity>();
			for(Opportunity opp : parentList) {
				oppsToUpdate.add(opp);
			}
			update oppsToUpdate;
		}
	}
}