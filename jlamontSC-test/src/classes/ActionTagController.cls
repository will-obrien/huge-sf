public with sharing class ActionTagController {
    public BulkEntryController pageController { get;
        set {
            if(value != null) {
                pageController = value;
                pageController.setAcTagController(this);
            }
        }
    }
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static Id advocacyFormTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Advocacy Form').getRecordTypeId();
    private static Id offlineActionCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Offline Action').getRecordTypeId();
    private static Id offlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
    public Campaign camp {get; set;} {camp = new Campaign();}
    public Campaign selectedCampaign {get; set;}
    public kweos__EOCS_Data__c action {get; set;}
    {
        action = new kweos__EOCS_Data__c();
        action.RecordTypeId = offlineActionTypeId;
    }
    public List<Campaign> campList {get; set;}
    public Id selectedCampaignId {get; set;}
    public String dtStartString;
    public String dtEndString;
    public String dtActionString;
    public String campaignName {get; set;}
    public String entityName {get; set;}
    public String localGrassrootsCampName {get; set;}
    public Date dtStart, dtEnd, dtAction;
    public Boolean hasErrors {get; set;} {hasErrors = false;}

    public void setSelectedCampaign() {
        campList = null;
        Campaign selectedCamp = [select Id, Name, StartDate, Promo_Description__c from Campaign where Id=:selectedCampaignId];
        action.kwac__Related_Action__c = selectedCampaignId;
        if(selectedCamp.StartDate == null) {
        	dtActionString = System.today().format();
        }
        else {
        	dtActionString = selectedCamp.StartDate.format();
        }
        selectedCampaign = selectedCamp;
    }
    public String getDtStartString() {
        return dtStartString;
    }
    public void setDtStartString(String dt) {
        dtStartString = dt;
        if(String.isEmpty(dtStartString)) {
            dtStart = null;
        }
        else {
            dtStart = Date.parse(dtStartString);
        }
    }
    public String getDtEndString() {
        return dtEndString;
    }
    public void setDtEndString(String dt) {
        dtEndString = dt;
        if(String.isEmpty(dtEndString)) {
            dtEnd = null;
        }
        else {
            dtEnd = Date.parse(dtEndString);
        }
    }
    public String getDtActionString() {
        return dtActionString;
    }
    public void setDtActionString(String dt) {
        dtActionString = dt;
        if(String.isEmpty(dtActionString)) {
            dtAction = null;
        }
        else {
            dtAction = Date.parse(dtActionString);
        }
        action.Action_Date__c = dtAction;
    }
    public void search() {
        String whereClause = 'RecordTypeId IN (:eventsTypeId, :advocacyFormTypeId, :offlineActionCampaignId) ';
        
        String nationalCampaign, strategy, local, state, tacticOwner, tacticOwnerCategory, promoDescription;
        if( ! String.isEmpty(campaignName) ) {
            whereClause += 'AND Name = :campaignName ';
        }
        if( ! String.isEmpty(entityName)) {
            whereClause += 'AND Club_Entity__r.Name LIKE \'%' + entityName.trim() + '%\' '; 
        }
        if(camp.National_Campaign_Global__c != null) {
            nationalCampaign = camp.National_Campaign_Global__c;
            whereClause += 'AND National_Campaign_Global__c = :nationalCampaign ';
        }
        if(camp.Campaign_Strategy_Global__c != null) {
            strategy = camp.Campaign_Strategy_Global__c;
            whereClause += 'AND Campaign_Strategy_Global__c = :strategy ';
        }
        if(camp.Local_Campaign_Global__c != null) {
            local = camp.Local_Campaign_Global__c;
            whereClause += 'AND Local_Campaign_Global__c = :local ';
        }
        if(camp.State_Global__c != null) {
            state = camp.State_Global__c;
            whereClause += 'AND State_Global__c = :state ';
        }
        if(camp.Tactic_Owner_Category_Global__c != null) {
            tacticOwnerCategory = camp.Tactic_Owner_Category_Global__c;
            whereClause += 'AND Tactic_Owner_Category_Global__c = :tacticOwnerCategory ';
        }
        if(camp.Tactic_Owner_Global__c != null) {
            tacticOwner = camp.Tactic_Owner_Global__c;
            whereClause += 'AND Tactic_Owner_Global__c = :tacticOwner ';
        }
        if( ! String.isEmpty(camp.Promo_Description__c)) {
            promoDescription = camp.Promo_Description__c;
            whereClause += 'AND Promo_Description__c LIKE \'%' + camp.Promo_Description__c.trim() + '%\' ';
        }
        if(! String.isEmpty(localGrassrootsCampName)) {
            whereClause += 'AND Local_Grassroots_Campaign__r.Name LIKE \'%' + localGrassrootsCampName.trim() + '%\' ';
        }
        if(dtStart != null) {
            whereClause += 'AND StartDate >= :dtStart ';
        }
        if(dtEnd != null) {
            whereClause += 'AND StartDate <= :dtEnd ';
        }
        String soql = 'SELECT Id, Name, RecordType.Name, Club_Entity__r.Name, Promo_Description__c, StartDate FROM Campaign ';
        if(whereClause.length() > 0) {
            soql += 'WHERE ' + whereClause;
        }
        soql += 'ORDER BY Name LIMIT 200';
        System.debug('soql:' + soql);
        campList = Database.query(soql);
    }
    public void cancelActionTag() {
        campList = null;
        selectedCampaign = null;
    }
    public void saveTag() {
        hasErrors = false;
        if(String.isEmpty(action.Action__c)) {
            addError('Action is Required');
            hasErrors = true;
        }
        if(! hasErrors) {
            pageController.selectedAction = action;
            action = pageController.selectedAction.clone();
            pageController.selectedActionCampaign = selectedCampaign;
        }
    }
    public void resetCampaign() {
        selectedCampaign = null;
    }
    public String getCloseAction() {
        if( ! hasErrors) {
            return 'closeTagModal()'; 
        }
        return '';
    }
    private static void addError(String message) {
        ApexPages.addmessage(
            new ApexPages.message(
                ApexPages.severity.ERROR, message)
            );
    }
}