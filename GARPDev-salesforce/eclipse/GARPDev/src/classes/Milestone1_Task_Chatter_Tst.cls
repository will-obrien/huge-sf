@isTest
private class Milestone1_Task_Chatter_Tst 
{
    static testMethod void testChatterTaskFollows()
    {
        Milestone1_Test_Utility.createDefaultCustomChatterSettings();
        
        Milestone1_Project__c testProject = Milestone1_Test_Utility.sampleProject('UNIT TEST PROJECT NAME ABC123XYZ UNIQUE' + System.now());
        insert testProject;
        
        Milestone1_Milestone__c testMilestone = Milestone1_Test_Utility.sampleMilestone(testProject.Id,null,'UNIT TEST MILESTONE NAME ACB123XYZ UNIQUE' + System.now());
        insert testMilestone;

        Milestone1_Task__c testTask = Milestone1_Test_Utility.sampleTask(testMilestone.Id);
        testTask.Assigned_To__c = UserInfo.getUserId();
        testTask.Complete__c = false;
        insert testTask;
        
        EntitySubscription subscription = [Select Id, ParentId, SubscriberId from EntitySubscription where ParentId =: testTask.Id];
        //assert that the user is following this object
        system.assertEquals(UserInfo.getUserId(),subscription.SubscriberId);
        
        testTask.Complete__c = true;
        update testTask;
        
        List<EntitySubscription> subscriptionList = [Select Id, ParentId, SubscriberId from EntitySubscription where ParentId =: testTask.Id];
        //assert that no one is following this object after its marked as complete
        system.assertEquals(0,subscriptionList.size());
        
    }
    
    static testMethod void testChatterTaskReassignment()
    {
       // List<User> otherUserList = [Select Id from User where Id <> :UserInfo.getUserId() limit 1];
        List<User> otherUserList = [Select Id from User where Id <> :UserInfo.getUserId() and IsActive = true limit 1];
        User otherUser = null;
        //if(otherUserList.size() == 0)
        if(otherUserList.size() == 0)
        {
            List<Profile> prof = [Select Id from Profile limit 1]; 
            otherUser = new User(Alias='testxyz1',emailencodingkey='UTF-8', languagelocalekey='en_US',timezonesidkey='America/Los_Angeles',  CommunityNickname='XYZTEST12301', FirstName='Test Account', LastName='LastName', Email='testaccountxzy@testfacke123.com', username='UnitTest123fake@testfake.com',localesidkey='en_US', ProfileId=prof.get(0).Id);
            insert otherUser;
        }else
        {
            otherUser = otherUserList.get(0);
        }
        Milestone1_Test_Utility.createDefaultCustomChatterSettings();
        
        Milestone1_Project__c testProject = Milestone1_Test_Utility.sampleProject('UNIT TEST PROJECT NAME ABC123XYZ UNIQUE' + System.now());
        insert testProject;
        
        Milestone1_Milestone__c testMilestone = Milestone1_Test_Utility.sampleMilestone(testProject.Id,null,'UNIT TEST MILESTONE NAME ACB123XYZ UNIQUE' + System.now());
        insert testMilestone;

        Milestone1_Task__c testTask = Milestone1_Test_Utility.sampleTask(testMilestone.Id);
        testTask.Assigned_To__c = UserInfo.getUserId();
        testTask.Complete__c = false;
        insert testTask;
        
        EntitySubscription subscription = [Select Id, ParentId, SubscriberId from EntitySubscription where ParentId =: testTask.Id];
        //assert that the user is following this object
        system.assertEquals(UserInfo.getUserId(),subscription.SubscriberId);
        system.debug('Other User Id == ' + otherUser.Id + 'Task Assigned Id ==' + testTask.Assigned_To__c);
        testTask.Assigned_To__c = otherUser.Id;
        update testTask;
        
        List<EntitySubscription> subscriptionList = [Select Id, ParentId, SubscriberId from EntitySubscription where ParentId =: testTask.Id and SubscriberId =: UserInfo.getUserId()];
        //assert that no one is following this object after its marked as complete
        system.assertEquals(0,subscriptionList.size());
        
    }
    

}