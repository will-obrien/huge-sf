@isTest
public class ChatterProfile_test {

  
    static testMethod void unitTest_1(){
        user user = new user(id= userinfo.getUserId()); 
        ApexPages.currentPage().getParameters().put('sfdc.userId',userinfo.getUserId());
        ChatterProfile chatter = new chatterProfile(new ApexPages.StandardController(user));
        chatter.save();
        chatter.cancel();
    }
    
}