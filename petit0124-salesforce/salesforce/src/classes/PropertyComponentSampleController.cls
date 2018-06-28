public with sharing class PropertyComponentSampleController extends zqu.PropertyComponentController.ParentController{
    
    ApexPages.StandardController controller;
    public zqu__Quote__c quote                      { get; set; }
    public zqu.PropertyComponentOptions theOptions  { get; set; }
    public Opportunity opp                             { get; set; }
    
    public PropertyComponentSampleController(ApexPages.StandardController stdController){
      System.debug('PropertyComponentSampleController(stdCtrl) executed!');
      this.controller = stdController;
      
      this.quote = (zqu__Quote__c) this.controller.getRecord();
      
      setOpportunity('006F000000TIXsk');
      
      // Initialize property component options
      theOptions = new zqu.PropertyComponentOptions();      theOptions.objectName = 'zqu__Quote__c';
      theOptions.viewType = zqu.ViewConfigurationManager.VIEW_CONFIGURATION_VIEW_TYPE_CREATE;
      theOptions.propertyPageTitle = 'Property Component Sample';
      theOptions.isEditMode = true;
      theOptions.parentController = this;
      theOptions.instanceName = 'sampleProperty';
      
      Schema.SObjectType objectType = zqu__Quote__c.sObjectType;
      Map<String, Schema.RecordTypeInfo> recordTypeInfoMap = objectType.getDescribe().getRecordTypeInfosByName();
      theOptions.recordTypeId = recordTypeInfoMap.get('Default').getRecordTypeId();
      
      theOptions.customRenderingFields.add('Custom_Picklist_Field__c');
      theOptions.customRenderingFields.add('Custom_Text_Field__c');
      
      theOptions.readonlyFields.add('zqu__Opportunity__c');
      
      theOptions.populateValuePlugin = 'PropertyComponentSampleController.PopulateDefaultFieldValuePlugin';
      theOptions.relatedObjectPlugin = 'PropertyComponentSampleController.PopulateRelatedObjectFieldPlugin';
      theOptions.updatePlugin = 'PropertyComponentSampleController.UpdateRecordPlugin';
      theOptions.cancelPlugin = 'PropertyComponentSampleController.CancelRecordPlugin';
    }
    
    public String selectedCustomPicklistValue { get; set; }
    
    // Set field default value
    public class PopulateDefaultFieldValuePlugin implements IPopulateValuePlugin {
      public void populateDefaultFieldValue(SObject record, zqu.PropertyComponentController.ParentController pcc) {
        
        // Get PropertyComponentSampleController instance
        PropertyComponentSampleController parentController = (PropertyComponentSampleController)pcc;
        Opportunity opportunity = parentController.opp;
        
        // Set default field values when create new quote
        if (parentController.quote.Id == null && opportunity != null) {
          
          // Set default opportunity
          record.put('zqu__Opportunity__c',opportunity.Id);
          
        }
      }
    }
    
    public class PopulateRelatedObjectFieldPlugin implements IRelatedObjectPlugin {
      public Map<String,SObject> getRelatedObject(zqu.PropertyComponentController.ParentController pcc) {
        
        // Get PropertyComponentSampleController instance
        PropertyComponentSampleController parentController = (PropertyComponentSampleController)pcc;
        
        Map<String, SObject> relatedObjectMap = new Map<String, SObject>();
        
        // Set value for related object field : Opportunity__r.AccountId
        relatedObjectMap.put('zqu__Opportunity__r',parentController.opp);
        
        return relatedObjectMap;
      }
    }
    
    public class UpdateRecordPlugin implements IUpdatePlugin {
      public PageReference doUpdate(SObject record, zqu.PropertyComponentController.ParentController pcc){
        // Add your saving logic here
        PropertyComponentSampleController parentController = (PropertyComponentSampleController)pcc;
        Opportunity opportunity = parentController.opp;
        
        PageReference pageRef = new PageReference('/apex/ZuoraProductSelector?Id=' + opportunity.Id + '&quoteType=Subscription&retUrl=%2F006F000000TIXskIAH&stepNumber=3');
        pageRef.setRedirect(true);
        return pageRef;
      }
    }
 
    public class CancelRecordPlugin implements ICancelPlugin {
      public PageReference doCancel(SObject record, zqu.PropertyComponentController.ParentController pcc){
        // Add your cancel logic here
     
        PropertyComponentSampleController parentController = (PropertyComponentSampleController)pcc;
        Opportunity opportunity = parentController.opp;
        
        PageReference pageRef = new PageReference( '/' + opportunity.Id);

        pageRef.setRedirect(true);
        return pageRef;
     
      }
    }

    
    // Action function for custom rendering field
    public void onChangeCustomPicklist() {
      System.debug('selected picklist value : ' + selectedCustomPicklistValue);
      this.quote.Custom_Picklist_Field__c = selectedCustomPicklistValue;
      this.quote.Custom_Text_Field__c = selectedCustomPicklistValue;
    }
    
    public void setOpportunity(Id oppId) {
      String opp_query;
      if (UserInfo.isMultiCurrencyOrganization()) {
        opp_query = 'SELECT Id, Name,CurrencyISOCode, Account.Id, Account.Name FROM Opportunity WHERE Id = \'' + oppId + '\'';
      } else {
        opp_query = 'SELECT Id, Name, Account.Id, Account.Name FROM Opportunity WHERE Id = \'' + oppId + '\'';
      }
      
      this.opp = Database.query(opp_query);
    }
}