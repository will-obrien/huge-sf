public class ChannelManagerService {

   public static void createNewChannel(String objType, String objRefCol, String objRefId, String channelId){
       Channel_Manager__c newChannel = new Channel_Manager__c();
       newChannel.Object_Type__c = objType;
       newChannel.Object_Ref_Column__c = objRefCol;
       newChannel.Object_Ref_ID__c = objRefId;
       newChannel.Channel_ID__c = channelId;
       Database.upsert(newChannel);
   } 
  
   public static Channel_Manager__c getChannelByStory(String storyId) {
        return ChannelManagerService.getChannel('story', 'name', storyId);
   }  
  
    // getChannel
    // objType - e.g. story object
    // objRefCol - e.g. story name or story number
    // objRefId - e.g. value of ref col
   public static Channel_Manager__c getChannel(String objType, String objRefCol, String objRefId) {
        return [SELECT Channel_ID__c FROM Channel_Manager__c WHERE Object_Type__c = :objType AND Object_Ref_Column__c = :objRefCol AND Object_Ref_ID__c = :objRefId];
   }
   
}