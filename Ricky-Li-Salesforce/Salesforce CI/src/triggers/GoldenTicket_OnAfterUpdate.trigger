trigger GoldenTicket_OnAfterUpdate on User (After Update) {
    
    Set<ID> ids = Trigger.newMap.keySet();
    List <User> listUserIds = [Select id, Attending_GStock__c from User where IsActive = true and id in: ids]; 
    
    Set <Id> userIds = new Set <Id>();
    for(User user : listUserIds){
        if(user.Attending_GStock__c == true){
            userIds.add(user.Id);
        }
    }

    //Call the respective classes
    if(userIds.size() > 0){
        ShowGoldenTicket sgt = new ShowGoldenTicket();
        sgt.AssignPermissionSet(userIds);
    }
}