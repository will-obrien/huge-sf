/* 
 * This test class checks for the JSON returned by the getJSON method
 */

@isTest
Public Class TestGNationGroupUpdateObject{

  static testmethod void TestGroupUpdateObject(){
    
    String fromName = 'Subodh';
    String fromId = '';
    String toName = 'GStock13';
    String toId = '';
    String message = 'GStock is going to be awesome';
    String PhotoUrl = '';
    String timeDiff = '2';
    String GroupId = '';
    String ChatterImageURL = '';
    String ChatterImageURLBig = '';
    String Title = '';
    String Type = ''; 
    String BadgeName = '';
    Boolean isComment = false;
    String badgeRecipient = '';
    
    Test.startTest();
        GNationGroupUpdateObject gguo = new GNationGroupUpdateObject(fromName,fromId, toName, toId, message, PhotoUrl, timeDiff, GroupId, ChatterImageURL, ChatterImageURLBig, Title, Type, BadgeName, isComment, badgeRecipient); 
        gguo.getFromLink();
        gguo.getToLink();
        gguo.getJSON();
    Test.stopTest();   
    
    //Asserts
    System.AssertEquals(gguo.getJSON(), 'feed= { "fromName": "Subodh", "fromId": "/_ui/core/userprofile/UserProfilePage?u=" , "toName" : "GStock13", "toId" : "/_ui/core/chatter/groups/GroupProfilePage?g=", "message" : "GStock is going to be awesome", "photourl" : "", "time" : "2", "Image" : "", "ImageBig" : "", "Title" : "", "Type" : "", "BadgeName" : "", "isComment" : "false", "badgeRecipient" : ""}');
  }
}