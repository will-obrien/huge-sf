/*
OpportunitySummaryCreatorTest

Test for class OpportunitySummaryCreator

Created by:	Mark Maslow
Created on: August 15, 2014
*/
@isTest
public class OpportunitySummaryCreatorTest {

	static Id donationTypeId;
	static Id membershipTypeId;

	static {
		donationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		membershipTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
	}

	@IsTest
    static void testOpportunitySummary() {
    	TestDataUtility testData = new TestDataUtility();
    	rC_Giving__GAU__c gau = testData.createNewGivingGAU();
    	Campaign campaign = testData.createNewCampaign();

        rC_Giving__GAU__c membershipGAU = new rC_Giving__GAU__c();
        membershipGAU.Name = 'Test Data Membership GAU';
        membershipGAU.GivingType__c = 'Membership';
        membershipGAU.Recipient__c = '';
        membershipGAU.FundType__c = '';
   	  	insert membershipGAU;
    	
    	Account account1 = testData.createNewAccount(true, 'Account1', 'Household');
    	Account account2 = testData.createNewAccount(true, 'Account2', 'Household');
    	Account account3 = testData.createNewAccount(true, 'Account3', 'Household');
  	
		List<Opportunity> oppList = new List<Opportunity>();
		
    	Opportunity opp1 = createNewOpportunity();
    	opp1.rC_Giving__GAU__c = gau.Id;
    	opp1.CampaignId = campaign.Id;
    	opp1.RecordTypeId = donationTypeId;
    	opp1.GivingType__c = 'Donations';
    	opp1.AccountId = account1.Id;
    	opp1.CloseDate = date.newInstance(2014,2,1);
    	opp1.rC_Giving__Closed_Amount__c = 100;
    	opp1.rC_Giving__Giving_Amount__c = 100;
    	oppList.add(opp1);

    	Opportunity opp2 = createNewOpportunity();
    	opp2.rC_Giving__GAU__c = gau.Id;
    	opp2.CampaignId = campaign.Id;
    	opp2.RecordTypeId = donationTypeId;
    	opp2.GivingType__c = 'Donations';
    	opp2.AccountId = account1.Id;
    	opp2.CloseDate = date.newInstance(2014,1,15);
    	opp2.rC_Giving__Closed_Amount__c = 1000;
    	opp2.rC_Giving__Giving_Amount__c = 1000;
    	oppList.add(opp2);
    	
    	Opportunity opp3 = createNewOpportunity();
    	opp3.rC_Giving__GAU__c = membershipGAU.Id;
    	opp3.CampaignId = campaign.Id;
    	opp3.RecordTypeId = donationTypeId;
    	opp3.GivingType__c = 'Membership';
    	opp3.AccountId = account1.Id;
    	opp3.CloseDate = system.today().addDays(-5);
    	opp3.rC_Giving__Closed_Amount__c = 35;
    	opp3.rC_Giving__Giving_Amount__c = 35;
    	oppList.add(opp3);

    	Opportunity opp4 = createNewOpportunity();
    	opp4.rC_Giving__GAU__c = gau.Id;
    	opp4.CampaignId = campaign.Id;
    	opp4.RecordTypeId = donationTypeId;
    	opp4.GivingType__c = 'Donations';
    	opp4.AccountId = account1.Id;
    	opp4.CloseDate = date.newInstance(2015,6,1);
    	opp4.rC_Giving__Closed_Amount__c = 10;
    	opp4.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp4);

    	Opportunity opp5 = createNewOpportunity();
    	opp5.rC_Giving__GAU__c = gau.Id;
    	opp5.CampaignId = campaign.Id;
    	opp5.RecordTypeId = donationTypeId;
    	opp5.GivingType__c = 'Donations';
    	opp5.AccountId = account1.Id;
    	opp5.CloseDate = date.newInstance(2016,6,1);
    	opp5.rC_Giving__Closed_Amount__c = 10;
    	opp5.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp5);

    	Opportunity opp6 = createNewOpportunity();
    	opp6.rC_Giving__GAU__c = gau.Id;
    	opp6.CampaignId = campaign.Id;
    	opp6.RecordTypeId = donationTypeId;
    	opp6.GivingType__c = 'Donations';
    	opp6.AccountId = account1.Id;
    	opp6.CloseDate = date.newInstance(2017,6,1);
    	opp6.rC_Giving__Closed_Amount__c = 10;
    	opp6.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp6);

    	Opportunity opp7 = createNewOpportunity();
    	opp7.rC_Giving__GAU__c = gau.Id;
    	opp7.CampaignId = campaign.Id;
    	opp7.RecordTypeId = donationTypeId;
    	opp7.AccountId = account1.Id;
    	opp7.GivingType__c = 'Donations';
    	opp7.CloseDate = date.newInstance(2018,6,1);
    	opp7.rC_Giving__Closed_Amount__c = 10;
    	opp7.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp7);

    	Opportunity opp8 = createNewOpportunity();
    	opp8.rC_Giving__GAU__c = gau.Id;
    	opp8.CampaignId = campaign.Id;
    	opp8.RecordTypeId = donationTypeId;
    	opp8.GivingType__c = 'Donations';
    	opp8.AccountId = account1.Id;
    	opp8.CloseDate = date.newInstance(2019,6,1);
    	opp8.rC_Giving__Closed_Amount__c = 10;
    	opp8.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp8);

    	Opportunity opp9 = createNewOpportunity();
    	opp9.rC_Giving__GAU__c = gau.Id;
    	opp9.CampaignId = campaign.Id;
    	opp9.RecordTypeId = donationTypeId;
    	opp9.GivingType__c = 'Donations';
    	opp9.AccountId = account1.Id;
    	opp9.CloseDate = date.newInstance(2020,6,1);
    	opp9.rC_Giving__Closed_Amount__c = 10;
    	opp9.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp9);

    	Opportunity opp10 = createNewOpportunity();
    	opp10.rC_Giving__GAU__c = gau.Id;
    	opp10.CampaignId = campaign.Id;
    	opp10.RecordTypeId = donationTypeId;
    	opp10.GivingType__c = 'Donations';
    	opp10.AccountId = account2.Id;
    	opp10.CloseDate = date.newInstance(2013,6,1);
    	opp10.rC_Giving__Closed_Amount__c = 10;
    	opp10.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp10);

    	Opportunity opp11 = createNewOpportunity();
    	opp11.rC_Giving__GAU__c = gau.Id;
    	opp11.CampaignId = campaign.Id;
    	opp11.RecordTypeId = donationTypeId;
    	opp11.GivingType__c = 'Donations';
    	opp11.AccountId = account2.Id;
    	opp11.CloseDate = date.newInstance(2012,6,1);
    	opp11.rC_Giving__Closed_Amount__c = 10;
    	opp11.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp11);

    	Opportunity opp12 = createNewOpportunity();
    	opp12.rC_Giving__GAU__c = gau.Id;
    	opp12.CampaignId = campaign.Id;
    	opp12.RecordTypeId = donationTypeId;
    	opp12.GivingType__c = 'Donations';
    	opp12.AccountId = account1.Id;
    	opp12.CloseDate = date.newInstance(2020,6,1);
    	opp12.rC_Giving__Closed_Amount__c = 20;
    	opp12.rC_Giving__Giving_Amount__c = 20;
    	opp12.External_ID__c = '11111111';
    	oppList.add(opp12);

    	Opportunity opp13 = createNewOpportunity();
    	opp13.rC_Giving__GAU__c = gau.Id;
    	opp13.CampaignId = campaign.Id;
    	opp13.RecordTypeId = donationTypeId;
    	opp13.GivingType__c = 'Donations';
    	opp13.AccountId = account1.Id;
    	opp13.CloseDate = date.newInstance(2020,6,1);
    	opp13.rC_Giving__Closed_Amount__c = 20;
    	opp13.rC_Giving__Giving_Amount__c = 20;
    	opp12.External_ID__c = '22222222';
    	oppList.add(opp13);

    	Opportunity opp14 = createNewOpportunity();
    	opp14.rC_Giving__GAU__c = gau.Id;
    	opp14.CampaignId = campaign.Id;
    	opp14.RecordTypeId = donationTypeId;
    	opp14.GivingType__c = 'Donations';
    	opp14.AccountId = account1.Id;
    	opp14.CloseDate = date.newInstance(2020,6,1);
    	opp14.rC_Giving__Closed_Amount__c = 20;
    	opp14.rC_Giving__Giving_Amount__c = 20;
    	opp14.External_ID__c = '33333333';
    	oppList.add(opp14);

    	Opportunity opp15 = createNewOpportunity();
    	opp15.rC_Giving__GAU__c = membershipGAU.Id;
    	opp15.CampaignId = campaign.Id;
    	opp15.RecordTypeId = donationTypeId;
    	opp15.GivingType__c = 'Membership';
    	opp15.AccountId = account3.Id;
    	opp15.CloseDate = date.newInstance(2013,6,1);
    	opp15.rC_Giving__Closed_Amount__c = 10;
    	opp15.rC_Giving__Giving_Amount__c = 10;
    	oppList.add(opp15);

    	Opportunity opp16 = createNewOpportunity();
    	opp16.rC_Giving__GAU__c = MembershipGAU.Id;
    	opp16.CampaignId = campaign.Id;
    	opp16.RecordTypeId = donationTypeId;
    	opp16.GivingType__c = 'Membership';
    	opp16.AccountId = account3.Id;
    	opp16.CloseDate = date.newInstance(2014,6,1);
    	opp16.rC_Giving__Closed_Amount__c = 20;
    	opp16.rC_Giving__Giving_Amount__c = 20;
    	oppList.add(opp16);

    	insert oppList;
    	
    	List<Id> idList = new List<Id>();
    	idList.add(account1.Id);
    	idList.add(account2.Id);
    	idList.add(account3.Id); 
    	OpportunitySummaryCreator osc = new OpportunitySummaryCreator();
    	osc.summarizeOpportunities(idList);
    	
    	Account account = [
    		SELECT 
			Last_Donation_Date__c,
			Last_Donation_Amount__c,
			First_Donation_Date__c,
			Total_Donation_Count__c,
			Total_Donation_Amount__c,
			Largest_Donation_Amount__c,
			Total_Donations_2014__c,
			Total_Donations_2015__c,
			Last_Donation_GAU__c,
			Last_Donation_Primary_Campaign_Source__c,
			Total_Membership_Amount__c,
			Largest_Membership_Amount__c,
			Last_Membership_Amount__c,
			Largest_Donation_Date__c
			FROM Account
			WHERE Id = :account1.Id
    	];
       System.assertEquals(account.Last_Donation_Date__c, date.newInstance(2020,6,1));
       System.assertEquals(account.Last_Donation_Amount__c, 20);
       System.assertEquals(account.First_Donation_Date__c, date.newInstance(2014,1,15));
       System.assertEquals(account.Total_Donation_Count__c, 11);
       System.assertEquals(account.Total_Donation_Amount__c, 1220);
       System.assertEquals(account.Largest_Donation_Amount__c, 1000);
       System.assertEquals(account.Total_Donations_2014__c, 1100);
       System.assertEquals(account.Total_Donations_2015__c, 10);
       System.assertEquals(account.Total_Membership_Amount__c, 35);
       System.assertEquals(account.Largest_Membership_Amount__c, 35);
       System.assertEquals(account.Last_Membership_Amount__c, 35);
       System.assertEquals(opp2.CloseDate, account.Largest_Donation_Date__c);
    }

	private static Opportunity createNewOpportunity(){
	   Opportunity opp = new Opportunity();
	   opp.name = 'Test Giving';
	   opp.StageName = 'Completed';
	   return opp;
	}
}