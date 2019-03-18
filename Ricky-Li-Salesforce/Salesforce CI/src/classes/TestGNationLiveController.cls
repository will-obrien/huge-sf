/*
 *
 */
 
@isTest
public Class TestGNationLiveController{
    
    
    /* This Method: 1. Tests that the custom setting has no group Id
     *              2. Tests that there is no posts in the group
     *
     */
   static testmethod void TestControllerNegative(){
     User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
         
         System.runAs( thisUser ){
            GNationLive__c mycs = GNationLive__c.getValues('Group_Name__c');
            if(mycs == null) {
                mycs = new GNationLive__c(Name='GNation Live');
                insert mycs;
            }
         }
                     
     Test.startTest();
       GNationLiveController GNLC = new GNationLiveController();
       GNLC.getGNationLivePosts();
       GNLC.RefreshPosts();
       GNLC.getRefreshTime();
     Test.stopTest(); 
     
     /* This method should return 1. Null
      *                           2. Why? Since there are now feeds in the Chatter Group in the custom settings
      */ 
   }
   
   /* This method: 1. Tests the positive scenarios of the feed i.e. there are feeds 
    *              2. This also tests the attachment of an image to the feed.
    */
   
   static testmethod void TestControllerPositive(){
       //Get the current User's Id
       Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
   	   User newUser = new User(LastName='Testing12345', Alias='standt', Email='testUser1@test.com', EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', ProfileId=p.Id, UserName='standarduser12345@testorg.com');   	 
   	   insert newUser;
       User thisUser = [ Select Id from User where Username = 'standarduser12345@testorg.com' limit 1];   
       
       //Create a group
       CollaborationGroup CollaborationGroup  = new CollaborationGroup(Name='Group1234');
       CollaborationGroup.CollaborationType = 'Public';
       insert CollaborationGroup;
       
       //Add a member to the group
       CollaborationGroupMember member = new CollaborationGroupMember();
       member.memberid = thisUser.id;
       member.CollaborationGroupId = CollaborationGroup.Id;
       insert member;
       
       //Add the group to GNationConfigure
       GNationLive__c GNationLive = new GNationLive__c(Name=CollaborationGroup.Name,Group_Id__c=CollaborationGroup.Id,refresh_time__c=5);       
       insert GNationLive;
       
       //Create an account which will be the Parent Id for the attachment
       Account acc = new Account(Salutation='Mr.', LastName = 'Bahl', BillingCountry = 'Canada');
       insert acc;
       
       PageReference Image = new PageReference('http://stuffpoint.com/lamborghini/image/thumb/43918-lamborghini-lamborghini.jpg');
       Blob body;
       body = !Test.isRunningTest() ? Image.getContent() : Blob.ValueOf('dummy text');
       
       // Create the attachment
       Attachment ImageAttachment = new Attachment();
       ImageAttachment.Body = body;
       ImageAttachment.Name = 'Test.png';
       ImageAttachment.ParentId = acc.id;
       insert ImageAttachment;
       
       //Create a FeedItem
       FeedItem feed = new FeedItem(Body='Hello', ParentId=CollaborationGroup.Id, createdDate=Date.ValueOf('2013-03-18T18:42:49.000'));
       feed.Type = 'ContentPost';
       feed.ContentData = body;
       feed.ContentFileName = 'Testing.png';
       insert feed;
       
       //Create a FeedComment
       FeedComment fcomment = new FeedComment();
	   fcomment.FeedItemId = feed.Id;
	   fcomment.CommentBody = 'Feed Comment';	   
	   insert fcomment;
       
       
       //Feed with body > 400 Characters
       FeedItem feed1 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Date.ValueOf('2013-03-20T18:42:49.000'));
       feed1.body='12345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910'+
       '12345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789'+
       '12345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910'+
       '1234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910'+
       '12345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910'+
       '12345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910123456789101234567891012345678910'+
       '1234567891012345678910123456789101234567891012345678910123456789101012345678910';
       insert feed1;
       
       //Feed with CreatedTime rightnow
       FeedItem feed2 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now(), body='Hello');
       insert feed2;
       
       //Feed with CreatedTime - 60seconds
       FeedItem feed3 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addSeconds(-70), body='Hello');
       insert feed3;
       
       //Feed with CreatedTime - 2 mins
       FeedItem feed4 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addSeconds(-120), body='Hello');
       insert feed4;
       
       //Feed with CreatedTime - 10 mins
       FeedItem feed5 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addSeconds(-600), body='Hello');
       insert feed5;
       
       //Feed with CreatedTime > 1 hour && less than 2 hours
       FeedItem feed6 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addSeconds(-3700), body='Hello');
       insert feed6;
       
       //Feed with CreatedTime > 2 hours && less than 24 hours
       FeedItem feed7 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addSeconds(-7700), body='Hello');
       insert feed7;
       
       //Feed with CreatedTime == 24 hours 
       FeedItem feed8 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addSeconds(-86400), body='Hello');
       insert feed8;
       
       //Feed with CreatedTime > 24 hours && 48 hours
       FeedItem feed9 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addSeconds(-95000), body='Hello');
       insert feed9;
       
       //Feed with CreatedTime == 48 hours
       FeedItem feed10 = new FeedItem(ParentId=CollaborationGroup.Id, createdDate=Datetime.now().addDays(-3), body='Hello');
       insert feed10;
       
         System.runAs( thisUser ){
            GNationLive__c mycs = GNationLive__c.getValues('Group_Name__c');
            if(mycs == null) {
                mycs = new GNationLive__c(Name='GNation Live');
                mycs.Group_Id__c = CollaborationGroup.Id;
                mycs.Refresh_Time__c = 5;
                insert mycs;
            }
         }
         
                     
     Test.startTest();
       GNationLiveController GNLC = new GNationLiveController();
       GNLC.getGNationLivePosts();
       GNLC.RefreshPosts();
       GNLC.getRefreshTime();
     Test.stopTest();  
   
      //Asserts
      System.AssertEquals(5, GNLC.getRefreshTime());
   }
   
}