@isTest
private class AutoNameCampaignsTest {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static Id actionsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Offline Action').getRecordTypeId();
    private static Id addupTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AddUP Campaign').getRecordTypeId();
    private static Id listsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
	private static Id profileId = [SELECT Id FROM profile WHERE name='System Administrator'].Id;    

    static testMethod void myUnitTest() {
		CampaignValidation__c validation = new CampaignValidation__c(
			Auto_name_Campaigns__c = true,
			SetupOwnerId = profileId 
		);
		insert validation;
        
    	User usr = createUser();
        insert usr;
        Campaign camp1, camp2, camp3, camp4;
    	System.runAs(usr) {
	    	List<Campaign> campaignList = new List<Campaign>();
	    	
	    	camp1 = new Campaign(
	    		RecordTypeId = eventsTypeId,
	    		Start_Date__c = System.today(),
	    		Start_Time__c = '8:00 AM',
	    		Sponsor_Description__c = 'Test Sponsor',
                Name = 'Test Events Campaign'
	    	);
	    	campaignList.add(camp1);
	    	
	    	camp2 = new Campaign(
	    		RecordTypeId = actionsTypeId,
                Name = 'Test Offline Action Campaign'
	    	);
	    	campaignList.add(camp2);
            
            camp3 = new Campaign(
	    		RecordTypeId = addupTypeId,
                Name = 'Test AddUP Campaign'
	    	);
	    	campaignList.add(camp3);
            
	    	camp4 = new Campaign(
	    		RecordTypeId = listsTypeId,
                Name = 'Test Lists Campaign'
	    	);
	    	campaignList.add(camp4);            
	    	
	    	ClubEventTriggerHandler.testing = true;
            insert campaignList;
    	}
    	List<Campaign> campList = [
    		select Id, Name from Campaign
    	];
    	System.debug('campList: ' + campList);
    	Integer num1, num2, num3, num4;
    	for(Campaign camp : campList) {
    		if(camp.Id == camp1.Id) {
    			System.assert(camp.Name.startsWith('5' + AutoNameCampaigns.getDatePortion() + 'SF'));
    			num1 = Integer.valueOf(camp.name.substring(6));
    		}
    		else if(camp.Id == camp2.Id) {
    			System.assert(camp.Name.startsWith('X' + AutoNameCampaigns.getDatePortion() + 'HE'));
    			num2 = Integer.valueOf(camp.name.substring(6));
    		}
            else if(camp.Id == camp3.Id) {
    			System.assert(camp.Name.startsWith('7' + AutoNameCampaigns.getDatePortion() + 'AU'));
    			num3 = Integer.valueOf(camp.name.substring(6));
    		}
            else if(camp.Id == camp4.Id) {
    			System.assert(camp.Name.startsWith('X' + AutoNameCampaigns.getDatePortion() + 'LI'));
    			num4 = Integer.valueOf(camp.name.substring(6));
    		}            
    	}
    	System.assertEquals(num2, num1 + 1);
    }
	private static User createUser() {
		String FirstName = 'Test';
		String LastName = 'User1';
		String Email = 'testuser1@autonamecampaigns.test';
		
		string aliasText = 'tusr1';
        String myNickName = Email;
        User usr = new User(firstName = FirstName,
                                    lastName = LastName,
                                    Email = Email,
                                    CommunityNickname = myNickName,
                                    languagelocalekey = 'en_US',
                                    localesidkey = UserInfo.getLocale(),
                                    emailEncodingKey = 'UTF-8',
                                    timeZoneSidKey = 'America/Los_Angeles', 
                                    profileId = profileId,
                                    userName = Email,
                                    alias = aliasText );
        return usr;
	}
}