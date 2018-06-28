// *************************************************************************/
// AccountAddressBlankUnknownValues Class
// 
// Values of address fields set to Unknown so that Batch Update will process
// 
// Remove "Unknown" values when inserting into Address fields
//
//  11/2/2015      Mark Maslw		Original
// *************************************************************************/
public with sharing class AccountAddressBlankUnknownValues {
	public static void blankUnknownValues(List<rC_Bios__Account_Address__c> addrList) {
		for(rC_Bios__Account_Address__c addr : addrList) {
			if(addr.rC_Bios__Original_Street_Line_1__c == 'Unknown') {
				addr.rC_Bios__Original_Street_Line_1__c = null;
			}
			if(addr.rC_Bios__Original_City__c == 'Unknown') {
				addr.rC_Bios__Original_City__c = null;
			}
			if(addr.rC_Bios__Original_State__c == 'UN') {
				addr.rC_Bios__Original_State__c = null;
			}
			if(addr.rC_Bios__Original_Postal_Code__c == 'Unknown') {
				addr.rC_Bios__Original_Postal_Code__c = null;
			}
		}
	}
}