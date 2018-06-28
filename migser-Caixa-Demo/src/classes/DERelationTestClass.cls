@isTest
public class DERelationTestClass {
    public static testMethod void testRelation(){
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
        
        Contact_User_Relationship__c relations = DERelationCtrl.getRelation(c.Id, iu.Id);
    }
}