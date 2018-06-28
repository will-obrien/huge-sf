/**
 * RenewalSubscriptionsBatch creates new Opps and Fogbugz cases for ending Domain Subscriptions.
 */
public without sharing class RenewalSubscriptionsBatch implements Database.Batchable<Accounting_Subscription__c>, Database.AllowsCallouts, Database.Stateful {

    private Date currentDate;
    private Business_Unit__c incBusinessUnit;
    private User defaultOppOwner;
    private Subscription_Renewal_Settings__c settings;
    private List<DatabaseErrorInfo> oppsErrors;
    private List<DatabaseErrorInfo> subsErrors;
    private Map<String, Date> createdOppsForDomains;
    private Map<String, PricebookEntry> priceBookEntries;
    private PricebookEntry commCareEntry;
    private Map<String, Decimal> salesPrices;

    public RenewalSubscriptionsBatch () {
        this.currentDate = Date.today();
    }

    public RenewalSubscriptionsBatch (Date currentDate) {
        this.currentDate = currentDate;
    }

    public List<Accounting_Subscription__c> start(Database.BatchableContext context) {
        List<Accounting_Subscription__c> subscriptions = getFutureSubscriptions();
        this.settings = Subscription_Renewal_Settings__c.getOrgDefaults();

        this.incBusinessUnit = [SELECT Id FROM Business_Unit__c WHERE Name =: settings.Default_Business_Unit__c];
        this.defaultOppOwner = [SELECT Id FROM User WHERE Name =: settings.Default_Opportunity_Owner__c];

        if (this.incBusinessUnit == null || this.defaultOppOwner == null) {
            EmailHelper.sendEmail(settings.Error_Emails__c.split(','), 'Subscription Renewal ERROR',
                                  'Cannot find default Opportunity owner or Inc business unit');
            NoDataFoundException ex = new NoDataFoundException();
            ex.setMessage('Cannot find default Opportunity owner or INC business unit');
            throw ex;
        }

        Set<String> domainsWithFutureSubscriptions = new Set<String>();
        for (Accounting_Subscription__c sb : subscriptions) {
            if (!domainsWithFutureSubscriptions.contains(sb.Accounting_subscriber_domain__r.Name)) {
                domainsWithFutureSubscriptions.add(sb.Accounting_subscriber_domain__r.Name);
            }
        }

        this.oppsErrors = new List<DatabaseErrorInfo>();
        this.subsErrors = new List<DatabaseErrorInfo>();
        this.createdOppsForDomains = new Map<String, Date>();
        this.priceBookEntries = new Map<String, PricebookEntry>();

        Set<String> productCodes = new Set<String> { 'Reseller', 'Managed Hosting', 'Advanced', 'Community', 'Enterprise', 'Pro', 'Standard' };
        PriceBook2 dimagiPriceBook = [SELECT Id FROM PriceBook2 WHERE Name = 'Dimagi'];
        List<PricebookEntry> entries = [SELECT Id, ProductCode, UnitPrice FROM PricebookEntry WHERE ProductCode IN: ProductCodes AND Pricebook2Id =: dimagiPriceBook.Id];

        for (PricebookEntry entry : entries) {
            this.priceBookEntries.put(entry.ProductCode, entry);
        }

        this.commCareEntry = [SELECT Id, ProductCode, UnitPrice FROM PricebookEntry WHERE ProductCode = 'CommCare' AND Pricebook2Id =: dimagiPriceBook.Id LIMIT 1];

        if (entries.size() != 7 || this.commCareEntry == null) {
            NoDataFoundException ex = new NoDataFoundException();
            ex.setMessage('Cannot find price book entries');
            throw ex;
        }

        this.salesPrices = new Map<String, Decimal>();
        this.salesPrices.put('Community', this.settings.Community__c != null ? this.settings.Community__c : 0);
        this.salesPrices.put('Standard', this.settings.Standard__c != null ? this.settings.Standard__c : 100);
        this.salesPrices.put('Pro', this.settings.Pro__c != null ? this.settings.Pro__c : 500);
        this.salesPrices.put('Advanced', this.settings.Advanced__c != null ? this.settings.Advanced__c : 1000);
        this.salesPrices.put('Enterprise', this.settings.Enterprise__c != null ? this.settings.Enterprise__c : 2000);
        this.salesPrices.put('Managed Hosting', this.settings.Managed_Hosting__c != null ? this.settings.Managed_Hosting__c : 2000);
        this.salesPrices.put('Reseller', this.settings.Reseller__c != null ? this.settings.Reseller__c : 500);

        return getSubscriptionsForRenewal(domainsWithFutureSubscriptions);
    }

    public void execute(Database.BatchableContext context, List<Accounting_Subscription__c> subs) {
        List<Opportunity> newOpps = new List<Opportunity>();
        List<Accounting_Subscription__c> subsToUpdate = new List<Accounting_Subscription__c>();
        List<OpportunityLineItem> opportunityProducts = new List<OpportunityLineItem>();
        List<OpportunityLineItem> opportunityCommcareProducts = new List<OpportunityLineItem>();

        Set<Id> domainsSet = new Set<Id>();
        for (Accounting_Subscription__c subscription : subs) {
            domainsSet.add(subscription.Accounting_subscriber_domain__c);
        }

        Map<Id, Domain__c> domains = new Map<Id, Domain__c> ([SELECT Id, Opportunity__c FROM Domain__c WHERE Id IN: domainsSet]);
        List<Domain__c> domainsToUpdate = new List<Domain__c>();

        for (Accounting_Subscription__c subscription : subs) {
            if (!this.createdOppsForDomains.containsKey(subscription.Accounting_subscriber_domain__c) && subscription.Renewal_Opportunity_created__c == false) {
                String oppNameFirstPart = subscription.Accounting_subscriber_domain__r.Account__r.Name != null && subscription.Accounting_subscriber_domain__r.Account__r.Name != '' ?
                                            subscription.Accounting_subscriber_domain__r.Account__r.Name : subscription.Accounting_subscriber_domain__r.Name;

                Opportunity newOpp = new Opportunity(
                                                        Prior_Dimagi_contact__c = subscription.Dimagi_Contact__c,
                                                        Name = oppNameFirstPart + ' - ' + subscription.Software_Plan_Edition__c + ' - Renewal',
                                                        Subscriptions_web_users__c = subscription.Accounting_subscriber_domain__r.cpAllWebUsers__c,
                                                        Fogbugz_Probability__c = 30,
                                                        Probability = 30,
                                                        Duration_months__c = 12,
                                                        Expected_Buffer__c = 100,
                                                        of_Execution_budget_for_GS__c = 0,
                                                        CloseDate = subscription.date_end__c,
                                                        Domain_Name__c = subscription.Accounting_subscriber_domain__c,
                                                        StageName = 'Stage 3 - Prospect',
                                                        OwnerId = this.defaultOppOwner.Id,
                                                        Implementation_Type__c = 'Self Service',
                                                        Channel_Response__c = 'Inside Sales',
                                                        Opportunity_Owning_Entity__c = this.incBusinessUnit.Id,
                                                        Contract_Owner_BU__c = this.incBusinessUnit.Id,
                                                        Implementing_Business_Unit__c = this.incBusinessUnit.Id
                                                    );

                if (subscription.service_type__c == 'Implementation' || subscription.service_type__c == 'Product') {
                    newOpp.Opportunity_Source__c = 'Implementation Renewal';
                } else {
                    newOpp.Opportunity_Source__c = 'Product Renewal';
                }

                subscription.Renewal_Opportunity_created__c = true;
                newOpps.add(newOpp);
                subsToUpdate.add(subscription);

                PricebookEntry pbe = this.priceBookEntries.get(subscription.Software_Plan_Edition__c);
                Decimal price = this.salesPrices.get(subscription.Software_Plan_Edition__c);
                opportunityProducts.add(new OpportunityLineItem(PricebookEntryId = pbe.Id, Quantity = 12, UnitPrice = price));
                opportunityCommcareProducts.add(new OpportunityLineItem(PricebookEntryId = commCareEntry.Id, Quantity = 1, UnitPrice = commCareEntry.UnitPrice));

                Domain__c domainToUpdate = domains.get(subscription.Accounting_subscriber_domain__c);
                domainsToUpdate.add(domainToUpdate);
            }
            // we must create Opp only for the latest subscription which will end
            if (!this.createdOppsForDomains.containsKey(subscription.Accounting_subscriber_domain__c)) {
                this.createdOppsForDomains.put(subscription.Accounting_subscriber_domain__c, subscription.date_end__c);
            }
        }

        // Create new Opps
        if (newOpps.size() > 0) {
            List<Database.SaveResult> insertResults = Database.insert(newOpps, false);
            for(Integer i = 0; i < insertResults.size(); i++){
                if (!insertResults.get(i).isSuccess()){
                    Database.Error error = insertResults.get(i).getErrors().get(0);
                    System.debug('Opp Error : Fields - ' + error.getFields() + ' Message - ' + error.getMessage());
                    this.oppsErrors.add(new DatabaseErrorInfo(newOpps.get(i).Domain_Name__c, 'Fields - ' + error.getFields() + ' Message - ' + error.getMessage()));
                }
            }
            for (Integer i = 0; i < newOpps.size(); i++) {
                Opportunity o = newOpps.get(i);
                if (!String.isBlank(o.Id)) {
                    opportunityProducts.get(i).OpportunityId = o.Id;
                    opportunityCommcareProducts.get(i).OpportunityId = o.Id;
                    domainsToUpdate.get(i).Opportunity__c = o.Id;
                }
            }
        }

        // Add Opp products
        if (opportunityProducts.size() > 0) {
            processProductsErrors(Database.insert(opportunityProducts, false), newOpps);
            processProductsErrors(Database.insert(opportunityCommcareProducts, false), newOpps);
            processProductsErrors(Database.update(domainsToUpdate, false), newOpps);
        }

        // Update subscriptions
        if (subsToUpdate.size() > 0) {
            List<Database.SaveResult> updateResults = Database.update(subsToUpdate, false);
            for(Integer i = 0; i < updateResults.size(); i++){
                if (!updateResults.get(i).isSuccess()){
                    Database.Error error = updateResults.get(i).getErrors().get(0);
                    this.subsErrors.add(new DatabaseErrorInfo(updateResults.get(i).getId(), 'Fields - ' + error.getFields() + ' Message - ' + error.getMessage()));
                }
            }
        }
    }

    public void finish(Database.BatchableContext context) {
        if (Test.isRunningTest()) {
            return;
        }

        Database.executeBatch(new CreateFBCasesBatch(), 5);

        String emailBody = 'RenewalSubscriptionsBatch : ' + Date.today();
        Boolean tableStart = false;

        if (oppsErrors.size() > 0) {
            emailBody += '</br></br>OPP Errors : </br>';
            emailBody += '<table border="1"><tr><td>Domain Id</td><td>Error Message</td></tr>';
            for (DatabaseErrorInfo er : this.oppsErrors) {
                emailBody += '<tr><td>' + er.objectId + '</td><td>' + er.errorMessage + '</td></tr>';
            }
            emailBody += '</table></br></br>Subs Errors : </br>';
        }

        if (subsErrors.size() > 0) {
            emailBody += '<table border="1"><tr><td>Sub Id</td><td>Error Message</td></tr>';
            for (DatabaseErrorInfo er : this.subsErrors) {
                emailBody += '<tr><td>' + er.objectId + '</td><td>' + er.errorMessage + '</td></tr>';
            }
            emailBody += '</table>';
        }

        EmailHelper.sendEmail(settings.Error_Emails__c.split(','), 'Subscription Renewal Job Status', emailBody);
    }

    public class DatabaseErrorInfo {

        public DatabaseErrorInfo (String id, String message) {
            this.objectId = id;
            this.errorMessage = message;
        }

        public String objectId { get; set; }
        public String errorMessage { get; set; }
    }

    /**
     * Returns Subscriptions which ends after 60 days
     */
    public List<Accounting_Subscription__c> getFutureSubscriptions() {
        return [SELECT Id, Accounting_subscriber_domain__r.Name FROM Accounting_Subscription__c
                WHERE Accounting_subscriber_domain__r.Name != '' AND is_active__c = true AND is_trial__c = false
                AND date_end__c != null AND date_end__c >: this.currentDate.addDays(60) AND Server_Name__c = 'CommCareHQ'];
    }

    /**
     * Returns Subscriptions which ends in 60 days for domains which dosen't contain subscriptions from future (which ends after 60 days).
     */
    public List<Accounting_Subscription__c> getSubscriptionsForRenewal(Set<String> domainsWithFutureSubscriptions) {
        return [SELECT Id, date_end__c, service_type__c, Accounting_subscriber_domain__c, Accounting_subscriber_domain__r.Name, Dimagi_Contact__c, Accounting_subscriber_domain__r.Account__r.Name,
                Accounting_subscriber_domain__r.cpAllWebUsers__c, Software_Plan_Edition__c, Renewal_Opportunity_created__c FROM Accounting_Subscription__c
                WHERE Accounting_subscriber_domain__r.Name != '' AND Accounting_subscriber_domain__r.Opportunity__c = '' AND date_end__c != null AND date_end__c <=: this.currentDate.addDays(60)
                AND date_end__c >=: this.currentDate AND Accounting_subscriber_domain__r.Name NOT IN: domainsWithFutureSubscriptions AND is_active__c = true
                AND is_trial__c = false AND Server_Name__c = 'CommCareHQ' ORDER BY date_end__c DESC];
    }

    private void processProductsErrors(List<Database.SaveResult> insertResults, List<Opportunity> newOpps) {
        for(Integer i = 0; i < insertResults.size(); i++){
            if (!insertResults.get(i).isSuccess()){
                Database.Error error = insertResults.get(i).getErrors().get(0);
                System.debug('Opp Error : Fields - ' + error.getFields() + ' Message - ' + error.getMessage());
                this.oppsErrors.add(new DatabaseErrorInfo(newOpps.get(i).Domain_Name__c, 'Cannot create Product/updateDomain: Fields - ' + error.getFields() + ' Message - ' + error.getMessage()));
            }
        }
    }
}