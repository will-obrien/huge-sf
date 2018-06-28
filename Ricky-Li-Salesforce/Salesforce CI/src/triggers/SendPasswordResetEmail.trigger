trigger SendPasswordResetEmail on User (before insert, after insert) {
    for(User u1:Trigger.new){
        //reset only on insert, training sandbox, profile Inside Sales
        if(UserInfo.getUserName().right(8).equals('training')&& u1.profileId=='00e30000001oqfR'){
            if(Trigger.isBefore){
                u1.UserPermissionsSupportUser = true;
                u1.CallCenterId = '';//remove after refresh Training sandbox
            }else{
                System.debug('reseting password');
                System.resetPassword(u1.Id, true);        
            }
        }
    }   
}