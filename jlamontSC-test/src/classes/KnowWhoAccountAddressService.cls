// *************************************************************************/
// KnowWhoAccountAddressService Class
//		VB: This class appears to be a wrapper for the KnowWho ZDM Single 
//			Address record service.  Given a rC Account Address, it maps
//			the fields returned from the KW ZDM to the rC object.
//			 
//	2015/03/31		Peter Churchill     Original
//	2015/04/06		Vernon Baas			Commenting
//	2015/10/06		Peter Churchill		Implementing Address Line 2 Fixes to match Batch Upload

// *************************************************************************/
public with sharing class KnowWhoAccountAddressService {

	public sObject updatedAddress {get;set;}
	public String sErrorMessage;
	public Boolean bError;
	public Boolean bUnVerifiedError;
	public kwzd.KWD_SingleRecordUpdate kws {get;set;}	// KnowWho ZDM service  

	// Constructor
	public KnowWhoAccountAddressService() {
		
		// Instantiate the KW ZDM service.
		kws = new kwzd.KWD_SingleRecordUpdate();
		
		// Initialize the error mechanisms
    	bError = FALSE;
    	bUnVerifiedError = FALSE;
    	sErrorMessage = '';
    	kws.bSubmittoDatabase = FALSE;
	}


	public void getAddressInfo(sObject rcAddress) {
		String sObjectName = rcAddress.getsObjectType().getdescribe().getname();
		try{
		// WARNING: Move outside Try?  That or unblank the values? 
    		//Remove Lat & Lon to ensure correct processing
    		rcAddress.put('kwrc__Latitude__c', NULL);
    		rcAddress.put('kwrc__Longitude__c', NULL);
    		rcAddress.put('kwrc__Zip_4__c', NULL);
		//
		
			// VB: Huh?
			//Empty Zip Codes fail, but complete if wrong will get matched
			//
			// If the Zip is blank, place in the dummy 00000 value
    		if(String.IsEmpty((String)rcAddress.get('rC_Bios__Original_Postal_Code__c') )) {
				rcAddress.put('rC_Bios__Original_Postal_Code__c','00000');
			}

			// VB: Documentation?
			//
			//	Call the KW
			// 
		    kws.executeupdate(sObjectName, rcAddress);

		} catch(Exception e) {

			// If the KW ZDM Service fails
		    sErrorMessage = 'Error with Address Validate Service';
    		bError = true;
    		
			// Re-blank out the zip, if the dummy value was placed into that field.
    		blankZipCode(rcAddress);
    		   
		}

		//Now Process Response    
		//
		// It seems the KW ZDM can succeed, but still return errors    
		if (kws.showerrors) {
			
			// Parse the error, setting the correct error message
		    if (kws.showcrediterror) {
        		sErrorMessage = 'Address cannot be validated : No ZDM Credits Available';
    		} else if (kws.showexpiryerror) {
        		sErrorMessage = 'Address cannot be validated : ZDM Subscription Expired';
    		} else if (kws.showaddresserror) {
        		sErrorMessage =  'Address cannot be validated : Incomplete Address';
    		} else if (kws.showziperror) {
    			sErrorMessage = 'Address cannot be validated : Invalid Zipcode';
    		} else {
        		sErrorMessage = 'Address cannot be validated : ' +  kws.dbError + '\n' + 'Please check Override if you still want to save this.';
    		}

			// Re-blank out the zip, if the dummy value was placed into that field.
    		blankZipCode(rcAddress);
    		

    		bError = true;
    		
    	} else {

			//Now check if address found but not verified by USPS
     		updatedAddress =  kws.soProcessed;
     		
     		kwzd.KWD_Process_JSON_Response.updateTargetfromSourceObject(updatedAddress, 'kwrc__', rcAddress, 'kwrc__');

			// VB: ZDM can correctly match an address to a constituent, but the address may still fail
			//		USPS verification.
			//		Matched = ZDM Information available
			//		Verified = USPS Verified
		    if (updatedAddress.get('kwrc__USPS_Verified__c') == FALSE) {

				// Report the error condition and let the user decide if the address should be saved.
        		sErrorMessage = 'This address was matched but could not be fully confirmed as valid by USPS. ' + 
        						'Please check Override if you still want to save this.';
        		bError = true;
        		bUnVerifiedError = true;
    		}
    		
		    /*
			// VB: I'm guessing these are fields unmodified by the ZDM?
			// Map the un-ZDM'd fields to the updatedAddress
			updatedAddress.rC_Bios__Type__c = aa.rC_Bios__Type__c;
			updatedAddress.rC_Bios__Active__c = aa.rC_Bios__Active__c;
			updatedAddress.rC_Bios__Original_Country__c = aa.rC_Bios__Original_Country__c;
			updatedAddress.rC_Bios__Seasonal_Start_Month__c = aa.rC_Bios__Seasonal_Start_Month__c;
			updatedAddress.rC_Bios__Seasonal_End_Month__c = aa.rC_Bios__Seasonal_End_Month__c;
			updatedAddress.rC_Bios__Seasonal_Start_Day__c = aa.rC_Bios__Seasonal_Start_Day__c;
			updatedAddress.rC_Bios__Seasonal_End_Day__c = aa.rC_Bios__Seasonal_End_Day__c;
			updatedAddress.rC_Bios__Start_Date__c = aa.rC_Bios__Start_Date__c;
			updatedAddress.rC_Bios__End_Date__c = aa.rC_Bios__End_Date__c;
			updatedAddress.rC_Bios__Preferred_Billing__c = aa.rC_Bios__Preferred_Billing__c;
			updatedAddress.rC_Bios__Preferred_Shipping__c = aa.rC_Bios__Preferred_Shipping__c;
			updatedAddress.rC_Bios__Do_Not_Mail__c = aa.rC_Bios__Do_Not_Mail__c;

			// VB: Why?  Sorry, not following this crucial move.
			aa = updatedAddress;
			
			// Log the new zip returned
			system.debug('ZIP' + aa.rC_Bios__Original_Postal_Code__c);
			*/

			// WARNING: Unnecessary?  Not sure I see the logic path that would require this.
			// If the dummy value is still in the zip, then blank it out.
			//		Meaning it wasn't caught on the above error conditions?
			blankZipCode(rcAddress);

			// WARNING: Nothing is returned, so why update the aa fields?
			//		Isn't this supposed to assign the values to the updatedAddress?
			//		I'm guessing that the ZDM returns the values into the new custom fields
			//			listed below which now need to be mapped onto the existing Account
			//			address original address fields.
			//		Why not have the KW ZDM just update the Original fields?
			//
			// Update the rC Account Address fields with those returned by the ZDM
			//Set KW UPdate Field to FALSE so we don't trigger workflow
			
			
			rcAddress.put('kwrc__KnowWho_Address_Update__c', FALSE);
			
			rcAddress.put('rC_Bios__Original_City__c', rcAddress.get('kwrc__USPS_City__c'));
			rcAddress.put('rC_Bios__Original_Postal_Code__c', rcAddress.get('kwrc__USPS_Zip__c'));
			rcAddress.put('rC_Bios__Original_State__c', rcAddress.get('kwrc__USPS_State__c'));
			rcAddress.put('kwrc__Initial_Street_1__c', (String)rcAddress.get('rC_Bios__Original_Street_Line_1__c'));

			//2015/10/06 Peter Churchill - Move Address Line to Line 1 from USPS when Verified
			if (updatedAddress.get('kwrc__USPS_Verified__c') == TRUE) {

				String sStreet =  (String)rcAddress.get('kwrc__USPS_Street__c');
					if (String.IsEmpty((String)rcAddress.get('kwrc__USPS_Street_2__c')) == FALSE) {
						sStreet += ' ' + (String)rcAddress.get('kwrc__USPS_Street_2__c');
					}
				rcAddress.put('rC_Bios__Original_Street_Line_1__c', sStreet);
					if (String.IsEmpty( (String)rcAddress.get('rC_Bios__Original_Street_Line_2__c') ) == FALSE) {
						rcAddress.put('kwrc__Initial_Street_2__c', rcAddress.get('rC_Bios__Original_Street_Line_2__c'));
						rcAddress.put('rC_Bios__Original_Street_Line_2__c', cleanStreet2((String)rcAddress.get('rC_Bios__Original_Street_Line_2__c')) );
					}
			}
			//rcAddress.put('rC_Bios__Original_Street_Line_2__c', rcAddress.get('kwrc__USPS_Street_2__c'));
			//Do we blank out RC Street 2 values though?


			}
    
		//return aa;
	} //end execute


	public static Boolean bCheckUSA(String sCountry) {
	// VB: Snazzy
		//return (sCountry.equalsIgnoreCase('United States') || sCountry.equalsIgnoreCase('USA') || sCountry.equalsIgnoreCase('US'));
		if (sCountry == NULL) {
			return TRUE;
		}
	    else if (sCountry.equalsIgnoreCase('United States') || sCountry.equalsIgnoreCase('USA') || sCountry.equalsIgnoreCase('US') ) {
        	return TRUE;
    	}
    	return FALSE;
	}

	public sObject blankZipCode(sObject rcAddressZip) {
		if(rcAddressZip.get('rC_Bios__Original_Postal_Code__c') != NULL && rcAddressZip.get('rC_Bios__Original_Postal_Code__c').equals('00000')) {
            	rcAddressZip.put('rC_Bios__Original_Postal_Code__c', '');
    	}
    	return rcAddressZip;   

	}

	public static String cleanStreet2 (String sCurrentValue) {
		if (sCurrentValue.containsIgnoreCase('c/o')) {
			return sCurrentValue;
		}
		
		String sReturnString = sCurrentValue;
		Map<String, StreetAddressTwoValues__c> street2 = StreetAddressTwoValues__c.getall();
		for (String s: street2.keyset() ) {
			if (sCurrentValue.toLowerCase().StartsWith(s.toLowerCase())) {
				//Match Found
				sReturnString = '';
				break;
			}

		}
		return sReturnString;
	}

}