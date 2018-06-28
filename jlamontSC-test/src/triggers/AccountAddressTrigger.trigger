// *************************************************************************/
// rC_Bios__Account_Address__c Trigger
//      VB: This class is the generic trigger handler for the rC Object 
//          rC_Bios__Account_Address__c.  
//           
//  2015/04/17      Vernon Baas         Original
//  2015/06         Mark Maslow         Add before insert and before update. 
//										Add call to AccountAddressDupCheck.
//  8/2015          Check integration status and workflow status to set flags correctly or bypass processing
//  8/24/2015       Remove checking of integration status - done in CIAccountAddressChanges
//  11/2/2015       Mark Maslow         Add call to AccountAddressBlankUnknownValues
// *************************************************************************/
trigger AccountAddressTrigger on rC_Bios__Account_Address__c (before insert, before update, after insert, after update) {
	if(Trigger.isAfter) {
		if(Trigger.isInsert || Trigger.isUpdate) {
			AccountAddressTriggerHandler aaTriggerHandler = new AccountAddressTriggerHandler();
			aaTriggerHandler.moveZDMInfo(Trigger.new);
		}
	}
	else {
		if(Trigger.isBefore) {
			if(Trigger.isInsert) {
				new AccountAddressDupCheck().checkForDups(Trigger.new, null);
			}
			else if(Trigger.isUpdate) {
				new AccountAddressDupCheck().checkForDups(Trigger.new, Trigger.oldMap);
			}
			AccountAddressBlankUnknownValues.blankUnknownValues(Trigger.new);
		}
	}
}