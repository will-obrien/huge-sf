@IsTest
public with sharing class RecalculateParentOpportunityTest {
	static Id opportunityDonationTypeId;
	static Id opportunityProposalTypeId;
	static Id accountHouseholdTypeId;
	static Account account1;
	static rC_Giving__GAU__c givingGAU;
	static Campaign promotionCampaign;
	static Opportunity opp1, opp2;
	
	static {
		opportunityDonationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opportunityProposalTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}
	@isTest
	static void testRecalculate() {
		account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
        insert account1;
		givingGAU = new rC_Giving__GAU__c();
		givingGAU.Name = 'Test Data GAU';
		givingGAU.GivingType__c = 'Donations';
		givingGAU.Recipient__c = 'Club';
		givingGAU.FundType__c = 'Chapter Funds';
		insert givingGAU;
		
		promotionCampaign = new Campaign();
		promotionCampaign.Name = 'test opp camp';
		promotionCampaign.Type = 'Promotion';
		promotionCampaign.Status = 'Planned';
		insert promotionCampaign;
		
		opp1 = new Opportunity();
		opp1.name = 'Test Donation';
		opp1.rC_Giving__GAU__c = givingGAU.Id;
		opp1.AccountId = account1.Id;
		opp1.CloseDate = system.today().addDays(3);
		opp1.StageName = 'Completed';
		opp1.rC_Giving__Projected_Amount__c = 1000;
		opp1.Campaign = promotionCampaign;
		opp1.rC_Giving__Giving_Amount__c = 1110;
		opp1.rC_Giving__Closed_Amount__c = 1110;
		opp1.RecordTypeId = opportunityProposalTypeId;
		opp1.rC_Giving__Giving_Years__c = 2;
		opp1.rC_Giving__Giving_Frequency__c = 'Quarterly';
		insert opp1;
		opp1 = [SELECT Id, LastModifiedDate FROM Opportunity WHERE Id = :opp1.Id];
		
		DateTime dtOppCreated = opp1.LastModifiedDate;
		
		opp2 = new Opportunity();
		opp2.name = 'Test Giving';
		opp2.rC_Giving__GAU__c = givingGAU.Id;
		opp2.AccountId = account1.Id;
		opp2.CloseDate = system.today().addDays(3);
		opp2.StageName = 'Completed';
		opp2.rC_Giving__Projected_Amount__c = 1000;
		opp2.Campaign = promotionCampaign;
		opp2.rC_Giving__Giving_Amount__c = 1110;
		opp2.rC_Giving__Closed_Amount__c = 1110;
		opp2.RecordTypeId = opportunityDonationTypeId;
		opp2.rC_Giving__Parent__c = opp1.Id;
		opp2.rC_Giving__Giving_Years__c = 2;
		opp2.rC_Giving__Giving_Frequency__c = 'Quarterly';
		insert opp2;
		
		Test.startTest();
		delete opp2;
		Test.stopTest();
		
		Opportunity opp = [SELECT Id, LastModifiedDate FROM Opportunity WHERE Id = :opp1.Id];
		System.assert(opp.LastModifiedDate > dtOppCreated);
	}
}