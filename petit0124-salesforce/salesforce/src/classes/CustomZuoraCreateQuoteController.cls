public with sharing class CustomZuoraCreateQuoteController extends zqu.PropertyComponentController.ParentController {
 ApexPages.StandardController controller;
 public zqu__Quote__c quote {
   get;
   set;
 }
 public zqu.PropertyComponentOptions theOptions {
   get;
   set;
 }
 public Opportunity opp {
   get;
   set;
 }
 public zqu.NotificationOptions notificationOptions {
   get {
     if (notificationOptions == null) notificationOptions = new zqu.NotificationOptions();
     return notificationOptions;
   }
   set;
 }
 public String quoteType {
   get;
   set;
 }
 public Zuora.zObject subscription {
   get;
   set;
 }
 private static final Map < String, Schema.RecordTypeInfo > recordTypeInfoMap = zqu__Quote__c.sObjectType.getDescribe().getRecordTypeInfosByName();
 private static final String CANCEL_QUOTE_WIZARD_WARNING = 'Are you sure you want to cancel? This action will delete the quote you are currently creating.';
 // Constructor
 public CustomZuoraCreateQuoteController(ApexPages.StandardController stdController) {
   System.debug('CustomZuoraCreateQuoteController(stdCtrl) executed!');
   this.controller = stdController;
   this.quote = (zqu__Quote__c)this.controller.getRecord();
   // Get opportunity from id in URL parameters
   final String oppId = ApexPages.currentPage().getParameters().get('oppid');
   if (String.isBlank(oppId)) {
     throw new zqu.ZQException('Need to specify the oppid in the url.');
   }
   setOpportunity(oppId);
   // Initialize property component options
   theOptions = new zqu.PropertyComponentOptions();
   theOptions.objectName = 'zqu__Quote__c';
   theOptions.objectId = this.quote.Id != null ? this.quote.Id : null;
   theOptions.viewType = zqu.ViewConfigurationManager.VIEW_CONFIGURATION_VIEW_TYPE_CREATE;
   theOptions.propertyPageTitle = 'Create Quote Sample';
   theOptions.isEditMode = true;
   // Initialize notification options
   notificationOptions.isPopup = false;
   theOptions.notificationOptions = notificationOptions;
   // Set to detail mode
   String mode = ApexPages.currentPage().getParameters().get('mode');
   if (this.quote.Id != null && mode == 'detail')
     theOptions.isEditMode = false;
   theOptions.renderButtonBar = theOptions.isEditMode;
   theOptions.renderBackButton = true;
   theOptions.parentController = this;
   theOptions.instanceName = 'sampleProperty';
   // Get the quote type from the URL paramters
   this.quoteType = ApexPages.currentPage().getParameters().get('quoteType');
   if (String.isBlank(this.quoteType)) {
     throw new zqu.ZQException('Need to specify the quotetype in the url.');
   }
   // Set the record type Id based on the quote type
   final String recordTypeName = this.quotetype == 'Subscription' ? 'Default' : this.quoteType;
   theOptions.recordTypeId = recordTypeInfoMap.get(recordTypeName).getRecordTypeId();
   theOptions.populateValuePlugin = 'CustomZuoraCreateQuoteController.PopulateDefaultFieldValuePlugin';
   theOptions.relatedObjectPlugin = 'CustomZuoraCreateQuoteController.PopulateRelatedObjectFieldPlugin';
   theOptions.goBackPlugin = 'CustomZuoraCreateQuoteController.GoBackPlugin';
   theOptions.updatePlugin = 'CustomZuoraCreateQuoteController.UpdateRecordPlugin';
   theOptions.cancelPlugin = 'CustomZuoraCreateQuoteController.CancelRecordPlugin';
   // Set read only fields
   theOptions.readonlyFields.add('zqu__Opportunity__c');
   theOptions.readonlyFields.add('zqu__SubscriptionVersion__c');
   if(this.quoteType == 'Renewal') theOptions.readonlyFields.add('zqu__Subscription_Term_Type__c');
   // For existing billing accounts, currency should be read only
   if(String.isNotBlank(ApexPages.currentPage().getParameters().get('billingAccountId'))) theOptions.readonlyFields.add('zqu__Currency__c');
   if (this.opp != null) {
     // Set up options for Bill To Contact lookup field
     zqu.LookupComponentOptions optionsForBillTo = new zqu.LookupComponentOptions();
     optionsForBillTo.objectName = 'Contact';
     optionsForBillTo.Id = 'BillToContact';
     optionsForBillTo.contextParameters = new Map < String, String > {
       'objectId' => this.opp.Id
     };
     optionsForBillTo.isEditMode = theOptions.isEditMode;
     optionsForBillTo.isRequired = true;
     optionsForBillTo.lookupComponentControllerName = 'zqu.ContactLookupComponentController';
     optionsForBillTo.recordTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Master').getRecordTypeId();
     optionsForBillTo.popupWindowTitle = 'Bill to Contact Lookup';
     optionsForBillTo.fieldLabel = 'Bill to Contact';
     // Set up options for Sold To Contact lookup field
     zqu.LookupComponentOptions optionsForSoldTo = new zqu.LookupComponentOptions();
     optionsForSoldTo.objectName = 'Contact';
     optionsForSoldTo.Id = 'SoldToContact';
     optionsForSoldTo.contextParameters = new Map < String, String > {
       'objectId' => this.opp.Id
     };
     optionsForSoldTo.isEditMode = theOptions.isEditMode;
     optionsForSoldTo.isRequired = true;
     optionsForSoldTo.lookupComponentControllerName = 'zqu.ContactLookupComponentController';
     optionsForSoldTo.recordTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Master').getRecordTypeId();
     optionsForSoldTo.popupWindowTitle = 'Sold to Contact Lookup';
     optionsForSoldTo.fieldLabel = 'Sold To Contact';
     theOptions.lookupFields = new Map < String, zqu.LookupComponentOptions > {
       'zqu__BillToContact__c' => optionsForBillTo,
         'zqu__SoldToContact__c' => optionsForSoldTo
     };
   }
 }
 // Plugin to set field default values
public class PopulateDefaultFieldValuePlugin implements IPopulateValuePlugin {
 // ZApi for querying existing subscription and billing account from Zuora
 private Zuora.zApi api {
   get {
     if (api == null) api = new Zuora.zApi();
     return api;
   }
   set;
 }
 public void populateDefaultFieldValue(SObject record, zqu.PropertyComponentController.ParentController pcc) {
   // Get CustomZuoraCreateQuoteController instance
   CustomZuoraCreateQuoteController parentController = (CustomZuoraCreateQuoteController) pcc;
   Opportunity opportunity = parentController.opp;
   // Set default field values when create new quote
   if (parentController.quote.Id == null && opportunity != null) {
     // Set default opportunity
     record.put('zqu__Opportunity__c', opportunity.Id);
   }
   record.put('Name', 'Sample Quote Name');
   if ('Amendment' == parentController.quoteType || 'Renewal' == parentController.quoteType) {
     final String billingAccountId = ApexPages.currentPage().getParameters().get('billingaccountid');
     if (String.isNotBlank(billingAccountId)) {
       record.put('zqu__ZuoraAccountId__c', billingAccountId);
     }
     else {
       throw new zqu.ZQException('Need to specify the billingaccountid for ' + parentController.quoteType + ' in the url.');
     }
     final String existSubscriptionID = ApexPages.currentPage().getParameters().get('subscriptionid');
      
     if (String.isNotBlank(existSubscriptionId)) {
       record.put('zqu__existSubscriptionID__c', existSubscriptionId);
     }
     else {
       throw new zqu.ZQException('Need to specify the existsubscriptionid for ' + parentController.quoteType + ' in the url.');
     }
     try {
       api.zlogin();
       Zuora.zObject acczobj = this.getBillingAccount(billingAccountID);
       if (acczobj != null) {
         record.put('zqu__Currency__c', (String) acczobj.getValue('Currency'));
       }
       final Zuora.zObject subzobj = this.getSubscription(existSubscriptionId);
       if (null != subzobj) {
         parentController.subscription = subzobj;
         // For amendments
         if ('Amend' == parentController.quoteType) {
           record.put('zqu__StartDate__c', ((Datetime) subzobj.getValue('TermStartDate')).date());
         }
         // For renewals
         else {
           record.put('zqu__StartDate__c', ((Datetime) subzobj.getValue('TermEndDate')).date());
         }
         // Populate terms and conditions from original subscription
         record.put('zqu__AutoRenew__c', (Boolean) subzobj.getValue('AutoRenew'));
         record.put('zqu__InitialTerm__c', (Integer) subzobj.getValue('InitialTerm'));
         record.put('zqu__RenewalTerm__c', (Integer) subzobj.getValue('RenewalTerm'));
         record.put('zqu__SubscriptionTermStartDate__c', ((Datetime) subzobj.getValue('TermStartDate')).date());
         record.put('zqu__SubscriptionTermEndDate__c', ((Datetime) subzobj.getValue('TermEndDate')).date());
         record.put('zqu__Subscription_Term_Type__c', (String) subzobj.getValue('TermType'));
         record.put('zqu__Hidden_Subscription_Name__c', (String) subzobj.getValue('Name'));
         record.put('zqu__SubscriptionVersion__c', (Integer) subzobj.getValue('Version'));
       }
     }
     catch (Exception e) {
       throw new zqu.ZQException(e.getMessage());
     }
   }
   // Set record type and subscription type based on quote type URL parameter
   if (parentController.quoteType == 'Subscription') {
     record.put('zqu__SubscriptionType__c', 'New Subscription');
     record.put('RecordTypeId', CustomZuoraCreateQuoteController.recordTypeInfoMap.get('Default').getRecordTypeId());
   }
   else if (parentController.quoteType == 'Amendment') {
     record.put('zqu__SubscriptionType__c', 'Amend Subscription');
     record.put('RecordTypeId', CustomZuoraCreateQuoteController.recordTypeInfoMap.get('Amendment').getRecordTypeId());
   }
   else if (parentController.quoteType == 'Renewal') {
     record.put('zqu__SubscriptionType__c', 'Renew Subscription');
     record.put('RecordTypeId', CustomZuoraCreateQuoteController.recordTypeInfoMap.get('Renewal').getRecordTypeId());
   }
 
   // For edit / detail mode, make sure the quote is get from record of property component
   if (parentController.quote.Id != null) {
     parentController.quote = (zqu__Quote__c) record;
   }
 }
 private Zuora.zObject getSubscription(String subscriptionId) {
   final Zuora.zObject subzobj;
   final String zoqlsubscription = 'Select Id, Name, Version, AccountId, OriginalId, ContractEffectiveDate, AutoRenew, InitialTerm, TermStartDate, TermEndDate, TermType, RenewalTerm from Subscription where Id = \'' + subscriptionId + '\'';
   final List < Zuora.zObject > subzobjs = api.zquery(zoqlsubscription);
   if (subzobjs.size() == 1) subzobj = subzobjs[0];
   return subzobj;
 }
 private Zuora.zObject getBillingAccount(String billingaccountId) {
   final Zuora.zObject acczobj;
   final String zoqlacc = 'SELECT BillToId,SoldToId,Currency from Account where Id=\'' + billingaccountId + '\'';
   final List < Zuora.zObject > acczobjs = api.zquery(zoqlacc);
   if (acczobjs.size() == 1) acczobj = acczobjs[0];
   return acczobj;
 }
}
 // Plugin to populate related objects
 public class PopulateRelatedObjectFieldPlugin implements IRelatedObjectPlugin {
   public Map < String, SObject > getRelatedObject(zqu.PropertyComponentController.ParentController pcc) {
     // Get CustomZuoraCreateQuoteController instance
     CustomZuoraCreateQuoteController parentController = (CustomZuoraCreateQuoteController) pcc;
     Map < String, SObject > relatedObjectMap = new Map < String, SObject > ();
     // Set value for related object field : Opportunity__r.AccountId
     relatedObjectMap.put('Opportunity__r', parentController.opp);
     return relatedObjectMap;
   }
 }
 //Plugin for Back button
 public virtual class GoBackPlugin implements IGoBackPlugin {
   public virtual PageReference goBack(SObject record, zqu.PropertyComponentController.ParentController pcc) {
     //Cast parent controller
     CustomZuoraCreateQuoteController parentController = (CustomZuoraCreateQuoteController) pcc;
     PageReference pageRef;
      
     //If on step number 1, cancel the quote wizard
     if (ApexPages.currentPage().getParameters().get('stepNumber') == '1') {
       pageRef = zqu.QuoteWizardManager.cancel(parentController.getReturnUrl());
     }
     //Else, revert the quote wizard
     else {
       if(parentController.opp != null){
         pageRef = zqu.QuoteWizardManager.navigateBack(new Map < String, String > {
           'oppId' => parentController.opp.Id
         });
       }
       else {
         Map<String, String> urlParams = new Map<String, String>();
         if(ApexPages.currentPage().getParameters().get('crmAccountId') != null){
           urlParams.put('crmAccountId', ApexPages.currentPage().getParameters().get('crmAccountId'));
         }
         if(ApexPages.currentPage().getParameters().get('retUrl') != null){
           urlParams.put('retUrl', ApexPages.currentPage().getParameters().get('retUrl'));
         }
         pageRef = zqu.QuoteWizardManager.navigateBack(urlParams);
       }
     }
     return pageRef;
   }
 }
 // Plugin for Save button
 public virtual class UpdateRecordPlugin implements IUpdatePlugin {
   public virtual PageReference doUpdate(SObject record, zqu.PropertyComponentController.ParentController pcc) {
     // Get ZQQuoteEditController instance
     CustomZuoraCreateQuoteController parentController = (CustomZuoraCreateQuoteController) pcc;
     // Set changes to be processed for T&C amendments
     parentController.prepareTermsAndConditionChanges(record);
     // Changed for upsert
     try{
       upsert record;
     } catch (Exception e){
       ApexPages.addMessages(e);
       return null;
     }
     // Map of URL parameters for next page
     Map < String, String > urlParams = new Map < String, String > {
       'Id' => record.Id
     };
     // Use quoteWizardManager to navigate to the next page of the quoting flow
     PageReference pageRef = zqu.QuoteWizardManager.navigateNext(urlParams);
     return pageRef;
   }
 }
 // Plugin for Cancel button
 public virtual class CancelRecordPlugin implements ICancelPlugin {
   public virtual PageReference doCancel(SObject record, zqu.PropertyComponentController.ParentController pcc) {
     // Get CustomZuoraCreateQuoteController instance
     CustomZuoraCreateQuoteController parentController = (CustomZuoraCreateQuoteController) pcc;
     // Put the embedded notification component into popup mode
     parentController.enablePopup();
     // Display warning message on popup notification
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, CANCEL_QUOTE_WIZARD_WARNING));
     return null;
   }
 }
 // Private helper methods
 // Enable popup mode for notification component
 private void enablePopup() {
   notificationOptions.isPopup = true;
   notificationOptions.continueAction = 'hidePopupNotification(); displayStatusModal(); doCancel()';
   notificationOptions.backAction = 'hidePopupNotification(); closeStatusModal(); goBack();';
 }
 // Disable popup mode for notification component
 private void disablePopup() {
   notificationOptions.isPopup = false;
   notificationOptions.continueAction = '';
   notificationOptions.backAction = '';
 }
 private String getReturnUrl() {
   String retUrl = null;
   if (this.opp != null) {
     retUrl = '/' + this.opp.Id;
   }
   else if (ApexPages.currentPage() != null && ApexPages.currentPage().getParameters().get('retUrl') != null) {
     retUrl = ApexPages.currentPage().getParameters().get('retUrl');
   }
   else {
     retUrl = Page.zqu__QuoteList.getUrl();
   }
   return retUrl;
 }
 public void prepareTermsAndConditionChanges(SObject record) {
   // Cast the record into a quote object
   zqu__Quote__c quote = (zqu__Quote__c)record;
   // Do not process T&C amendments if the quote is not linked to a subscription
   if(String.isBlank(quote.zqu__ExistSubscriptionID__c)) return;
   // Get the terms and condition changes
   Map < String, Object > termsAndConditionChanges = getTermAndConditionChanges(this.subscription, quote);
   // Pass the changes to subscriptionTermsMap to be used when the quote record is upserted
   zqu.zQuoteUtil.setSubscriptionTermChanges(new Map<String, Map<String, Object>>{quote.zqu__ExistSubscriptionID__c => termsAndConditionChanges});
 }
 private static Map < String, Object > getTermAndConditionChanges(Zuora.zObject originalSub, zqu__Quote__c quote) {
   // Initialize changes to empty map
   Map < String, Object > changes = new Map < String, Object > ();
   // First, add the differences for AutoRenew and RenewalTerm (they are valid for both amendments and renewals)
   if ((Boolean)originalSub.getValue('AutoRenew') != quote.zqu__AutoRenew__c) changes.put('zqu__AutoRenew__c', String.valueOf(quote.zqu__AutoRenew__c));
   if ((Integer)originalSub.getValue('RenewalTerm') != quote.zqu__RenewalTerm__c && quote.zqu__RenewalTerm__c != 0) changes.put('zqu__RenewalTerm__c', quote.zqu__RenewalTerm__c);
    
   // If the update version of the quote has a type of Renewal, do not generate differences for the remaining fields (they are not valid for renewal quotes)
   if (quote.zqu__SubscriptionType__c == 'Renew Amendment') return changes;
   // Compare every terms/conditions field of the quote to the original subscription information, adding any discrepancies found
   if ((String)originalSub.getValue('TermType') != quote.zqu__Subscription_Term_Type__c) changes.put('zqu__Subscription_Term_Type__c', quote.zqu__Subscription_Term_Type__c);
   if (((Datetime)originalSub.getValue('TermStartDate')).dateGMT() != quote.zqu__SubscriptionTermStartDate__c) changes.put('zqu__TermStartDate__c', quote.zqu__SubscriptionTermStartDate__c);
   if ((Integer)originalSub.getValue('InitialTerm') != quote.zqu__InitialTerm__c && quote.zqu__InitialTerm__c != 0) changes.put('zqu__InitialTerm__c', quote.zqu__InitialTerm__c);
   return changes;
 }
 // Public methods called from javascript in page
 // When user clicks cancel on popup notification component
 public PageReference cancelQuoteWizard() {
   return zqu.QuoteWizardManager.cancel(getReturnUrl());
 }
 // When user clicks goBack on popup notification, disable popup and rerender page without taking any action
 public PageReference goBack() {
   disablePopup();
   return null;
 }
 public void setOpportunity(Id oppId) {
   String opp_query;
   if (UserInfo.isMultiCurrencyOrganization()) {
     opp_query = 'SELECT Id, Name,CurrencyISOCode, Account.Id, Account.Name FROM Opportunity WHERE Id = \'' + oppId + '\'';
   }
   else {
     opp_query = 'SELECT Id, Name, Account.Id, Account.Name FROM Opportunity WHERE Id = \'' + oppId + '\'';
   }
   this.opp = Database.query(opp_query);
 }
}