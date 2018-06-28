/*********************************************************************
Name : Test_UpdateExistingLeadsAndContacts 
Created On : dec 19, 2011  
Created By : Lalit Bohra
Description : Test class on  Trigger on Lead UpdateExistingLeadsAndContacts 
**********************************************************************/
@isTest
private class Test_UpdateExistingLeadsAndContacts {

    static testMethod void myUnitTest() {  
       // TO DO: implement unit test
        User u=createUser();
        system.runAs(u){            
            Account acc= new Account();
            acc.Name='Test Acc'; 
            acc.ChannelType__c='Reseller';
            insert acc;
            
            list<Contact> ContactList= new list<Contact>(); 
            list<Lead> LeadList= new list<Lead>(); 
            
            Contact con= new Contact(); 
            con.LastName='Test con1';
            con.AccountId=acc.Id;
            con.Email='Testing@testsite.com'; 
            con.IM_USER_ID__c='TestUser Id11';
            
            Contact con1= new Contact(); 
            con1.LastName='Test con';
            con1.AccountId=acc.Id;
            con1.Email='Test1@testsite.com'; 
            con1.IM_USER_ID__c='TestUser Id1';
            
            Contact con2= new Contact(); 
            con2.LastName='Test con1';
            con2.AccountId=acc.Id;
            con2.Email='Contest@testsite.com'; 
            con2.IM_USER_ID__c='contact Id11';
            ContactList.add(con);
            ContactList.add(con1);
            ContactList.add(con2); 
            
            Contact con3= new Contact(); 
            con3.LastName='Test con11';
            con3.AccountId=acc.Id;
            con3.Email='Contest1@testsite.com'; 
            con3.IM_USER_ID__c='UserId';        
            ContactList.add(con3); 
            
            insert ContactList; 
            
            
            Lead objLead1= new Lead();
            objLead1.Phone='25678955';
            objLead1.Company='Test Company';
            objLead1.LastName='Test Lead';
            objLead1.Status='Open Working';
            objLead1.CurrencyIsoCode='USD';
            objLead1.IM_USER_ID__c='TestUser Id';
            ObjLead1.Email='Test@testsite.com';
            //ObjLead1.Chat_ID__c='1';
            ObjLead1.City='testcity';
            ObjLead1.Company_Name_Kana__c='t';
            ObjLead1.Country='a';
            ObjLead1.FirstName='fname';
            ObjLead1.IM_BILLTOFIRSTNAME__c='te';
            ObjLead1.IM_BILLTOLASTNAME__c='asdsd';
            ObjLead1.IM_COMPANY__c='jsdn';
            ObjLead1.Department__c='Quality';
            ObjLead1.IM_CREDITCARDONFILE__c=true;
            ObjLead1.IM_LOCATION__c='fdfs';
            ObjLead1.IM_PGI_ACCT_ID__c='asdasd';
            ObjLead1.IM_PGICLIENTID__c='sdsd';
            ObjLead1.IM_SALESREP_EMAIL__c='Testing@testsite.com';
            //ObjLead1.Disqual_Reason_Other__c='asas';
            ObjLead1.IM_AVGATTENDEES__c=1.0;
            //ObjLead1.Mail_ID__c='testmailid@yahoo.com';            
            ObjLead1.Description='asas';
            ObjLead1.Disqual_Reason_Other__c='asas';
            ObjLead1.IM_BILLINGSTARTDATE__c=date.today();
            ObjLead1.IM_CREDITCARDONFILE__c=false;
            ObjLead1.IM_LAST_IMEET_ROOM_LOGIN__c=date.today();
            ObjLead1.IM_LAST_ROOM_LOGIN__c=date.today();
            ObjLead1.IM_MAXATTENDEES__c=1.0;
            ObjLead1.IM_MEETINGSLAST30DAYS__c=1.0;
            ObjLead1.IM_MEETINGSLAST60DAYS__c=1.0;
            ObjLead1.IM_MEETINGSLAST90DAYS__c=1.0;
            ObjLead1.IM_MOSTRECENTMEETING__c=date.today();
            ObjLead1.IM_OFFEREXPIRES__c=date.today();
            ObjLead1.IM_PHONE_1__c='1234';
            ObjLead1.IM_PHONE_2__c='2345';
           // ObjLead1.IM_ROOM_URL__c='www.tests1.com';
            ObjLead1.IM_SIGN_UP_DATE__c=date.today();
            ObjLead1.IM_TEXT_NOTIFICATION__c='test1';
            ObjLead1.IM_TOTAL_MEETINGS__c=1.0;
            ObjLead1.IM_UPDATED_AT__c=date.today();
            ObjLead1.IM_USAGEDELETEDATE__c=date.today(); 
            ObjLead1.Company_Name_Kanji__c ='Test Kanji company';
            objLead1.IM_ACCOUNT_CANCELLED__c=date.today();
            objLead1.Industry__c='Other';
            objLead1.Notes__c='Test notes';
            objLead1.Number_of_Licenses_Users__c=1.0;
            objLead1.Omniture_Campaign_Code__c='Test Compaign 101';            
            objLead1.Product_Interest__c='Web : General';
            objLead1.Referring_URL__c='test url data';         
            objLead1.Channel__c=  'GCS Diamond';
            objLead1.TESLA_SALESMANAGER_ID__c='testsm2';
                
            Lead objLead2= new Lead();
            objLead2.Phone='25678955';
            objLead2.Company='Test Company2';
            objLead2.LastName='Test Lead2';
            objLead2.Status='Open Working';
            objLead2.CurrencyIsoCode='USD';
            objLead2.IM_USER_ID__c='TestUser Id11';
            ObjLead2.Email='Testing@testsite.com';
            ObjLead2.IM_AVGATTENDEES__c=1.0;  
            LeadList.add(ObjLead2);
             
            Lead objLead3= new Lead();
            objLead3.Phone='25678955';
            objLead3.Company='Test Company1';
            objLead3.LastName='Test Lead1';
            objLead3.Status='Open Working';
            objLead3.CurrencyIsoCode='USD';
            objLead3.IM_USER_ID__c='TestUser Id';
            ObjLead3.Email='Test@testsite.com';   
            ObjLead3.IM_AVGATTENDEES__c =1.0;       
            LeadList.add(ObjLead3);
            
            // below lead will be used to put values in contact object in trigger
            Lead objLead4= new Lead();
            objLead4.Phone='25678955';
            objLead4.Company='Test Company1';
            objLead4.LastName='Test Lead1';
            objLead4.Status='Open Working';
            objLead4.CurrencyIsoCode='USD';
            objLead4.IM_USER_ID__c='User Id1';
            ObjLead4.Email='Contest@testsite.com';     
            objLead4.IM_ACCOUNT_CANCELLED__c=date.today(); 
            ObjLead4.IM_BILLTOFIRSTNAME__c='te';
            ObjLead4.IM_BILLTOLASTNAME__c='asdsd';
            ObjLead4.IM_COMPANY__c='jsdn'; 
            ObjLead4.IM_CREDITCARDONFILE__c=true;
            ObjLead4.IM_LOCATION__c='fdfs';
            ObjLead4.IM_PGI_ACCT_ID__c='asdasd';
            ObjLead4.IM_PGICLIENTID__c='sdsd';
            ObjLead4.IM_SALESREP_EMAIL__c='asas';       
            ObjLead4.IM_AVGATTENDEES__c=1.0;
            ObjLead4.IM_BILLINGSTARTDATE__c=date.today();
            ObjLead4.IM_CREDITCARDONFILE__c=false;
            ObjLead4.IM_LAST_IMEET_ROOM_LOGIN__c=date.today();
            ObjLead4.IM_LAST_ROOM_LOGIN__c=date.today();
            ObjLead4.IM_MAXATTENDEES__c=1.0;
            ObjLead4.IM_MEETINGSLAST30DAYS__c=1.0;
            ObjLead4.IM_MEETINGSLAST60DAYS__c=1.0;
            ObjLead4.IM_MEETINGSLAST90DAYS__c=1.0;
            ObjLead4.IM_MOSTRECENTMEETING__c=date.today();
            ObjLead4.IM_OFFEREXPIRES__c=date.today();
            ObjLead4.IM_PHONE_1__c='1234';
            ObjLead4.IM_PHONE_2__c='2345';
            ObjLead4.IM_ROOM_URL__c='www.tests1.com';
            ObjLead4.IM_SIGN_UP_DATE__c=date.today();
            ObjLead4.IM_TEXT_NOTIFICATION__c='test1';
            ObjLead4.IM_TOTAL_MEETINGS__c=1.0;
            ObjLead4.IM_UPDATED_AT__c=date.today();
            ObjLead4.IM_USAGEDELETEDATE__c=date.today(); 
            LeadList.add(objLead4);
           
            
            Lead objLead5= new Lead();
            objLead5.Phone='25678955';
            objLead5.Company='Test Company5';
            objLead5.LastName='Test Lead5';
            objLead5.Status='Open Working';
            objLead5.CurrencyIsoCode='USD';                
            ObjLead5.IM_AVGATTENDEES__c=1.0;  
            ObjLead5.IM_SALESREP_EMAIL__c='testing@testsite.com';
            ObjLead5.TESLA_SALESMANAGER_ID__c='SalesMngr1';
            LeadList.add(ObjLead5);
            
            Lead objLead6= new Lead();
            objLead6.Phone='25678955';
            objLead6.Company='Test Company6';
            objLead6.LastName='Test Lead6';
            objLead6.Status='Open Working';
            objLead6.CurrencyIsoCode='USD';                
            ObjLead6.IM_AVGATTENDEES__c=1.0;  
            ObjLead6.IM_SALESREP_EMAIL__c='testing@testsite.com';
            ObjLead6.TESLA_SALESMANAGER_ID__c='SalesMngr1';
            ObjLead6.IM_USER_ID__c='UserId';
            ObjLead6.Email=null;
            LeadList.add(ObjLead6);
            
            test.startTest(); 
            insert LeadList;
            insert ObjLead1;
            
            //-----------
            con = [Select ID, IM_USER_ID__c, IM_AVGATTENDEES__c, IM_LOCATION__c, IM_PGI_ACCT_ID__c, IM_COMPANY__c, IM_BILLTOFIRSTNAME__c, IM_BILLTOLASTNAME__c 
                        from Contact where ID = :con.id];
            system.assertEquals(con.IM_USER_ID__c, ObjLead2.IM_USER_ID__c);
            system.assertEquals(con.IM_AVGATTENDEES__c, ObjLead2.IM_AVGATTENDEES__c);
            system.assertEquals(con.IM_LOCATION__c, ObjLead2.IM_LOCATION__c);
            system.assertEquals(con.IM_PGI_ACCT_ID__c, ObjLead2.IM_PGI_ACCT_ID__c);
            system.assertEquals(con.IM_COMPANY__c, ObjLead2.IM_COMPANY__c);
            system.assertEquals(con.IM_BILLTOFIRSTNAME__c, ObjLead2.IM_BILLTOFIRSTNAME__c);
            system.assertEquals(con.IM_BILLTOLASTNAME__c, ObjLead2.IM_BILLTOLASTNAME__c);
            
            con2 = [Select ID, IM_USER_ID__c, IM_AVGATTENDEES__c, IM_LOCATION__c, IM_PGI_ACCT_ID__c, IM_COMPANY__c, IM_BILLTOFIRSTNAME__c, IM_BILLTOLASTNAME__c 
                        from Contact where ID = :con2.id];
            system.assertEquals(con2.IM_USER_ID__c,         ObjLead4.IM_USER_ID__c);
            system.assertEquals(con2.IM_AVGATTENDEES__c,    ObjLead4.IM_AVGATTENDEES__c);
            system.assertEquals(con2.IM_LOCATION__c,        ObjLead4.IM_LOCATION__c);
            system.assertEquals(con2.IM_PGI_ACCT_ID__c,     ObjLead4.IM_PGI_ACCT_ID__c);
            system.assertEquals(con2.IM_COMPANY__c,         ObjLead4.IM_COMPANY__c);
            system.assertEquals(con2.IM_BILLTOFIRSTNAME__c, ObjLead4.IM_BILLTOFIRSTNAME__c);
            system.assertEquals(con2.IM_BILLTOLASTNAME__c,  ObjLead4.IM_BILLTOLASTNAME__c); 

            
            //Already Exist A lead with same IM_USER_ID__c and Email
           Lead lead = [Select ID, To_be_Deleted__c, //Chat_ID__c, Mail_ID__c,
             IM_USER_ID__c From Lead where ID = :ObjLead1.id];
            system.assertEquals(lead.To_be_Deleted__c, true);
           // system.assertEquals(lead.Chat_ID__c, ObjLead1.Chat_ID__c+'_Duplicate');
          //  system.assertEquals(lead.Mail_ID__c, ObjLead1.Mail_ID__c+'_Duplicate');
            system.assertEquals(lead.IM_USER_ID__c, ObjLead1.IM_USER_ID__c+'_Duplicate');
            
            //updated the existing contact with this lead information in system  
            lead = [Select ID, To_be_Deleted__c From Lead where ID = :ObjLead2.id];
            system.assertEquals(lead.To_be_Deleted__c, true);
            
            //No contact Updated
            lead = [Select ID, To_be_Deleted__c From Lead where ID = :ObjLead3.id];
            system.assertEquals(lead.To_be_Deleted__c, false);
            
            //updated the existing contact with this lead information in system 
            lead = [Select ID, To_be_Deleted__c From Lead where ID = :ObjLead4.id];
            system.assertEquals(lead.To_be_Deleted__c, true);
            
            //No contact Updated
            lead = [Select ID, To_be_Deleted__c From Lead where ID = :ObjLead5.id];
            system.assertEquals(lead.To_be_Deleted__c, false);
            
            //No contact Updated
            lead = [Select ID, To_be_Deleted__c From Lead where ID = :ObjLead6.id];
            system.assertEquals(lead.To_be_Deleted__c, false);
            //-----------
            
            test.stopTest();
            
            list<Lead> NewLeadList=[Select id,To_Be_Deleted__c from Lead where id =:ObjLead1.Id and To_Be_Deleted__c=true];
            
            if(NewLeadList != null && NewLeadList.size()==1){
                system.assert(true);
            }
            else{
                    system.assert(false);
            }     
        } 
    }
    
      public static User createUser() {
        // need to change these values
        List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
        String profileId = profiles.get(0).Id;
        User user = new User();
        user.Email = 'test.dummy.20110405@appirio.com';
        user.CommunityNickname = 'test.dummy.20110405@appirio.com';
        user.UserName = 'test.dummy.20110405@pgi.com';
        user.FirstName = 'Foo';
        user.LastName = 'Bar';
        user.Alias = 'foo';
        user.ProfileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';
        user.TESLA_SalesRep_Email__c ='testing@testsite.com';
        user.TESLA_SALESMANAGER_ID__c='testsm2';
        user.TESLA_SALESMANAGER_ID__c='SalesMngr1';
        insert user;
        return user;
    }
}