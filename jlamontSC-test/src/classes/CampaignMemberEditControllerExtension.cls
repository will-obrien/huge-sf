public class CampaignMemberEditControllerExtension {
    
    public CampaignMember campaign_member;
    
    public CampaignMemberEditControllerExtension(ApexPages.StandardController controller) {
        this.campaign_member = (CampaignMember)controller.getRecord();
        
    }
    
    public List<SelectOption> getOptions() {
                List<SelectOption> options = new List<SelectOption>(); 
                for (CampaignMemberStatus cms : [select label from CampaignMemberStatus where campaignId=:campaign_member.campaignId]) {
                        options.add(new SelectOption(cms.Label,cms.Label));
		}              
		return options;            
	}
    
    
    //Attempt to make record type rendering not dependent on hardcoded rt value
    //public Boolean isEvent {get; set;}  
	//public Boolean getCheckEvent() {
	//	String EventCampaignRecordType = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    //	String CampaignRecordType = String.valueOf(CampaignMember.Campaign.RecordTypeId);
   	//	Boolean isEvent = (CampaignRecordType == EventCampaignRecordType);
   	//	return isEvent;
	//}
}