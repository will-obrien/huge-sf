@IsTest
public with sharing class CampaignPremiumsTest {
	@IsTest
	public static void testCampaignPremium() {
		Campaign camp = new Campaign(
			Name='Test Campaign',
			Number_of_Premiums_Selectable__c=1
		);
		insert camp;
		
		Premium_Item__c premiumItem = new Premium_Item__c(
			Name='Test Premium Item',
			Active__c = true,
			Premium_Code__c = 'TEST',
			Image_URL__c = 'http://www.sierraclub.org',
			Description__c = 'Test Description'
		);
		insert premiumItem;
		
		Premium__c premium = new Premium__c(
			Form_Campaign__c = camp.Id,
			Minimum_Donation__c = 35.00,
			Premium_Item__c = premiumItem.Id 
		);
		insert premium;
		
		RestRequest req = new RestRequest(); 
	    RestResponse res = new RestResponse();
	
		String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
	    req.requestURI = baseUrl + '/services/apexrest/CampaignPremiums/' + camp.Id;
	    req.httpMethod = 'GET';
	    RestContext.request = req;
	    RestContext.response = res;
	
	    CampaignPremiums.Premiums results = CampaignPremiums.getPremiums();
	    
		System.assertEquals(1, results.NumberPremiumsSelectable);
		System.assertEquals(1, results.premiumList.size());
		CampaignPremiums.PremiumItem item = results.premiumList[0];
		System.assertEquals('TEST', item.code);
		System.assertEquals(35, item.minimumDonation);
		System.assertEquals('Test Premium Item', item.name);
		System.assertEquals('http://www.sierraclub.org', item.imageUrl);
		System.assertEquals('Test Description', item.description);
	}
}