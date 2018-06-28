public with sharing class CopyChatterFeeds
{
    public String selectedParentId {get;set;}  //which record to post feed to
    public String selectedStoryId {get;set;} //which story feeds to grab
    public Integer secondsApart {get;set;} //# of seconds apart when posting feedItems
    public Integer increment {get;set;}
    public CopyChatterFeeds()
    {
        selectedParentId = '';
        //selectedStoryId = '';
        selectedStoryId = '';
        increment = 5;
    }
    public void setIncrementTime(Integer inc)
    {
    	increment = inc;
    	if(secondsApart == null)
    		secondsApart = increment;
    }
    
    public void copyFeedsFromStoryToRecord()
    {
        System.debug('ParentId: '+ selectedParentId);
        System.debug('selectedStoryId: '+ selectedStoryId);
        
        List<FeedComment> storyFeedComments = [SELECT CommentBody,CommentType,CreatedById,CreatedDate,FeedItemId,RelatedRecordId    //parentId is auto fill depends on feedItemId
                                               FROM FeedComment
                                               WHERE ParentId = :selectedStoryId
                                               Order by CreatedDate ASC];
        System.debug(storyFeedComments);                                               
        List<FeedComment> newRecordFeedComments = storyFeedComments.deepClone(false,true,false);
        
        //change newRecordFeedComments.FeedItemId to new one
        for(FeedComment fc: newRecordFeedComments)
        {
            fc.FeedItemId = selectedParentId;
            fc.createdDate = null;
            //create scheduled Comment Post
            ScheduledChatterComment chatComment = new ScheduledChatterComment(fc);
            String schDateTime = calculateScheduleTimeStr(); //X seconds after NOW
            system.schedule('Scheduled FeedComment '+' '+String.valueof(secondsApart)+' '+System.Now()+Math.random(), schDateTime, chatComment); //SCHEDULE THE POST!!!!
        }
        //insert newRecordFeedComments;                      
    }
    
    public String calculateScheduleTimeStr()
    {
        DateTime schDateTime = System.now().addSeconds(secondsApart);
        String scheduleStr = '';
        scheduleStr = schDateTime.format('s m H d M')+ ' ? '+schDateTime.format('yyyy');
        //add  secondsApart seconds to the next schedule time
        secondsApart += increment;
        return scheduleStr;
    }
    
    /* this doesn't work that well because feedComment needs to know FeedItemId before posting. scheduling feedComment post on schedueled FeedItem post does not work
    public void copyFeedsFromStoryToRecord()
    {
        //selectedParentId; //record id
        List<FeedItem> storyFeedItems = [SELECT Body,ContentData,ContentDescription,ContentFileName,CreatedById,CreatedDate,Id,LikeCount,LinkUrl,ParentId,RelatedRecordId,Title,Type 
                                         FROM FeedItem
                                         WHERE ParentId = :selectedStoryId 
                                         LIMIT 20];
        List<FeedItem> newRecordFeedItems = storyFeedItems.deepClone(false,true,false);
        List<FeedComment> storyFeedComments = [SELECT CommentBody,CommentType,CreatedById,CreatedDate,FeedItemId,RelatedRecordId    //parentId is auto fill depends on feedItemId
                                               FROM FeedComment
                                               WHERE ParentId = :selectedStoryId];
        List<FeedComment> newRecordFeedComments = storyFeedComments.deepClone(false,true,false);
        //change parentId
        for(FeedItem f : newRecordFeedItems)
        {
            f.Visibility = '';
            f.ParentId = selectedParentId;
            f.createdDate = null;
            //create scheduledPost
            ScheduledChatterPost chatPost = new ScheduledChatterPost(f);
            String schDateTime = calculateScheduleTimeStr(); //X seconds after NOW
            system.schedule('Scheduled Feed Post'+String.valueof(secondsApart), schDateTime, chatPost); //SCHEDULE THE POST!!!!
        }
        
        Map<String,String> oldFeedItemId_to_newFeedItemId = new Map<String,String>(); //key = oldFeedItemId, value = newRecordFeedItemId
        //Map storyFeedItemId to new FeedItemId in newRecordFeedComments
        for(Integer i=0;i<storyFeedItems.size();i++)
            oldFeedItemId_to_newFeedItemId.put( storyFeedItems[i].id, newRecordFeedItems[i].id );
        
        //change newRecordFeedComments.FeedItemId to new one
        for(FeedComment fc: newRecordFeedComments)
        {
            fc.FeedItemId = oldFeedItemId_to_newFeedItemId.get(fc.FeedItemId);
            fc.createdDate = null;
            //create scheduled Comment Post
            ScheduledChatterComment chatComment = new ScheduledChatterComment(fc);
            String schDateTime = calculateScheduleTimeStr(); //X seconds after NOW
            system.schedule('Scheduled Feed Comment Post'+String.valueof(secondsApart), schDateTime, chatComment); //SCHEDULE THE POST!!!!
        }
        //insert newRecordFeedComments;                      
    }
    */
}