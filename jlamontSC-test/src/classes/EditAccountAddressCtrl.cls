//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Class used to redirect over ManageAddress by Edit Click/ Override
//	7 March 2014    Pitamber (Appirio)     Original
//**********************************************************************/
public with sharing class EditAccountAddressCtrl {
	private Id accountId;
	
	public EditAccountAddressCtrl(ApexPages.StandardController controller) {
		rC_Bios__Account_Address__c accAdd = (rC_Bios__Account_Address__c)controller.getRecord();
		accAdd = [Select rc_Bios__Account__c from rC_Bios__Account_Address__c where Id =: accAdd.Id];
		accountId = accAdd.rc_Bios__Account__c;
	}
	
	public PageReference redirectToManageAddress() {
		return new PageReference('/apex/ManageAddress?Id='+accountId);
	}
}