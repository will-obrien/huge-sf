/* 
	1. When Add_to_List__c field is changed on a Campaign, add existing Event Registrants and Action Takers to the new list.
	2. When Event Registrations or Advocacy Actions are created/edited on Campaigns with a Lists Campaign specified in Add_to_List__c,
	create a campaign member on that Lists Campaign if it does not already exist.
	
	This class is called by triggers CampaignTrigger, EventRegistrationTrigger, and AdvocacyActionTrigger. 
	Test in AddToListsCampaignTest.
           
  	4/18/2017		Tami Lau			Original
  	6/20/2017		Tami Lau			Added campaignUpdate and campaignUpdateProcessRecords methods,
										removed references to Campaign_Member_Created__c
*/

public class AddToListsCampaign {
	
	public static void campaignUpdate (List<Campaign> newCmps, Map<Id, Campaign> oldCmpsMap) {
		List<Id> membersToAdd = new List<Id>();
		
		for (Campaign cmp : newCmps) {
			if (cmp.Add_to_List__c != null && oldCmpsMap.get(cmp.Id).Add_to_List__c != cmp.Add_to_List__c) {
				membersToAdd.add(cmp.Id);
			}
		}
		
		if (membersToAdd.size() > 0) {
			campaignUpdateProcessRecords(membersToAdd);
		}
	}
    
    @future
    private static void campaignUpdateProcessRecords(List<Id> cmpIds) {
			List<Event_Registration__c> eventRegs = new List<Event_Registration__c>([SELECT Id FROM Event_Registration__c WHERE Campaign__c IN :cmpIds AND Contact__c != null]);
			if (eventRegs.size() > 0) {
				fromEventRegistration(eventRegs);
            }
        
			List<kweos__EOCS_Data__c> actions = new List<kweos__EOCS_Data__c>([SELECT Id FROM kweos__EOCS_Data__c WHERE kwac__Related_Action__c IN :cmpIds AND kwac__Contact__c != null]);
			if (actions.size() > 0) {
				fromAdvocacyAction(actions);	
			}        
    }  
    
    public static void fromEventRegistration (List<Event_Registration__c> regs) {
        
        List<Event_Registration__c> regs2 = new List<Event_Registration__c>([SELECT Contact__c, Campaign__r.Add_to_List__c FROM Event_Registration__c WHERE Id IN :regs]);       
        Map<Id, Set<Id>> campaignContactMap = new Map<Id, Set<Id>>();
        
        for (Event_Registration__c r : regs2) {
            if (r.Contact__c != null && r.Campaign__r.Add_to_List__c != null) {
                if (campaignContactMap.containsKey(r.Campaign__r.Add_to_List__c)) {
                    Set<Id> contactIds = campaignContactMap.get(r.Campaign__r.Add_to_List__c);
                    contactIds.add(r.Contact__c);
                    campaignContactMap.put(r.Campaign__r.Add_to_List__c, contactIds);                    
                }
                else {
                    campaignContactMap.put(r.Campaign__r.Add_to_List__c, new Set<Id> {r.Contact__c});
                }
            }            
        }
       
        if (campaignContactMap.size() > 0) {
            createCampaignMember(campaignContactMap);
        }       
    }
       
    public static void fromAdvocacyAction (List<kweos__EOCS_Data__c> actions) {
        
        List<kweos__EOCS_Data__c> actions2 = new List<kweos__EOCS_Data__c>([SELECT kwac__Contact__c, kwac__Related_Action__r.Add_to_List__c FROM kweos__EOCS_Data__c WHERE Id IN :actions]);
        Map<Id, Set<Id>> campaignContactMap = new Map<Id, Set<Id>>();
        
        for (kweos__EOCS_Data__c r : actions2) {
            if (r.kwac__Contact__c != null && r.kwac__Related_Action__r.Add_to_List__c != null) {
                if (campaignContactMap.containsKey(r.kwac__Related_Action__r.Add_to_List__c)) {
                    Set<Id> contactIds = campaignContactMap.get(r.kwac__Related_Action__r.Add_to_List__c);
                    contactIds.add(r.kwac__Contact__c);
                    campaignContactMap.put(r.kwac__Related_Action__r.Add_to_List__c, contactIds);                    
                }
                else {
                    campaignContactMap.put(r.kwac__Related_Action__r.Add_to_List__c, new Set<Id> {r.kwac__Contact__c});
                }
            }            
        }        
        
        if (campaignContactMap.size() > 0) {
            createCampaignMember(campaignContactMap);
        }        
    }
    
    private static void createCampaignMember(Map<Id, Set<Id>> campaignContactMap) {
        
        List<CampaignMember> existingCmpMembers = new List<CampaignMember>([SELECT ContactId, CampaignId FROM CampaignMember WHERE CampaignId IN :campaignContactMap.keySet()]);
        Map<Id, Set<Id>> existingCmpMembersMap = new Map<Id, Set<Id>>();
        for (CampaignMember cmpmem : existingCmpMembers) {
            if (existingCmpMembersMap.containsKey(cmpmem.CampaignId)) {
                Set<Id> contactIds = existingCmpMembersMap.get(cmpmem.CampaignId);
                contactIds.add(cmpmem.ContactId);
                existingCmpMembersMap.put(cmpmem.CampaignId, contactIds);
            }
            else {
                existingCmpMembersMap.put(cmpmem.CampaignId, new Set<Id> {cmpmem.ContactId});
            }
        }
     
        List<CampaignMember> cmpMembersToInsert = new List<CampaignMember>();
        
        for (Id cmpId : campaignContactMap.keySet()) {
            for (Id ctId : campaignContactMap.get(cmpId)) {
                if (existingCmpMembersMap.size() == 0 || existingCmpMembersMap.get(cmpId).contains(ctId) == false) {
                	CampaignMember cmpmem = new CampaignMember (ContactId = ctId, CampaignId = cmpId);
                	cmpMembersToInsert.add(cmpmem);                    
                }
            }
        }
      
        if (cmpMembersToInsert.size() > 0) {
            insert cmpMembersToInsert;
        }              
    }
        
}