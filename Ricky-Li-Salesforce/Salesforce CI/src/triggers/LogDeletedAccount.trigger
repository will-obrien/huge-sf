trigger LogDeletedAccount on Account (after delete) {
    //first get mergewinner ids from our set of deleted records
    Set <Id> mergeWinnersIds = new Set<Id>();
    String abc;
    for (Account ac:Trigger.old){
        if(ac.MasterRecordId != null){//if it does not have master recordId set it's a survivor
            mergeWinnersIds.add(ac.MasterRecordId);
        }
    }
    
    //get 1 service for the survivor
    List <TravellerServices__c> listServiceForSurvivor = [Select Service__c from TravellerServices__c where Account__c in : mergeWinnersIds Limit 1];
    //if the survivor does not have any services then don't do anything
    if(listServiceForSurvivor.size() == 0){
        System.Debug('Do not do anything');
    }
    else{   
    //copy the single Id to a string for calculations
    String serviceId = listServiceForSurvivor[0].Service__c;
       
    List <Service__c> listDummy = [Select Dummy_Field__c from Service__c where Id =: serviceId];
    listDummy[0].Dummy_Field__c = 'Merge Successful';
    update listDummy;} 
    //now get the merge winners
    Map <Id,Account> mergeWinners = new Map<Id, Account>([Select Compass_ID_2__c from Account Where Id in :mergeWinnersIds]);
    List <DeletedAccount__c> delAccountsToInsert = new DeletedAccount__c[]{};
    for (Account acc:Trigger.old){
        DeletedAccount__c da = new DeletedAccount__c();
        da.AccountID__c = acc.Id;
        da.Name = acc.FirstName+' '+acc.LastName;
        da.CompassID__c = acc.Compass_ID_2__c;
        if(acc.MasterRecordId != null){ //this is a deletion as a result of a merge
            da.MergeRecordId__c = acc.MasterRecordId;
            if(da.MergeRecordId__c != null && da.MergeRecordId__c.trim().length() > 0){
                //let's get the merge record compass id
                Account winner = mergeWinners.get(da.MergeRecordId__c);
                da.MergeCompassID__c = winner.Compass_ID_2__c;
            }
        }
        delAccountsToInsert.add(da);
    }
    insert delAccountsToInsert;
  }