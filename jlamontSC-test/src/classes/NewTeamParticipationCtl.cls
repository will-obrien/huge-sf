public with sharing class NewTeamParticipationCtl implements CampaignSetter {
    
    private final Team_Participation__c teamparticipation;
    
    public NewTeamParticipationCtl(ApexPages.StandardController controller) {
        this.teamparticipation = (Team_Participation__c)controller.getRecord();
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
        teamparticipation.Event_Action__c = camp.Id;
    }
}