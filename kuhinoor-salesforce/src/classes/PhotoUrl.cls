Public class PhotoUrl
{
    public string Photolink{get;set;}
    Public String profileid{get;set;}
    Public String companyName{get;set;}
    Public String usertype{get;set;}
    Public String sessionid{get;set;}
    Public PhotoUrl(){
     
          
          
       }
       public pageReference check(){
       PageReference pageRef;
           if(UserInfo.getSessionId()!=null){
                    
                profileid= UserInfo.getProfileId();
                companyName=UserInfo.getOrganizationName();
                usertype=UserInfo.getUserType();
                sessionid=UserInfo.getSessionId();
                User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:Userinfo.getUserid()];
                Photolink = u.FullPhotoUrl;
              }else{
                pageRef = new PageReference('https://login.salesforce.com/');
                profileid= UserInfo.getProfileId();
                companyName=UserInfo.getOrganizationName();
                usertype=UserInfo.getUserType();
                sessionid=UserInfo.getSessionId();
                User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:Userinfo.getUserid()];
                Photolink = u.FullPhotoUrl;
                
              }
              return new PageReference('/apex/PhotoUrlpages');
       } 
      
}