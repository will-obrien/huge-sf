public class GNationLiveController {
    
   //Properties
   public boolean noFeeds {get; set;}
   public Map <Id, User> MapIdUser;
   public Map <Id, WorkBadgeDefinition> workBadgeDefn;
   List <User> listUser;
   List <FeedItem> ChatterPosts;
   String GNationGroup;
   GNationLive__c GNationLive;
   Integer RefreshTime;
   String instance;
   String ChatterImageAttachmentURL2 = '.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB120BY90&versionId=';
   String ChatterImageAttachmentURL3 = '&operationContext=CHATTER';
   String ChatterImageAttachmentURL2Big = '.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
   String Message;
   String PostImageURL; 
   String PostImageURLBig;
   String PostBody;
   String OriginalPostUrl;
   boolean containsImage;
   boolean postContainsImage;
   /* 
    * Constructor: 1. Fetches Group Id, Refresh Time from the Custom Setting
    *              2. Creates a Map of User's Id & PhotoUrl
    *              3. Sets a flag if there is no Chatter Posts on the Group
    *              4. Fetches the instance the page is open on
    */
    
   public GNationLiveController() {
       //Get the Group Id & refresh time from the custom setting
       GNationLive = [Select Group_Id__c, Refresh_Time__c from GNationLive__c Limit 1];
       GNationGroup = GNationLive.Group_Id__c;
       RefreshTime = (Integer) GNationLive.Refresh_Time__c;
       
       //Check if there is any chatter posts in the group specified in the custom setting
       ChatterPosts = [Select Id, Body, CreatedById, CreatedBy.Name, Parent.Name, ParentId, CreatedDate from FeedItem where ParentId =:GNationGroup];
       
       //Create a map of Id, Name & photo Url of the user
       MapIdUser = new Map<Id, User>([Select Id, Name, FullPhotoUrl from User where isActive=true]);
       
       //Create a map for WorkBadgeDefinition Lookup
       workBadgeDefn = new Map<Id, WorkBadgeDefinition>([Select Id, name,description, ImageURL, IsActive from workbadgedefinition where IsActive = true]);       
      
       //Set a check flag
       if(ChatterPosts.size () > 0)
           nofeeds = false;
       else
           nofeeds = true;
           
       //Fetch the instance
       String[] baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('/');
       String instanceURL  = baseURL[2];
       String[] instanceName = instanceURL.split('.visual.force.com');
       instance = instanceName[0];
   }

   /*
    * This method: 1. Gets Chatter Posts & the posts info
    *              2. Grabs PhotoUrl from the MapIdUser
    *              3. Creates another object 'GNationGroupUpdateObject'
    */
    
   public list<GNationGroupUpdateObject> getGNationLivePosts(){
       List <GNationGroupUpdateObject> updates = new List <GNationGroupUpdateObject>();
       String orgId = UserInfo.getOrganizationId();
       if(nofeeds == false){
           Chatter_Post_Comment_Table__c[] feeds;
           try{
               feeds = [Select Id, Body__c, CreatedById__c, CreatedDate__c, RelatedRecordId__c, ContentType__c, isComment__c, Post_Body__c, Post_RelatedRecordId__c, Title__c, Type__c, CreatedById from Chatter_Post_Comment_Table__c Order By CreatedDate__c DESC Limit 25];
           }
           catch(System.QueryException e){
               return updates;
           }
           
           //Create Look up map for feed -> workBadgeDefn
           Set<Id> feedRelatedRecordIds = new Set<Id>();
           for(Chatter_Post_Comment_Table__c feed : feeds){
           	if(feed.RelatedRecordId__c != null)
           		feedRelatedRecordIds.add(feed.RelatedRecordId__c);
           	if(feed.Post_RelatedRecordId__c != null && feed.Type__c != null)
           		if(!feed.Type__c.equals('LinkPost'))
           			feedRelatedRecordIds.add(feed.Post_RelatedRecordId__c);
           }

           List<WorkBadge> workBadges = [select RecipientId, definitionId, SourceId, Id from workbadge where sourceId =: feedRelatedRecordIds];

           Map<Id, WorkBadgeDefinition> feedToWorkBadgeDefn = new Map<Id, WorkBadgeDefinition>();
           
           Map<Id, Id> feedRecipientMap = new Map<Id, Id>();
           
           for(WorkBadge wb: WorkBadges){
           	feedToWorkBadgeDefn.put(wb.SourceId, workBadgeDefn.get(wb.definitionId));
           	feedRecipientMap.put(wb.SourceId, wb.RecipientId);
           }
           
           
           for(Chatter_Post_Comment_Table__c feed : feeds){
               String PhotoUrl = MapIdUser.get(feed.CreatedById__c).FullPhotoUrl;
               String createdByName = MapIdUser.get(feed.CreatedById__c).Name;
               String originalPostBody = feed.Post_Body__c;
               PostImageURL = '';
               String badgeTitle = '';
               String badgeName = '';
               String badgeRecipient = '';
               PostImageURLBig = '';
               
               //Time Difference
               DateTime currentTime = datetime.now();
               DateTime postedTime = feed.CreatedDate__c;
               
               double timeDiff = currentTime.getTime() - postedTime.getTime();
               double convertedSecs = timeDiff/1000;
               String timeAgo;
               Integer roundConvertedHours;
               Integer roundConvertedDays;
               
               if(convertedSecs < 60){
                   timeAgo = String.valueOf((integer)convertedSecs) +' secs';
               }
               
               double convertedMins = convertedSecs/60;
               Integer roundConvertedMins = (integer) convertedMins;
               if(ConvertedSecs >60 && roundConvertedMins < 2)
                  timeAgo = '1 min';
                  
               if(roundConvertedMins == 2)
                   timeAgo = '2 mins';
                      
               if(roundConvertedMins > 2 && roundConvertedMins < 60)
                  timeAgo = String.valueOf(roundConvertedMins)+' mins';
                   
             if(roundConvertedMins > 60){
                   roundConvertedHours = roundConvertedMins/60;
                   
                   if(roundConvertedHours < 2){
                       timeAgo = '1 hour';
                   }
         
                   if(roundConvertedHours == 2 || (roundConvertedHours > 2 && roundConvertedHours < 24)){
                       timeAgo = String.valueOf(roundConvertedHours)+ ' hours'; 
                   }
                   
                   if(roundConvertedHours == 24){
                       timeAgo = '1 day';
                   }
                   
                   if(roundConvertedHours > 24){
                       roundConvertedDays = roundConvertedHours/24;
                       if(roundConvertedDays == 1)
                           timeAgo = '1 day';
                       else
                           timeAgo = String.valueOf(roundConvertedDays)+ ' days';
                   }
               }
               
               /*
                * This checks if the User posted an image, if yes it captures the Image
                */
               containsImage = false;
               if(feed.relatedRecordId__c != null){
                 String contentType = feed.ContentType__c;
                   	if((contentType != null && feed.Type__c != 'LinkPost') || (contentType == 'ContentComment' && feed.Type__c == 'LinkPost')){
                       PostImageURLBig = 'https://'+instance+ChatterImageAttachmentURL2Big+feed.RelatedRecordId__c+ChatterImageAttachmentURL3;
                       containsImage = true;
                   }
               }
               
               OriginalPostUrl = '';
               PostBody = feed.Post_Body__c;
               if(feed.isComment__c){
               		postContainsImage = false;
	               if(feed.Post_RelatedRecordId__c != null){
	               		postContainsImage = true;
	               		OriginalPostUrl = 'https://'+instance+ChatterImageAttachmentURL2Big+feed.Post_RelatedRecordId__c+ChatterImageAttachmentURL3;
	               		if(feed.Type__c != null){
	               			if(feed.Type__c.equals('RypplePost')){
	               				if(feedToWorkBadgeDefn.get(feed.Post_RelatedRecordId__c) != null){
	               					badgeTitle = feedToWorkBadgeDefn.get(feed.Post_RelatedRecordId__c).Description;
	               					badgeName = feedToWorkBadgeDefn.get(feed.Post_RelatedRecordId__c).Name;
	               					OriginalPostUrl = feedToWorkBadgeDefn.get(feed.Post_RelatedRecordId__c).ImageUrl;
	               					if(!OriginalPostUrl.startsWith('/img/')){
               							OriginalPostUrl = '/servlet/servlet.ImageServer?id=' + OriginalPostUrl + '&oid=' + orgId;
               						}
	               				}
	               			}else if(feed.Type__c.equals('LinkPost')){	
	               				badgeTitle = feed.Title__c;
	               				OriginalPostUrl = feed.Post_RelatedRecordId__c;
	               				postContainsImage = false;
	               			}                			
	               		}
	               }
	               
	               if(feed.Post_Body__c != null){
	               	if(feed.Type__c.equals('RypplePost')){
               			if(feedRecipientMap.get(feed.Post_RelatedRecordId__c)!=null){               		
               	  			badgeRecipient = '@' + MapIdUser.get(feedRecipientMap.get(feed.Post_RelatedRecordId__c)).Name;
               	   			if(feed.Post_Body__c.startsWith(badgeRecipient)){
               	   				PostBody = feed.Post_Body__c.removeStart(badgeRecipient);
               	   			}
               			}
               		} 
	               	if(feed.Post_Body__c.length() >=400){
                   		PostBody = PostBody.substring(0,399)+'...';
              		 } 
	               }/*else if(postContainsImage){
              	   PostBody = 'Image';
             		 }else if(feed.Type__c.equals('LinkPost')){
             		 	PostBody = 'Link';
             		 	
             		 }*/	               
               
               }
               
               if(feed.Type__c != null){
               	if(feed.Type__c.equals('RypplePost') && !feed.isComment__c){
               		if(feedToWorkBadgeDefn.get(feed.relatedRecordId__c) != null){
               			
	               		badgeTitle = feedToWorkBadgeDefn.get(feed.relatedRecordId__c).Description;
	               		badgeName = feedToWorkBadgeDefn.get(feed.relatedRecordId__c).Name;
	               		PostImageURL = feedToWorkBadgeDefn.get(feed.relatedRecordId__c).ImageUrl;
	               		if(!PostImageURL.startsWith('/img/')){
	               			PostImageURL = '/servlet/servlet.ImageServer?id=' + PostImageURL + '&oid=' + orgId;
	               		}
               		}
               	}else if(feed.Type__c.equals('LinkPost') && !feed.isComment__c){
               		badgeTitle = feed.Title__c;//link title
               		PostImageURL = feed.Post_Body__c; //link URL               		
               	}
               }

              //Check if the body is longer than 400 characters
              message = feed.body__c;
              if(feed.body__c != null){
               if(feed.Type__c.equals('RypplePost') && !feed.isComment__c){
               	if(feedRecipientMap.get(feed.relatedRecordId__c)!=null){               		
               	   badgeRecipient = '@' + MapIdUser.get(feedRecipientMap.get(feed.relatedRecordId__c)).Name;
               	   if(feed.Body__c.startsWith(badgeRecipient)){
               	   	message = feed.Body__c.removeStart(badgeRecipient);
               	   }
               	}
               } 
               if(feed.body__c.length() >=400){
                   message = feed.body__c.substring(0,399)+'...';
               } 
              }else if(containsImage){
              	   message = createdByName + ' posted an image';
              }else if(feed.Type__c == 'LinkPost'){
              	   message = createdByName + ' posted a Link';
              }
                    
             /*
              * Post will only be displayed if there is a body or image
              * Object type defined in Apex Class GNationGroupUpdateObject
              * GNationGroupUpdateObject(String fromName, String fromId, String toName, String toId, String message, String PhotoUrl, String timeDiff, String GroupId, String ChatterImageURL, String ChatterImageURLBig)
              * toName, toId are not used and thus filled by null or if it is a comment toName = PostBody, toId = OriginalPostUrl
              */  
               if(message != '')
                   updates.add(new GNationGroupUpdateObject(createdByName, feed.CreatedById__c, PostBody, OriginalPostUrl, message, PhotoUrl, timeAgo, GNationGroup, PostImageURL, PostImageURLBig, badgeTitle, feed.Type__c, badgeName, feed.isComment__c, badgeRecipient));
           }
           return updates;
       }
       else
           return null;
   }
   
   /*
    *  This method: 1. Its the action component of action poller
    *               2. Calls the getGNationLivePosts method to return all the chatter posts
    */
    
   public PageReference RefreshPosts() {
        getGNationLivePosts();
        return null;
   }
    
   /* This method: 1. Dynamically fetches refresh time from the custom setting
    *              2. Returns the refresh time to the action poller method 
    */   
   public Integer getRefreshTime() {
        return RefreshTime;
    }
}