/*********************************************************************************************************
Name              : ModifyCampaignMemberStatuses
Created By        : Tami Lau & Justin LaMont
Created Date      : April 2017
Description       : Replaces default campaign member status values for Lists and Events campaigns
				  : 
Last Updated      : 
*********************************************************************************************************/



public class ModifyCampaignMemberStatuses {
        
    public static void modifyStatuses(List<Campaign> cmps) {
        
        Id listsId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
        Id eventsId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();        
        
        List<Campaign> cmpsToUpdate = new List<Campaign>();     
        for (Campaign cmp : cmps) {
            if (cmp.RecordTypeId == listsId || cmp.RecordTypeId == eventsId) {
                cmpsToUpdate.add(cmp);
            }
        }
        
        if (cmpsToUpdate.size() > 0) {
        
	        List<CampaignMemberStatus> cmsvToDelete = [SELECT Id FROM CampaignMemberStatus WHERE CampaignId IN :cmpsToUpdate AND (Label = 'Sent' OR Label = 'Responded')];
	        List<CampaignMemberStatus> cmsvToInsert = new List<CampaignMemberStatus>();
        
            for (Campaign c : cmpsToUpdate) {
                    CampaignMemberStatus cms1 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=false, Label='To Contact', SortOrder=3, IsDefault=true);	
                    CampaignMemberStatus cms2 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=true, Label='Contacted', SortOrder=4);	
                    CampaignMemberStatus cms3 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=false, Label='No Answer', SortOrder=5);	
                    CampaignMemberStatus cms4 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=false, Label='Left Message', SortOrder=6);
                    CampaignMemberStatus cms5 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=true, Label='Wrong Number/Disconnected', SortOrder=7);
                    CampaignMemberStatus cms6 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=true, Label='Non-English Speaker', SortOrder=8);
                    cmsvToInsert.add(cms1);
                    cmsvToInsert.add(cms2);
                    cmsvToInsert.add(cms3);
                    cmsvToInsert.add(cms4);
                    cmsvToInsert.add(cms5);
                    cmsvToInsert.add(cms6);
            }
            
                insert cmsvToInsert;
                delete cmsvToDelete; 

		}
        
    }

}