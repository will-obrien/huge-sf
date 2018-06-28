//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Class used to redirect over ManageAddress by Edit Click/ Override
//	19 March 2014    Pitamber (Appirio)     Original
//**********************************************************************/
public with sharing class EditContactAddressCtrl {
	private Id contactId;
	
	public EditContactAddressCtrl(ApexPages.StandardController controller) {
		rC_Bios__Contact_Address__c cntAdd = (rC_Bios__Contact_Address__c)controller.getRecord();
		cntAdd = [Select rc_Bios__Contact__c from rC_Bios__Contact_Address__c where Id =: cntAdd.Id];
		contactId = cntAdd.rc_Bios__Contact__c;
	}
	
	public PageReference redirectToManageAddress() {
		return new PageReference('/apex/ManageContactAddress?Id='+contactId);
	}
}