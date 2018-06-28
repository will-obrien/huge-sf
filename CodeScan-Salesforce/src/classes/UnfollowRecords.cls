public global  with sharing class UnfollowRecords{

    public static Long UnfollowRecordsButtonAction(SET<Id> recordIds){
        List<EntitySubscription> followersToRemove=[SELECT Id FROM EntitySubscription WHERE ParentId IN : recordIds];
        Long numRemoved=followersToRemove.size();
        try{
            delete followersToRemove;
            return numRemoved;
        }catch(DMLException e){
//            system.debug('Followers were not removed properly.  Error: '+e);
            return 0;
        }
    }//UnfollowRecordsButtonAction

}//class Unfollow