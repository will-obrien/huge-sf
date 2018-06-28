public class AdvocacyActionDelete {
    
    //only allows delete if the user is a Sys Admin or the creator of the Advocacy Action
    public static void checkUser(List<kweos__EOCS_Data__c> actions) {
        
        Id runningUserId = UserInfo.getUserId();
        Id runningUserProfileId = UserInfo.getProfileId();
        List<Profile> runningUserProfile = [SELECT Id, Name FROM Profile WHERE Id = :runningUserProfileId];
        String runningUserProfileName = runningUserProfile[0].Name;
        
        for (kweos__EOCS_Data__c a : actions) {
            if (runningUserId != a.CreatedById && runningUserProfileName != 'System Administrator' && runningUserProfileName != 'CastIron') {
                a.addError('You can only delete actions you created');
            }
        }       
    }
    
    //if the deleted Advocacy Action had a corresponding batch upload, delete the batch upload
    public static void deleteBatchUpload(List<kweos__EOCS_Data__c> actions) {
        
        List<String> actionIDs = new List<String>();
        for (kweos__EOCS_Data__c a : actions) {
            actionIDs.add(string.valueOf(a.Id));
        }

		List<rC_Connect__Batch_Upload__c> batchUploads = new List<rC_Connect__Batch_Upload__c>([SELECT Id FROM rC_Connect__Batch_Upload__c WHERE kwrcac__KW_Advocacy_Id__c IN :actionIDs]);
		
        if (batchUploads.size() > 0) {
            delete batchUploads;
        }
		       
    }    

}