public with sharing class LeadConversionAugmenter {
	
	private map<Id,Id> convertedLeadMap {get;set;}
	
	public LeadConversionAugmenter(map<Id,Id> convertedLeadMap){
		this.convertedLeadMap = convertedLeadMap;
	}
	
	public void tranferReferrals(){
		list<Referral__c> referrals = [SELECT id,referred_To_Lead__c,Referred_To_Account__c,Referred_By_Lead__c,Referred_By_Account__c FROM Referral__c WHERE referred_To_Lead__c in :convertedLeadMap.keySet() OR Referred_By_Lead__c in :convertedLeadMap.keySet()];
		for(Referral__c referral : referrals){
			String accountId = convertedLeadMap.get(referral.referred_To_Lead__c);
			if(accountId != null){
				referral.Referred_By_Lead__c = null;
				referral.Referred_To_Account__c = accountId;
			}else{
				accountId = convertedLeadMap.get(referral.Referred_By_Lead__c);
				if(accountId != null){
					referral.Referred_By_Lead__c = null;
					referral.Referred_By_Account__c = accountId;
				}
			}
		}
		Database.update(referrals);
	}
	
	public void tranferLeadSources(){
		list<Lead_Sources__c> leadSources = [SELECT id,Lead__c,Account__c FROM Lead_Sources__c WHERE Lead__c in :convertedLeadMap.keySet()];
		for(Lead_Sources__c leadSource : leadSources){
			String accountId = convertedLeadMap.get(leadSource.Lead__c);
			if(accountId != null){
				leadSource.Lead__c = null;
				leadSource.Account__c = accountId;
			}
		}
		Database.update(leadSources);
	}
	
	public void tranferWebinarAttendances(){
		list<Webinar_Attendance__c> webinarAttendances = [SELECT id,Lead__c,Account__c FROM Webinar_Attendance__c WHERE Lead__c in :convertedLeadMap.keySet()];
		for(Webinar_Attendance__c webinarAttendance : webinarAttendances){
			String accountId = convertedLeadMap.get(webinarAttendance.Lead__c);
			if(accountId != null){
				webinarAttendance.Lead__c = null;
				webinarAttendance.Account__c = accountId;
			}
		}
		Database.update(webinarAttendances);
	}
	
}