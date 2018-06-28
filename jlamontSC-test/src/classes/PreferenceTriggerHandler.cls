/*********************************************************************************************************
Name			: PreferenceTriggerHandler
Created by		: Dipika Gupta (Appirio)
Created Date	: Feb 7, 2014
Description		: T-242113 update Account/Contact custom fields
Updated			: 2014/08/04 VB: Making major changes in support of new Summit Circle fields.
				: 2014/08/26 VB: Bug fix in Contact Preference, listCheckboxes.set(5,true); set twice
				: 2015/06/18 VB: Added Contact level SierraRise preference support
				: 2015/07/15 VB: Switched to static lookups for RecordTypes
				: 2015/08/05 VB: Added static non-SOQL record type lookup
				: 2015/11/30 VB: Updated JMS for 2016 
				: 2015/12/09 VB: Updated Planned Giving Prospect to RCS
				: 2017/02/20 VB: Updated JMS for 2017
				: 2017/03/03 VB: CORE3: New support for 5 new checkboxes
									No Email | No Mail | No Phone | No Chapter Contact | Keep Anonymous 
				: 2017/03/07 VB: Small change, No Mail now supports "No Fundraising Mail - Local" pref
				: 2017/03/08 VB: Adding support for checkbox population for both HH & Org record types
				: 2017/04/25 VB: Reduced No Fundraising Mail/Phone down to just "No Mail" & "No Phone" prefs
				: 2017/05/23 VB: Removing code to update No Phone/No Mail on Contact, this is to be handled 
									 by triggers/workflows and inherited by the parent account.  
									Contact-level preferences are to be ignored.
				: 2017/06/12 VB: Adding support for new No Local Phone/No Local Mail preference.  Works
									similarly to No Phone/No Mail as it is only maintained on Account. 
***********************************************************************************************************/
public without sharing class PreferenceTriggerHandler {

	/*
    private static String HouseHoldAccountRecordType;
    private static String HouseHoldContactRecordType;
    private static String GeneralPreferenceRecordType;

    //fetch Account and Contact record type with name 'Houshold'
    private static void recordTypes(){
        for(RecordType RT: [SELECT ID,SobjectType 
        						FROM RecordType 
        						WHERE ((SobjectType='Account' OR SobjectType='Contact') AND NAME='Household')
        							OR (SobjectType='rC_Bios__Preference__c' AND NAME='General')]){
            if(RT.SobjectType == 'Account' ){
                HouseholdAccountRecordType = RT.ID;
            }
            if(RT.SobjectType == 'Contact'){
                HouseholdContactRecordType = RT.ID;
            }
            if(RT.SobjectType == 'rC_Bios__Preference__c' ){
                GeneralPreferenceRecordType = RT.ID;
            }
        }
    }
    */
    
    static String HouseHoldAccountRecordType;
    static String OrganizationAccountRecordType;
    static String HouseHoldContactRecordType;
    static String OrganizationContactRecordType;
    static String GeneralPreferenceRecordType;
	static {
		HouseHoldAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		OrganizationAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
		HouseHoldContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		OrganizationContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Organizational').getRecordTypeId();
		GeneralPreferenceRecordType = Schema.SObjectType.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();
	}
    


    //
    // listPreferences - the Trigger.New from PreferenceTrigger
    //
    // This is called after an insert or undelete with the Trigger.new
    // 	and is called after a delete with the Trigger.old
	public static void AfterInsert(List<rC_Bios__Preference__c> listPreference){
        
		List<Id> listAccountId = new List<Id>();
		List<Id> listContactId = new List<Id>();

		// Collect accountIds of all inserted/updated rC_Bios__Preference__c
		// 
		// Build lists of all AccountIds and ContactIds for the new Preferences
		for(rC_Bios__Preference__c PR: listPreference){
            
            // If the Preference has an Account defined
			if(PR.rC_Bios__Account__c != null){
				listAccountId.add(PR.rC_Bios__Account__c);
			}
            
            // If the Preference has a Contact defined
			if(PR.rC_Bios__Contact__c != null){
				listContactId.add(PR.rC_Bios__Contact__c);
			}
		}
		//system.debug('------listAccountId-------'+listAccountId);
		//system.debug('------listContactId-------'+listContactId);
        
        // If any Accounts or Contacts were affected by this insert ( )
		if(listAccountId.size()>0 || listContactId.size()>0){
            
            // Update the Parent Accounts & Contacts with the correct checkboxes
			updateFields(listAccountId,listContactId);
		}
	}

    // Called after an update to a preference
    // 		First param is the Trigger.new
    // 		Second param is the Trigger.oldMap
	public static void AfterUpdate(List<rC_Bios__Preference__c> listPreference, Map<ID,rC_Bios__Preference__c> MapPreference){
        
		List<Id> listAccountId = new List<Id>();
		List<Id> listContactId = new List<Id>();
	
		//Collect accountIds of all inserted/updated rC_Bios__Preference__c
		for(rC_Bios__Preference__c PR: listPreference){
            
            // If the Preferences Account has changed
            // AND the old Preference had a non-NULL value
			if(PR.rC_Bios__Account__c != MapPreference.get(PR.ID).rC_Bios__Account__c
			    && MapPreference.get(PR.ID).rC_Bios__Account__c!= null){
                    
				// Save the OLD Account value.
				listAccountId.add(MapPreference.get(PR.ID).rC_Bios__Account__c);
			}
            
            // Save the Preference Account
			if(PR.rC_Bios__Account__c != null){
				listAccountId.add(PR.rC_Bios__Account__c);
			}
            // Save the Preference Contact
			if(PR.rC_Bios__Contact__c != null){
				listContactId.add(PR.rC_Bios__Contact__c);
			}
            
            // If the Preference's Contact has changed
            // AND the old value had a non-NULL value
			if(PR.rC_Bios__Contact__c != MapPreference.get(PR.ID).rC_Bios__Contact__c
			    && MapPreference.get(PR.ID).rC_Bios__Contact__c != null ){
                    
				// Save the OLD Contact value.
				listContactId.add(MapPreference.get(PR.ID).rC_Bios__Contact__c);
			}
		}

        // If anything got changed, 
		if(listAccountId.size()>0 || listContactId.size()>0){
			updateFields(listAccountId,listContactId);
		}
	}

	//This method update fields of account and contacts
	private static void updateFields(List<Id> listAccountId, List<Id> listContactId){

        //recordTypes();
        
		List<Account> listAccount = new List<Account>();
		List<Contact> listContact = new List<Contact>();
        
        //  VB: 7/15/15 - Trying to remove this dependency
		//List<ID> listRecordTypeId = new List<ID>();
		
		// List of Contacts that will need a SierraRise Exclusive preference.
		List<Id> contactsToConfirmSierraRiseExclusiveInsert = new List<Id>();  
		List<Id> contactsToConfirmSierraRiseExclusiveDelete = new List<Id>();  
		
		// VB: 7/15/15 - Finally killing this mess
        //
        // VB:Why the hell?
        // 
        // Look up the Account & Contact record type Ids and save them to a list.
		//for(RecordType RT: [SELECT ID,SobjectType FROM RecordType WHERE NAME ='Household']){
        //    
        //    // VB:Why not include this in the WHERE clause above?
		//	if(RT.SobjectType == 'Account' || RT.SobjectType == 'Contact'){
		//		listRecordTypeId.add(RT.ID);
		//	}
		//}

        // If there are Accounts to be "processed"
		if(listAccountId.size()>0) {
            
            //
            // What is the point of this thing?
            // 
            // I Think they track if there was an preference on the current Account ( Active or Inactive )
			//list<boolean> listCheckboxes = new list<boolean>{false,false,false,false,false,false,false};
			//
			// 0: Major Gift Donor
			// 1: Major Gift Donor Prospect
			// 2: Summit Circle Member
			// 3: Planned Gift Donor
			// 4: Planned Gift Prospect
			// 5: JMS Donor 2014
			// 6: Estate
			//  7: Summit Circle Prospect
			//  8: Summit Circle Disqualified
			//  9: Summit Circle Member Do Not Contact
			// 10: Summit Circle No Email
			// 11: Summit Circle Solicited by GO
			// 12: Grasstops
			// 13: No Email
			// 14: No Mail
			// 15: No Phone 
			// 16: No Chapter Contact
			// 17: Keep Anonymous
			// 18: No Local Mail
			// 19: No Local Phone
			list<boolean> listCheckboxes = new list<boolean>{false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false};
                
			//Fetch all Account records with prefernces related list
			//
			// VB: I don't even know what that subselect from a __r relationship field does...
			// 
			// Look up the existing Preference checkboxes for the account
			// 		apparently, also look up to see if that Preference is Active and its subcategory value?
			for(Account acc: [SELECT 	Major_Donor__c,
                              			Major_Donor_Prospect__c,
                              			Summit_Circle_Member__c,
										Planned_Giving__c,
                              			Planned_Giving_Prospect__c,
                              			John_Muir_Society__c,
                              			Estate__c,
                                        Summit_Circle_Prospect__c,
                                        Summit_Circle_Disqualified__c,
                                        Summit_Circle_Member_Do_Not_Contact__c,
                                        Summit_Circle_No_Email__c,
                                        Summit_Circle_Solicited_by_GO__c,
                                        Grasstop__c,
                                        No_Email__c,
                                        No_Mail__c,
                                        No_Phone__c,
                                        No_Chapter_Contact__c,
                                        Keep_Anonymous__c,
                                        No_Local_Mail__c,
                                        No_Local_Phone__c,
							   			(SELECT rC_Bios__Active__c, 
                                         		rC_Bios__Subcategory__c 
                                         	FROM rC_Bios__Preferences__r
							    			ORDER BY LastModifiedDate DESC)
							  	FROM Account
							  	WHERE ID IN: listAccountId
							  		AND (RecordTypeID = :HouseHoldAccountRecordType OR RecordTypeID =:OrganizationAccountRecordType)]) {

				// ?
				// 
				// ?If there were preferences on the current account?
				if(acc.rC_Bios__Preferences__r.size() != 0){
                    
                    // Um, 	wtf?
                    // 		if the current account's most recent preference is active?
                    // 			then that preference's active status 
                    // 			becomes the Major Donor Prospect's checkbox value?
                    // 
                    // WARNING: The below statement _might_ be a bug, or I just don't get it yet.
					//
					// VB: 3/18/15 - commenting out the below line
					//acc.Major_Donor_Prospect__c = acc.rC_Bios__Preferences__r.get(0).rC_Bios__Active__c;
                    
                    // Step through each of the Preferences__r things?
                    // 
                    // WARNING: This appears to have the current bug:
                    // 		If an account does have more than one preference of the same subcategory
                    // 		then the Account would inherit the value of the OLDEST existing
                    // 		preference, not the most recent preference.  
					for(rC_Bios__Preference__c PR : acc.rC_Bios__Preferences__r){
                        
                        // If the Preference's Subcategory is a Major Gift Donor
						if(PR.rC_Bios__Subcategory__c == 'Major Gift Donor'){
                            
                            // Set the account's MD flag to the active status of the Preference?
							acc.Major_Donor__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(0,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'Major Gift Donor Prospect'){
							acc.Major_Donor_Prospect__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(1,true);
						}                        
						else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Member'){
							acc.Summit_Circle_Member__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(2,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'Planned Gift Donor'){
							acc.Planned_Giving__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(3,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'RCS'){
							acc.Planned_Giving_Prospect__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(4,true);
						}
						// VB: 2/9/15 Added check for 2015 in addition to 2014 ( per request by Mark Bosler )
						// VB: 11/30/15 Updated code for 2016
						// VB: 02/20/17 Updated code for 2017
						//else if(PR.rC_Bios__Subcategory__c == 'JMS Donor 2015' || PR.rC_Bios__Subcategory__c == 'JMS Donor 2016' ){
						else if(PR.rC_Bios__Subcategory__c == 'JMS Donor 2017'){
							acc.John_Muir_Society__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(5,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Estate') {		// Added For T-254264
							acc.Estate__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(6,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Prospect') {		// Added For Summit Circle
							acc.Summit_Circle_Prospect__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(7,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Disqualified') {		// Added For Summit Circle
							acc.Summit_Circle_Disqualified__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(8,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Member Do Not Contact') {		// Added For Summit Circle
							acc.Summit_Circle_Member_Do_Not_Contact__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(9,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle No Email') {				// Added For Summit Circle
							acc.Summit_Circle_No_Email__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(10,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Solicited by GO') {		// Added For Summit Circle
							acc.Summit_Circle_Solicited_by_GO__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(11,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Grasstop') {
							acc.Grasstop__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(12,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'No Email') {
							acc.No_Email__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(13,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'No Mail' ) {
							acc.No_Mail__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(14,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'No Phone' ){
							acc.No_Phone__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(15,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'No Chapter Contact') {
							acc.No_Chapter_Contact__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(16,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Keep anonymous') {
							acc.Keep_Anonymous__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(17,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'No Local Mail' ) {
							acc.No_Local_Mail__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(18,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'No Local Phone' ){
							acc.No_Local_Phone__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(19,true);
						}
					}
                    
                    // Is this some kind of test?
                    // 		This seems to be undoing what just got done above?
                    // 		Is the listCheckboxes, checking for the existance of a preference?
                    // 		
                    // Trying to decode this mess:
                    // The default value of the listCheckboxes are false.
                    // It can only be set to true, if the oldest existing preference of that subcategory is Active.
                    // - I think it means to be written: if there's an active preference
                    // 
                    // This statement pulls the boolean from the list and NOTs it
                    // so if FALSE, then !FALSE, which is True, so then set the value to false.
                    // so if TRUE, then !TRUE, which is false, so then set the value to itself? ( Don't change it)
                    // 
                    // So if we found no preferences for the Account, then set the preference to False.
                    // But if we did find a preference, then leave it alone, assuming it was set correctly above?
                    // 
                    // Why not:
                    // 		// If no preference existed under this account, set to false
                    // 		if(!listCheckboxes.get(0)) acc.Major_Donor__c = false;
                    //
					acc.Major_Donor__c 				= !listCheckboxes.get(0)? false :acc.Major_Donor__c;
					acc.Major_Donor_Prospect__c 	= !listCheckboxes.get(1)? false :acc.Major_Donor_Prospect__c;
					acc.Summit_Circle_Member__c		= !listCheckboxes.get(2)? false :acc.Summit_Circle_Member__c;
					acc.Planned_Giving__c 			= !listCheckboxes.get(3)? false :acc.Planned_Giving__c;
					acc.Planned_Giving_Prospect__c 	= !listCheckboxes.get(4)? false :acc.Planned_Giving_Prospect__c;
					acc.John_Muir_Society__c 		= !listCheckboxes.get(5)? false :acc.John_Muir_Society__c;
					acc.Estate__c 					= !listCheckboxes.get(6)? false :acc.Estate__c;	 // Added For T-254264
                    
                    // Added For Summit Circle
					acc.Summit_Circle_Prospect__c 				= !listCheckboxes.get(7)? false :acc.Summit_Circle_Prospect__c;
					acc.Summit_Circle_Disqualified__c 			= !listCheckboxes.get(8)? false :acc.Summit_Circle_Disqualified__c;
					acc.Summit_Circle_Member_Do_Not_Contact__c 	= !listCheckboxes.get(9)? false :acc.Summit_Circle_Member_Do_Not_Contact__c;
					acc.Summit_Circle_No_Email__c 				= !listCheckboxes.get(10)? false :acc.Summit_Circle_No_Email__c;
					acc.Summit_Circle_Solicited_by_GO__c 		= !listCheckboxes.get(11)? false :acc.Summit_Circle_Solicited_by_GO__c;

					// Added for CORE3
					acc.Grasstop__c 			= !listCheckboxes.get(12)? false :acc.Grasstop__c;
					acc.No_Email__c 			= !listCheckboxes.get(13)? false :acc.No_Email__c;
					acc.No_Mail__c 				= !listCheckboxes.get(14)? false :acc.No_Mail__c;
					acc.No_Phone__c 			= !listCheckboxes.get(15)? false :acc.No_Phone__c;
					acc.No_Chapter_Contact__c 	= !listCheckboxes.get(16)? false :acc.No_Chapter_Contact__c;
					acc.Keep_Anonymous__c 		= !listCheckboxes.get(17)? false :acc.Keep_Anonymous__c;

					// Added for CORE3.b
					acc.No_Local_Mail__c 		= !listCheckboxes.get(18)? false :acc.No_Local_Mail__c;
					acc.No_Local_Phone__c 		= !listCheckboxes.get(19)? false :acc.No_Local_Phone__c;
                    
					listAccount.add(acc);
				}
                                        
				// Updated condition for Estate too 4 march For T-254264
				//
				// Else, they had no preferences whatsoever
				//
				else {
                    
					// if any of their preferences were true?
					// - I guess this means we only update the account if necessary
                    if(	acc.Major_Donor__c || 
                       	acc.Major_Donor_Prospect__c || 
                       	acc.Summit_Circle_Member__c || 
                       	acc.Planned_Giving__c || 
                       	acc.Planned_Giving_Prospect__c || 
                       	acc.John_Muir_Society__c || 
                       	acc.Estate__c ||
						acc.Summit_Circle_Prospect__c ||
						acc.Summit_Circle_Disqualified__c ||
						acc.Summit_Circle_Member_Do_Not_Contact__c ||
						acc.Summit_Circle_No_Email__c ||
						acc.Summit_Circle_Solicited_by_GO__c ||
						acc.Grasstop__c ||
						acc.No_Email__c ||
						acc.No_Mail__c ||
						acc.No_Phone__c ||
						acc.No_Chapter_Contact__c ||
						acc.Keep_Anonymous__c ||
						acc.No_Local_Mail__c ||
						acc.No_Local_Phone__c
						
                      ) {

                        // Set all of their preferences to false
                        acc.Major_Donor__c = false;
                        acc.Major_Donor_Prospect__c = false;
                        acc.Summit_Circle_Member__c = false;
                        acc.Planned_Giving__c = false;
                        acc.Planned_Giving_Prospect__c = false;
                        acc.John_Muir_Society__c = false;
                        acc.Estate__c = false;
						acc.Summit_Circle_Prospect__c = false;
						acc.Summit_Circle_Disqualified__c = false;
						acc.Summit_Circle_Member_Do_Not_Contact__c = false;
						acc.Summit_Circle_No_Email__c = false;
						acc.Summit_Circle_Solicited_by_GO__c = false;
						acc.Grasstop__c = false;
						acc.No_Email__c = false;
						acc.No_Mail__c = false;
						acc.No_Phone__c = false;
						acc.No_Chapter_Contact__c = false;
						acc.Keep_Anonymous__c = false;
						acc.No_Local_Mail__c = false;
						acc.No_Local_Phone__c = false;
                          
                        listAccount.add(acc);
					}
				}
			}
		}
        
        // Same Process for Contacts
        // 
        // Were there any preferences for this contact?
		if(listContactId.size()>0) {
            
			//
			//  0: Major Gift Donor
			//  1: Major Gift Donor Prospect
			//  2: Summit Circle Member
			//  3: Planned Gift Donor
			//  4: Planned Gift Prospect
			//  5: JMS Donor 2014
			//  6: Estate
			//  7: Summit Circle Prospect
			//  8: Summit Circle Disqualified
			//  9: Summit Circle Member Do Not Contact
			// 10: Summit Circle No Email
			// 11: Summit Circle Solicited by GO
			// 12: Grasstops
			// 13: No Email
			// 14: No Mail		VB: Removed 5/24/17
			// 15: No Phone  	VB: Removed 5/24/17
			// 16: No Chapter Contact
			// 17: Keep Anonymous
			// 18: SierraRise All ( Only on Contact)
			// 19: SierraRise Exclusive
			// 20: Team Sierra Fundraiser
			//list<boolean> listCheckboxes = new list<boolean>{false,false,false,false,false,false,false};
			list<boolean> listCheckboxes = new list<boolean>{false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false};
                
			//Fetch all Contact records with prefernces related list
			for(Contact con: [SELECT 	Major_Donor__c,
                              			Major_Donor_Prospect__c ,
                              			Summit_Circle_Member__c,
                              			Planned_Giving__c,
                              			Planned_Giving_Prospect__c,
                              			John_Muir_Society__c,
                              			Estate__c,
                                        Summit_Circle_Prospect__c,
                                        Summit_Circle_Disqualified__c,
                                        Summit_Circle_Member_Do_Not_Contact__c,
                                        Summit_Circle_No_Email__c,
                                        Summit_Circle_Solicited_by_GO__c,
                                        Grasstop__c,
                                        No_Email__c,
                                        //No_Mail__c,					VB: Removed 5/24/17, value controlled by Account level preference
                                        //No_Phone__c,					VB: Removed 5/24/17, value controlled by Account level preference
                                        No_Chapter_Contact__c,
                                        Keep_Anonymous__c,
							  			(SELECT rC_Bios__Active__c, 
                                         		rC_Bios__Subcategory__c 
											FROM rC_Bios__Preferences__r
											ORDER BY LastModifiedDate DESC),
										SierraRise_All__c,
										SierraRise_Exclusive__c,
                              			Team_Sierra_Fundraiser__c,
										Account_Membership_Active__c,
										Account_Non_SierraRise_Donor__c
							  		FROM Contact
							  		WHERE ID IN: listContactId
							  		AND (RecordTypeId = :HouseHoldContactRecordType OR RecordTypeId =:OrganizationContactRecordType)]) {
							  		//AND RecordTypeId IN: listRecordTypeId ]){

				// If there were any preferences for this Contact
				if(con.rC_Bios__Preferences__r.size() != 0) {

					// Step through the Preferences
					// 	If there's an active preference, 
					// 		update the Contact
					// 		mark the listCheckboxes of the presence of a preference
					for(rC_Bios__Preference__c PR : con.rC_Bios__Preferences__r){
						if(PR.rC_Bios__Subcategory__c == 'Major Gift Donor'){
							con.Major_Donor__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(0,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'Major Gift Donor Prospect'){
							con.Major_Donor_Prospect__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(1,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Member'){
							con.Summit_Circle_Member__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(2,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'Planned Gift Donor'){
							con.Planned_Giving__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(3,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'RCS'){
							con.Planned_Giving_Prospect__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(4,true);
						}
						// VB: 2/9/15 Added check for 2015 in addition to 2014 ( per request by Mark Bosler )
						// VB: 11/30/15 Updated code for 2016
						// VB: 02/20/17 Updated code for 2017
						//else if(PR.rC_Bios__Subcategory__c == 'JMS Donor 2015' || PR.rC_Bios__Subcategory__c == 'JMS Donor 2016' ){
						else if(PR.rC_Bios__Subcategory__c == 'JMS Donor 2017' ){
							con.John_Muir_Society__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(5,true);
						}
						else if(PR.rC_Bios__Subcategory__c == 'Estate'){// Added For T-254264
							con.Estate__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(6,true);	// Was this REALLY set to 5? WARNING: Check production!!!
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Prospect') {		// Added For Summit Circle
							con.Summit_Circle_Prospect__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(7,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Disqualified') {		// Added For Summit Circle
							con.Summit_Circle_Disqualified__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(8,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Member Do Not Contact') {		// Added For Summit Circle
							con.Summit_Circle_Member_Do_Not_Contact__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(9,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle No Email') {		// Added For Summit Circle
							con.Summit_Circle_No_Email__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(10,true);
						}
                        else if(PR.rC_Bios__Subcategory__c == 'Summit Circle Solicited by GO') {		// Added For Summit Circle
							con.Summit_Circle_Solicited_by_GO__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(11,true);
                        }
                        else if(PR.rC_Bios__Subcategory__c == 'Grasstop') {
							con.Grasstop__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(12,true);
                        }
                        else if(PR.rC_Bios__Subcategory__c == 'No Email') {
							con.No_Email__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(13,true);
                        }
						// 	VB: Removed 5/24/17, value controlled by Account level preference
						////VB:4/25/17 - else if(PR.rC_Bios__Subcategory__c == 'No Fundraising Mail - Nat' || PR.rC_Bios__Subcategory__c == 'No Fundraising Mail - Local' ) {
						//else if(PR.rC_Bios__Subcategory__c == 'No Mail' ) {
						//	con.No_Mail__c = PR.rC_Bios__Active__c;
						//	listCheckboxes.set(14,true);
                        //}
						// 	VB: Removed 5/24/17, value controlled by Account level preference
						////VB:4/25/17 - else if(PR.rC_Bios__Subcategory__c == 'No Fundraising Phone - Nat' || PR.rC_Bios__Subcategory__c == 'No Fundraising Phone - Local' ){
						//else if(PR.rC_Bios__Subcategory__c == 'No Phone' ){
						//	con.No_Phone__c = PR.rC_Bios__Active__c;
						//	listCheckboxes.set(15,true);
                       // }
                        else if(PR.rC_Bios__Subcategory__c == 'No Chapter Contact') {
							con.No_Chapter_Contact__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(16,true);
                        }
                        else if(PR.rC_Bios__Subcategory__c == 'Keep anonymous') {
							con.Keep_Anonymous__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(17,true);
                        }
                        else if(PR.rC_Bios__Subcategory__c == 'Team Sierra Fundraiser') {
							con.Team_Sierra_Fundraiser__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(20,true);
                        }                        
                        else if(PR.rC_Bios__Subcategory__c == 'SierraRise All') {							// Added For SierraRise
							con.SierraRise_All__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(18,true);

							// Now that a SierraRise preference has been added/updated
							//		We need to check to see if the Contact should also be added
							//		to SierraRise Exclusive
							
							// Now check to see if this Contact COULD be SierraRise Exclusive
							//
							// If the Contact's Account does not have an cctive membership
							//		and the Contact's Account has never given a non-SierraRise Donation							
							if(!con.Account_Membership_Active__c && !con.Account_Non_SierraRise_Donor__c) {


								// if the currently processed Preference is active
								if(PR.rC_Bios__Active__c) {
									
									// Trying to make the person SR Exclusive
									// Save the Contact, so they can be placed in SierraRise Exclusive!
									contactsToConfirmSierraRiseExclusiveInsert.add(con.Id);
									
								} else {

									// Make them SR Exclusive Inactive
									contactsToConfirmSierraRiseExclusiveDelete.add(con.Id);
									
								}

							} else {
								
								// The contact is excluded from being SR Exclusive
								// if the currently processed Preference is active
								if(PR.rC_Bios__Active__c) {
									
									// Make them SR Exclusive Inactive
									contactsToConfirmSierraRiseExclusiveDelete.add(con.Id);
									
								} else {

									// do nothing, they're fine?
									
									// or
									
									// make them Exclusive Inactive
									contactsToConfirmSierraRiseExclusiveDelete.add(con.Id);
									
								}
							}

							
							
						}
                        else if(PR.rC_Bios__Subcategory__c == 'SierraRise Exclusive') {					// Added For SierraRise


							//
							// WARNING: I'm not entirely sure if I need to be checking when a SR Exclusive
							//		preference is added to a record, should it only be allowed when 
							//		the other citeria exist?  Or should I assume that the intent was
							//		purposeful, and allow it to go thru as an 'override'.
							//		At this point, I'm assuming the process that got this preference 
							//		to fire, was correct and to simply follow its intent.
							//
							// Mark the Contact with the current state of the SR Exclusive preference
							con.SierraRise_Exclusive__c = PR.rC_Bios__Active__c;
							listCheckboxes.set(19,true);


							// Now that a preference has been added/updated
							//		We need to check more than just the preference
							
							// Now check to see if this Contact COULD be SierraRise Exclusive
							//
							// If the Contact's Account does not have an cctive membership
							//		and the Contact's Account has never given a non-SierraRise Donation							
							if(!con.Account_Membership_Active__c && !con.Account_Non_SierraRise_Donor__c) {


								// if the currently processed Preference is active
								if(PR.rC_Bios__Active__c) {
									
									// Trying to make the person SR Exclusive
									// Save the Contact, so they can be placed in SierraRise Exclusive!
									contactsToConfirmSierraRiseExclusiveInsert.add(con.Id);
									
								} else {

									// Make them SR Exclusive Inactive
									contactsToConfirmSierraRiseExclusiveDelete.add(con.Id);
									
								}

							} else {
								
								// The contact is excluded from being SR Exclusive
								// if the currently processed Preference is active
								if(PR.rC_Bios__Active__c) {
									
									// Make them SR Exclusive Inactive
									contactsToConfirmSierraRiseExclusiveDelete.add(con.Id);
									
								} else {

									// do nothing, they're fine?
									
									// or
									
									// make them Exclusive Inactive
									contactsToConfirmSierraRiseExclusiveDelete.add(con.Id);
									
								}
							}
						}
					}

                    // If there was no preference of a specific type, then mark it as false
					con.Major_Donor__c 				= !listCheckboxes.get(0)? false :con.Major_Donor__c;
					con.Major_Donor_Prospect__c 	= !listCheckboxes.get(1)? false :con.Major_Donor_Prospect__c;
					con.Summit_Circle_Member__c 	= !listCheckboxes.get(2)? false :con.Summit_Circle_Member__c;
					con.Planned_Giving__c 			= !listCheckboxes.get(3)? false :con.Planned_Giving__c;
					con.Planned_Giving_Prospect__c 	= !listCheckboxes.get(4)? false :con.Planned_Giving_Prospect__c;
					con.John_Muir_Society__c 		= !listCheckboxes.get(5)? false :con.John_Muir_Society__c;
					con.Estate__c 					= !listCheckboxes.get(6)? false :con.Estate__c;		// Added For T-254264

                    // Added For Summit Circle
					con.Summit_Circle_Prospect__c 				= !listCheckboxes.get(7)? false :con.Summit_Circle_Prospect__c;
					con.Summit_Circle_Disqualified__c 			= !listCheckboxes.get(8)? false :con.Summit_Circle_Disqualified__c;
					con.Summit_Circle_Member_Do_Not_Contact__c 	= !listCheckboxes.get(9)? false :con.Summit_Circle_Member_Do_Not_Contact__c;
					con.Summit_Circle_No_Email__c 				= !listCheckboxes.get(10)? false :con.Summit_Circle_No_Email__c;
					con.Summit_Circle_Solicited_by_GO__c 		= !listCheckboxes.get(11)? false :con.Summit_Circle_Solicited_by_GO__c;

					// CORE3 Preference checkboxes
					con.Grasstop__c 			= !listCheckboxes.get(12)? false :con.Grasstop__c;
					con.No_Email__c 			= !listCheckboxes.get(13)? false :con.No_Email__c;
					//con.No_Mail__c 			= !listCheckboxes.get(14)? false :con.No_Mail__c;		VB: Removed 5/24/17
					//con.No_Phone__c 			= !listCheckboxes.get(15)? false :con.No_Phone__c;  	VB: Removed 5/24/17
					con.No_Chapter_Contact__c 	= !listCheckboxes.get(16)? false :con.No_Chapter_Contact__c;
					con.Keep_Anonymous__c 		= !listCheckboxes.get(17)? false :con.Keep_Anonymous__c;

					con.SierraRise_All__c				 		= !listCheckboxes.get(18)? false :con.SierraRise_All__c;
					con.SierraRise_Exclusive__c				 	= !listCheckboxes.get(19)? false :con.SierraRise_Exclusive__c;
                    con.Team_Sierra_Fundraiser__c				= !listCheckboxes.get(20)? false :con.Team_Sierra_Fundraiser__c;
                    
					listContact.add(con);
				}
				// Updated condition for Estate too 4 march For T-254264
				// 
				// If there were no preferences for this Contact
				else{ 
                    
                    // If any of the preferences are currently true
					if(con.Major_Donor__c || 
                       	con.Major_Donor_Prospect__c || 
                       	con.Summit_Circle_Member__c || 
                       	con.Planned_Giving__c || 
                       	con.Planned_Giving_Prospect__c || 
                        con.John_Muir_Society__c || 
						con.Estate__c ||
						con.Summit_Circle_Prospect__c ||
						con.Summit_Circle_Disqualified__c ||
						con.Summit_Circle_Member_Do_Not_Contact__c ||
						con.Summit_Circle_No_Email__c ||
						con.Summit_Circle_Solicited_by_GO__c ||
						con.Grasstop__c ||
						con.No_Email__c ||
						//con.No_Mail__c ||		VB: Removed 5/24/17
						//con.No_Phone__c || 	VB: Removed 5/24/17
						con.No_Chapter_Contact__c ||
						con.Keep_Anonymous__c ||
						con.SierraRise_All__c ||
						con.SierraRise_Exclusive__c ||
                       	con.Team_Sierra_Fundraiser__c
                      ){
                         
						// Mark all the preferences as false
						con.Major_Donor__c = false;
						con.Major_Donor_Prospect__c = false;
						con.Summit_Circle_Member__c = false;
						con.Planned_Giving__c = false;
						con.Planned_Giving_Prospect__c = false;
						con.John_Muir_Society__c = false;
						con.Estate__c = false;
						con.Summit_Circle_Prospect__c = false;
						con.Summit_Circle_Disqualified__c = false;
						con.Summit_Circle_Member_Do_Not_Contact__c = false;
						con.Summit_Circle_No_Email__c = false;
						con.Summit_Circle_Solicited_by_GO__c = false;
						con.Grasstop__c = false;
						con.No_Email__c = false;
						//con.No_Mail__c = false;	VB: Removed 5/24/17
						//con.No_Phone__c = false; 	VB: Removed 5/24/17
						con.No_Chapter_Contact__c = false;
						con.Keep_Anonymous__c = false;
						con.SierraRise_All__c = false;						// WARNING: Not sure if this applies correctly for SR
						con.SierraRise_Exclusive__c = false;				// WARNING: Not sure if this applies correctly for SRE
						con.Team_Sierra_Fundraiser__c = false;
                          
						listContact.add(con);
					}
				}
			}
		}

		// If there are Accounts to update, update them
		if(listAccount.size()>0){
			update listAccount;
		}

        // If there are Contacts to update, update them
	    if(listContact.size()>0){
	    	update listContact;
		}
		
        // If there are Contacts to add SierraRise Exclusive preference for
	    if(contactsToConfirmSierraRiseExclusiveInsert.size()>0){
	    	
	    	//List<Id> theC = new List<Id>();
			//processInsertSierraRiseExclusiveContacts(contactsToConfirmSierraRiseExclusiveInsert);
			processSierraRiseExclusive(contactsToConfirmSierraRiseExclusiveInsert);
		}
        // If there are Contacts to add SierraRise Exclusive preference for
	    if(contactsToConfirmSierraRiseExclusiveDelete.size()>0){
	    	
	    	//List<Id> theC = new List<Id>();
			//processInsertSierraRiseExclusiveContacts(contactsToConfirmSierraRiseExclusiveInsert);
			processSierraRiseExclusiveDelete(contactsToConfirmSierraRiseExclusiveDelete);
		}
		
	}
	
	// Given a list of Contacts:
	//		Looks up existing preferences and determines if an existing preference simply needs to be updated
	//		or if a new preference needs to be created and inserted.	
	public static void processSierraRiseExclusive(List<Id> theContactsToProcess) {
		
		// Holder of preferences to be inserted
		// Now we start building the new preferences
		//List<kweos__EOCS_Data__c> newPreferences = new List<kweos__EOCS_Data__c>(); 
		List<rC_Bios__Preference__c> newSierraRisePreferences = new List<rC_Bios__Preference__c>();

		// Build a Map of existing SierrRise preferences for these Contacts by
		// 	looking up all of the SR Exclusive Preferences for the Contacts passed-in.
		Map<Id, rC_Bios__Preference__c> existingPreferences = new Map<Id, rC_Bios__Preference__c>(
				[SELECT Id, rC_Bios__Account__c, rC_Bios__Contact__c, rC_Bios__Active__c, rC_Bios__Category__c, rC_Bios__Subcategory__c
					FROM rC_Bios__Preference__c 
					WHERE rC_Bios__Category__c = 'Classification'
						AND rC_Bios__Subcategory__c = 'SierraRise Exclusive'
						AND	rC_Bios__Contact__c IN :theContactsToProcess]);

		// Loop through the List of Contacts
		for (Contact thisContact : [SELECT Id, AccountId FROM Contact WHERE Id IN :theContactsToProcess]) {

			// Did we find the preference for this contact?
			Boolean preferenceFound = false; 


			// This feels very ineffecient, especially for large volumnes.
			//		Would rather have a searchable list, but the key is the ID of the preference
			//		versus the key of the contact.
			// WARNING:  No duplicate testing, which could/should also be done here.
			//
			// Step through all of the SR preferences we found
			for (rC_Bios__Preference__c thePreference : existingPreferences.values()) {

				// If the contact has an existing preference
				if(thePreference.rC_Bios__Contact__c == thisContact.Id ) {

					// record that we found the preference for this Contact
					preferenceFound = true;
					
					// DI - SierraRise spec states:
					//		If NotSierraRiseDonation checkbox on Account not checked and 
					//		membership active field on Account not checked, create 
					//		SIERRARISEEXCLUSIVE Preference, but do not activate a 
					//		pre-existing SIERRARISEEXLUSIVE Prefernece.  
					//
					// So if the preference exists, then just leave it alone. 
					//		Don't activate it or even check its status.
				}
			}
			
			// If no SR preference was found for this contact,
			if (!preferenceFound) {
				
				// Create a new preference for this contact.
				// Add the Preference to be inserted
				rC_Bios__Preference__c newPreference = new rC_Bios__Preference__c(
					//rC_Bios__Account__c = thisContact.AccountId,
					rC_Bios__Contact__c = thisContact.Id,
					RecordTypeId = GeneralPreferenceRecordType,
					rC_Bios__Category__c = 'Classification',			// 7/24/15: Populate by Value failed
					rC_Bios__Subcategory__c = 'SierraRise Exclusive', 	// 7/24/15: Populate by Value failed
					rC_Bios__Code_Value__c = 'SREXCLUSIVE',
					//rC_Bios__Value__c = 'SREXCLUSIVE',				// 8/18/15: Seeing if commenting this helps.
					rC_Bios__Active__c = true);
				
				// Save off the new Preference					
				newSierraRisePreferences.add(newPreference);
			}
		}

		// Insert the new Preferences
		if(newSierraRisePreferences.size() > 0) {
		    insert newSierraRisePreferences;
		}

	}

	// Given a list of Contacts:
	//		Looks up existing preferences and determines if an existing preference simply needs to be deactivated
	//		This trigger also will actively insert a
	// 
	//	NOTE: This method actively will create a deactivated SierraRise Exclusive preference when given
	// 		a Contact to deactivate.
	//		This is done so a disqualifying event ( e.g. Donation/Preference/etc ) is recorded so that a 
	//		future qualifying event would not allow the Contact to be activated.
	//
	public static void processSierraRiseExclusiveDelete(List<Id> theContactsToProcess) {
		
		// Holder of preferences to be inserted
		// Now we start building the new preferences
		//List<kweos__EOCS_Data__c> newPreferences = new List<kweos__EOCS_Data__c>(); 
		List<rC_Bios__Preference__c> newSierraRisePreferences = new List<rC_Bios__Preference__c>();

		// List of preferences taht need to be deactivated
		List<rC_Bios__Preference__c> updatedSierraRisePreferences = new List<rC_Bios__Preference__c>();


		// Build a Map of existing SierrRise preferences for these Contacts by
		// 	looking up all of the SR Exclusive Preferences for the Contacts passed-in.
		Map<Id, rC_Bios__Preference__c> existingPreferences = new Map<Id, rC_Bios__Preference__c>(
				[SELECT 	Id, 
							rC_Bios__Account__c, 
							rC_Bios__Contact__c, 
							rC_Bios__Active__c, 
							rC_Bios__Category__c, 
							rC_Bios__Subcategory__c
					FROM rC_Bios__Preference__c 
					WHERE rC_Bios__Category__c = 'Classification'
						AND rC_Bios__Subcategory__c = 'SierraRise Exclusive'
						AND	rC_Bios__Contact__c IN :theContactsToProcess]);

		// Loop through the List of Contacts
		for (Contact thisContact : [SELECT Id, AccountId FROM Contact WHERE Id IN :theContactsToProcess]) {

			// Did we find the preference for this contact?
			Boolean preferenceFound = false; 


			// This feels very ineffecient, especially for large volumnes.
			//		Would rather have a searchable list, but the key is the ID of the preference
			//		versus the key of the contact.
			// WARNING:  No duplicate testing, which could/should also be done here.
			//
			// Step through all of the SR preferences we found
			for (rC_Bios__Preference__c thePreference : existingPreferences.values()) {

				// If the contact has an existing preference
				if(thePreference.rC_Bios__Contact__c == thisContact.Id ) {

					// record that we found the preference for this Contact
					preferenceFound = true;
					
					// DI - SierraRise spec states:
					//		If NotSierraRiseDonation checkbox on Account not checked and 
					//		membership active field on Account not checked, create 
					//		SIERRARISEEXCLUSIVE Preference, but do not activate a 
					//		pre-existing SIERRARISEEXLUSIVE Prefernece.  
					//
					// So if the preference exists, then deactivate it 
					//
					if(thePreference.rC_Bios__Active__c) {
						
						// Update it to inactive, and add it to the list to be updated
						thePreference.rC_Bios__Active__c = false;
						updatedSierraRisePreferences.add(thePreference);
					}
				}
			}
			
			// If no SR preference was found for this contact,
			if (!preferenceFound) {
				
				// Create a new preference for this contact.
				// Add the Preference to be inserted
				rC_Bios__Preference__c newPreference = new rC_Bios__Preference__c(
					//rC_Bios__Account__c = thisContact.AccountId,
					rC_Bios__Contact__c = thisContact.Id,
					RecordTypeId = GeneralPreferenceRecordType,
					rC_Bios__Category__c = 'Classification',			// 7/24/15: Populate by Value failed
					rC_Bios__Subcategory__c = 'SierraRise Exclusive', 	// 7/24/15: Populate by Value failed
					rC_Bios__Code_Value__c = 'SREXCLUSIVE',
					//rC_Bios__Value__c = 'SREXCLUSIVE',				// 8/18/15: Seeing of commenting this out helps
					rC_Bios__Active__c = false);						// INACTIVE Preference
				
				// Save off the new Preference					
				newSierraRisePreferences.add(newPreference);
			}
		}

		// Insert the new inactive Preferences
		if(newSierraRisePreferences.size() > 0) {
		    insert newSierraRisePreferences;
		}

		// Update the new Preferences to be deactivated
		if(updatedSierraRisePreferences.size() > 0) {
		    update updatedSierraRisePreferences;
		}

	}

	
}