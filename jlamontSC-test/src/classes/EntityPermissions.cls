/*
EntityPermissions

Created by: Mark Maslow
Created on: January, 2015

Query leadership roles to get list of entities and permissions within each entity.

10/17/2016 Maslow - Fix problem where lower permission in chapter would override higher permission in a child entity.

December, 2016 Maslow - Add code to check for preference indicating contact is staff. Staff get access to entity CLUB.
*/
public without sharing class EntityPermissions {
	//Input - Contact Id
	//Output - List of entities in which contact has leadership roles, with specific permissions for each entity 
	public static List<EntityPermission> getPermissions(Id contactId) {
	    //Retrieve all Leaderhip Roles for Contact
        List<Leadership__c> allRoles = [  
            select Club_Entity__c, Club_Entity__r.EntityId__c, Club_Entity__r.Name, Club_Entity__r.Type__c, 
            	Leader_Position__r.ClubEventPermission_Outings__c, Leader_Position__r.ClubEventPermission_NonOutings__c 
            from Leadership__c
            where Contact__c = :contactId and Position_Active__c = true and Club_Entity__r.Status__c = 'Active'
            order by Club_Entity__c
        ];
        //
        //Code deleted because staff check is done later
        //
        //If no roles, return empty list
        //if(allRoles.size() == 0) {
        //	return new List<EntityPermission>();
        //}
        
        //Create map to correlate a Club Entity with a Leader Role
        //The role in the map will be populated with the highest access found in the entity
        Map<Id, Leadership__c> positionMap = new Map<Id, Leadership__c>();
        for(Leadership__c role : allRoles) {
    		Leadership__c processedRole = positionMap.get(role.Club_Entity__c);
    		if(processedRole == null) {
    			positionMap.put(role.Club_Entity__c, role);
    		}
    		else {
    			if(role.Leader_Position__r.ClubEventPermission_Outings__c == 'Administrator') {
					processedRole.Leader_Position__r.ClubEventPermission_Outings__c = 'Administrator';	    				
    			}
    			else if(role.Leader_Position__r.ClubEventPermission_Outings__c == 'Standard' && 
    					processedRole.Leader_Position__r.ClubEventPermission_Outings__c != 'Administrator') {
							processedRole.Leader_Position__r.ClubEventPermission_Outings__c = 'Standard';	    				
    			}
    			if(role.Leader_Position__r.ClubEventPermission_NonOutings__c == 'Administrator') {
					processedRole.Leader_Position__r.ClubEventPermission_NonOutings__c = 'Administrator';	    				
    			}
    			else if(role.Leader_Position__r.ClubEventPermission_NonOutings__c == 'Standard' &&
    					processedRole.Leader_Position__r.ClubEventPermission_NonOutings__c != 'Administrator') {
							processedRole.Leader_Position__r.ClubEventPermission_NonOutings__c = 'Standard';	    				
    			}
    			positionMap.put(role.Club_Entity__c, processedRole);
    		}
	    }
	    //Administrators in a Chapter also gets access to child entities of the Chapter
	    //Users with standard access to non-outings events also get access to child entities of the Chapter 
	    List<Id> chapters = new List<Id>();
        Map<Id, EntityPermission> permissionMap = new Map<Id, EntityPermission>();
	    for(Leadership__c role : positionMap.values()) {
	    	EntityPermission ep = new EntityPermission(
	    		role.Club_Entity__c,
	    		role.Club_Entity__r.EntityId__c + '-' + role.Club_Entity__r.Name,
	    		role.Club_Entity__r.Type__c,
	    		role.Leader_Position__r.ClubEventPermission_NonOutings__c, 
	    		role.Leader_Position__r.ClubEventPermission_Outings__c 
	    	);
	    	permissionMap.put(role.Club_Entity__c, ep);
	    	if(
	    		//role.Club_Entity__r.Type__c == 'Chapter' && 
		    	  (
		    	  	role.Leader_Position__r.ClubEventPermission_NonOutings__c == 'Administrator' || 
		    	  	role.Leader_Position__r.ClubEventPermission_NonOutings__c == 'Standard' ||
		    	  	role.Leader_Position__r.ClubEventPermission_Outings__c == 'Administrator'
		    	  )
	    	  ) {
	    			chapters.add(role.Club_Entity__c);
	    	}
	    }
    	if(chapters.size() > 0) {
    		List<Club_Entity__c> children = new List<Club_Entity__c>([
    			select Id, EntityId__c, Name, Type__c, Parent_Chapter__c
    			from Club_Entity__c
    			where Parent_Chapter__c in :chapters and Status__c = 'Active' 
    		]);
    		for(Club_Entity__c ent : children) {
    			EntityPermission parentRole = permissionMap.get(ent.Parent_Chapter__c);
                EntityPermission childRole = permissionMap.get(ent.Id);
                if(childRole == null) {
                    EntityPermission childPermission = new EntityPermission(
                        ent.Id,
                        ent.EntityId__c + '-' + ent.Name,
                        ent.Type__c,
                        parentRole.clubEventPermissionNonOutings,
                        parentRole.clubEventPermissionOutings
                    );
                    permissionMap.put(ent.Id, childPermission);
                }
                else {
                    if(parentRole.clubEventPermissionNonOutings == 'Administrator') {
      					childRole.clubEventPermissionNonOutings = 'Administrator';
                    }
                    else if(parentRole.clubEventPermissionNonOutings == 'Standard') {
                        if(childRole.clubEventPermissionNonOutings == 'None') {
                	        childRole.clubEventPermissionNonOutings = 'Standard';
                        }
                    }
                    if(parentRole.clubEventPermissionOutings == 'Administrator') {
      					childRole.clubEventPermissionOutings = 'Administrator';
                    }
                    else if(parentRole.clubEventPermissionOutings == 'Standard') {
                        if(childRole.clubEventPermissionOutings == 'None') {
                	        childRole.clubEventPermissionOutings = 'Standard';
                        }
                    }
                }
    		}
    	}

    	List<Club_Entity__c> clubEntityList = [
			select Id, EntityId__c, Name, Type__c
			from Club_Entity__c
			where EntityId__c = 'CLUB'
    	];
    	if( ! clubEntityList.isEmpty()) {
    		Club_Entity__c clubEntity = clubEntityList.get(0);
    		if(permissionMap.get(clubEntity.Id) == null) {
				if(isStaff(contactId)) {
                    EntityPermission ep = new EntityPermission(
                        clubEntity.Id,
                        clubEntity.EntityId__c + '-' + clubEntity.Name,
                        clubEntity.Type__c,
                        'Administrator',
                        'None'
                    );
                    permissionMap.put(clubEntity.Id, ep);
				}    			
    		}
    	}
        return permissionMap.values();
    }
    private static Boolean isStaff(Id contactId) {
    	List<rC_Bios__Preference__c> preferenceList = [
    		select Id
    		from rC_Bios__Preference__c
    		where rC_Bios__Contact__c = :contactId
    		and rC_Bios__Code_Value__c = 'SCFDNSTAFF'
       		and rC_Bios__Active__c = true
    	];
    	return ! preferenceList.isEmpty();
    }
    public class EntityPermission {
    	public Id clubEntityId { get; set; }
    	public String name { get; set; }
    	public String entityType {get; set;}
    	public String clubEventPermissionOutings { get; set; }
    	public String clubEventPermissionNonOutings { get; set; }

    	public EntityPermission(Id clubEntityId, String name, String entityType, String clubEventPermissionNonOutings, String clubEventPermissionOutings) {
    		this.clubEntityId = clubEntityId;
    		this.name = name;
    		this.entityType = entityType;
    		this.clubEventPermissionNonOutings = clubEventPermissionNonOutings;
    		this.clubEventPermissionOutings = clubEventPermissionOutings;
    	}
    }
}