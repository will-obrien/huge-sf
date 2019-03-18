trigger updateBrochureReferralSource on Account (after insert, after update) {	
	Set<Id> acctIds = new Set<Id>();
	for(Account a: trigger.new){		
		if(a.Referral__c != null){
			acctIds.add(a.Id);
		}		
	}
	
	Map<Id, Account> acctMap = new Map<Id, Account>([select Id, Name, Referral__c, Inquiry_Subcategory__c from Account where Id in : acctIds]);
	List<Brochure_Request__c> brs = new List<Brochure_Request__c>([select Id, Name, Referral_Source__c, Referral_Detail__c, Account__c from Brochure_Request__c where Account__c in : acctIds]);
	List<Brochure_Request__c> brsUpdate = new List<Brochure_Request__c>();
	for(Brochure_Request__c br : brs){
		br.Referral_Source__c = acctMap.get(br.Account__c).Referral__c;
		br.Referral_Detail__c = acctMap.get(br.Account__c).Inquiry_Subcategory__c;
		brsUpdate.add(br);
	}
	
	update(brsUpdate);
}