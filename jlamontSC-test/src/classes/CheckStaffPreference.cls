/*
CheckStaffPreference

Created by: Mark Maslow
Created on: December, 2016

Called by PreferenceTrigger

When a preference with code value 'SCFDNSTAFF' is activated, the associated Contact 
will be added to permission set 'Club Staff'

When a preference with code value 'SCFDNSTAFF' is deactivated, the associated Contact 
will be removed from permission set 'Club Staff'

*/
public with sharing class CheckStaffPreference {
	private static Id clubStaffPermission = [select Id from PermissionSet where Name = 'Club_Staff'].Id;
	
	public static void afterInsert(List<rC_Bios__Preference__c> newList) {
		Set<Id> contactSet = new Set<Id>();
		List<rC_Bios__Preference__c> prefsToProcess = new List<rC_Bios__Preference__c>();
		for(rC_Bios__Preference__c pref : newList) {
			if(pref.rC_Bios__Code_Value__c == 'SCFDNSTAFF' && pref.rC_Bios__Active__c == true) {
				contactSet.add(pref.rC_Bios__Contact__c);
				prefsToProcess.add(pref);
			}
		}
		if( ! prefsToProcess.isEmpty()) {
			
	        Map<Id, Id> contactToUserMap = new Map<Id, Id>();
	        Map<Id, Id> userToContactMap = new Map<Id, Id>();

	        for(User usr : [select Id, ContactId from User where ContactId in :contactSet]) {
	            contactToUserMap.put(usr.ContactId, usr.Id);
	        	userToContactMap.put(usr.Id, usr.ContactId);
	        }
	        for(User_Lookups__c usr : [select User__c, Contact__c from User_Lookups__c where Contact__c in :contactSet]) {
	        	contactToUserMap.put(usr.Contact__c, usr.User__c);
	        	userToContactMap.put(usr.User__c, usr.Contact__c);
	        }
	        if(contactToUserMap.isEmpty()) {
	        	return;
	        }
			List<PermissionSetAssignment> permList = [
				select assigneeId from PermissionSetAssignment
				where 
					PermissionSetId = :clubStaffPermission
					and AssigneeId in :contactToUserMap.values()  
			];
			Set<Id> contactsWithPerm = new Set<Id>();
			for(PermissionSetAssignment assignee : permList) {
				contactsWithPerm.add(userToContactMap.get(assignee.AssigneeId));
			}
			List<PermissionSetAssignment> permissionsToAdd = new List<PermissionSetAssignment>();
			for(rC_Bios__Preference__c pref : prefsToProcess) {
				if( ! contactsWithPerm.contains(pref.rC_Bios__Contact__c)) {
					Id usrId = contactToUserMap.get(pref.rC_Bios__Contact__c);
					if(usrId != null) {
						permissionsToAdd.add(new PermissionSetAssignment(
							AssigneeId = usrId,
							PermissionSetId = clubStaffPermission
						));
					}
				}
			}
			if( ! permissionsToAdd.isEmpty()) {
				//insert permissionsToAdd;
		        List<String> permsToAdd = new List<String>();
	            for(PermissionSetAssignment psa : permissionsToAdd) {
	                permsToAdd.add(JSON.Serialize(psa));
	            }
		        if(Test.isRunningTest()) {
		            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		            System.runAs ( thisUser ) {
		                if(permissionsToAdd.size() > 0) {
		                    insert permissionsToAdd;
		                }
		            }
		        }
		        else {
	            	AssignLeaderPermissions.adjustPermissions(permsToAdd, null);
		        }
			}	
		}
	}
	public static void afterUpdate(List<rC_Bios__Preference__c> newList, Map<Id, rC_Bios__Preference__c> oldMap) {
		List<Id> contactsToAdd = new List<Id>();
		List<Id> contactsToRemove = new List<Id>();
		for(rC_Bios__Preference__c pref : newList) {
			if(pref.rC_Bios__Code_Value__c == 'SCFDNSTAFF') { 
				if(pref.rC_Bios__Active__c == false) {
					rC_Bios__Preference__c oldValue = oldMap.get(pref.Id);
					if(oldValue.rC_Bios__Active__c == true) {
						contactsToRemove.add(pref.rC_Bios__Contact__c);
					}
				}
				else if(pref.rC_Bios__Active__c == true) {
					rC_Bios__Preference__c oldValue = oldMap.get(pref.Id);
					if(oldValue.rC_Bios__Active__c == false) {
						contactsToAdd.add(pref.rC_Bios__Contact__c);
					}
				}
			}
		}
		Set<Id> contactSet = new Set<Id>();
		contactSet.addAll(contactsToAdd);
		contactSet.addAll(contactsToRemove);
		
		if(contactSet.isEmpty()) {
			return;
		}
		
        Map<Id, Id> contactToUserMap = new Map<Id, Id>();
 
        for(User usr : [select Id, ContactId from User where ContactId in :contactSet]) {
            contactToUserMap.put(usr.ContactId, usr.Id);
        }
        for(User_Lookups__c usr : [select User__c, Contact__c from User_Lookups__c where Contact__c in :contactSet]) {
        	contactToUserMap.put(usr.Contact__c, usr.User__c);
        }
		
		Set<Id> usersToRemove = new Set<Id>();
		for(Id contactId : contactsToRemove) {
			usersToRemove.add(contactToUserMap.get(contactId));
		}

	    List<String> permsToAdd = new List<String>();
	    List<String> permsToDelete = new List<String>();

		List<PermissionSetAssignment> permissionsToAdd = new List<PermissionSetAssignment>();
		List<PermissionSetAssignment> permissionsToDelete = new List<PermissionSetAssignment>();

		if( ! contactsToRemove.isEmpty()) {
			permissionsToDelete = [
				select Id from PermissionSetAssignment 
				where 
					PermissionSetId = :clubStaffPermission
					and AssigneeId in :usersToRemove
			];
			//delete permissionsToDelete;
            for(PermissionSetAssignment psa : permissionsToDelete) {
                permsToDelete.add(JSON.Serialize(psa));
            }
		}
		if( ! contactsToAdd.isEmpty()) {
			for(Id contactId : contactsToAdd) {
				permissionsToAdd.add(new PermissionSetAssignment(
					AssigneeId = contactToUserMap.get(contactId),
					PermissionSetId = clubStaffPermission
				));
			}
			//insert permissionsToAdd;
            for(PermissionSetAssignment psa : permissionsToAdd) {
                permsToAdd.add(JSON.Serialize(psa));
            }
		}
        if(Test.isRunningTest()) {
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
                if(permissionsToAdd.size() > 0) {
                    insert permissionsToAdd;
                }
                if(permissionsToDelete.size() > 0) {
                    delete permissionsToDelete;
                }
            }
        }
       	else if(permsToAdd.size() + permsToDelete.size() > 0) {
       		AssignLeaderPermissions.adjustPermissions(permsToAdd, permsToDelete);
       	}
	}
}