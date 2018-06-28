/*********************************************************************************************************
Name              : CampaignMemberTriggerHandler
Created By        : Tami Lau & Justin LaMont
Created Date      : April 2017
Description       : Implements phonebank functionality for Campaign Members
Last Updated      : 
*********************************************************************************************************/

public class CampaignMemberTriggerHandler {
    
    public static void phonebankProcessing(Map<Id,CampaignMember> oldCmpMbrs, List<CampaignMember> updatedCmpMbrs) {
        
        List<CampaignMember> cmpMbrsToProcess = new List<CampaignMember>();
        
        Set<String> activityInterests = new Set<String>();
        for (Activity_Interests__c ai : Activity_Interests__c.getAll().values()) {
        	activityInterests.add(ai.Name);
        }
            
        for (CampaignMember cm : updatedCmpMbrs) {
            if (cm.Status == 'Contacted' && oldCmpMbrs.get(cm.Id).Status != 'Contacted') {
                cmpMbrsToProcess.add(cm);                
            }
        }
        
        if (cmpMbrsToProcess.size() > 0) {
            
            List<CampaignMember> cmpMbrsToProcess2 = new List<CampaignMember>([SELECT Id, ContactId, Contact.AccountId, CampaignId, rC_Event__Phone__c, Event_RSVP__c, No_Phone__c, Bad_Phone__c, Update_Phone__c, Contact.Phone, Custom_Field_1_Response__c, Custom_Field_2_Response__c, Custom_Field_3_Response__c, Custom_Field_4_Response__c, Custom_Field_5_Response__c, Interest_One__c, Interest_Two__c, Interest_Three__c, Campaign.Interest_One__c, Campaign.Interest_Two__c, Campaign.Interest_Three__c FROM CampaignMember WHERE Id IN :cmpMbrsToProcess]);
            List<Event_Registration__c> eventRegToInsert = new List<Event_Registration__c>();
            List<Contact> contactsToUpdate = new List<Contact>();
            List<Interest__c> interestsToInsert = new List<Interest__c>();
            List<rC_Bios__Preference__c> preferencesToInsert = new List<rC_Bios__Preference__c>();
            
            for (CampaignMember cm : cmpMbrsToProcess2) {
                if (cm.Event_RSVP__c == 'Yes') {
                    Event_Registration__c eventReg = new Event_Registration__c(
                    	Contact__c = cm.ContactId,
                    	Campaign__c = cm.CampaignId,
						Custom_Field_1_Response__c = cm.Custom_Field_1_Response__c,
                        Custom_Field_2_Response__c = cm.Custom_Field_2_Response__c,
                        Custom_Field_3_Response__c = cm.Custom_Field_3_Response__c,
                        Custom_Field_4_Response__c = cm.Custom_Field_4_Response__c,
                        Custom_Field_5_Response__c = cm.Custom_Field_5_Response__c,
                    	Status__c = 'Registered',
                    	Source__c = 'Phonebank Response');
                    eventRegToInsert.add(eventReg);                    
                }
                
                if (cm.No_Phone__c == true) {
                    rC_Bios__Preference__c pref = new rC_Bios__Preference__c (
                    	rC_Bios__Account__c = cm.Contact.AccountId,
                    	rC_Bios__Code_Value__c = 'NOPHONE');
						System.debug('Account ID ' + cm.Contact.AccountId);
                    preferencesToInsert.add(pref);
                }
                
                if (cm.Bad_Phone__c == true) {
                    if (cm.rC_Event__Phone__c == cm.Contact.Phone) {
                        Contact ct = new Contact (
                        	Id = cm.ContactId,
                            HomePhone = null,
                        	rC_Bios__Preferred_Phone__c = 'Home');
                        contactsToUpdate.add(ct);
                    }
                }
                
                if (cm.Update_Phone__c == true) {
                    if (cm.rC_Event__Phone__c != cm.Contact.Phone && cm.rC_Event__Phone__c != null) {
                        Contact ct = new Contact (
                        	Id = cm.ContactId,
                            HomePhone = cm.rC_Event__Phone__c,
                        	rC_Bios__Preferred_Phone__c = 'Home');
                        contactsToUpdate.add(ct);
                    }                                        
                }
                
                if (cm.Interest_One__c != false) {
                	if (activityInterests.contains(cm.Campaign.Interest_One__c)) {
                		Interest__c interestOne = new Interest__c (
                			Contact__c = cm.ContactId,
                			Interest_Description__c = cm.Campaign.Interest_One__c,
                			Interest_Type__c = 'Activity');
                			interestsToInsert.add(interestOne);
                	} else {
                		Interest__c interestOne = new Interest__c (
                			Contact__c = cm.ContactId,
                			Interest_Description__c = cm.Campaign.Interest_One__c,
                			Interest_Type__c = 'Issue');
                		
                		interestsToInsert.add(interestOne);
                	}
                }
                
                 if (cm.Interest_Two__c != false) {
                	if (activityInterests.contains(cm.Campaign.Interest_Two__c)) {
                		Interest__c interestTwo = new Interest__c (
                			Contact__c = cm.ContactId,
                			Interest_Description__c = cm.Campaign.Interest_Two__c,
                			Interest_Type__c = 'Activity');
                			interestsToInsert.add(interestTwo);
                	} else {
                		Interest__c interestTwo = new Interest__c (
                			Contact__c = cm.ContactId,
                			Interest_Description__c = cm.Campaign.Interest_Two__c,
                			Interest_Type__c = 'Issue');
                			
                		interestsToInsert.add(interestTwo);
                	}
                }
                
                 if (cm.Interest_Three__c != false) {
                	
                	if (activityInterests.contains(cm.Campaign.Interest_Three__c)) {
                		Interest__c interestThree = new Interest__c (
                			Contact__c = cm.ContactId,
                			Interest_Description__c = cm.Campaign.Interest_Three__c,
                			Interest_Type__c = 'Activity');
                			interestsToInsert.add(interestThree);
                	} else {
                		Interest__c interestThree = new Interest__c (
                			Contact__c = cm.ContactId,
                			Interest_Description__c = cm.Campaign.Interest_Three__c,
                			Interest_Type__c = 'Issue');
                		
                		interestsToInsert.add(interestThree);
                	}
                }
                
            }
            
			if (eventRegToInsert.size() > 0) {
            	insert eventRegToInsert;
            }
            
			if (preferencesToInsert.size() > 0) {
            	insert preferencesToInsert;
            } 
            if (interestsToInsert.size() > 0) {
            	insert interestsToInsert;
            }
            
			if (contactsToUpdate.size() > 0) {
            	update contactsToUpdate;
            }

        }
        
    }

}