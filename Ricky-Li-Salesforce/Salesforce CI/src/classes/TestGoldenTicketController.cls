/*
 * Purpose: This class tests the insert and update of Golden Ticket 
 *
 */
@isTest
Public Class TestGoldenTicketController{
    
    /*
     * This method tests the Showing of the Golden ticket to the user and the manager
     */
    static testMethod void testShowGoldenTicket(){

       /* insert a user */       
       User a = new User();
       a.username = 'pqr@pqr.com';
       a.LastName = 'Test';
       a.Email = 'p@p.com';
       a.alias = 'p';
       a.TimeZoneSidKey='GMT';
       a.LocaleSidKey='en_CA';
       a.ProfileId='00e30000001nP3JAAU';
       a.EmailEncodingKey='ISO-8859-1';
       a.LanguageLocaleKey='en_US';
       a.ManagerId = '00530000005Y2aS';
       insert a;
       
       List <User> listUsers = [Select ManagerId, Attending_GStock__c from user where id =: a.Id];
       listUsers[0].Attending_GStock__c = true;
       update listUsers;
        
        // User Asserts
        List <PermissionSet> listPS = [Select id from PermissionSet where Name = 'Golden_Ticket'];
        List <PermissionSetAssignment> listPSA = [Select Id, AssigneeId from PermissionSetAssignment where PermissionSetId =: listPS[0].id and AssigneeId=:a.Id];
        String AssigneeId = listPSA[0].AssigneeId;
        System.assertEquals(a.Id, AssigneeId);
        System.assertEquals(listPSA.size(), 1);
        
        // Manager Asserts
        List <PermissionSet> listPSManager = [Select id from PermissionSet where Name = 'Golden_Ticket_Manager'];
        List <PermissionSetAssignment> listPSAManager = [Select Id, AssigneeId from PermissionSetAssignment where PermissionSetId =: listPSManager[0].id and AssigneeId=:a.ManagerId];
        String AssigneeIdManager = listPSAManager[0].AssigneeId;
        System.assertEquals(a.ManagerId, AssigneeIdManager);
        System.assertEquals(listPSAManager.size(), 1);
        
        /*
        Golden_Ticket__c gt = new Golden_Ticket__c(Name=userName, User__c=userId);
        insert gt;
        
        gt.Request_Different_Dates__c = true;
        update gt;*/

    }
    
    /*
     * This test class below tests GoldenTicket visualforce pages main controller
     * Name: GoldenTicket_Controller
     */
    static testmethod void testGoldenTicket_Toronto(){
       
       /*User a = new User();
       a.username = 'pqr@pqr.com';
       a.FirstName = 'Testing';
       a.LastName = 'Test';
       a.Email = 'p@p.com';
       a.alias = 'p';
       a.TimeZoneSidKey='GMT';
       a.LocaleSidKey='en_CA';
       a.ProfileId='00e30000001nP3JAAU';
       a.EmailEncodingKey='ISO-8859-1';
       a.LanguageLocaleKey='en_US';
       a.ManagerId = '00530000005Y2aS';
       insert a;
       
       Golden_Ticket__c gt = new Golden_Ticket__c(Name=a.FirstName + '' + a.LastName, User__c = a.Id);
       insert gt;
       
       gt.Arrival_Date__c = Date.parse('18/09/2013');
       gt.Departure_Date__c = Date.parse('27/09/2013');
       gt.Date_Change_Reason__c = 'Testing';
       gt.Standard_Stay__c = false;
       update gt;*/
       
       Golden_Ticket__c gt = new Golden_Ticket__c(Name=userInfo.getName(), User__c=userinfo.getUserId(), Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'),isComing__c = true, 
                                                   ownerId=userinfo.getUserId());
       insert gt;
       
       GoldenTicket_Controller gtc = new GoldenTicket_Controller();
       gtc.Criteria = 'Yes';
       gtc.GettingToNiagara = 'Bus';
       gtc.NightsStaying = 'Thursday Only';
       gtc.getUser();
       gtc.getUserName();
       gtc.MainRenderer();
       gtc.getDiet();
       gtc.getTransportation();
       gtc.getNightsInNiagara();
       gtc.getSelectItems();
       gtc.setHideShowOutsiders(true);
       gtc.getHideShowOutsiders();
       gtc.getHideShowToronto();
       gtc.getShowCommonQuestions();
       gtc.updateModel();

       //Assert
       System.AssertEquals('2013-09-27', String.valueOf(gt.Departure_Date__c));
       System.AssertEquals('2013-09-18', String.valueOf(gt.Arrival_Date__c));
       System.AssertEquals(true, gt.isComing__c);
       
    }
    
    /*
     * This test class below tests GoldenTicket visualforce pages main controller
     * Name: GoldenTicket_Controller 
     */
     static testmethod void testGoldenTicket_Outsiders(){
     
       User a = new User();
       a.username = 'pqrs@pqr.com';
       a.FirstName = 'Testing';
       a.LastName = 'Test';
       a.Email = 'ps@ps.com';
       a.alias = 'ps';
       a.TimeZoneSidKey='GMT';
       a.LocaleSidKey='en_CA';
       a.ProfileId='00e30000001nP3JAAU';
       a.EmailEncodingKey='ISO-8859-1';
       a.LanguageLocaleKey='en_US';
       a.ManagerId = '00530000005Y2aS';
       a.City='Ottawa';
       insert a;
       
       
       
    System.RunAs(a) {  
       Golden_Ticket__c gt1 = new GOlden_Ticket__c(Name=userinfo.getUserName(), User__c=userInfo.getUserId(), Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'), Date_Change_Reason__c = 'Testing', 
                                                   ownerId=userinfo.getUserId(), isComing__c = true);
       insert gt1;
       
       GoldenTicket_Controller gtc = new GoldenTicket_Controller();
              System.Debug('GTC'+gtc);
       gtc.Criteria = 'Yes';
       gtc.GettingToNiagara = 'Bus';
       gtc.NightsStaying = 'Thursday Only';
       gtc.NightsStaying = null;
       gtc.StandardDates = 'true';
       gtc.Outsiders_StartDate = '17/09/2013';
       gtc.Outsiders_EndDate = '28/09/2013';
       gtc.Passport_DOB = '10/10/2010';
       gtc.Passport_DOB = '10/10/1900';
       gtc.getUser();
       gtc.getUserName();
       gtc.MainRenderer();
       gtc.getDiet();
       gtc.getTransportation();
       gtc.getNightsInNiagara();
       gtc.getSelectItems();
       gtc.setHideShowOutsiders(true);
       gtc.getHideShowOutsiders();
       gtc.getHideShowToronto();
       gtc.getShowCommonQuestions();
       gtc.updateModel();
               System.Debug('GTC'+gtc);
               System.Debug('GT'+gt1);
     
       //Asserts
       System.AssertEquals(gt1.ownerId,userinfo.getUserId());
       System.AssertEquals('2013-09-27', String.valueOf(gt1.Departure_Date__c));
       System.AssertEquals('2013-09-18', String.valueOf(gt1.Arrival_Date__c));
     
     }
   
   }
   
   /*
     * This test class below tests GoldenTicket visualforce pages main controller
     * Name: GoldenTicket_Controller 
     */
     static testmethod void testGoldenTicket_Null(){
     
       User a = new User();
       a.username = 'pqrs@pqr.com';
       a.FirstName = 'Testing';
       a.LastName = 'Test';
       a.Email = 'ps@ps.com';
       a.alias = 'ps';
       a.TimeZoneSidKey='GMT';
       a.LocaleSidKey='en_CA';
       a.ProfileId='00e30000001nP3JAAU';
       a.EmailEncodingKey='ISO-8859-1';
       a.LanguageLocaleKey='en_US';
       a.ManagerId = '00530000005Y2aS';
       a.City='Ottawa';
       insert a;
       
       
       
    System.RunAs(a) {  
       Golden_Ticket__c gt1 = new GOlden_Ticket__c(Name=a.Name, User__c=a.Id, Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'), Date_Change_Reason__c = 'Testing', 
                                                   ownerId=userinfo.getUserId(), isComing__c = true);
       insert gt1;
       
       GoldenTicket_Controller gtc = new GoldenTicket_Controller();
       gtc.Criteria = 'Yes';
       gtc.GettingToNiagara = null;
       gtc.NightsStaying = null;
       gtc.StandardDates = null;
       gtc.DietRequests = 'Vegetarian';
       gtc.Passport_FullName = '';
       gtc.Passport_Nationality = '';
       gtc.DepartureCity = '';
       gtc.ReturnCity = '';
       gtc.RoomiePreference = 'Yes';
       gtc.Passport_DOB = '10-10-2010';
       gtc.Passport_DOB = 'dd/MM/YYYY';
       gtc.getUser();
       gtc.getUserName();
       gtc.MainRenderer();
       gtc.getDiet();
       gtc.getTransportation();
       gtc.getNightsInNiagara();
       gtc.getSelectItems();
       gtc.setHideShowOutsiders(true);
       gtc.getHideShowOutsiders();
       gtc.getHideShowToronto();
       gtc.getShowCommonQuestions();
       gtc.updateModel();
       
     }
   
   }
   
   static testmethod void testGoldenTicket_FalsePositives(){
     
       User a = new User();
       a.username = 'pqrs@pqr.com';
       a.FirstName = 'Testing';
       a.LastName = 'Test';
       a.Email = 'ps@ps.com';
       a.alias = 'ps';
       a.TimeZoneSidKey='GMT';
       a.LocaleSidKey='en_CA';
       a.ProfileId='00e30000001nP3JAAU';
       a.EmailEncodingKey='ISO-8859-1';
       a.LanguageLocaleKey='en_US';
       a.ManagerId = '00530000005Y2aS';
       a.City='Ottawa';
       insert a;
       
       
       
    System.RunAs(a) {  
       Golden_Ticket__c gt1 = new GOlden_Ticket__c(Name=a.Name, User__c=a.Id, Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'), Date_Change_Reason__c = 'Testing', 
                                                   ownerId=userinfo.getUserId(), isComing__c = true);
       insert gt1;
       
       GoldenTicket_Controller gtc = new GoldenTicket_Controller();
       gtc.Criteria = 'Yes';
       gtc.GettingToNiagara = null;
       gtc.NightsStaying = null;
       gtc.StandardDates = 'false';
       gtc.DietRequests = 'Vegetarian';
       gtc.RoomiePreference = 'false';
       gtc.ExploreNiagara = 'Yes';
       gtc.getUser();
       gtc.getUserName();
       gtc.MainRenderer();
       gtc.getDiet();
       gtc.getTransportation();
       gtc.getNightsInNiagara();
       gtc.getSelectItems();
       gtc.setHideShowOutsiders(true);
       gtc.getHideShowOutsiders();
       gtc.getHideShowToronto();
       gtc.getShowCommonQuestions();
       gtc.updateModel();
     }
   
   }
   
   /*
    * This method will pass in the real values to the Controller
    * Criteria is Yes and isBaseCamper Yes 
    */
      static testmethod void testGoldenTicket_RealValues(){
     
       User b = new User();
       b.username = 'pqrst@pqr.com';
       b.FirstName = 'Testinga';
       b.LastName = 'Test';
       b.Email = 'psb@psb.com';
       b.alias = 'psb';
       b.TimeZoneSidKey='GMT';
       b.LocaleSidKey='en_CA';
       b.ProfileId='00e30000001nP3JAAU';
       b.EmailEncodingKey='ISO-8859-1';
       b.LanguageLocaleKey='en_US';
       b.ManagerId = '00530000005Y2aS';
       b.City='Ottawa';
       insert b;
   
       System.Debug(b.Name);
       
       
  System.RunAs(b) {  
       Golden_Ticket__c gt1 = new GOlden_Ticket__c(Name=b.FirstName, User__c=b.Id, Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'), Date_Change_Reason__c = '', status__c='unconfirmed');
       insert gt1;
       
       System.Debug('Real values is getting called');
       System.Debug(gt1.Name);
       System.DEbug(gt1.isBaseCamper__c);
       System.Debug(gt1.Status__c);
       GoldenTicket_Controller gtc = new GoldenTicket_Controller();
       gtc.Criteria = 'Yes';
       gt1.isComing__c = true;
       gtc.StandardDates = 'true';
       gtc.Passport_FullName = 'Test';
       gtc.Passport_DOB = '12/12/1990';
       gtc.Passport_Nationality = 'Canada';
       gtc.TravelThroughUS = 'Yes';
       gtc.Smoker = 'true';
       gtc.RoomiePreference = 'false';
       gtc.ExploreNiagara = 'Yes';
       gtc.DietRequests = 'None';
       gtc.GettingToNiagara = 'Bus';
       gtc.NightsStaying = 'None';
       gt1.Status__c = 'Confirmed';
       gtc.getUser();
       gtc.getUserName();
       gtc.MainRenderer();
       gtc.getDiet();
       gtc.getTransportation();
       gtc.getNightsInNiagara();
       gtc.getSelectItems();
       gtc.setHideShowOutsiders(true);
       gtc.getHideShowOutsiders();
       gtc.getHideShowToronto();
       gtc.getShowCommonQuestions();
       gtc.updateModel();
       System.Debug(gtc);
       System.Debug(gt1);
       
       //Assert
       System.AssertEquals(true, gt1.isComing__c);
       System.AssertEquals('Confirmed', gt1.Status__c);
       
     }
   }
   
   static testmethod void testGoldenTicket_RealValuesApproval(){
     
       User c = new User();
       c.username = 'pt@pqr.com';
       c.FirstName = 'Testinga';
       c.LastName = 'Test';
       c.Email = 'sb@psb.com';
       c.alias = 'psban';
       c.TimeZoneSidKey='GMT';
       c.LocaleSidKey='en_CA';
       c.ProfileId='00e30000001nP3JAAU';
       c.EmailEncodingKey='ISO-8859-1';
       c.LanguageLocaleKey='en_US';
       c.ManagerId = '00530000005Y2aS';
       c.City='Manila';
       insert c;
   
       System.Debug(c.Name);
       
       
  System.RunAs(c) {  
       Golden_Ticket__c gt1 = new GOlden_Ticket__c(Name=c.FirstName, User__c=c.Id, Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('25/09/2013'), Date_Change_Reason__c = 'testing', Request_Different_Dates__c= true);
       insert gt1;
       
       System.Debug(gt1.Name);
       System.DEbug(gt1.isBaseCamper__c);
       System.Debug(gt1.Status__c);
       GoldenTicket_Controller gtc = new GoldenTicket_Controller();
       gtc.Criteria = 'Yes';
       gt1.isComing__c = true;

       gtc.StandardDates = 'false';
       gtc.Outsiders_StartDate = '21/10/2013';
       gtc.Outsiders_EndDate = '31/10/2013';
       gtc.Outsiders_DateChangeReason = 'Test';
       gtc.Passport_FullName = 'Test';
       gtc.Passport_DOB = '12/12/1990';
       gtc.Passport_Nationality = 'Canada';
       gtc.TravelThroughUS = 'Yes';
       gtc.Smoker = 'true';
       gtc.RoomiePreference = 'false';
       gtc.ExploreNiagara = 'Yes';
       gtc.DietRequests = 'None';
       gt1.Status__c = 'Approved By Manager';
 //      gtc.GettingToNiagara = 'Bus';
 //      gtc.NightsStaying = 'None';
       gtc.getUser();
       gtc.getUserName();
       gtc.MainRenderer();
       gtc.getDiet();
       gtc.getTransportation();
       gtc.getNightsInNiagara();
       gtc.getSelectItems();
       gtc.setHideShowOutsiders(true);
       gtc.getHideShowOutsiders();
       gtc.getHideShowToronto();
       gtc.getShowCommonQuestions();
       gtc.updateModel();
       
       System.DEbug('This is gt1'+ gt1);
 
       //Assert
       System.ASsertEquals('Approved By Manager', gt1.Status__c);
       
     }
   }
     
}