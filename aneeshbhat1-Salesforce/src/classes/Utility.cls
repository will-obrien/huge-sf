public class Utility {
    // To get all sub roles.
   
    
    
    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

    Set<ID> currentRoleIds = new Set<ID>();

    // get all of the roles underneath the passed roles
    for(UserRole userRole :[select Id from UserRole where ParentRoleId 
         IN :roleIds AND ParentRoleID != null]) {
        currentRoleIds.add(userRole.Id);
    }

    // go fetch some more rolls!
    if(currentRoleIds.size() > 0) {
        currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
    }

    return currentRoleIds;
}
    // To get all Parent Roles.
    public static Set<ID> getParentRoleId(Set<ID> roleIds) {

        Set<ID> currentRoleIds = new Set<ID>();
    
        
        // get all of the parent roles.
        for(UserRole ur :[select Id, ParentRoleId from UserRole where Id IN: roleIds]) {
            currentRoleIds.add(ur.ParentRoleId);
        }
    
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getParentRoleId(currentRoleIds));
        }
    
        return currentRoleIds;
    }
}