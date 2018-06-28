public class NewActionController implements CampaignSetter {
    
    private kweos__EOCS_Data__c action;
    
    public NewActionController(ApexPages.StandardController controller) {
        this.action = (kweos__EOCS_Data__c)controller.getRecord();
/*		
        if (action.kwac__Related_Action__c != null) {
            action.Action_Date__c = action.kwac__Related_Action__r.StartDate;
        }
*/
    }
    
    private CampaignSearchController campSearchController;
    
    public CampaignSearchController getCampSearchController() {
        return campSearchController;
    }
    public void setCampSearchController(CampaignSearchController controller) {
        campSearchController = controller;
    }
    public CampaignSetter getThis() {
        return this;
    }
    public void setSelectedCampaign(Campaign camp) {
        action.kwac__Related_Action__c = camp.Id;
    }
}