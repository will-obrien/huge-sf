public class MyIdeasListController {
@AuraEnabled
    public static List<SoBject> getIdeas() {
        List<List<SoBject>> ideas = [FIND '#idea*' IN ALL FIELDS 
                               RETURNING FeedItem( Id, Type,CreatedDate,CreatedBy.Name, Title, Visibility, Status, Body, CommentCount, LikeCount)]; 
        
        
        
        return ideas[0];
    }
}