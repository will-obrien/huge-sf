public with sharing class ChatterAssassin {

	public class wrappedPost{
		public boolean checked{get;set;}
		public NewsFeed fi{get;set;}
		public FeedComment fc {get;set;}
		public List<wrappedPost> commentList{get;set;}
		public string ftcBody{get;set;}
		
		
		public wrappedPost(NewsFeed inc){
			fi = inc;
			checked = false;
			if(fi.feedComments.size() > 0)
			{
				commentList = new list<wrappedPost>();
				for(FeedComment fc : fi.feedComments)	
				{
					commentList.add(new wrappedPost(fc));
				}
			}
			if(fi.feedTrackedChanges.size() > 0)
			{
				ftcbody = fi.feedTrackedChanges[0].fieldName + ' Changed from ' + fi.feedTrackedChanges[0].oldvalue + ' to ' + fi.feedTrackedChanges[0].newValue;
			}
			else
				ftcBody = null;
		}
		public wrappedPost(feedComment inc){
			fc = inc;
			checked = false;
		}
		public boolean gethasComments(){
			return fi.feedComments.size() > 0;
		}
		public pageReference deleteMe(){
			if(fi != null)
				delete [select id from FeedItem where id = :fi.id];
			else if(fc != null)
				delete [select id from FeedComment where id = :fc.id];
				
			return null;
		}
	}
	
	
	public list<wrappedPost> targetHolder{get;set;}
	
	public ChatterAssassin(){
		//generate list of erryting
	}
	public List<wrappedPost> getTargets(){
		List<NewsFeed>nfList = [SELECT ID, body, CreatedDate, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, ParentId, Parent.Name,
(SELECT ID, FieldName, OldValue, NewValue FROM FeedTrackedChanges ORDER BY ID DESC), (Select id, commentbody, createdByID from FeedComments order by id desc)
FROM NewsFeed ORDER BY CreatedDate DESC, Id DESC LIMIT 20];
		targetHolder = new list<wrappedPost>();
		for(NewsFeed nf : nfList)
		{
			targetHolder.add(new wrappedPost(nf));
		}
		return targetHolder;
	}
	
	public void deleteEm(){
		List<string> fiList = new list<string>();
		list<feedComment> fcList = new list<feedComment>();
		
		for(wrappedPost target: targetHolder)
		{
			if(target.checked)
			{
				fiList.add(target.fi.id);
			}
			if(target.gethasComments())
			{
				for(WrappeDPost tC : target.commentList)
				{
					if(tc.checked)
					{
						fcList.add(tc.fc);
					}
				}
			}
		}
		
		List<FeedItem> delList = [select id from FeedItem where id in :fiList];
		delete fcList;
		delete dellist;
	}
    
    public void deleteAllFTC(){
        List<FeedItem> fiList = [select id from FeedItem where type = 'TrackedChange'];
        delete fiList;
    }
    
    public void deleteAllAll(){
        //Now we're all sons-of-bitches
        List<FeedItem> fiList = [select id from FeedItem];
        delete fiList;
    }
	
}