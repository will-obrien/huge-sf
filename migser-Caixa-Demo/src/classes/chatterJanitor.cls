public with sharing class chatterJanitor {
  
  public class chatterPost{
    public FeedPost post{get;set;}
    public SObject feed{get;set;} 
    public FeedTrackedChange ftc{get;set;}
    
    public chatterPost(){
        post = null;
        feed = null;
        ftc = null;
    }
    
    public chatterPost(SObject incFeed, boolean skipFTC, boolean skipChat)
    {
      feed = incFeed;
      if(feed.get('type') != 'TrackedChange')
      {
        post = (FeedPost)incFeed.getSObject('feedPost');
        ftc = NULL;
      }
      else
      {
        FeedTrackedChange[]ftcAry = (FeedTrackedChange[])incFeed.getSObjects('FeedTrackedChanges');
        ftc = ftcAry[0]; 
        post = NULL;
      }
      if(skipFTC)
      	ftc = null;
      if(skipChat)
      	post= null;
    }
    
  }
  
  
  
  public static void cleanObjects(string emailAddress, List<ChatterJanitorSetting__c> cjsList)
  {
  	//Begin random local variables
    DateTime dateLimit;
    List<Sobject> feeds;
    List<Sobject> ftcs;
    string query;
    string tableName;
   
    string attachmentBody = '';
    List<chatterPost> comboList;
    boolean archival = false;
        
    //loop through setting records (objects)
    for(ChatterJanitorSetting__c cjs : cjsList) 
    {
      
      //Set date limit per setting record
      //Format correctly for SOQL query.
      dateLimit = dateTime.now();
      if(cjs.Date_Limit_Type__c == 'Day(s)')
      {
        dateLimit = dateLimit.addDays(cjs.Date_Limit_no_of_Type__c.intValue() * -1);          
      }
      else if(cjs.Date_Limit_Type__c == 'Month(s)')
      {
        dateLimit = dateLimit.addMonths(cjs.Date_Limit_no_of_Type__c.intValue() * -1);
      }
      else if(cjs.Date_Limit_Type__c == 'Year(s)')
      {
        dateLimit = dateLimit.addYears(cjs.Date_Limit_no_of_Type__c.intValue() * -1);
      }
      string sDateLimit = dateLimit.formatGMT('yyyy-MM-dd') + 'T' + dateLimit.formatGMT('kk:mm:ss') + 'Z';
      
      
       comboList = new List<ChatterPost>();
      //build query, figure out if custom object, then dynamic soql to get feed objects.
      query = cjs.object_name__c;
      if(cjs.object_name__c.substring(cjs.object_name__c.length()-3, cjs.object_name__c.length()).contains('__c')) //if last three digits in object name = __c
      {
        query = query.substring(0, query.length()-1);
      }
      query += 'feed';
      tablename = query;
      
      
      if(!cjs.Skip_Written_Posts__c)
      {
      	query = 'select id, type, feedpostID, createdByID, createdDate, feedpost.id, feedPost.Body, feedPost.linkURl from ' + query;
      	query += ' where type != \'TrackedChange\' and systemModStamp <= ' + sDateLimit;
      	feeds = database.query(query);
      	for(Sobject f : feeds)
      	{
        //build combo object
        comboList.add(new chatterPost(f, cjs.Skip_Tracked_Changes__c, cjs.Skip_Written_Posts__c));  
      	}
      }
      if(!cjs.Skip_Tracked_Changes__c)
      {
      	query = 'select id, type, createdDate, createdByID, (Select fieldName, id, newValue, oldValue from feedTrackedChanges) from ' + tablename;	
  	  	query += ' where type = \'TrackedChange\' and systemModStamp <= ' + sDateLimit;
  	  	ftcs = database.query(query);
  	  	
  	  	for(Sobject f : ftcs)
      {
        //build combo object
        comboList.add(new chatterPost(f, cjs.Skip_Tracked_Changes__c, cjs.Skip_Written_Posts__c));  
      }
      }
      
      
      //begin archival tracking
      if(cjs.email_archival__c && emailaddress != null)
      {
        
        //build the attachment file body for the email. CSV content.
        archival = true;
        attachmentBody += 'Object:,' + cjs.Object_Name__c + ',Cutoff Date:,' + dateLimit + '\n';
        attachmentBody += 'Feed ID, Post/Change Unique ID, Created Date, Creator Name, Object.Field changed, Field Old Value, Field New Value, Attached Link(If Any), Comment\n';
        
        for(ChatterPost f : comboList)
        {
          if(f.post != NULL)
            attachmentbody += f.feed.get('id') + ',' + f.post.id + ',' + f.feed.get('createdDate') + ',"' + f.feed.get('createdByID') + '",,,,"' + f.post.linkURL + '","' + string.valueOf(f.post.body).replace('\n', '') + '"\n';
          else if(f.ftc != NULL)
            attachmentbody += f.feed.get('id') + ',' + f.ftc.id + ',' + f.feed.get('createdDate') + ',"' + f.feed.get('createdByID') + '",' + f.ftc.fieldname + ',"' + string.valueOf(f.ftc.oldValue).replace('\n', '') + '","' + string.valueOf(f.ftc.newValue).replace('\n', '') +'",,\n';
            
        }
      }
      if(!cjs.Skip_Tracked_Changes__c)
      	database.delete(ftcs);
      if(!cjs.Skip_Written_Posts__c)
      	database.delete(feeds);
    }
    
    
    //archive goes here
    if(archival)
      emailArchive(attachmentBody, emailAddress);
  	
  }
  
  //Email address passed in is where you want archive to go. If set to Null, will not send email archive out, just delete.
  @future
  public static void cleanHouse(string emailAddress){  
    List<ChatterJanitorSetting__c> cjsList = [select date_limit_no_of_type__c, skip_tracked_changes__c, skip_written_posts__c, date_limit_type__c, id, email_archival__c, name, object_name__c from ChatterJanitorSetting__c where active__c = true order by object_name__c asc];    
    
    //Begin random local variables
    DateTime dateLimit;
    List<Sobject> feeds;
    List<Sobject> ftcs;
    string query;
   	string tablename;
   
    string attachmentBody = '';
    List<chatterPost> comboList;
    boolean archival = false;
        
    //loop through setting records (objects)
    for(ChatterJanitorSetting__c cjs : cjsList) 
    {
       
      //Set date limit per setting record
      //Format correctly for SOQL query.
      dateLimit = dateTime.now();
      
      if(cjs.Date_Limit_Type__c == 'Day(s)')
      {
        dateLimit = dateLimit.addDays(cjs.Date_Limit_no_of_Type__c.intValue() * -1);          
      }
      else if(cjs.Date_Limit_Type__c == 'Month(s)')
      {
        dateLimit = dateLimit.addMonths(cjs.Date_Limit_no_of_Type__c.intValue() * -1);
      }
      else if(cjs.Date_Limit_Type__c == 'Year(s)')
      {
        dateLimit = dateLimit.addYears(cjs.Date_Limit_no_of_Type__c.intValue() * -1);
      }
      string sDateLimit = dateLimit.formatGMT('yyyy-MM-dd') + 'T' + dateLimit.formatGMT('kk:mm:ss') + 'Z';
      
      
      
      comboList = new List<ChatterPost>();
      //build query, figure out if custom object, then dynamic soql to get feed objects.
      query = cjs.object_name__c;
      if(cjs.object_name__c.substring(cjs.object_name__c.length()-3, cjs.object_name__c.length()).contains('__c')) //if last three digits in object name = __c
      {
        query = query.substring(0, query.length()-1);
      }
      query += 'feed';
      tablename = query;
       //query = 'select id, feedpostID, createdByID, createdDate, feedpost.id, feedPost.Body, feedPost.linkURl, (Select fieldName, id, newValue, oldValue from feedTrackedChanges) from ' + query;
      if(!cjs.Skip_Written_Posts__c)
      {
      	query = 'select id, type, feedpostID, createdByID, createdDate, feedpost.id, feedPost.Body, feedPost.linkURl from ' + query;
      	query += ' where type != \'TrackedChange\' and systemModstamp <= ' + sDateLimit;
      	feeds = database.query(query);
      	for(Sobject f : feeds)
      	{
        //build combo object
        comboList.add(new chatterPost(f, cjs.Skip_Tracked_Changes__c, cjs.Skip_Written_Posts__c));  
      	}
      }
      if(!cjs.Skip_Tracked_Changes__c)
      {
      	query = 'select id, type, createdDate, createdByID, (Select fieldName, id, newValue, oldValue from feedTrackedChanges) from ' + tablename;	
  	  	query += ' where type = \'TrackedChange\' and systemModstamp <= ' + sDateLimit;
  	  	ftcs = database.query(query);
  	  	
  	  	for(Sobject f : ftcs)
      {
        //build combo object
        comboList.add(new chatterPost(f, cjs.Skip_Tracked_Changes__c, cjs.Skip_Written_Posts__c));  
      }
      }
      
      
      
           
      
      
      
      
      
      //begin archival tracking
      if(cjs.email_archival__c && emailaddress != null)
      {
        
        //build the attachment file body for the email. CSV content.
        archival = true;
        attachmentBody += 'Object:,' + cjs.Object_Name__c + ',Cutoff Date:,' + dateLimit + '\n';
        attachmentBody += 'Feed ID, Post/Change Unique ID, Created Date, Creator Name, Object.Field changed, Field Old Value, Field New Value, Attached Link(If Any), Comment\n';
        
        for(ChatterPost f : comboList)
        {
          if(f.post != NULL)
            attachmentbody += f.feed.get('id') + ',' + f.post.id + ',' + f.feed.get('createdDate') + ',"' + f.feed.get('createdByID') + '",,,,"' + f.post.linkURL + '","' + string.valueOf(f.post.body).replace('\n', '') + '"\n';
          else if(f.ftc != NULL)
            attachmentbody += f.feed.get('id') + ',' + f.ftc.id + ',' + f.feed.get('createdDate') + ',"' + f.feed.get('createdByID') + '",' + f.ftc.fieldname + ',"' + string.valueOf(f.ftc.oldValue).replace('\n', '') + '","' + string.valueOf(f.ftc.newValue).replace('\n', '') +'",,\n';
            
        }
      }
      if(!cjs.Skip_Tracked_Changes__c)
      	database.delete(ftcs);
      if(!cjs.Skip_Written_Posts__c)
      	database.delete(feeds);  
    }
    
    
    //archive goes here
    if(archival)
      emailArchive(attachmentBody, emailAddress);
              
  }
  
  private static void emailArchive(string attachmentBody, string emailAddress){
    //Get content
    
    blob attachBody = Blob.valueOf(attachmentbody);
    //stuff into blob
    //send email with attachment
    
    Messaging.Singleemailmessage email = new Messaging.SingleEmailMessage();
    
    string[] emailAddys = new string[] {emailAddress};
    email.setToAddresses(emailAddys);
    email.setSubject('Chatter Post Archive data - ' + Date.Today());
    email.setPlainTextBody('Archive data for today attached.');
    
    
    
    Messaging.Emailfileattachment eAttach = new Messaging.Emailfileattachment();
    eAttach.setBody(attachBody);
    eattach.setContentType('text/csv');
    eAttach.setFileName('chatterarchival' + Date.today() + '.csv');
        
    email.setFileAttachments(new messaging.EmailFileAttachment[] {eAttach});
    
    messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    
    return; 
  }
  
      
  
  public chatterJanitor(){}
  
  public pageReference doWork(){ //used for testing purposes or immediate runs of janitor(cjTester)
    chatterJanitor.cleanHouse('cjimson@mailinator.com');
    return new pageReference('/home/home.jsp');
  }
  
}