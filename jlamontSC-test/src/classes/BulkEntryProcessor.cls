public without sharing class BulkEntryProcessor {
	private BulkEntryController ctl;
    private static Id offlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
	private Map<Integer, Id> rowToActionMap = new Map<Integer, Id>();
	private Map<Integer, Id> rowToEventRegMap = new Map<Integer, Id>();
	private Id defaultCampaignId;

	public BulkEntryProcessor(BulkEntryController controller) {
		this.ctl = controller;
	}
	public void processRows() {
		List<Interest__c> interestList = new List<Interest__c>();
		List<sObject> objsToInsert = new List<sObject>();
		List<Event_Registration__c> eventRegsToUpdate = new List<Event_Registration__c>();
		List<Contact> contactsToUpdate = new List<Contact>();
		
		Map<Id, Event_Registration__c> contactIdToEventRegMap = new Map<Id, Event_Registration__c>();
		if(ctl.selectedEvent != null) {
			Set<String> idSet = new Set<String>();
			for(BulkEntryController.EntryRow row : ctl.getRowsMatched()) {
				idSet.add(row.Id);
			}
			List<Event_Registration__c> regList = [
				select Id, Contact__c, Status__c
				from Event_Registration__c
				where Campaign__c = :ctl.selectedEvent.Id and Contact__c in :idSet
			];
			if(! regList.isEmpty()) {
				for(Event_Registration__c reg: regList) {
					contactIdToEventRegMap.put(reg.Contact__c, reg);
				}
			}
		}
        
		Set<Id> contactsInList = new Set<Id>();        
		if (ctl.selectedListCampaign != null) {
			List<CampaignMember> campaignMembers = new List<CampaignMember>([SELECT ContactId FROM CampaignMember WHERE CampaignId = :ctl.selectedListCampaign.Id]);
			for (CampaignMember cm : campaignMembers) {
				contactsInList.add(cm.ContactId);
            }
        }        
		
		List<rC_Connect__Batch_Upload__c> uploadList = new List<rC_Connect__Batch_Upload__c>();

		for(BulkEntryController.EntryRow row : ctl.getRowsMatched()) {
			if(row.remove) {
				continue;
			}
			if(ctl.selectedInterest != null) {
				objsToInsert.add(new Interest__c(
					Contact__c = row.id,
					Interest_Type__c = ctl.selectedInterest.Interest_Type__c,
					Interest_Description__c = ctl.selectedInterest.Interest_Description__c
				));
			}
			if(ctl.selectedAction != null) {
                kweos__EOCS_Data__c a = new kweos__EOCS_Data__c(
                    kwac__Contact__c = row.id,
                    kweos__First_Name__c = row.firstName,
                    kweos__Last_Name__c = row.LastName,
                    kweos__Email__c = row.email,
                    kweos__Phone__c = row.phone,
                    kweos__Address1__c = row.street,
                    kweos__City__c = row.city,
                    kweos__State__c = row.state,
					Action__c = ctl.selectedAction.Action__c,
					Action_Status__c = ctl.selectedAction.Action_Status__c,
					Action_Date__c = ctl.selectedAction.Action_Date__c,
					kwac__Related_Action__c = ctl.selectedAction.kwac__Related_Action__c,
                	RecordTypeId = offlineActionTypeId);
                if(ctl.selectedCampaign != null) {
                    a.kwac__Source_Campaign__c = ctl.selectedCampaign.Id;
                }
				objsToInsert.add(a);
			}
			if(ctl.selectedEvent != null) {
				Event_Registration__c eventReg = contactIdToEventRegMap.get(row.id);
				if(eventReg == null) {
                    Event_Registration__c e = new Event_Registration__c(
						First_Name__c = row.firstName,
						Last_Name__c = row.lastName,
						Email__c = row.email,
						Phone__c = row.phone,
						Street__c = row.street,
						City__c = row.city,
						State__c = row.state,
						PostalCode__c = row.postalCode,
						Contact__c = row.id,
						Status__c = ctl.selectedEventRegistrationStatus,
						Club_Event__c = ctl.selectedEvent.Club_Event__c,
						Campaign__c = ctl.selectedEvent.Id,
						Source__c = 'Bulk Entry');
					if(ctl.selectedCampaign != null) {
                    	e.Source_Campaign__c = ctl.selectedCampaign.Id;
                	} 
					objsToInsert.add(e);                        
				}
				else if(ctl.selectedEventRegistrationStatus != 'Registered') {
					eventRegsToUpdate.add(new Event_Registration__c(
						Id = eventReg.Id,
						Status__c = ctl.selectedEventRegistrationStatus							
					));
				}
			}
			if(ctl.selectedPreference != null) {
				objsToInsert.add(new rC_Bios__Preference__c(
					rC_Bios__Contact__c = row.id,
					rC_Bios__Account__c = row.matchedContact.AccountId,
					rC_Bios__Category__c = ctl.selectedPreference.rC_Bios__Category__c,
					rC_Bios__Subcategory__c = ctl.selectedPreference.rC_Bios__Subcategory__c
				));
			}
            
            if (ctl.selectedListCampaign != null) {
                if (!contactsInList.contains(row.id)) {
                    objsToInsert.add(new CampaignMember(
					ContactId = row.id,
					CampaignId = ctl.selectedListCampaign.Id
				));
                }
            }
            
			Contact ctct = new Contact(Id = row.id);
			Boolean updateContact = false;
			if(row.updateEmail) {
				if(! String.isEmpty(row.email)) {
					ctct.rC_Bios__Home_Email__c = row.email;
					ctct.rC_Bios__Preferred_Email__c = 'Home';
					updateContact = true;
				}
			}
			if(row.updatePhone) {
				ctct.HomePhone = row.phone;
				ctct.rC_Bios__Preferred_Phone__c = 'Home';
				updateContact = true;
			}
			if(updateContact) {
				contactsToUpdate.add(ctct);
			}
			if(row.updateAddress) {
				rC_Connect__Batch_Upload__c upload = new rC_Connect__Batch_Upload__c(
					rC_Connect__Batch_Upload_Contact_1_Matched__c = row.id,
					rC_Connect__Contact_1_First_Name__c = row.firstName,
					rC_Connect__Contact_1_Last_Name__c = row.lastName,
					rC_Connect__Address_Street_Line_1__c = row.street,
					rC_Connect__Address_City__c = row.city,
					rC_Connect__Address_State__c = row.state,
					rC_Connect__Address_Postal_Code__c = row.postalCode
				);
				uploadList.add(upload);			
			}
		}
		if(! objsToInsert.isEmpty()) {
			objsToInsert.sort();
			insert objsToInsert;
		}
		if(! contactsToUpdate.isEmpty()) {
			update contactsToUpdate;
		}
		if(! eventRegsToUpdate.isEmpty()) {
			update eventRegsToUpdate;
		} 
		
		if(! ctl.rowsNotMatched.isEmpty()) {
			if(ctl.selectedEvent != null || ctl.selectedAction != null) {
				createEventRegsAndActions();
			}
		}
		
		for(BulkEntryController.EntryRow row : ctl.getRowsNotMatched()) {
			if(row.remove) {
				continue;
			}
			rC_Connect__Batch_Upload__c upload = new rC_Connect__Batch_Upload__c(
				rC_Connect__Contact_1_First_Name__c = row.firstName,
				rC_Connect__Contact_1_Last_Name__c = row.lastName,
				rC_Connect__Address_Street_Line_1__c = row.street,
				rC_Connect__Address_City__c = row.city,
				rC_Connect__Address_State__c = row.state,
				rC_Connect__Address_Postal_Code__c = row.postalCode,
				rC_Connect__Contact_1_Email__c = row.email,
				rC_Connect__Contact_1_Phone_1__c = row.phone
			);			
			Id eventRegId = rowToEventRegMap.get(row.rowNumber);
			if(eventRegId != null) {
				upload.Event_Registration_Id__c = eventRegId;
			}
			Id actionId = rowToActionMap.get(row.rowNumber);
			if(actionId != null) {
				upload.kwrcac__KW_Advocacy_Id__c = actionId;
			}
			if(ctl.selectedInterest != null) {
				upload.Interest_Type__c = ctl.selectedInterest.Interest_Type__c;
				upload.Interest_Description__c = ctl.selectedInterest.Interest_Description__c;
			}
			if(ctl.selectedPreference != null) {
				upload.rC_Connect__Preferences_1_Category__c = ctl.selectedPreference.rC_Bios__Category__c;
				upload.rC_Connect__Preferences_1_Subcategory__c = ctl.selectedPreference.rC_Bios__Subcategory__c;
			}
            if(ctl.selectedListCampaign != null) {
                upload.Group_Campaign_Id__c = ctl.selectedListCampaign.Id;
            }            
			if(ctl.selectedCampaign != null) {
				upload.rC_Connect__Batch_Upload_Campaign_Matched__c = ctl.selectedCampaign.Id;
			}
			else if(ctl.selectedEvent != null) {
				upload.rC_Connect__Batch_Upload_Campaign_Matched__c = ctl.selectedEvent.Id;
			}
			else if(ctl.selectedActionCampaign != null) {
				upload.rC_Connect__Batch_Upload_Campaign_Matched__c = ctl.selectedActionCampaign.Id;
			}
			else {
				upload.rC_Connect__Batch_Upload_Campaign_Matched__c = getDefaultCampaignId();
			}
			uploadList.add(upload);
		}
		if(!uploadList.isEmpty()) {
			insert uploadList;
		}
	}
	private String getDefaultCampaignId() {
		if(defaultCampaignId == null) {
            Id profileId = userinfo.getProfileId();
            Original_Campaign__c oc = Original_Campaign__c.getinstance(profileId);
            String campName = oc.Campaign_Name__c;
			defaultCampaignId = [select Id from Campaign where Name = :campName].Id;
		}
		return defaultCampaignId;
	}
	private void createEventRegsAndActions() {
		List<Integer> eventRegRows = new List<Integer>();
		List<Integer> actionRows = new list<Integer>();
		List<Event_Registration__c> eventRegsToInsert = new List<Event_Registration__c>();
		List<kweos__EOCS_Data__c> actionsToInsert = new List<kweos__EOCS_Data__c>();
		for(BulkEntryController.EntryRow row : ctl.getRowsNotMatched()) {
			if(ctl.selectedEvent != null) {
				eventRegRows.add(row.rowNumber);
                Event_Registration__c e = new Event_Registration__c(
					First_Name__c = row.firstName,
					Last_Name__c = row.lastName,
					Email__c = row.email,
					Phone__c = row.phone,
					Street__c = row.street,
					City__c = row.city,
					State__c = row.state,
					PostalCode__c = row.postalCode,
					Status__c = ctl.selectedEventRegistrationStatus,
					Club_Event__c = ctl.selectedEvent.Club_Event__c,
					Campaign__c = ctl.selectedEvent.Id,
					Source__c = 'Bulk Entry');	
                if(ctl.selectedCampaign != null) {
                    e.Source_Campaign__c = ctl.selectedCampaign.Id;
                } 
                eventRegsToInsert.add(e);
			}	
			if(ctl.selectedAction != null) {
				actionRows.add(row.rowNumber);
                kweos__EOCS_Data__c a = new kweos__EOCS_Data__c(
                    kweos__First_Name__c = row.firstName,
                    kweos__Last_Name__c = row.LastName,
                    kweos__Email__c = row.email,
                    kweos__Phone__c = row.phone,
                    kweos__Address1__c = row.street,
                    kweos__City__c = row.city,
                    kweos__State__c = row.state,
                	Action__c = ctl.selectedAction.Action__c,
					Action_Status__c = ctl.selectedAction.Action_Status__c,
					Action_Date__c = ctl.selectedAction.Action_Date__c,
					kwac__Related_Action__c = ctl.selectedAction.kwac__Related_Action__c,
					RecordTypeId = offlineActionTypeId);
                if(ctl.selectedCampaign != null) {
                    a.kwac__Source_Campaign__c = ctl.selectedCampaign.Id;
                }                  
                actionsToInsert.add(a);
			}	
		}
		if(! eventRegsToInsert.isEmpty()) {
			Database.SaveResult[] eventResults = Database.insert(eventRegsToInsert);
			Integer idx = 0;
			for(Database.SaveResult eventSr : eventResults) {
				if(eventSr.isSuccess()) {
					rowToEventRegMap.put(eventRegRows.get(idx), eventSr.getId());
				}
				idx ++;
			}
		}
		if(! actionsToInsert.isEmpty()) {
			Database.SaveResult[] actionResults = Database.insert(actionsToInsert);
			Integer idx = 0;
			for(Database.SaveResult actionSr : actionResults) {
				if(actionSr.isSuccess()) {
					rowToActionMap.put(actionRows.get(idx), actionSr.getId());
				}
				idx ++;
			}
		}
	}
}