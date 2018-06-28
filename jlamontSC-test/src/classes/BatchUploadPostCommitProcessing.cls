/*********************************************************************************************************
(c) 2015 Sierra Club
Name			: BatchUploadPostCommitProcessing
Created by		: Mark Maslow
Created Date	: December, 2015
Description		: Handler Class for BatchUploadTrigger
				:  This class looks for committed batch upload records that have a Contact Id
				:		meaning either the Contact was created or simply found using the matching rules.
				:		If a Batch Upload has a Group Campaign Id
				:			the Contact is added as a Campaign Member
				:		If a Batch Upload has an Event Registration Id
				:			the Event Registration has its Contact field populated
				:		If a Batch Upload has a Survey Form Response Id
				:			the Survey Response has its Contact field populated
Update			: 2015/12/00 - MM
				: 2015/08/05 - VB - Added comments & code to match the survey response to the Contact
				: 2016/05/20 - TL - Added code to create preferences for inserted contacts
				: 2016/10/14 - TL - Added code to create interests
***********************************************************************************************************/
public with sharing class BatchUploadPostCommitProcessing {
	
	public static Boolean processingComplete = false;
	 
	public static void afterBUUpdate(List<rC_Connect__Batch_Upload__c> newbu) {
		
		if( ! processingComplete) {
			
			List<rC_Connect__Batch_Upload__c> buForProcessing = new List<rC_Connect__Batch_Upload__c> ();
			
			// Step through the trigger
			for(rC_Connect__Batch_Upload__c bu : newbu) {
				if(bu.rC_Connect__Batch_Upload_Status__c == 'Committed') {
					
					// If there is a populated Event Registration, Survey Response, Group Campaign, or New Contact Pref Code
					if( bu.Event_Registration_Id__c != null || 
						bu.Group_Campaign_Id__c     != null ||
						bu.Survey_Response_Id__c    != null ||
                        bu.Preference_Code_New_Contact__c != null ||
                      	(bu.Interest_Type__c != null && bu.Interest_Description__c != null) )
                       {
						
						// If the Batch Upload has been connected to a Contact
						if(bu.rC_Connect__Batch_Upload_Contact_1_Matched__c != null) {
							
							// Save off the Batch Upload for processing
							buForProcessing.add(bu);
						}
					}
				}
			}
			
			// If there are BU's that need to be processed
			if( ! buForProcessing.isEmpty()) {
				
				processingComplete = true;
				
				List<Event_Registration__c> regList = new List<Event_Registration__c>();
				List<Survey_Response__c> surveyList = new List<Survey_Response__c>();
				List<CampaignMember>    campMbrList = new List<CampaignMember>();
                List<rC_Bios__Preference__c> prefList = new List<rC_Bios__Preference__c>();
                List<Interest__c> intList = new List<Interest__c>();

				// Step through the Batch Uploads to be processed				
				for(rC_Connect__Batch_Upload__c bu2 : buForProcessing) {
					
					// If the BU has an Event Registration
					if(bu2.Event_Registration_Id__c != null) {
						Event_Registration__c reg = new Event_Registration__c(
							Id = bu2.Event_Registration_Id__c,
							Contact__c = bu2.rC_Connect__Batch_Upload_Contact_1_Matched__c
						);
						regList.add(reg);
					}
					
					// If the BU has a Survey Response
					if(bu2.Survey_Response_Id__c != null) {
						Survey_Response__c survey = new Survey_Response__c(
							Id = bu2.Survey_Response_Id__c,
							Contact__c = bu2.rC_Connect__Batch_Upload_Contact_1_Matched__c
						);
						surveyList.add(survey);
					}
					
					// If the BU has a Group Campaign
					if(bu2.Group_Campaign_Id__c != null) {
						CampaignMember campMbr = new CampaignMember(
							ContactId = bu2.rC_Connect__Batch_Upload_Contact_1_Matched__c,
							CampaignId = bu2.Group_Campaign_Id__c
						);
						campMbrList.add(campMbr);
					}
                    
                    //If the BU has a New Contact Pref Code and Contact status is Inserted
                    if(bu2.Preference_Code_New_Contact__c != null && bu2.rC_Connect__Contact1_Status__c == 'Inserted') {
                        rC_Bios__Preference__c pref = new rC_Bios__Preference__c(
                        	rC_Bios__Contact__c = bu2.rC_Connect__Batch_Upload_Contact_1_Matched__c,
                        	rC_Bios__Code_Value__c = bu2.Preference_Code_New_Contact__c,
                            rC_Bios__Active__c = true
                        );
                        prefList.add(pref);
                    }
                    
                    // If the BU has an Interest
					if(bu2.Interest_Description__c != null) {
						Interest__c interest = new Interest__c(
							Contact__c = bu2.rC_Connect__Batch_Upload_Contact_1_Matched__c,
							Interest_Type__c = bu2.Interest_Type__c,
                            Interest_Description__c = bu2.Interest_Description__c
						);
						intList.add(interest);
					}
                    
				}
				if( ! regList.isEmpty()) {
					update regList;
				}
				if( ! surveyList.isEmpty()) {
					update surveyList;
				}
				if( ! campMbrList.isEmpty()) {
					database.insert(campMbrList, false);
				}
                if(!prefList.isEmpty()) {
                    insert prefList;
                }
                if(!intList.isEmpty()) {
                    insert intList;
                }
			}
		}
	}
}