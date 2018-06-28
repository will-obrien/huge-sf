@RestResource(urlMapping='/CampaignPremiums/*')
global without sharing class CampaignPremiums {
    @HttpGet
    global static Premiums getPremiums() {
    	RestRequest req = RestContext.request;
		String campaignId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        PremiumItem[] premiumItemList = new List<PremiumItem>();
        List<Premium__c> premiumList = new List<Premium__c>([
            select 
                Minimum_Donation__c, 
                Premium_Item__r.Name, 
                Premium_Item__r.Premium_Code__c,
                Premium_Item__r.Description__c,
                Premium_Item__r.Image_URL__c,
                Form_Campaign__r.Number_of_Premiums_Selectable__c
            from Premium__c 
            where 
                Form_Campaign__c = :campaignId
                and Premium_Item__r.Active__c = true
        ]);
        for(Premium__c prem : premiumList) {
            PremiumItem item = new PremiumItem();
            item.minimumDonation = prem.Minimum_Donation__c;
            item.name = prem.Premium_Item__r.Name;
            item.code = prem.Premium_Item__r.Premium_Code__c;
            item.description = prem.Premium_Item__r.Description__c;
            item.imageUrl = prem.Premium_Item__r.Image_URL__c;
            premiumItemList.add(item);
        }
        Premiums retVal = new Premiums();
        retVal.premiumList = premiumItemList;
        if(premiumItemList.size() == 0) {
            retVal.NumberPremiumsSelectable = 0;
        }
        else {
            Premium__c prem = premiumList[0];
            retVal.NumberPremiumsSelectable = (Integer)prem.Form_Campaign__r.Number_of_Premiums_Selectable__c;
        }
        return retVal;
    }
    global class PremiumItem {
        public Decimal minimumDonation;
        public String name;
        public String code;
        public String description;
        public String imageUrl;
    }
    global class Premiums {
        public Integer NumberPremiumsSelectable;
        public PremiumItem[] premiumList;
    }
}