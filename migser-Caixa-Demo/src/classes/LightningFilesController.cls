public class LightningFilesController {
    @AuraEnabled
    public static List<ContentDocument> getMyFiles(){
        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId()];
        return   [Select Title, OwnerId, ParentId, PublishStatus,FileType,LastViewedDate
                   From ContentDocument
                   Where OwnerId= : loggedInUser.Id
                   ORDER BY LastViewedDate  DESC Limit 5 ];
      }
    
    @AuraEnabled
    public List<ContentVersion> getContentVersions() {
        return [Select id, Title, Description, FileType,
                Owner.Name, VersionNumber 
                From ContentVersion
                Where IsLatest = true];
    }

     
}