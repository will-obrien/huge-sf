public with sharing class CampaignSearchController {
    private static Id groupsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
    private Campaign camp = new Campaign();
    public List<Campaign> campList {get; set;}
    public Id selectedCampaignId {get; set;}
    public String dtStartString;
    public String dtEndString;
    public Date dtStart, dtEnd;
    public String campaignName {get; set;}
    public String entityName {get; set;}
    public String localGrassrootsCampName {get; set;}
    public CampaignSetter pageController { get;
        set {
            if(value != null) {
                pageController = value;
                pageController.setCampSearchController(this);
            }
        }
    }
    public Campaign getCampaign() {
        return camp;
    }
    public void setCampaign(Campaign camp) {
        this.camp = camp;
    }
    public void setSelectedCampaign() {
        campList = null;
        Campaign selectedCamp = [select Id, Name, Promo_Description__c from Campaign where Id=:selectedCampaignId];
        pageController.setSelectedCampaign(selectedCamp);
    }
    public String getDtStartString() {
        return dtStartString;
    }
    public void setDtStartString(String dt) {
        dtStartString = dt;
        if( ! String.isEmpty(dtStartString)) {
            dtStart = Date.parse(dtStartString);
        }
    }
    public String getDtEndString() {
        return dtEndString;
    }
    public void setDtEndString(String dt) {
        dtEndString = dt;
        if( ! String.isEmpty(dtEndString)) {
            dtEnd = Date.parse(dtEndString);
        }
    }
    public void search() {
        String whereClause = 'RecordTypeId != :groupsTypeId ';
        
        String nationalCampaign, strategy, local, state, tacticOwnerCategory, tacticOwner;
        if( ! String.isEmpty(campaignName) ) {
            whereClause += 'AND Name = :campaignName ';
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
    public void cancel() {
        campList = null;
    }
}