/* This class is the Test class for ConvertedLeads VisualForce Page.
 *
 * Functionality: this class will Test Different Cases
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     21/03/2016   Basic Functionality Acheived 
 *
 */
@istest public class TestLeadExtension {
    static testmethod void testCase1(){
        List<Lead> listRecordsLeads = TestDataFactory.createTestRecordLeads(3); 
        List<Account> listRecordsAccounts = TestDataFactory.createTestRecordAccounts(3);
        List<Contact> listRecordsContacts = TestDataFactory.createTestRecordContacts(3);
        insert listRecordsLeads;
        Test.startTest();
 		Test.setCurrentPageReference(new PageReference('Page.myPage'));
  		ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listRecordsLeads);
  		stdSetController.setSelected(listRecordsLeads);
  		LeadsExtension objLeadsExtension = new LeadsExtension(stdSetController);
 		Test.stopTest();
        objLeadsExtension.convertLeads();
        List<Lead> listResultLeads=[Select id,isConverted from lead where Id in :listRecordsLeads ];
        for(Lead objLead : listResultLeads){
            system.assertEquals(objLead.isConverted , true);
        }
    }
}