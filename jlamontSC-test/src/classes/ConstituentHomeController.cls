/*
ConstituentHomeController

Created by: Mark Maslow

December 2016 Maslow - Add check for staff permission

*/
public without sharing class ConstituentHomeController {
    //This set should contain the names of all permission sets that may be assigned to leaders
    Set<String> leaderPermissionNames = new Set<String>{'Club_Leader','Board_of_Directors','Club_Staff'};
    //This map will correlate leader permission names with their Ids
    Map<Id, String> allLeaderPermissions;
    Set<String> permissionsForUser;

    private Map<Id, String> getAllLeaderPermissions() {
        if(allLeaderPermissions == null) {
            List<PermissionSet> permList = new List<PermissionSet>([
                select Id, Name from PermissionSet
                where Name in :leaderPermissionNames
            ]); 
            allLeaderPermissions = new Map<Id, String>();
            for(PermissionSet perms : permList) {
                allLeaderPermissions.put(perms.Id, perms.Name);
            }
        }
        System.debug('allLeaderPermissions:' + allLeaderPermissions);
        return allLeaderPermissions;
    }
	private Set<String> getPermissionsForUser() {
		if(permissionsForUser == null) {
			permissionsForUser = new Set<String>();
			List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>([
				select PermissionSetId
				from PermissionSetAssignment
				where 
					AssigneeId = :UserInfo.getUserId()
					and PermissionSetId in :getAllLeaderPermissions().keySet()
			]);
			for(PermissionSetAssignment psa : psaList) {
				String permName = allLeaderPermissions.get(psa.PermissionSetId);
				if(permName != null) {
					permissionsForUser.add(permName);
				}
			}
		}
		System.debug('permissionsForUser:' + permissionsForUser);
		return permissionsForUser;
	}
	public boolean getIsLeader() {
		return getPermissionsForUser().contains('Club_Leader');
	}
	public boolean getIsBod() {
		return getPermissionsForUser().contains('Board_of_Directors');
	}
	public boolean getIsStaff() {
		return getPermissionsForUser().contains('Club_Staff');
	}
	public PageReference checkUser() {
		if(System.Userinfo.getUserType() == 'Guest') {
			return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/campfire/ConstituentLoginPage');
		}
		if(getPermissionsForUser().isEmpty()) {
			User usr = [select ContactId from User where Id = :UserInfo.getUserId()];
			new AssignLeaderPermissions().assignPermissions(new List<Id>{usr.ContactId});
		}
		return null;
	}
}