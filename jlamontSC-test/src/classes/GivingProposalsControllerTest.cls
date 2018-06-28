//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Test class for the Controller GivingProposals.
//                  
// Original : March 03, 2014  : KapiL Choudhary(Appirio India) 
// Updated  : March 07, 2014  : KapiL Choudhary(Appirio India) 
//      
//          
// ***************************************************************************/
@isTest
private class GivingProposalsControllerTest {
    static account acc;
    static Contact con;
    static Campaign	cmp;
    static TestDataUtility tDataUtil;
    static testMethod void GivingProposalsTest() {
    	tDataUtil = new TestDataUtility();
		createData();
        PageReference pageRef = Page.AccountOpportunityRelatedList;
        Test.setCurrentPage(pageRef);
         // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        GivingProposalsController gpCon = new GivingProposalsController();
		
		system.assertNotEquals(0, gpCon.ProposalsList.size());
		gpCon.givingIdToDelete = gpCon.ProposalsList.get(0).id;
		gpCon.deleteGiving();
		
		Opportunity oppCon = new Opportunity(name ='Giving Test2', Donor_Contact__c = con.id, StageName = 'Open',CloseDate = Date.today(), 
										  recordtypeId=tDataUtil.getOpportunityRecordTypeId('Proposal'),
										  AccountId= acc.id,CampaignId =cmp.id);
	    insert oppCon;
	    ApexPages.currentPage().getParameters().put('id', con.Id);
        GivingProposalsController gpContact = new GivingProposalsController();
        system.assertNotEquals(0, gpContact.ProposalsList.size()); 
    }
    static void createData(){
    	acc = tDataUtil.createNewAccount(true, 'Test Account', '');
    	con = new Contact(lastName= 'Test lName1',AccountId =acc.id);
    	insert con;
	      cmp = new Campaign();
	   	  cmp.Name = 'test opp camp';
	   	  cmp.Type = 'Promotion';
	   	  cmp.Status = 'Planned';
	   	  insert cmp;
    	Opportunity opp = new Opportunity(name ='Giving Test1',StageName = 'Open',CloseDate = Date.today() ,
    									  recordtypeId=tDataUtil.getOpportunityRecordTypeId('Proposal'),
    									  AccountId= acc.id, CampaignId =cmp.id);
    	insert opp;
    }
}