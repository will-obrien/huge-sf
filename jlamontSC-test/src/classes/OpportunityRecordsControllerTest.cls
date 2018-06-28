//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Test class for OpportunityRecordsController.
//                  
// Original : March 07, 2014  : KapiL Choudhary(Appirio India) 
// Updated  :
//      
//          
// ***************************************************************************/

@isTest
private class OpportunityRecordsControllerTest {

    static account acc;
    static Contact con;
    static TestDataUtility tDataUtil;
    static testMethod void opportunityRecordsTest() {
    	tDataUtil = new TestDataUtility();
		createData();
        PageReference pageRef = Page.opportunityRecords;
        Test.setCurrentPage(pageRef);
         // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        ApexPages.currentPage().getParameters().put('recType', 'Proposal');
        opportunityRecordsController gpCon = new opportunityRecordsController();
		
		//system.assertNotEquals(0, gpCon.ProposalsList.size());
		
		Opportunity oppCon = new Opportunity(name ='Giving Test2', Donor_Contact__c = con.id, StageName = 'Open',CloseDate = Date.today(), 
										  recordtypeId=tDataUtil.getOpportunityRecordTypeId('Transaction'),
										  AccountId= acc.id);
	    insert oppCon;
	    ApexPages.currentPage().getParameters().put('id', con.Id);
	    ApexPages.currentPage().getParameters().put('recType', 'Other');
        opportunityRecordsController gpContact = new opportunityRecordsController();
        system.assertNotEquals(0, gpContact.ProposalsList.size()); 
    }
    static void createData(){
    	acc = tDataUtil.createNewAccount(true, 'Test Account', '');
    	con = new Contact(lastName= 'Test lName1',AccountId =acc.id);
    	insert con;
    	Opportunity opp = new Opportunity(name ='Giving Test1',StageName = 'Open',CloseDate = Date.today() ,
    									  recordtypeId=tDataUtil.getOpportunityRecordTypeId('Proposal'),
    									  AccountId= acc.id);
    	try {
    		insert opp;
    	} catch(Exception e) {
    	}
    }
}