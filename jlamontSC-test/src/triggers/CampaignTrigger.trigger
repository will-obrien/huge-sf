// *************************************************************************/
// CampaignTrigger Trigger
//      MM: This trigger is a wrapper for the CampaignTriggerHandler
//          The class fires errors when a duplicate Campaign name is detected 
//				for Group Campaigns
//			It also sets the External Id to the Name of the campaign.
//           
//  2015/05/27		Mark Maslow			Original
//  2016/09/16      Mark Maslow         Add call to AutoNameCampaigns
//  2017/02         Mark Maslow         Add call to EventsCampaignTriggerHandler.beforeDelete
//	2017/06			Tami Lau			Add call to AddToListsCampaign.campaignUpdate
//  2017/04			Tami Lau			Add call to CampaignPromotionAttributes.setPromoAttributes
//  2017/06         Mark Maslow         Add call to CampaignReportingAttr.checkAttributes
//  2017/07			Justin LaMont		Add call to ModifyCampaignMemberStatuses
// *************************************************************************/
trigger CampaignTrigger on Campaign (before insert, before update, after insert, after update, before delete) {
	if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
		Map<Id, Campaign>oldMap = null;
		if(Trigger.isUpdate) {
			oldMap = Trigger.oldMap;
		}
		CampaignTriggerHandler.beforeInsertUpdate(Trigger.new, oldMap);
		EventsCampaignTriggerHandler.beforeInsertUpdate(Trigger.new, oldMap);
		
        if(Trigger.isInsert) {
			AutoNameCampaigns.setNames(Trigger.new);
		}
        
        //CampaignPromotionAttributes.setPromoAttributes(Trigger.new);
	}
	else if(Trigger.isAfter && Trigger.isInsert) {
		EventsCampaignTriggerHandler.afterInsert(Trigger.new);
		ModifyCampaignMemberStatuses.modifyStatuses(Trigger.new);
	}
      else if(Trigger.isAfter && Trigger.isUpdate) {
          EventsCampaignTriggerHandler.afterUpdate(Trigger.new);
          AddToListsCampaign.campaignUpdate(Trigger.new, Trigger.oldMap);
          CampaignReportingAttr.checkAttributes(Trigger.new, Trigger.oldMap);
	  }
	  else if(Trigger.isBefore && Trigger.isDelete) {
	  	EventsCampaignTriggerHandler.beforeDelete(Trigger.old);
	  }
}