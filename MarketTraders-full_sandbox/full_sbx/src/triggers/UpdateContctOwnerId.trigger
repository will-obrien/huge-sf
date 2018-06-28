trigger UpdateContctOwnerId on Contact (before insert, before update) {
    User ObjUser = [SELECT Id FROM User WHERE Name = : Label.OWID AND IsActive = true];
    system.debug(ObjUser.Id);
     if(Trigger.isInsert){
        for(Contact objContact : Trigger.new ){
            objContact.ownerId = ObjUser.Id;
        }
        
    }
    if(Trigger.isUpdate){
        for(Contact objContact : Trigger.new ){
            objContact.ownerId = ObjUser.Id;
        }
        
    }
}