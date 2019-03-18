/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_AccountStamper {
    

 static testMethod void testStamper1() {
        Account testAccount = new Account();
        testAccount.Name = 'test acct';
        insert testAccount;
        
        Webinar_Credentials__c webinarcredential1 = new Webinar_Credentials__c();
        webinarcredential1.name = 'Options';
        webinarcredential1.Credentials_ID__c = '1';
        webinarcredential1.Org_ID__c = 'testcred1';
        webinarcredential1.Token__c = 'testtoken1';
        webinarcredential1.Mnemonic__c = 'testmnemonic1';
        webinarcredential1.StampType__c = 'Ultimate Options Course';
        insert webinarcredential1;
        
        Webinar_Credentials__c webinarcredential2 = new Webinar_Credentials__c();
        webinarcredential2.name = 'LMFS';
        webinarcredential2.Credentials_ID__c = '2';
        webinarcredential2.Org_ID__c = 'testcred2';
        webinarcredential2.Token__c = 'testtoken2';
        webinarcredential2.Mnemonic__c = 'testmnemonic2';
        webinarcredential2.StampType__c = 'Live Market Forex Session';
        insert webinarcredential2;      
        
        Webinar_Credentials__c webinarcredential3 = new Webinar_Credentials__c();
        webinarcredential3.name = 'UTP OnDemand';
        webinarcredential3.Credentials_ID__c = '3';
        webinarcredential3.Org_ID__c = 'testcred3';
        webinarcredential3.Token__c = 'testtoken3';
        webinarcredential3.Mnemonic__c = 'testmnemonic3';
        webinarcredential3.StampType__c = 'UTP OnDemand';
        insert webinarcredential3;

        Webinar_Credentials__c webinarcredential4 = new Webinar_Credentials__c();
        webinarcredential4.name = 'Continued Education';
        webinarcredential4.Credentials_ID__c = '4';
        webinarcredential4.Org_ID__c = 'testcred4';
        webinarcredential4.Token__c = 'testtoken4';
        webinarcredential4.Mnemonic__c = 'testmnemonic4';
        webinarcredential4.StampType__c = 'Continued Education';
        insert webinarcredential4;      
 
        Webinar_Credentials__c webinarcredential5 = new Webinar_Credentials__c();
        webinarcredential5.name = 'OnDemand';
        webinarcredential5.Credentials_ID__c = '5';
        webinarcredential5.Org_ID__c = 'testcred5';
        webinarcredential5.Token__c = 'testtoken5';
        webinarcredential5.Mnemonic__c = 'testmnemonic5';
        webinarcredential5.StampType__c = 'OnDemand';
        insert webinarcredential5; 
 
        List<Webinar__c> testWebinars = new List<Webinar__c>();
        Webinar__c testWeb1 = new Webinar__c();
        testWeb1.Name = 'test webinar 1';
        testWeb1.Event_Date_Time__c = Date.today().addDays(-140);
        testWeb1.Event_Time__c = '12:00';
        testWeb1.PrimaryPresenter__c = 'test presenter';
        testWeb1.StampType__c = 'Ultimate Options Course' ;
        testWeb1.Webinar_Credentials__c = webinarcredential1.id;
        testWebinars.add(testWeb1);
        
        Webinar__c testWeb2 = new Webinar__c();
        testWeb2 = new Webinar__c();
        testWeb2.Name = 'test webinar 2';
        testWeb2.Event_Date_Time__c = Date.today().addDays(-70);
        testWeb2.Event_Time__c = '12:00';
        testWeb2.StampType__c = 'Live Market Forex Session';        
        testWeb2.Webinar_Credentials__c = webinarcredential2.id;
        testWebinars.add(testWeb2);
        
        Webinar__c testWeb3 = new Webinar__c();
        testWeb3 = new Webinar__c();
        testWeb3.Name = 'test webinar 3';
        testWeb3.Event_Date_Time__c = Date.today();
        testWeb3.Event_Time__c = '12:00';
        testWeb3.StampType__c = 'UTP OnDemand';        
        testWeb3.Webinar_Credentials__c = webinarcredential3.id;
        testWebinars.add(testWeb3);
        
        Webinar__c testWeb4 = new Webinar__c();
        testWeb4 = new Webinar__c();
        testWeb4.Name = 'test webinar 2';
        testWeb4.Event_Date_Time__c = Date.today().addDays(-70);
        testWeb4.Event_Time__c = '12:00';
         testWeb4.StampType__c = 'Continued Education';       
        testWeb4.Webinar_Credentials__c = webinarcredential4.id;
        testWebinars.add(testWeb4);
        
        Webinar__c testWeb5 = new Webinar__c();
        testWeb5 = new Webinar__c();
        testWeb5.Name = 'test webinar 5';
        testWeb5.Event_Date_Time__c = Date.today();
        testWeb5.Event_Time__c = '12:00';
        testWeb5.StampType__c = 'OnDemand';        
        testWeb5.Webinar_Credentials__c = webinarcredential5.id;
        testWebinars.add(testWeb5);
        
        insert testWebinars;
        
        
        
        
        
        
        
        et4ae5__SendDefinition__c emailSend = new et4ae5__SendDefinition__c();
        insert emailSend;
        
        
        List<Webinar_Attendance__c> testAttendances = new List<Webinar_Attendance__c>();
        
        // Stamp total data: need stamp type and duration
        // Stamp first last:  need stamp type, status, attendance dates 70 days apart, need fields for stamp
        //      webinarId           string      webinar
        //      attendanceDate      date        webinar event date
        //      attendanceTime      time        webinar event time
        //      joinTime            datetime    HH:00
        //      webinarSourceOther  string      any
        //      duration            integer     30
        //      sessions            integer     any
        //      presenter           string      any
        //      creditName          string      any
        //      creditId            string      any
        //      attended            boolean     true
        //      stampType           string      any
        //      status              string      any
        //      sendNumber          string      any
        // Type=OnDemand, Attended=true, Status=Completed, Duration=30, attendancedate comes from webinar (OK), need fields for stamp
        Webinar_Attendance__c testWebAtt;
        
        // OnDemand data
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb5.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'OnDemand';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb5.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'OnDemand';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb5.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'OnDemand';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        // UTP data
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb3.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'UTP';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb3.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'UTP';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb3.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'UTP';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        
        // UOC data
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb1.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'UOC';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb1.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'UOC';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb1.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'UOC';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        // LMFS data
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb2.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'LMFS';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb2.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'LMFS';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb2.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'LMFS';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        //cont ed
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb4.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'Continued Education';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
    
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb4.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'Continued Education';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
        
        
        testWebAtt = new Webinar_Attendance__c();
        testWebAtt.Account__c = testAccount.Id;
        testWebAtt.Webinar__c = testWeb4.Id;
        testWebAtt.Source_Other__c = 'test source';
        testWebAtt.Duration__c = 30;
        testWebAtt.OnDemand_Views__c = 1;
        testWebAtt.Credit_Name__c = 'test credit name';
        testWebAtt.Credit_User__c = null;   // MAY NEED USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        testWebAtt.Attended__c = true;  //false;
        testWebAtt.Stamp_Type__c = 'Continued Education';
        testWebAtt.Status__c = 'Complete';
        testWebAtt.IER_et4ae5_SendDefinition__c = emailSend.Id;
        testAttendances.add(testWebAtt);
    
        insert testAttendances;
        
        // Begin Testing
        Test.startTest();
        
        Map<Id, Account> acctMap = new Map<Id, Account>();
        acctMap.put(testAccount.Id, testAccount);
        AccountStamper.stampWebinarData(acctMap);
        
        Test.stopTest();
        
    }
}