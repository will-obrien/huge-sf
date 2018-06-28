// *************************************************************************/
// BatchUploadTriggerHandler Class
//      VB: This class is a wrapper for the KnowWho ZDM Single 
//          Address record service to update Batch Upload records
//			It also populates the Batch Upload status to 'To ZDM'
//           
//  2015/04/07      Vernon Baas		Original
//	2015/05/12		Vernon Baas		Blank US countries on insert
//	2015/05/14		Vernon Baas		Added checks for trigger type
//	2015/09/15	 	Mark Maslow		If no value in Campaign Matched, set 
//										field Campaign Matched to Form 
//										Campaign
//	2015/10/23		Vernon Baas		Adding in new defaults for Member Level
//										and Member Type for "SC" GAU. 
//  2015/10/29      Mark Maslow     If any address field has a value, ensure that all address fields have a value
//                                  Repurpose method "blankUSCountry - renamed to "handleBlanks"
//	2015/11/10		Vernon Baas		Added catches for all known Membership GAU Types per DS request.
//										Updates to Mbr Level/Type should only occur for Membership GAUs
//	2015/03/28		Vernon Baas		Request from Mark Bosler to lower minimum of Mbr/Level/Type from 
//										$15.00 down to $5.00.
//	2016/04/12		Vernon Baas		Changed so that General Accounting Unit on a Batch Upload
//										is never ovewritten, but only populated during insert if
//										the value is blank (and a value from the Form Campaign exists).  
//										Code to populate/update the General Accounting Unit during an 
//										update was commented out.
//	2016/04/18		Vernon Baas		Re-enabled the defaulting of a BU GAU from its Form Campaign, but 
//										only when the value is blank, never in an attempt to 'correct' it 
//										when it's different
//  2016/07         Mark Maslow     Add static variable updatingAccountAddress
//										Used to bypass trigger when updating Account Address
// *************************************************************************/
public with sharing class BatchUploadTriggerHandler {

    public static boolean isUpdateTrigger;
	public static boolean updatingAccountAddress = false;
	//
	// VB: See comment on loadGAU method below
	//
    //public static String MembershipGAU;
    //public static String MembershipGAUMAG;
    //public static String MembershipGAUXMAG;
    //public static String MembershipGAUSCU;
    //public static String MembershipGAUSCU250;
    //public static String MembershipGAUSCUAG;
    //public static String MembershipGAUSCUJ;
    public final static String MembershipGAU 		= 'a0ii00000090yeLAAQ';
	public final static String MembershipGAUMAG 	= 'a0ii00000090yeIAAQ';
	public final static String MembershipGAUXMAG	= 'a0ii00000090yg3AAA';
	public final static String MembershipGAUSCU 	= 'a0ii00000090yecAAA';
	public final static String MembershipGAUSCU250 = 'a0ii00000090yedAAA';
	public final static String MembershipGAUSCUAG 	= 'a0ii00000090yeeAAA';
	public final static String MembershipGAUSCUJ 	= 'a0ii00000090yefAAA';


    
    private static Boolean GAUsLoaded = false;

    public string mGAU()      {return MembershipGAU;}
    public string magGAU()    {return MembershipGAUMAG;}
    public string xmagGAU()   {return MembershipGAUXMAG;}
    public string scuGAU()    {return MembershipGAUSCU;}
    public string scu250GAU() {return MembershipGAUSCU250;}
    public string scuagGAU()  {return MembershipGAUSCUAG;}
    public string scujGAU()   {return MembershipGAUSCUJ;}

	/*
	VB: Gave up trying to do this correctly, there appears to be either a permissions error related to the 
		Batch Upload User record or some other access issue as the SOQL query below never returns any rows
		in production.
		
	public void loadGAUs() {

		
		// If the values have already been loaded
		if(GAUsLoaded) return;

        for(rC_Giving__GAU__c scGAU :[SELECT Id, GAU_ID__c
        									FROM rC_Giving__GAU__c 
        									WHERE  GAU_ID__c = 'SC' 		// Membership
        										OR GAU_ID__c = 'MAG' 		// Sierra SubscribingDonors
        										OR GAU_ID__c = 'XMAG' 		// Sierra SubscribingDonors
        										OR GAU_ID__c = 'SCU' 		// Upgrade - misc
        										OR GAU_ID__c = 'SCU250' 	// Life member payment
        										OR GAU_ID__c = 'SCUAG' 		// Upgrade-retailer
        										OR GAU_ID__c = 'SCUJ' 		// Upgrade to joint
        									]) {
        									
		    system.debug('::TRIGGER:scGAU::' + scGAU.GAU_ID__c + ':' + scGAU.Id + ':');
        	if (scGAU.GAU_ID__c == 'SC') {
            	MembershipGAU = scGAU.Id;
        	} else if (scGAU.GAU_ID__c == 'MAG') {
				MembershipGAUMAG = scGAU.Id;
        	} else if (scGAU.GAU_ID__c == 'XMAG') {
				MembershipGAUXMAG = scGAU.Id;
        	} else if (scGAU.GAU_ID__c == 'SCU') {
				MembershipGAUSCU = scGAU.Id;
        	} else if (scGAU.GAU_ID__c == 'SCU250') {
				MembershipGAUSCU250 = scGAU.Id;
        	} else if (scGAU.GAU_ID__c == 'SCUAG') {
				MembershipGAUSCUAG = scGAU.Id;
        	} else if (scGAU.GAU_ID__c == 'SCUJ') {
				MembershipGAUSCUJ = scGAU.Id;
        	}
        }
        // Now set the value
        GAUsLoaded = true;

		// ARGH, I give up.
    	MembershipGAU 		= 'a0ii00000090yeLAAQ';
		MembershipGAUMAG 	= 'a0ii00000090yeIAAQ';
		MembershipGAUXMAG	= 'a0ii00000090yg3AAA';
		MembershipGAUSCU 	= 'a0ii00000090yecAAA';
		MembershipGAUSCU250 = 'a0ii00000090yedAAA';
		MembershipGAUSCUAG 	= 'a0ii00000090yeeAAA';
		MembershipGAUSCUJ 	= 'a0ii00000090yefAAA';


		system.debug('::TRIGGER:LOAD_GAUS::');
	    system.debug('::TRIGGER:      GAU::' + MembershipGAU + ':');
	    system.debug('::TRIGGER:   GAUMAG::' + MembershipGAUMAG + ':');
	    system.debug('::TRIGGER:  GAUXMAG::' + MembershipGAUXMAG + ':');
	    system.debug('::TRIGGER:   GAUSCU::' + MembershipGAUSCU + ':');
	    system.debug('::TRIGGER:GAUSCU250::' + MembershipGAUSCU250 + ':');
	    system.debug('::TRIGGER: GAUSCUAG::' + MembershipGAUSCUAG + ':');
	    system.debug('::TRIGGER:  GAUSCUJ::' + MembershipGAUSCUJ + ':');
	}
    */

	Map<Id,rC_Connect__Batch_Upload__c> batchuploadsToUpdateMap = new Map<Id,rC_Connect__Batch_Upload__c>();

    public void beforeInsert(List<rC_Connect__Batch_Upload__c> newList) {

		//system.debug('::TRIGGER:WHAT::');
		//system.debug('::TRIGGER:Insert:' + Trigger.isInsert  + '::');
		//system.debug('::TRIGGER:Before:' + Trigger.isBefore  + '::');

		// Make sure we've looked up the Membership GAUs.
		//loadGAUs();

		// ODD: It seems this method is still getting called on an afterUpdate.
    	if (Trigger.isBefore && Trigger.IsInsert) {

	    	// Make sure this instance hasn't called the onUpdate method
	    	// This value is created in the onUpdate method
	        if (BatchUploadTriggerHandler.isUpdateTrigger == NULL) {
	    	
		    	// Set the Batch Upload Status
		    	initBatchUploadStatus(newList);
		    	
		    	// Initialize the GAU, if needed.
		    	initGeneralAccountingUnit(newList);
		    	
		    	//blankUSCountry(newList);
		    	// Set the Country to blank if it's US
				//If any address field has a value, ensure that all address fields have a value
		    	handleBlanks(newList); 
		    	
		    	// Set the Member Level and Type, 
		    	//	depending on the Campaign and specific Campaign Asks defined.
		        insertMemberLevelType(newList);
                
                // If no value in Campaign Matched, set field Campaign Matched to Form Campaign
                for(rC_Connect__Batch_Upload__c bu : newList) {
                    if(
                       (String.isEmpty(bu.rC_Connect__Batch_Upload_Campaign_Matched__c)) &&
                       (! String.isEmpty(bu.Form_Campaign__c))
                      ) {
                          bu.rC_Connect__Batch_Upload_Campaign_Matched__c = bu.Form_Campaign__c;
                    }
                }
	    	}
    	}
    }

    // Initialize the Batch Upload Status to 'To ZDM' 
    private void initBatchUploadStatus(List<rC_Connect__Batch_Upload__c> newList){

		// Step through the trigger and initialize the BU status
        for(rC_Connect__Batch_Upload__c bu: newList){
			bu.rC_Connect__Batch_Upload_Status__c = 'To ZDM';
        }
    }    

    // Initialize the GAU to the Form Campaign GAU's Case Sensitive ID
    //	VB: 4/12/16 - This will no longer attempt to 'fix' a General Accounting Unit
    //			Only to populate a value if it's blank and we have one from the Form Campaign 
    private void initGeneralAccountingUnit(List<rC_Connect__Batch_Upload__c> newList){

		// Step through the trigger and initialize the BU status
        for(rC_Connect__Batch_Upload__c bu: newList){

        	// If Paid and the GAU is blank.
			if(bu.rC_Connect__Giving_Paid__c == true && ( bu.General_Accounting_Unit__c == null || bu.General_Accounting_Unit__c == '')) {

				// If there is a value defined for the Form Campaign GAU Id lookup field
				if (bu.Form_Campaign_GAU_Id__c != null && bu.Form_Campaign_GAU_Id__c != '') {
					
					// Assign the lookup field value to the GAU field.
					bu.General_Accounting_Unit__c = bu.Form_Campaign_GAU_Id__c;
				}
			}
        	
        }
    }    

    // Blank the Country fields on the Batch Upload if it looks like the United States 
    //private void blankUSCountry(List<rC_Connect__Batch_Upload__c> newList){
	private void handleBlanks(List<rC_Connect__Batch_Upload__c> newList){
		// Step through the trigger
        for(rC_Connect__Batch_Upload__c bu: newList){
			        	
        	if( bu.rC_Connect__Address_Country__c != null && (
        		bu.rC_Connect__Address_Country__c.toUpperCase() == 'US' ||
        		bu.rC_Connect__Address_Country__c.toUpperCase() == 'USA' ||
        		bu.rC_Connect__Address_Country__c.toUpperCase() == 'UNITED STATES' ||
        		bu.rC_Connect__Address_Country__c.toUpperCase() == 'UNITED STATES OF AMERICA')) {
					// Blank it out.
					bu.rC_Connect__Address_Country__c = '';
        	}
        	if( bu.rC_Connect__Address_2_Country__c != null && (
        		bu.rC_Connect__Address_2_Country__c.toUpperCase() == 'US' ||
        		bu.rC_Connect__Address_2_Country__c.toUpperCase() == 'USA' ||
        		bu.rC_Connect__Address_2_Country__c.toUpperCase() == 'UNITED STATES' ||
        		bu.rC_Connect__Address_2_Country__c.toUpperCase() == 'UNITED STATES OF AMERICA')) {
					// Blank it out.
					bu.rC_Connect__Address_2_Country__c = '';
        	}
        	if( bu.rC_Connect__Recipient_Country__c != null && (
        		bu.rC_Connect__Recipient_Country__c.toUpperCase() == 'US' ||
        		bu.rC_Connect__Recipient_Country__c.toUpperCase() == 'USA' ||
        		bu.rC_Connect__Recipient_Country__c.toUpperCase() == 'UNITED STATES' ||
        		bu.rC_Connect__Recipient_Country__c.toUpperCase() == 'UNITED STATES OF AMERICA')) {
					// Blank it out.
					bu.rC_Connect__Recipient_Country__c = '';
        	}
        	//If any address field has a value, ensure that all address fields have a value
        	if( 
        		( ! String.isEmpty(bu.rC_Connect__Address_City__c) ) ||
        		( ! String.isEmpty(bu.rC_Connect__Address_Street_Line_1__c) ) ||
        		( ! String.isEmpty(bu.rC_Connect__Address_State__c) ) ||
        		( ! String.isEmpty(bu.rC_Connect__Address_Postal_Code__c) )
        	) {
        	    if(String.isEmpty(bu.rC_Connect__Address_City__c)) {
        			bu.rC_Connect__Address_City__c = 'Unknown';
        		}
        		if(String.isEmpty(bu.rC_Connect__Address_Street_Line_1__c)) {
        			bu.rC_Connect__Address_Street_Line_1__c = 'Unknown';
        		}
        		if(String.isEmpty(bu.rC_Connect__Address_State__c)) {
        			bu.rC_Connect__Address_State__c = 'UN';
        		}
        		if(String.isEmpty(bu.rC_Connect__Address_Postal_Code__c)) {
        			bu.rC_Connect__Address_Postal_Code__c = 'Unknown';
        		}
        	}
        }
    }    

    //PNC May 2015
    public void afterUpdate(List<rC_Connect__Batch_Upload__c> newList) {

		// VB: Might not be necessary, but matches the issue dealt with in the beforeInsert class above
    	if (Trigger.isAfter && Trigger.IsUpdate) {

			isUpdateTrigger = true;		// Record that this really is an update.
	    	
	    	// VB: 10/23/15 - Call the update to the Member Type/Level
	    	updateBatchUpload(newList);
	    	
	        Boolean bProcessCommitted = FALSE;
	        for(rC_Connect__Batch_Upload__c bu: newList){
	            if (bu.rC_Connect__Batch_Upload_Status__c == 'Committed') {
	                bProcessCommitted = TRUE;
	                break;
	            }
	        }
	            
	        if (bProcessCommitted) {
	            if (AccountAddressTriggerHandler.AccountAddressesHoldingVariable != NULL) {
	                AccountAddressTriggerHandler.MoveAddressToAccountAddress(AccountAddressTriggerHandler.AccountAddressesHoldingVariable);
	            }
	        }
    		
    	}
    }


    // Look for a defined Campaign Ask
    //		that matches the form Campaign, Giving Amount
    //		and apply the Campaign Asks Member Type and Level to the Batch Upload  
    private void insertMemberLevelType(List<rC_Connect__Batch_Upload__c> newList){

		// Make sure we've looked up the Membership GAUs.
		//loadGAUs();
    	
    	// List of Form Campaigns we will need to look up the Campaign Asks on.  <bulkifried>
    	Set<Id> formCampaignIDs = new Set<Id>();

    	// Save the Batch Upload Form Campaigns
        for(rC_Connect__Batch_Upload__c bu: newList){

			// Set the Status for the incoming BU records
			bu.rC_Connect__Batch_Upload_Status__c = 'To ZDM';
			        	
			// Save off the form Campaign ID's from the batch
			//
			// TODO: Stick a check in here in case it's already in the list?
			formCampaignIDs.add(bu.Form_Campaign__c);
        }
    	
    	// Look up all the Campaign Asks for the given set of formCampaigns
    	//		Only look at One Payment Frequency and Default Asks
    	//		WARNING: Hopefully, this should return one ask per campaign, but currently there are 
    	//			no validations to prevent the entry of multiple default campaign asks.  This currently
    	//			returns the first returned match. 
    	//
    	Map<String,rC_Connect__Campaign_Ask__c> campaignAsksMap = new Map<String,rC_Connect__Campaign_Ask__c>();
    	for (rC_Connect__Campaign_Ask__c theAsk :[
    			SELECT  rC_Connect__Campaign__c,
    					Ask_1_Member_Level__c, Ask_1_Member_Type__c, rC_Connect__Ask_1_Amount__c,
						Ask_2_Member_Level__c, Ask_2_Member_Type__c, rC_Connect__Ask_2_Amount__c,
						Ask_3_Member_Level__c, Ask_3_Member_Type__c, rC_Connect__Ask_3_Amount__c,
						Ask_4_Member_Level__c, Ask_4_Member_Type__c, rC_Connect__Ask_4_Amount__c,
						Ask_5_Member_Level__c, Ask_5_Member_Type__c, rC_Connect__Ask_5_Amount__c
    			FROM rC_Connect__Campaign_Ask__c
    			WHERE rC_Connect__Campaign__c IN :formCampaignIDs
    			AND rC_Connect__Giving_Frequency__c = 'One Payment'
    			AND rC_Connect__Is_Default_Ask__c = TRUE]) {
    		
    		// Now save off the 5 potential Level/Type definitions
    		//
    		// The Map key is the Campaign + the Ask Amount + which of the 5 asks
    		//		The Value is the Campaign Ask
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_1_Amount__c) + '1',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_2_Amount__c) + '2',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_3_Amount__c) + '3',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_4_Amount__c) + '4',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_5_Amount__c) + '5',theAsk);
    	}

		// Boolean to track if an Ask value was found for the Batch Upload record
		Boolean askFound = false;

		// Now step back through the Trigger list
		//		but populate the Level/Type from the Map
        for(rC_Connect__Batch_Upload__c bu: newList){

			// Throwing this in as a first check.  Will combine this later.
			if(bu.rC_Connect__Giving_Paid__c == true) {
				
				// VB: 11/10/15 - Making these Member Types & Levels only assigned when a Membership GAU
				// If the BU is Paid, the GAU is set to SC Membership, and there is no defined Membership Level/Level
				if( bu.General_Accounting_Unit__c == MembershipGAU ||
					bu.General_Accounting_Unit__c == MembershipGAUMAG ||
					bu.General_Accounting_Unit__c == MembershipGAUXMAG ||
					bu.General_Accounting_Unit__c == MembershipGAUSCU ||
					bu.General_Accounting_Unit__c == MembershipGAUSCU250 ||
					bu.General_Accounting_Unit__c == MembershipGAUSCUAG ||
					bu.General_Accounting_Unit__c == MembershipGAUSCUJ) {
	
					// Convert the Batch Upload Giving Amount to a string.
					//		Saves a lot of duplication below
					String buGivingAmt = String.valueOf(bu.rC_Connect__Giving_Giving_Amount__c);
	
					// Now check the 5 separate asks:
					// 		If the value is stored in the map, then update the 
					// TODO: Add a loop, if so motivated.
					if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '1')) {
						bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '1').Ask_1_Member_Type__c;
						bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '1').Ask_1_Member_Level__c;
					} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '2')) {
						bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '2').Ask_2_Member_Type__c;
						bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '2').Ask_2_Member_Level__c;
					} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '3')) {
						bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '3').Ask_3_Member_Type__c;
						bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '3').Ask_3_Member_Level__c;
					} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '4')) {
						bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '4').Ask_4_Member_Type__c;
						bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '4').Ask_4_Member_Level__c;
					} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '5')) {
						bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '5').Ask_5_Member_Type__c;
						bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '5').Ask_5_Member_Level__c;
					} else {  // WARNING: Some Asks appear to be poorly defined w/ blanks & zero values			

						// Assign a new Member Level & Member type based upon the Giving Amount
						//  NOTE: These values were determined by Mark Bosler around 10/15.
						if(bu.rC_Connect__Giving_Giving_Amount__c >= 5.00 && bu.rC_Connect__Giving_Giving_Amount__c < 60.00 ) {
							//system.debug('::TRIGGER:MBR2a::');
							bu.Member_Type__c  = 'Single';
							bu.Member_Level__c = 'Regular';
						} else if(bu.rC_Connect__Giving_Giving_Amount__c >= 60.00 && bu.rC_Connect__Giving_Giving_Amount__c < 120.00 ) {
							//system.debug('::TRIGGER:MBR2b::');
							bu.Member_Type__c  = 'Single';
							bu.Member_Level__c = 'Supporting';
						} else if(bu.rC_Connect__Giving_Giving_Amount__c >= 120.00) {
							//system.debug('::TRIGGER:MBR2c::');
							bu.Member_Type__c  = 'Single';
							bu.Member_Level__c = 'Contributing';
						}
					}
				}
			}			
		}
    }
    
    // On an update to the Batch UPload record, assign a value 
    // Look for a defined Campaign Ask
    //		that matches the form Campaign, Giving Amount
    //		and apply the Campaign Asks Member Type and Level to the Batch Upload  
    private void updateBatchUpload(List<rC_Connect__Batch_Upload__c> newList){

		system.debug('::TRIGGER:GAUS::');
	    system.debug('::TRIGGER:      GAU::' + MembershipGAU + ':');
	    system.debug('::TRIGGER:   GAUMAG::' + MembershipGAUMAG + ':');
	    system.debug('::TRIGGER:  GAUXMAG::' + MembershipGAUXMAG + ':');
	    system.debug('::TRIGGER:   GAUSCU::' + MembershipGAUSCU + ':');
	    system.debug('::TRIGGER:GAUSCU250::' + MembershipGAUSCU250 + ':');
	    system.debug('::TRIGGER: GAUSCUAG::' + MembershipGAUSCUAG + ':');
	    system.debug('::TRIGGER:  GAUSCUJ::' + MembershipGAUSCUJ + ':');

    	
		// Boolean to track if an member values were changed for this Batch Upload record
		Boolean memberChanged = false; 

		// Now step back through the Trigger list
		//		but populate the Level/Type from the Map
        for(rC_Connect__Batch_Upload__c bu: newList){

			system.debug('::TRIGGER:BU:GAU::' + bu.General_Accounting_Unit__c + ':');

			// Temp Batch Upload record to record any new Member Type/Level values
			rC_Connect__Batch_Upload__c tempBU = new rC_Connect__Batch_Upload__c(Id = bu.Id);


			//
			// VB: 4/12/16 - This was determined to not be needed, comming this out.
			//		Initialization should be handled at time of insert
			//			
			// Set the GAU, If Paid
			if(bu.rC_Connect__Giving_Paid__c == true) {
				
				// If the General Accounting Unit is blank				
				if ( bu.General_Accounting_Unit__c == null || bu.General_Accounting_Unit__c == '') {
					
					// If there is a value defined for the Form Campaign GAU Id lookup field
					if (bu.Form_Campaign_GAU_Id__c != null && bu.Form_Campaign_GAU_Id__c != '') {
						
						// Assign the lookup field value to the GAU field.
						tempBU.General_Accounting_Unit__c = bu.Form_Campaign_GAU_Id__c;
			        	memberChanged = true;
					}
				// VB: 4/18/16 - Re-enabling the above code, but this will remain commented out
				//		ONLY BU records that blank will get a value.
				//} else { // The General Accounting Unit is NOT blank
				//	// WARNING: What if the GAU is blanked out?
				//	// If there is a value defined for the Form Campaign GAU Id lookup field
				//	if (bu.Form_Campaign_GAU_Id__c != null && bu.Form_Campaign_GAU_Id__c != '') {
				//		// If the value on the lookup is different than the current value
				//		if (bu.Form_Campaign_GAU_Id__c != bu.General_Accounting_Unit__c) {
				//			// Assign the lookup field value to the GAU field.
				//			tempBU.General_Accounting_Unit__c = bu.Form_Campaign_GAU_Id__c;
				 //       	memberChanged = true;
				//		}
				//	}
				}
			}


			// If the BU is Paid, the GAU is set to SC Membership, and there is no defined Membership Level/Level
			if(bu.rC_Connect__Giving_Paid__c && 
					(bu.General_Accounting_Unit__c == MembershipGAU ||
					bu.General_Accounting_Unit__c == MembershipGAUMAG ||
					bu.General_Accounting_Unit__c == MembershipGAUXMAG ||
					bu.General_Accounting_Unit__c == MembershipGAUSCU ||
					bu.General_Accounting_Unit__c == MembershipGAUSCU250 ||
					bu.General_Accounting_Unit__c == MembershipGAUSCUAG ||
					bu.General_Accounting_Unit__c == MembershipGAUSCUJ ) &&  
					(bu.Member_Type__c == null || bu.Member_Type__c == '') && 
					(bu.Member_Level__c == null || bu.Member_Level__c == '')) {

				system.debug('::TRIGGER:BU:IN::');

				// Assign a new Member Level & Member type based upon the Giving Amount
				//  NOTE: These values were determined by Mark Bosler around 10/15.
				if(bu.rC_Connect__Giving_Giving_Amount__c >= 5.00 && bu.rC_Connect__Giving_Giving_Amount__c < 60.00 ) {

					system.debug('::TRIGGER:BU:IN1::');
					tempBU.Member_Type__c  = 'Single';
					tempBU.Member_Level__c = 'Regular';
		        	memberChanged = true;
				} else if(bu.rC_Connect__Giving_Giving_Amount__c >= 60.00 && bu.rC_Connect__Giving_Giving_Amount__c < 120.00 ) {

					system.debug('::TRIGGER:BU:IN2::');
					tempBU.Member_Type__c  = 'Single';
					tempBU.Member_Level__c = 'Supporting';
		        	memberChanged = true;
				} else if(bu.rC_Connect__Giving_Giving_Amount__c >= 120.00) {

					system.debug('::TRIGGER:BU:IN3::');
					tempBU.Member_Type__c  = 'Single';
					tempBU.Member_Level__c = 'Contributing';
		        	memberChanged = true;
				}
			}

			// If a change to the Member Type/Level has been done.
			if (memberChanged == true) {
				// Add the temp to the Map to be updated
				batchuploadsToUpdateMap.put(bu.Id,tempBU);
			}
			// Reset the tracker for the next iteration
			memberChanged = false;			
		}

		// If there has been a Batch Upload to be updated
		if (batchuploadsToUpdateMap.size() > 0) {
			system.debug('::TRIGGER:MBR: Update! :' + batchuploadsToUpdateMap.size());
			update batchuploadsToUpdateMap.values();
		}
		
    }
    
    
}