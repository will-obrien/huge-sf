public with sharing class Handler_Referral extends Handler{
	
	private list<Referral__c> newList;
	private map<Id,Referral__c> newMap;
	private list<Referral__c> oldList;
	private map<Id,Referral__c> oldMap;
	
	private set<Id> eligibleReferralOwners;
	private list<Id> usaCloserIds;

	public Handler_Referral(){
		
	}
	
	public Handler_Referral(String typeOfHandler) {
    	handlerType = typeOfHandler;
    }
	
	public override void mainEntry(String triggerObject,
		Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
		Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
		map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap) {
			this.newList = (list<Referral__c>)newList;
			this.newMap = (map<Id,Referral__c>)newMap;
			this.oldList = (list<Referral__c>)oldList;
			this.oldMap = (map<Id,Referral__c>)oldMap;
			
			/**
			 *	@author Jim Hutcherson
			 *	@date	July 3 2014
			 *
			 *	Queries for eligible referral owners based off their role. Accepts any
			 *	role containing the word closer and account executives.
			 *
			 */
			map<Id,User> eligibleReferralOwnersMap = new map<Id,User>(
				[SELECT Id,FirstName,LastName FROM User WHERE UserRole.Name LIKE '%closer%' OR UserRole.Name = 'Account Executive']
			);
			this.eligibleReferralOwners = eligibleReferralOwnersMap.keySet();
			
			/**
			 *	@author Jim Hutcherson
			 *	@date	July 3 2014
			 *
			 *	Queries for all Closer USA Role users and creates a list of their Ids
			 *
			 */
			this.usaCloserIds = new list<Id>();
			list<User> usaClosers = [SELECT Id,FirstName,LastName FROM User WHERE UserRole.Name = 'Closer USA'];
			for(User user : usaClosers){
				this.usaCloserIds.add(user.Id);
			}
			
			if(isAfter && isInsert){
				setReferrals(this.newList);
			}
			
			TriggerDispatcher.activeHandler = null;

	}
	
	public override void inProgressEntry(String triggerObject,
		Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
		Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
		map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap){
			system.debug('In Progress Entry: ' + triggerObject);
	}

	@TestVisible
	private Id getRandomReferralOwnerId() {
		if(this.usaCloserIds != null && !this.usaCloserIds.isEmpty()){
			integer randomIndex = getRandomInt(0,this.usaCloserIds.size());
			return this.usaCloserIds.get(randomIndex);
		}
		return null;
	}
	
	@TestVisible
	private integer getRandomInt(integer lower,integer upper) {
		return Math.round(Math.random() * (upper - lower)) + lower;
	}
	
	@TestVisible
	private void setReferrals(list<Referral__c> newList){
		try{
			map<String,Referral__c> referralMap = new map<String,Referral__c>();
			map<String,String> referredByMap = new map<String,String>();
			
			
			// referral comes in with referred by as Bruce Wayne (ACCT) and referred to as Clark Kent (LEAD)
			for(Referral__c ref :newList){
				String referredById;
				// this will pass as the referred by account is Bruce Wayne
				if(ref.Referred_By_Account__c != null){
					referredById = ref.Referred_By_Account__c;
				}else if(ref.Referred_By_Lead__c != null){
					referredById = ref.Referred_By_Lead__c;
				}
				
				if(referredById != null){
					// Bruce Wayne is added to REFERRAL map (NOTE: Key = Account, Value = referral record)
					referralMap.put(referredById,ref);
					
					String referredToId;
					// This should fail as there was not value assigned to referred to account in the test
					if(ref.Referred_To_Account__c != null){
						referredToId = ref.Referred_To_Account__c;
					}else if(ref.Referred_To_Lead__c != null){		// this will pass as the referred to lead is Clark Kent
						referredToId = ref.Referred_To_Lead__c;
					}
					
					if(referredToId != null){
						// Clark Kent added to REFERRED BY map (NOTE Key = Lead Id, Value = Account Id)
						referredByMap.put(referredToId,referredById);
					}
				}
			}
			
			// Leads are queried if they appear in the REFERRED BY map key set (should return the Clark Kent lead)
			list<Lead> leads = [SELECT id,OwnerId,Referred__c,Referral_Personal_Message__c,Referral_First_Name__c,Referral_Last_Name__c,Referral_Owner__c FROM Lead WHERE id in :referredByMap.keySet()];
			// Accounts are queried if they appear in the REFERRED BY map key set (should return 0 records)
			list<Account> accounts = [SELECT id,OwnerId,Referred__pc,Referral_Personal_Message__pc,Referral_First_Name__pc,Referral_Last_Name__pc,Referral_Owner__pc FROM Account WHERE id in : referredByMap.keySet()];
			
			// can iterate over the 1 Bruce Wayne lead
			for(Lead lead : leads){
				// get the value for referred by from the map, should get Id of the Bruce Wayne record
				String referredById = referredByMap.get(lead.id);
				// set referred to true
				lead.Referred__c = true;
				// this should pass as it should be the Bruce Wayne account id
				if(referredById != null){
					// get the referral record, which should be able to be found as it was put in the map with the key Bruce Wayne acct id
					Referral__c referral = referralMap.get(referredById);
					
					if(lead.Referral_Owner__c == null) {
						if(referral.Fronter__c != null && this.eligibleReferralOwners.contains(referral.Fronter__c)){
							lead.Referral_Owner__c = referral.Fronter__c;
							lead.OwnerId = referral.Fronter__c;
						}else{
							Id referralOwnerId = this.getRandomReferralOwnerId();
							if(referralOwnerId != null){
								lead.Referral_Owner__c = referralOwnerId;
								lead.OwnerId = referralOwnerId;
							}
						}
					}
					lead.Referral_First_Name__c = referral.Referred_By_First_Name__c;
					lead.Referral_Last_Name__c = referral.Referred_By_Last_Name__c;
					lead.Referral_Personal_Message__c = referral.Personal_Message__c;
				}
			}
			
			for(Account account : accounts){
				String referredById = referredByMap.get(account.id);
				account.Referred__pc = true;
				if(referredById != null){
					Referral__c referral = referralMap.get(referredById);
					if(referral.Fronter__c != null && this.eligibleReferralOwners.contains(referral.Fronter__c)){
						account.Referral_Owner__pc = referral.Fronter__c;
						account.OwnerId = referral.Fronter__c;
					}else{
						Id referralOwnerId = this.getRandomReferralOwnerId();
						if(referralOwnerId != null){
							account.Referral_Owner__pc = referral.Fronter__c;
							account.OwnerId = referral.Fronter__c;
						}
					}
					account.Referral_First_Name__pc = referral.Referred_By_First_Name__c;
					account.Referral_Last_Name__pc = referral.Referred_By_Last_Name__c;
					account.Referral_Personal_Message__pc = referral.Personal_Message__c;
				}
			}
			
			if(!leads.isEmpty()){
				Database.update(leads);
			}
			
			if(!accounts.isEmpty()){
				Database.update(accounts);
			}
		}catch(Exception ex){
	    	system.debug(ex);
		}
	}

}