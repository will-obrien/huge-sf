public class LightningRecentItems {

    @AuraEnabled
    public static List<RecentlyViewed> getRecentItem(){
        return   [SELECT Id, Name,Type
                    FROM RecentlyViewed
                    WHERE LastViewedDate !=null AND Type NOT IN ('Contact','User','ListView','ContentDocument')
                    ORDER BY LastViewedDate  DESC Limit 5];
      }
    
}