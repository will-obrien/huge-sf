@isTest
public class DETableCtrlTestClass {
    public static testMethod void testTableCtrl(){
        Account a = new Account(Name = 'Test Account');
        insert a;
        System.debug('Account' + a);
        
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'Contact';
        c.AccountId = a.Id;
        insert c;
        System.debug('Contact' + c);
        
        User newUser = new User();
        newUser.FirstName = 'Test';
        newUser.LastName = 'User';
        newUser.Username = 'testDComp@email.com';
        newUser.Email = 'testDComp@email.com';
        newUser.Alias = 'tuser';
        newUser.CommunityNickname = 'testNickname';
        newUser.TimeZoneSidKey = 'Europe/Dublin';
        newUser.LocaleSidKey = 'en_IE_EURO'; 
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.ProfileId = '00e58000000Vpn6AAC';
        newUser.LanguageLocaleKey = 'en_US';
        insert newUser;
        System.debug('User' + newUser);
        
        Involved_Users__c iu = new Involved_Users__c();
        iu.Account__c = a.Id;
        iu.Company_Personnel__c = newUser.Id;
        insert iu;
        System.debug('Involved User' + iu);
        
        Contact_User_Relationship__c cu_Relation = new Contact_User_Relationship__c();
        cu_Relation.Contact__c = c.Id;
        cu_Relation.Involved_User__c  = iu.Id;
        cu_Relation.Relationship_Classification__c = 'Trusted Advisor: willing to be influenced';
        cu_Relation.Relationship_Comment__c = 'This is the test comment for the test class';
        insert cu_Relation;
        
        List<Contact> contacts = DETableCtrl.getContacts(a.Id);
        System.assertEquals(contacts.size(), 1);
        
        List<Involved_Users__c> ius = DETableCtrl.getUsers(a.Id);
        System.assertEquals(ius.size(), 1);
        
        String replacementComment = 'This is the replacement comment';
        Contact_User_Relationship__c relations = DETableCtrl.updateComment(replacementComment, cu_Relation);
        //System.assertEquals(cu_Relation.size(), 1);
        
        String updateRelationType_1 = 'difficult';
        String updateRelationType_2 = 'regular';
        String updateRelationType_3 = 'trusted';
        Contact_User_Relationship__c relations_1 = DETableCtrl.updateRelationType(updateRelationType_1, cu_Relation);
        Contact_User_Relationship__c relations_2 = DETableCtrl.updateRelationType(updateRelationType_2, cu_Relation);
        Contact_User_Relationship__c relations_3 = DETableCtrl.updateRelationType(updateRelationType_3, cu_Relation);
    }
}