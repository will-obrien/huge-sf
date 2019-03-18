@isTest
public class ValidateChatterPost_Test {
    public static testMethod void testValidateThePost()
    {
        Blacklisted__c  bc=new Blacklisted__c(Name='shit');
        insert bc;  
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        System.runAs(thisUser) {
            FeedItem post2=new FeedItem();
            post2.ParentId='00528000001G7YY';
            post2.Title = 'this is titke';
            post2.Body = 'this is body';
            insert post2;
            
            FeedItem fi = [SELECT Id, Title, Body FROM FeedItem where Id=:post2.Id];   
            fi.Body='to update post';
            update fi;
        }
           
    }

}