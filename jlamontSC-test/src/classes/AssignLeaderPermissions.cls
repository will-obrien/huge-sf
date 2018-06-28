/*
AssignLeaderPermissions

Created by: Mark Maslow
Created on: February, 2015

Assign permission sets to Leaders

December 2016 Maslow - Add check for staff preference

*/
public without sharing class AssignLeaderPermissions {
    //This set should contain the names of all permission sets that may be assigned to leaders
    Set<String> leaderPermissionNames = new Set<String>{'Club_Leader'};
    //This map will correlate leader permission names with their Ids
    Map<String, Id> allLeaderPermissions;
    
    public void assignPermissions(List<Id> leaderList) {
        //Create set of Contact Ids to use to find all leadership positions
        Set<Id> contactIds = new Set<Id>();
        for(Id ldrId : leaderList) {
            contactIds.add(ldrId);
        }
        //Find the Contacts that have users attached, and create map to correlate Contact Id with User Id 
        Map<Id, Id> contactToUserMap = new Map<Id, Id>();
        for(User usr : [select Id, ContactId from User where ContactId in :contactIds]) {
            contactToUserMap.put(usr.ContactId, usr.Id);
        }
        for(User_Lookups__c usr : [select User__c, Contact__c from User_Lookups__c where Contact__c in :contactIds]) {
        	contactToUserMap.put(usr.Contact__c, usr.User__c);
        }
        //Get all leader roles for leaders who have users attached      
        Map<Id, Set<Leadership__c>> leaderRoles = new Map<Id, Set<Leadership__c>>();
        List<Leadership__c> activeRoleList = new List<Leadership__c>([
            select Contact__c, Club_Entity__c, Leader_Position__c 
            from Leadership__c
            where 
                Position_Active__c = true
                and Club_Entity__r.Status__c = 'Active'
                and Contact__c in :contactToUserMap.keySet()
            order by Contact__c
        ]);
        if(activeRoleList.size() > 0) {
            Leadership__c lastRole = activeRoleList.get(0);
            Set<Leadership__c> roleSet = new Set<Leadership__c>();
            for(Leadership__c ldrRole : activeRoleList) {
                if(ldrRole.Contact__c != lastRole.Contact__c) {
                    leaderRoles.put(lastRole.Contact__c, roleSet);
                    lastRole = ldrRole;
                    roleSet = new Set<Leadership__c>();
                }
                roleSet.add(ldrRole);
            }
            leaderRoles.put(lastRole.Contact__c, roleSet);
        }
        //Correlate leader roles with User Id
        Map<Id, Set<Leadership__c>> userToLeaderRole = new Map<Id, Set<Leadership__c>>();
        for(Id contactId : leaderRoles.keySet()) {
            Set<Leadership__c> roleSet = leaderRoles.get(contactId);
            Id userId = contactToUserMap.get(contactId);
            userToLeaderRole.put(userId, roleSet);
        }
        //Retrieve current PermissionSetAssignments
        List<PermissionSetAssignment> permissionsList = new List<PermissionSetAssignment>([
            select Id, PermissionSetId, AssigneeId from PermissionSetAssignment
            where AssigneeId in :contactToUserMap.values()
            order by AssigneeId
        ]);
        //Correlate User Id with current set of PermissionSetAssignments
        Map<Id, Set<PermissionSetAssignment>> userToPermissionSet = new Map<Id, Set<PermissionSetAssignment>>();
        if(permissionsList.size() > 0) {
            Id lastAssigneeId = permissionsList.get(0).AssigneeId;
            Set<PermissionSetAssignment> assignments = new Set<PermissionSetAssignment>();
            for(PermissionSetAssignment psa : permissionsList) {
                if(psa.AssigneeId != lastAssigneeId) {
                    userToPermissionSet.put(lastAssigneeId, assignments);
                    lastAssigneeId = psa.AssigneeId;
                    assignments = new Set<PermissionSetAssignment>();
                }
                assignments.add(psa);
            }
            userToPermissionSet.put(lastAssigneeId, assignments);
        }
        
        List<PermissionSetAssignment> permissionsToAdd = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> permissionsToDelete = new List<PermissionSetAssignment>();
        for(Id userId : userToLeaderRole.keySet()) {
            Set<Id> permsToAdd = permissionsToAdd(userToLeaderRole.get(userId), userToPermissionSet.get(userId));
            for(Id permId : permsToAdd) {
                permissionsToAdd.add(new PermissionSetAssignment(PermissionSetId = permId, AssigneeId = userId));
            }
            Set<Id> permsToDelete = permissionsToDelete(userToLeaderRole.get(userId), userToPermissionSet.get(userId));
            for(Id permId : permsToDelete) {
                permissionsToDelete.add(new PermissionSetAssignment(PermissionSetId = permId, AssigneeId = userId));
            }
        }
        
        //Find users whose contact was sent, but who no longer have any active leadership positions.
        //These should have all leader permissions deleted
        List<Id> retiredLeaders = new List<Id>();
        for(Id contactId : ContactIds) {
            Id userId = contactToUserMap.get(contactId);
            if(userId != null) {
                Set<Leadership__c> roleSet = userToLeaderRole.get(userId);
                if(roleSet == null) {
                    retiredLeaders.add(userId);
                }
            }
        }
        List<PermissionSetAssignment> retiredLeaderPermissions = new List<PermissionSetAssignment>([
            select PermissionSetId, AssigneeId
            from PermissionSetAssignment
            where 
                AssigneeId in :retiredLeaders
                and PermissionSetId in :getAllLeaderPermissions().values()
        ]);
        for(PermissionSetAssignment psa : retiredLeaderPermissions) {
            permissionsToDelete.add(psa);
        }
        
        //Check if any users have Staff preference (preference with code value 'SCFDNSTAFF')
        //and need to be added to Club Staff permission set
        List<rC_Bios__Preference__c> prefList = [
        	select Id, rC_Bios__Contact__c
        	from rC_Bios__Preference__c
        	where 
        		rC_Bios__Code_Value__c = 'SCFDNSTAFF' 
        		and rC_Bios__Active__c = true
        		and rC_Bios__Contact__c in :ContactIds
        ];
        Set<Id> staffUsers = new Set<Id>();
        for(rC_Bios__Preference__c pref : prefList) {
        	Id userId = contactToUserMap.get(pref.rC_Bios__Contact__c);
        	if(userId != null) {
        		staffUsers.add(userId);
        	}
        }
		
		Id clubStaffPermissionId = [select Id from PermissionSet where Name = 'Club_Staff'].Id;
        List<PermissionSetAssignment> permList = [
        	select AssigneeId from PermissionSetAssignment
			where 
				PermissionSetId = :clubStaffPermissionId
				and AssigneeId in :staffUsers 
        ];
        Set<Id> hasPermission = new Set<Id>();
        for(PermissionSetAssignment psa : permList) {
        	hasPermission.add(psa.AssigneeId);
        }
        for(Id staffId : staffUsers) {
        	if( ! hasPermission.contains(staffId) ) {
        		permissionsToAdd.add(
        			new PermissionSetAssignment(
        				PermissionSetId = clubStaffPermissionId,
        				AssigneeId = staffId
        			)
        		);
        	}
        }
        
        List<String> permsToAdd = new List<String>();
        List<String> permsToDelete = new List<String>();

        //Now adjust permissions
        //Must avoid MIXED_DML_OPERATION exception
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
        else {
        	if(permissionsToAdd.size() + permissionsToDelete.size() > 0) {
	            for(PermissionSetAssignment psa : permissionsToAdd) {
	                permsToAdd.add(JSON.Serialize(psa));
	            }
	            for(PermissionSetAssignment psa : permissionsToDelete) {
	                permsToDelete.add(JSON.Serialize(psa));
	            }
	            adjustPermissions(permsToAdd, permsToDelete);
        	}
        }
    }
    @future
    public static void adjustPermissions(List<String> permissionsToAdd, List<String> permissionsToDelete) {
        List<PermissionSetAssignment> permissionList = new List<PermissionSetAssignment>();
        if(permissionsToAdd != null) {
        	if( ! permissionsToAdd.isEmpty() ) {
		        for(String perm : permissionsToAdd) {
		            permissionList.add((PermissionSetAssignment)JSON.deserialize(perm, PermissionSetAssignment.class));
		        }
		        insert permissionList;
        	}
        }
        permissionList.clear();
        if(permissionsToDelete != null) {
        	if( ! permissionsToDelete.isEmpty() ) {
		        for(String perm : permissionsToDelete) {
		            permissionList.add((PermissionSetAssignment)JSON.deserialize(perm, PermissionSetAssignment.class));
		        }
		        delete permissionList;
        	}
        }
    }
    private Map<String, Id> getAllLeaderPermissions() {
        if(allLeaderPermissions == null) {
            List<PermissionSet> permList = new List<PermissionSet>([
                select Id, Name from PermissionSet
                where Name in :leaderPermissionNames
            ]); 
            allLeaderPermissions = new Map<String, Id>();
            for(PermissionSet perms : permList) {
                allLeaderPermissions.put(perms.Name, perms.Id);
            }
        }
        return allLeaderPermissions;
    }
    private Set<Id> permissionsToAdd(Set<Leadership__c> currentRoles, Set<PermissionSetAssignment> currentPermissions) {
        Set<Id> permsToAdd = new Set<Id>();
        if(currentRoles.size() > 0) {
            boolean eventsFound = false;
            Id eventsPermissionId = getAllLeaderPermissions().get('Club_Leader');
            for(PermissionSetAssignment psa : currentPermissions) {
                if(psa.PermissionSetId == eventsPermissionId) {
                    eventsFound = true;
                }
            }
            if( ! eventsFound ) {
                permsToAdd.add(eventsPermissionId);
            }
        }
        return permsToAdd;
    }
    private Set<Id> permissionsToDelete(Set<Leadership__c> currentRoles, Set<PermissionSetAssignment> currentPermissions) {
        Set<Id> permsToDelete = new Set<Id>();
        if(currentRoles == null || currentRoles.size() == 0) {
            boolean eventsFound = false;
            Id eventsPermissionId = getAllLeaderPermissions().get('Club_Leader');
            for(PermissionSetAssignment psa : currentPermissions) {
                if(psa.PermissionSetId == eventsPermissionId) {
                    eventsFound = true;
                }
            }
            if( eventsFound ) {
                permsToDelete.add(eventsPermissionId);
            }
        }
        return permsToDelete;
    }
}