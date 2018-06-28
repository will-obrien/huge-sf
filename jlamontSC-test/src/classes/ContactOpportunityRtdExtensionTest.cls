//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Test class for the Controller ContactOpportunityRelatedListExtension.
//                  
// Original : March 07, 2014  : KapiL Choudhary(Appirio India) 
// Updated  :
//      
//          
// ***************************************************************************/
@isTest
private class ContactOpportunityRtdExtensionTest {
    static Contact con;
    
    static testMethod void GivingProposalsTest() {
     TestDataUtility tDataUtil = new TestDataUtility();
     con = tDataUtil.createNewContact(true, 'TestFirstName', 'TestLastName', null, null);
     ApexPages.StandardController sc = new ApexPages.standardController(con);
     ContactOpportunityRelatedListExtension cOppExt = new ContactOpportunityRelatedListExtension(sc);
     system.assertEquals(con.id,cOppExt.contactRecord.id);
    }
}