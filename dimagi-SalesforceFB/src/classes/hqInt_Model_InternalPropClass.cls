public class hqInt_Model_InternalPropClass {

    public String area;
    public Boolean can_use_data;
    public String commcare_edition;
    public Boolean commtrack_domain;
    public Boolean custom_eula;
    public double goal_followup_rate;
    public Integer goal_time_period;
    public String[] initiative;
    public String[] platform;
    public String notes;
    public String organization_name;
    public String phone_model;
    public String project_manager;
    public String project_state;
    public Boolean self_started;
    public String services;
    public String sf_account_id;
    public String sf_contract_id;
    public String sub_area;
    public Boolean using_adm;
    public Boolean using_call_center;
    public String workshop_region;
    public String business_unit;

    public Internal_Properties__c createDbObject(String serverName) {
        Internal_Properties__c internalPropertiesObj = new Internal_Properties__c();
        internalPropertiesObj.area__c = this.area;
        internalPropertiesObj.can_use_data__c = this.can_use_data == null ? false : this.can_use_data;
        internalPropertiesObj.commcare_edition__c = this.commcare_edition;
        internalPropertiesObj.commtrack_domain__c = this.commtrack_domain == null ? false : this.commtrack_domain;
        internalPropertiesObj.custom_eula__c = this.custom_eula == null ? false : this.custom_eula;
        internalPropertiesObj.goal_followup_rate__c = this.goal_followup_rate;
        internalPropertiesObj.goal_time_period__c = this.goal_time_period;
        internalPropertiesObj.initiative__c = String.join(this.initiative, ',');
        internalPropertiesObj.platform__c = String.join(this.platform, ',');
        internalPropertiesObj.notes__c = this.notes;
        internalPropertiesObj.organization_name__c = this.organization_name;
        internalPropertiesObj.phone_model__c = this.phone_model;
        internalPropertiesObj.project_manager__c = this.project_manager;
        internalPropertiesObj.project_state__c = this.project_state;
        internalPropertiesObj.self_started__c = this.self_started == null ? false : this.self_started;
        internalPropertiesObj.services__c = this.services;
        internalPropertiesObj.sf_account_id__c = this.sf_account_id;
        internalPropertiesObj.sf_contract_id__c = this.sf_contract_id;
        internalPropertiesObj.sub_area__c = this.sub_area;
        internalPropertiesObj.using_adm__c = this.using_adm == null ? false : this.using_adm;
        internalPropertiesObj.using_call_center__c = this.using_call_center == null ? false : this.using_call_center;
        internalPropertiesObj.workshop_region__c = this.workshop_region;
        internalPropertiesObj.InternalProp_Business_Unit__c = this.business_unit;
        internalPropertiesObj.Server_Name__c = serverName;

        return internalPropertiesObj;
    }
}