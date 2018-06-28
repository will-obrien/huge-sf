public with sharing class PhonebankPDFController {
	private Campaign camp;
	private List<CampaignMember> campMbrList;
	private Id campId;
	private static Id eventId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
	 
	private Id getCampId() {
		if(campId == null) {
			campId = ApexPages.currentPage().getParameters().get('id');
		}
		return campId;
	}	 
	public Campaign getCamp() {
		if(camp == null) {
			Id id = getCampId();
			if(id != null) {
				List<Campaign> campList = [
					select 
						Id,
						RecordTypeId,
						Name,
						Event_Name__c,
						Promo_Description__c,
						Custom_Field_1_Label__c,
						Interest_One__c,
						Interest_Two__c,
						Interest_Three__c						
					from Campaign
					where Id = :id 
				];
				if( ! campList.isEmpty() ) {
					camp = campList.get(0);
				}
			}
		}
		return camp;		
	}
	public Boolean getIsEventCampaign() {
		Campaign camp = getCamp();
		if(camp == null) {
			return false;
		}
		return camp.RecordTypeId == eventId;
	}
    public List<CampaignMember> getCampMbrList() {
    	if(campMbrList == null) {
	    	Id id = getCampId();
	    	if(id != null) {
	    		campMbrList = [
	    			select
	    				FirstName,
	    				LastName,
	    				Phone
	    			from CampaignMember
	    			where CampaignId = :id
	    			order by FirstName, LastName
	    		];
	    	}
    	}
    	return campMbrList;
    }
}