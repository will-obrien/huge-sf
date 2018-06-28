global without sharing class authPage{

  
 public PageReference forwardToStartPage() {
        String communityUrl = 'https://build-garpbuild.cs16.force.com/apex/sfdcApp#!/';
        String customHomePage = '_ui/core/chatter/ui/ChatterPage';
    if (UserInfo.getUserType().equals('Guest')) {
        return new PageReference(communityUrl + 'CustomLogin');
    } else {
        return new PageReference(communityUrl + customHomePage);
        }
    }
 
   
    global PageReference auth() {
        
        //String un = ApexPages.currentPage().getParameters().get('username');
        //String pwd = ApexPages.currentPage().getParameters().get('password');
        
        String un = 'patelr101@outlook.com';
        String pwd = 'GARP2014';
        
        return Site.login(un, pwd, null);
        
        
        
    }
    
}