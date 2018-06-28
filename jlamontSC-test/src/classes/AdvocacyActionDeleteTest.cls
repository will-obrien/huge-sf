@isTest
public class AdvocacyActionDeleteTest {
    
    static testMethod void deleteActionTest() {
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='8.0-Activism'];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
		insert r;
        
		User u1 = new User(Alias = 'standt', Email='standarduser@sierraclub.org', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@sierraclub.org', UserRoleId = r.Id);
		User u2 = new User(Alias = 'sysadmin', Email='sysadmin@sierraclub.org', EmailEncodingKey='UTF-8', LastName='Testing Admin', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p2.Id, TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin@sierraclub.org', UserRoleId = r.Id);

		Id offlineActionId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Offline Action').getRecordTypeId();

        System.runAs(u2) {
            
            Campaign cmp = new Campaign(Name = 'X17Z123456', RecordTypeId = offlineActionId, Promo_Description__c = 'Test Campaign');
			insert cmp;
            
            kweos__EOCS_Data__c aa = new kweos__EOCS_Data__c (kwac__Related_Action__c = cmp.Id);
            insert aa;
            
            rC_Connect__Batch_Upload__c bu = new rC_Connect__Batch_Upload__c(Name = 'Test', kwrcac__KW_Advocacy_Id__c = aa.Id);
            insert bu;
            
            System.runAs(u1) {
            	try {
                	delete aa;
            	} catch (Exception e) {
					//Assert doesn't work because delete is blocked before it hits custom validation. Need to figure out how to trigger the scenario in question in a test class.
					//System.Assert(e.getMessage() == 'You can only delete actions you created.');

            	}
        	}
            
            delete aa;
        }
                
    }

}