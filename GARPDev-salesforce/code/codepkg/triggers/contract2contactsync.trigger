trigger contract2contactsync on Contract (after update, after insert) {
    
    
    
    Map<Id,Contract> mapAccountIds = new Map<Id,Contract>();

    for(Contract obj : trigger.New)
    {        
        mapAccountIds.put(obj.accountId,obj);
    }
    
    if(mapAccountIds.size() <= 0) return;

    if(!contractSyncUtil.bRecursive)
        contractSyncUtil.updateContracts(mapAccountIds);
    
    
}