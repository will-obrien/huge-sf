@isTest
private class CampaignTriggerHandlerTest {

    static testMethod void myUnitTest() {
    	List<Campaign> campaignList = new List<Campaign>();
    	
    	Campaign camp1 = new Campaign(Name = 'Test Campaign1');
    	campaignList.add(camp1);
    	
    	Campaign camp2 = new Campaign(Name = 'Test Campaign2');
    	campaignList.add(camp2);
    	
    	insert campaignList;
    	
    	camp1 = [select Id, Name, External_Id__c from Campaign where Id=:camp1.Id];
    	System.assertEquals('Test Campaign1', camp1.External_Id__c);

    	Campaign camp3 = new Campaign(Name = 'Test Campaign1');
    	Database.SaveResult result = Database.insert(camp3, false);
    	System.assertEquals(false, result.isSuccess());
    	System.assertEquals('Campaign already exists', result.getErrors()[0].getMessage());
    	
    	camp1.Name = 'Test Campaign2';
    	result = Database.update(camp1, false);
    	System.assertEquals(false, result.isSuccess());
    	System.assertEquals('Campaign already exists', result.getErrors()[0].getMessage());
    }
}