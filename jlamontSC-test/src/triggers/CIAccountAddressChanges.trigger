// ChangeLog		: MM: 4/10/2015 - Get CastIron UserId from Custom Setting, to reduce SOQL queries
//					MM: 8/2015 - Do not check for fields that are not used in integration
//                               Check integration status and workflow status to set flags correctly or bypass processing
// 			        : VB: 5/6/2016 - Removed references to CI tables (CI_AccountAddress_Change__c)
trigger CIAccountAddressChanges on rC_Bios__Account_Address__c (before update) {
	System.debug('**** CIAccountAddressChanges ****');
	for (rC_Bios__Account_Address__c newAccountAddress : Trigger.new) {
		System.debug('BEFORE AccountAddress Id:' + newAccountAddress.Id + '    Integration Status:' + newAccountAddress.CastIron_Integration_Status__c);
	}
	if(OutboundMessageHelper.addressInWorkflow) {
		System.debug('addressInWorkflow 1 = true - returning');
		return;
	}
	if(trigger.isBefore) {
		System.debug('trigger.isBefore');
		if(trigger.isUpdate) {
			System.debug('trigger.isUpdate');
		    for (rC_Bios__Account_Address__c newAddr : Trigger.new) {
		    	System.debug('newAddr:' + newAddr);
				if(newAddr.CastIron_Integration_Status__c == 'Sent') {
					System.debug('CastIron_Integration_Status:' + newAddr.CastIron_Integration_Status__c);
					newAddr.CastIron_Integration_Status__c = 'Success';
					OutboundMessageHelper.addressInWorkFlow = true;
				}    	
		    }
		}
	}
    if(OutboundMessageHelper.addressInWorkflow) {
		System.debug('addressInWorkflow 2 = true - returning');
    	return;
    }

    // Grab Cast Iron's Id
	private static final Id castironUserId = 
        //[SELECT Id FROM User WHERE alias = 'ciron'].Id;
		UserLookup.getId('ciron');
            
    Map<Id, rC_Bios__Account_Address__c> accountMap = new Map<Id, rC_Bios__Account_Address__c>();

    // Step through each of the Acccounts that's been modified
	for (rC_Bios__Account_Address__c newAccountAddress : Trigger.new) {

        // If the Account was NOT modified by Cast Iron
        if (System.UserInfo.getUserId() != castironUserId) {
        
            // Grab the corresponding Account from the old Values map
            rC_Bios__Account_Address__c oldAccountAddress = Trigger.oldMap.get(newAccountAddress.Id);
    
    		System.debug('newAccountAddress:' + newAccountAddress);
    		System.debug('oldAccountAddress:' + oldAccountAddress);
            // If the Name, Club Salutation, Email or Warning Comment has changed.
            if (newAccountAddress.CastIron_Resubmit__c ||	// Has the Account Address been marked for resubmission?
				oldAccountAddress.rC_Bios__Type__c != newAccountAddress.rC_Bios__Type__c ||
				oldAccountAddress.rC_Bios__Active__c != newAccountAddress.rC_Bios__Active__c ||
				oldAccountAddress.rC_Bios__Preferred_Billing__c != newAccountAddress.rC_Bios__Preferred_Billing__c ||
				oldAccountAddress.rC_Bios__Original_Street_Line_1__c != newAccountAddress.rC_Bios__Original_Street_Line_1__c ||
				oldAccountAddress.rC_Bios__Original_Street_Line_2__c != newAccountAddress.rC_Bios__Original_Street_Line_2__c ||
				oldAccountAddress.rC_Bios__Original_City__c != newAccountAddress.rC_Bios__Original_City__c ||
				oldAccountAddress.rC_Bios__Original_State__c != newAccountAddress.rC_Bios__Original_State__c ||
				oldAccountAddress.rC_Bios__Original_Postal_Code__c != newAccountAddress.rC_Bios__Original_Postal_Code__c ||
				oldAccountAddress.rC_Bios__Original_Country__c != newAccountAddress.rC_Bios__Original_Country__c ||
				oldAccountAddress.OrgName__c != newAccountAddress.OrgName__c ||
				oldAccountAddress.OrgName2__c != newAccountAddress.OrgName2__c
            	) {
                
				// Set some values to support the Cast Iron integration
				// 		The integration status 'in transit' drives the 
				// 		start of the cast 
				// 		MM:7/22/14 removed check for preferred billing
                newAccountAddress.CastIron_Integration_Status__c = 'In Transit';
                newAccountAddress.Transmit_Date__c 			  = datetime.now();
                newAccountAddress.CastIron_Resubmit__c 		  = FALSE;
                    
            }
        }
		System.debug('AFTER AccountAddress Id:' + newAccountAddress.Id + '    Integration Status:' + newAccountAddress.CastIron_Integration_Status__c);
	}    
}