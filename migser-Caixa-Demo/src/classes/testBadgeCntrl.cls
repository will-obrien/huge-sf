@isTest(SeeAllData=true)
public class testBadgeCntrl {
	public static testMethod void testmyMethod(){
       WorkBadge wb = [SELECT DefinitionId,Definition.Name,Giver.Name,GiverId,Id,ImageUrl,Message,RecipientId,SourceId FROM WorkBadge where RecipientId=:UserInfo.getUserId() order by createddate LIMIT 1];
       FetchBadges.getAllMyBadges();
       FetchBadges.getMyBadges();
       FetchBadges.fetchThatBadge(wb);
    }
}