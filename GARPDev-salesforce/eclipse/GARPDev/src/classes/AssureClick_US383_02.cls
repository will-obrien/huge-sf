/*  --- NOTE: AssureClick generated Test Class ---
    Test Case Name:     Modify New Venue
    Test Case Number:   US383-02
    AssureClick Version:    1.11
    Publish User:       Ripal Patel
    Date/time:      3/11/2014 9:24:52 AM EDT
*/
@IsTest
public class AssureClick_US383_02 {

    public static Venue__c venue_2 = null;
    public static Site__c site_1 = null;

    // Main test for the current user
    static testMethod void kehot_execute_test() {
        kehot_core_execution('', '', '', '');
    }

    public static void kehot_core_execution(String elsUsr, String elsProf, String elsRole, String elsPM) {
        Datetime   TstStart        = Datetime.now();
        kSecSett   kss = new kSecSett(); kss.us = elsUsr; kss.pr = elsProf; kss.rl = elsRole; kss.pm = elsPM;
        User TstExecUser = getUserForKSS(kss, TstStart);
        String     TstExecUserId   = TstExecUser.Id;

        // Call Start Element methods
        venue_2 = kehot_US383_02_2_Venue(TstExecUser);      // Start Element: Venue/Insert
        site_1 = kehot_US383_02_1_Site(TstExecUser);        // Start Element: Site/Insert

        insert site_1;      // Site/Insert

        venue_2.Site__c = site_1.Id;
        insert venue_2;     // Venue/Insert


        Test.startTest();
    System.runAs(TstExecUser) {


        // Updates for Input Element "Update Venue"
        venue_2.Name = 'VPRS Softech Solutions Pvt. ltd.';
        venue_2.Active__c = false;
        venue_2.Site__c = site_1.Id;    // Link to Start Element "Site/Insert"
        venue_2.Address2__c = 'Dr. V.P.R. Nagar,';
        venue_2.Address1__c = 'Dhanalakshmi College of Engineering,';

        update venue_2;     // Input Element: Update Venue


    }   // end runAs
        Test.stopTest();

        // Retrieve data for Start Element "Venue/Insert"
        list<Venue__c> lstVenue1 = [
            select  id
            from    Venue__c
            where   Id = :venue_2.Id
            ];
        system.assert(lstVenue1.size() == 1);


    }
    // Create the Venue for Start Element "Venue/Insert"
    public static Venue__c kehot_US383_02_2_Venue(User TstExecUser) {
        Venue__c Venue = new Venue__c();
        Venue.Name = 'VPRS Softech Solutions Pvt. ltd.';
        Venue.Active__c = true;
        Venue.Address1__c = 'Dhanalakshmi College of Engineering,';
        Venue.Address2__c = 'Dr. V.P.R. Nagar,';
        return Venue;
    }

    // Create the Site for Start Element "Site/Insert"
    public static Site__c kehot_US383_02_1_Site(User TstExecUser) {
        Site__c Site = new Site__c();
        Site.Name = 'India, Chennai';
        Site.Active__c = true;
        Site.Non_selectable__c = false;
        return Site;
    }

    public class kSecSett {
        public String us   {get; set;}
        public String pr   {get; set;}
        public String rl   {get; set;}
        public String pm   {get; set;}
    }
    public static User getUserForKSS(kSecSett kss, Datetime TstStart)
    {
        list<User> lstUsr = null;
        if (kss.us.length() == 0 && kss.pr.length() == 0 && kss.rl.length() == 0 && kss.pm.length() == 0) {
            lstUsr = [select id, name from User where isactive = true and id = :UserInfo.getUserId()]; 
        }
        else if (kss.us.length() > 0) {
            lstUsr = [select id, name from User where isactive = true and id = :kss.us];
        }
        if (lstUsr != null) {
            System.Assert(lstUsr.size() == 1);
            return lstUsr[0];
        }
        User usr = null;
        User currUser = [select id, name from User where isactive = true and id = :UserInfo.getUserId()];
        System.runAs(currUser) {    // avoid mixed_dml_operation error
            Double x = Math.random() * 10000;
            String rd = String.valueOf(Integer.valueOf(x));
            usr = new User();
            usr.FirstName = 'testfirstopmem';
            usr.LastName = 'testlastopmem';
            usr.EmailEncodingKey = 'ISO-8859-1';
            usr.Email = 'info@ext-it.com';
            usr.Alias = rd;
            usr.TimeZoneSidKey = 'America/New_York';
            usr.Username = 'somenam' + rd + '@ext-it.com';
            usr.LanguageLocaleKey = 'en_US';
            usr.LocaleSidKey = 'en_US';
            usr.CommunityNickname = 'somename' + rd;
            if (kss.pr.length() > 0)
                usr.ProfileId = kss.pr;
            if (kss.rl.length() > 0)
                usr.UserRoleId = kss.rl;
            insert usr;
            if (kss.pm.length() > 0) {
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = usr.Id;
                psa.PermissionSetId = kss.pm;
                insert psa;
            }
        }
        return usr;
    }
    private static Boolean kehot_UserIsInProfile(String userId, String profileId)
    {
        list<User> lstUsers = [select id, ProfileId from User where id = :userId and ProfileId = :profileId];
        return (lstUsers.size() == 1);
    }
    private static Boolean kehot_UserIsInRole(String userId, String roleId)
    {
        list<User> lstUsers = [select id, UserRoleId from User where id = :userId and UserRoleId = :roleId];
        return (lstUsers.size() == 1);
    }
    private static Boolean kehot_UserIsInProfileByName(String userId, Boolean foundDuringSrcGen, String profileName)
    {
        if (! foundDuringSrcGen)
            System.assert(false, 'Could not find Profile during source generation in this environment!');
        list<User> lstUsers = [select id, Profile.Name from User where id = :userId and Profile.Name = :profileName];
        return (lstUsers.size() == 1);
    }
    private static Boolean kehot_UserIsInRoleByName(String userId, Boolean foundDuringSrcGen, String roleDevName)
    {
        if (! foundDuringSrcGen)
            System.assert(false, 'Could not find Role during source generation in this environment!');
        list<User> lstUsers = [select id, UserRole.Name from User where id = :userId and UserRole.DeveloperName = :roleDevName];
        return (lstUsers.size() == 1);
    }
}