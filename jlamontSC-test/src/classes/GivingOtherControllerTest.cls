//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Test class for the Controller GivingOtherController.
//                  
// Original  : March 07, 2014  : KapiL Choudhary(Appirio India) 
//      
//          
// ***************************************************************************/

@isTest
private class GivingOtherControllerTest {
	static account acc;
    static Contact con;
    static Campaign cmp;
    static TestDataUtility tDataUtil;
    static testMethod void GivingOtherTest() {
    	tDataUtil = new TestDataUtility();
		createData();
        PageReference pageRef = Page.AccountOpportunityRelatedList;
        Test.setCurrentPage(pageRef);
         // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        GivingOtherController gpCon = new GivingOtherController();
		
		system.assertNotEquals(0, gpCon.OthersList.size());
		gpCon.givingIdToDelete = gpCon.OthersList.get(0).id;
		gpCon.deleteGiving();
		
		Opportunity oppCon = new Opportunity(name ='Giving Test2', Donor_Contact__c = con.id, StageName = 'Open',CloseDate = Date.today(), 
										  recordtypeId=tDataUtil.getOpportunityRecordTypeId('Transaction'),
										  AccountId= acc.id,CampaignId =cmp.id);
	    insert oppCon;
	    ApexPages.currentPage().getParameters().put('id', con.Id);
        GivingOtherController gpContact = new GivingOtherController();
        system.assertNotEquals(0, gpContact.OthersList.size()); 
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
    									  recordtypeId=tDataUtil.getOpportunityRecordTypeId('Transaction'),
    									  AccountId= acc.id,CampaignId =cmp.id);
    	insert opp;
    }
}