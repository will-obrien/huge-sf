//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	 Class for GivingGAUTrigger 
//	8 March 2014    Virendra (Appirio)     Original
//	Last Updated:   March 21, 2014  : KapiL Choudhary(Appirio India) Rename field for the task T-264724
//**********************************************************************/ 
public with sharing class GivingGAUTriggerHandler {
	
	//	T-257271
	//	Task Name	
	//	Oppty-Set Type1- Type 3 based on GAU
	public static void updateChildOpportunities(List<rC_Giving__GAU__c> newList,Map<Id, rC_Giving__GAU__c> oldMap) {
		Map<Id,rC_Giving__GAU__c> updatedGivingGAUs = new Map<Id,rC_Giving__GAU__c>();
		for(rC_Giving__GAU__c gGAU:newList){
			if(gGAU.GivingType__c != oldMap.get(gGAU.Id).GivingType__c || 
			   gGAU.Recipient__c != oldMap.get(gGAU.Id).Recipient__c ||
			   gGAU.FundType__c != oldMap.get(gGAU.Id).FundType__c ||
			   gGAU.Budget_Affecting__c != oldMap.get(gGAU.Id).Budget_Affecting__c ||
			   gGAU.rC_Giving__Parent__c != oldMap.get(gGAU.Id).rC_Giving__Parent__c){
			   updatedGivingGAUs.put(gGAU.Id,gGAU);	
			}
		}
		
		if(!updatedGivingGAUs.isEmpty()){
			updateChildGivings(updatedGivingGAUs);
		}
	}
	
	
	public static void updateChildGivings(Map<Id,rC_Giving__GAU__c> updatedGivingGAUs){
		List<Opportunity> updateOppProductTypes = new List<Opportunity>();
		for(Opportunity opp :[Select id, rC_Giving__GAU__c, 
																		 GivingType__c,
																		 Recipient__c,
																		 FundType__c, 
																		 Budget_Affecting__c, 
																		 Parent_General_Accounting_Unit__c,
																		 RecordType.Name from Opportunity 
		                      where rC_Giving__GAU__c in : updatedGivingGAUs.keySet()]){
		   rC_Giving__GAU__c gau =  updatedGivingGAUs.get(opp.rC_Giving__GAU__c);
		   
		   if(opp.RecordType.Name != 'Donation' && opp.RecordType.Name != 'Transaction') {
			   if(opp.GivingType__c != gau.GivingType__c){
			   	  opp.GivingType__c = gau.GivingType__c;
			   }
			   
			   if(opp.Recipient__c != gau.Recipient__c){
			   	  opp.Recipient__c = gau.Recipient__c;
			   }
			   
			   if(opp.FundType__c != gau.FundType__c){
			   	  opp.FundType__c = gau.FundType__c;
			   }
		  }

		  if(opp.Parent_General_Accounting_Unit__c != gau.rC_Giving__Parent__c){
	   	  opp.Parent_General_Accounting_Unit__c = gau.rC_Giving__Parent__c;
	   	}

	   	opp.Budget_Affecting__c = gau.Budget_Affecting__c ? 'Budget-Affecting' : 'Non-Budget Affecting';   	
		   
		  updateOppProductTypes.add(opp);
		}                   
		
		if(!updateOppProductTypes.isEmpty()){
			update updateOppProductTypes;
		}
	}

}