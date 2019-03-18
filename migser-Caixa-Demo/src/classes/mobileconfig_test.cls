@isTest
public class mobileconfig_test{
    static testMethod void test_uuid_generator() {
        String sample = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
        System.assertEquals(GuidUtil.NewGuid().length(), sample.length());
    }
    static testMethod void test_installer_extension() {
        User u = [select Id from User where Id = :UserInfo.getUserId()];
        Mobileconfig__c mc = new Mobileconfig__c(Name = 'Mobile App', Display_Name__c = 'Test', User__c = u.Id, Password__c = 'securePassword', Start_URL__c = '/apex/vf_page', Base64_App_Icon__c = 'abc');
        insert mc;
        ApexPages.StandardController sc = new ApexPages.standardController(mc);
        mobileconfig_installer e = new mobileconfig_installer(sc);
        
        
        String sample = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
        System.assertEquals(e.uuid.length(), sample.length());
        System.assertEquals(e.getNewUUID().length(), sample.length());
    }
    static testMethod void test_manager_controller(){
        mobileconfig_manager e = new mobileconfig_manager();
        List<Mobileconfig__c> mcs = [select Id, Name, Display_Name__c, User__c, Username__c, Password__c, Start_URL__c, Base64_App_Icon__c from Mobileconfig__c];
        
        System.assertEquals(e.mobileconfigs.size(), mcs.size());
        System.assertEquals(e.email_addresses.size(), mcs.size() + 1);
        System.assertEquals(e.displayPopup, false);
        System.assertEquals(e.current_mobileconfig.Name, (new Mobileconfig__c()).name);
        System.assertEquals(e.app_icon.Body, (new Document()).Body);
        
        e.showPopup();
        User u = [select Id from User where Id = :UserInfo.getUserId()];
        e.current_mobileconfig = new Mobileconfig__c(Name = 'Mobile App', Display_Name__c = 'Test', User__c = u.Id, Password__c = 'securePassword', Start_URL__c = '/apex/vf_page', Base64_App_Icon__c = 'abc');
        System.assertEquals(e.save_mobileconfig(), null);
        System.assertEquals(e.displayPopup, false);
        System.assertEquals(e.current_mobileconfig.Name, (new Mobileconfig__c()).Name);
        
        Mobileconfig__c m = [Select Id from Mobileconfig__c limit 1];
        apexpages.currentpage().getparameters().put('mobileconfig_id', m.Id);
        e.email_addresses.put(m.Id, 'pmercier@salesforce.com');
        System.assertEquals(e.send_mobileconfig(), null);
        System.assertEquals(e.email_addresses.get(m.Id), '');
        System.assertEquals(e.current_mobileconfig.Name, (new Mobileconfig__c()).Name);
        
        e.showPopup();
        System.assertEquals(e.displayPopup, true);
        System.assertEquals(e.current_mobileconfig.Id, m.Id);
        
        e.closePopup();
        System.assertEquals(e.displayPopup, false);
        System.assertEquals(e.current_mobileconfig.Name, (new Mobileconfig__c()).Name);
        
        e.showPopup();
        System.assertEquals(e.save_mobileconfig(), null);
        System.assertEquals(e.displayPopup, false);
        System.assertEquals(e.current_mobileconfig.Name, (new Mobileconfig__c()).Name);
        
        e.showPopup();
        System.assertEquals(e.remove_mobileconfig(), null);
        System.assertEquals(e.displayPopup, false);
        System.assertEquals(e.current_mobileconfig.Name, (new Mobileconfig__c()).Name);
        
        e.email_addresses.put('all', 'pmercier@salesforce.com');
        System.assertEquals(e.send_all_mobileconfigs(), null);
        System.assertEquals(e.email_addresses.get('all'), '');
    }
}