public class RSSFeedCtrl {

    @AuraEnabled
    public static List<DE_RSSObject> getRSSFeed(String url) {
        List<DE_RSSObject> toReturn = new List<DE_RSSObject>();
        if(url != null){
        	List<DE_RSSObject> temp = DE_RSSUtil.getRSSFeedObjects(url);
            Integer feedSize = 0;
            if(temp.size() > 5) {
                feedSize = 5;
            } else {
                feedSize = temp.size();
            }
            for(Integer i = 0;i < feedSize;i++) {
            	toReturn.add(temp.get(i));
            }
            return toReturn;
        }
        
        return toReturn;
    }
}