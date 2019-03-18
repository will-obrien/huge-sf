@isTest
public class LeadTriggerHandlerTest {
	Static testMethod void myUnitTest(){
       
    	
		// creating a lead by calling Test Data factory.
		Lead lead = TestDataFactory.createLeads(1)[0];
		              

		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(lead.id);
		lc.setDoNotCreateOpportunity(false);
        //LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		//lc.setConvertedStatus(convertStatus.MasterLabel);
		
		lc.setConvertedStatus('Qualified');
		Database.LeadConvertResult lcr;

		System.runAs(TestingUtils.ADMIN_USER){
			lcr = Database.convertLead(lc);
		}
		
		System.assert(lcr.isSuccess());

    }
}