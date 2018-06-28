public class CommunityUtils
{

    public static boolean bIsRecusrsive = false;

    public static void createCommunityUser(List<Contact> lstCon)
    {
    
        bIsRecusrsive = true;
        List<User> userList=new List<User>();
        User mockUser ;
        Profile pf = [SELECT Id FROM profile WHERE name='Customer Community' limit 1];
        set< id > contactIDs = new set< id >() ;     
        set< id > usersContactIDs  = new set< id >() ; 
        set< string > contactEmails  = new set< string >() ; 
        for ( Contact c : lstCon ) 
        {
         system.debug('Contact :'+c);
          system.debug('Contact Fire Flag:'+c.do_not_fire__c);
         if(c.do_not_fire__c == false)
                  contactIDs.add(c.id);
        }

        if(contactIDs.isEmpty()) return;
          
        map< id, string > contactid2AccountUserRole = new map< id, string > () ;
        Id memberRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        Set<String> setEmails = new Set<String>();
        for( User u : [select id,username,ContactId from User where ContactId IN :contactIDs] )
        {
            setEmails.add(u.username);
            usersContactIDs.add( u.ContactId ) ;
        }
    
  
      Set<Id> setAccountIds = new Set<Id>();

      for (Contact con:lstCon){
        system.debug('con == '+con);
        system.debug('usersContactIDs == '+usersContactIDs);
        system.debug('contactEmails == '+contactEmails);
        //system.debug('setAccountIds == '+setAccountIds);
        if (con.recordTypeId == memberRecordTypeId && (! usersContactIDs.contains(con.id)) && (!contactEmails.contains( con.Email) )) {
          mockUser=new User();
          mockUser.contactId=con.Id;
          /*if(setEmails.contains(con.email))
               mockUser.username = con.emai
               l;
          else*/
            if(Test.isrunningtest())
            mockUser.username = con.Email + '.' + string.valueof(Math.random()).substring(4,9) ;   
          else
              mockUser.username= con.Email;
          mockUser.firstname=con.FirstName;
          mockUser.lastname=con.LastName;
          mockUser.email=con.Email;
            if(Test.isrunningtest())
            mockUser.alias = con.LastName.substring(0,1) + string.valueof(Math.random()).substring(4,9) ;   
          else
            mockUser.communityNickname = con.GARP_Member_ID__c + string.valueof(Math.random()).substring(4,9);
          if(Test.isrunningtest())
            mockUser.alias = con.LastName.substring(0,1) + string.valueof(Math.random()).substring(4,9) ;   
          else
            mockUser.alias = con.GARP_Member_ID__c + string.valueof(Math.random()).substring(7,9);
            mockUser.Password__c = con.Password__c;
          mockUser.profileid = pf.Id;
          mockUser.emailencodingkey='UTF-8';
          mockUser.languagelocalekey='en_US';
          mockUser.localesidkey='en_US';
          mockUser.timezonesidkey='America/New_York';             
          Database.DMLOptions dlo = new Database.DMLOptions();
          dlo.EmailHeader.triggerUserEmail = true;
          dlo.EmailHeader.triggerAutoResponseEmail= true;
          mockUser.setOptions(dlo);   
          userList.add(mockUser); 
          system.debug('mockUser == '+mockUser);
          contactEmails.add(con.Email);   
          //setAccountIds.add(con.accountId);
   
    }  
  }
  if(userList.size() > 0)
  {
     system.debug('userList == '+userList);
     insert userList;
     /*Database.SaveResult[] srList = Database.insert(userList, false); //insert userList;
     // Iterate through each returned result
    for (Database.SaveResult sr : srList) {
        if (!sr.isSuccess()) {
            system.debug();
            for(Database.Error err : sr.getErrors()) {
                if(err.getStatusCode().indexOf('DUPLICATE_USERNAME') >= 0)
                {


                }
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Fields that affected this error: ' + err.getFields());
            }
        }
      }*/
  }
  else
    bIsRecusrsive = false;
                    
    
    }

    public void generateUserName(String strEmail)
    {
        //String strVal = strEmail.subString

    }
}