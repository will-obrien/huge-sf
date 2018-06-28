public class FetchBadges{
    
@AuraEnabled
  public static List<WorkBadge> getAllMyBadges(){
     
     List<WorkBadge> myBadges = [SELECT Definition.Name,Giver.Name,GiverId,Id,ImageUrl,
                                 Message,RecipientId,SourceId FROM WorkBadge 
                                 where RecipientId=:UserInfo.getUserId() 
                                 and NetworkId = :Network.getNetworkId() 
                                 order by createddate desc ];
     return myBadges;
  
  
  }
@AuraEnabled
  public static List<WorkBadge> getMyBadges(){
     
     List<WorkBadge> myBadges = [SELECT DefinitionId,Definition.Name,Giver.Name,GiverId,Id,ImageUrl,
                                 Message,RecipientId,SourceId FROM WorkBadge 
                                 where RecipientId=:UserInfo.getUserId() 
                                 and NetworkId = :Network.getNetworkId()
                                 order by createddate desc LIMIT 5];
     return myBadges;
  
  
  }
@AuraEnabled
  public static WorkBadge fetchThatBadge(WorkBadge wb){
      WorkBadge badge = [select Definition.Name,Giver.Name,GiverId,Id,ImageUrl,Message,Description from WorkBadge where id=:wb.id];
      return badge;
      
  }
    
}