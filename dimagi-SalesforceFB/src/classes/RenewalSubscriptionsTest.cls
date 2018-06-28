@isTest
public class RenewalSubscriptionsTest {

    private static void addTestData() {
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@dimagi.com',
            EmailEncodingKey='UTF-8', FirstName = 'FirstName', LastName='LastName', LanguageLocaleKey='en_US',
            TimeZoneSidKey='America/Panama', LocaleSidKey='en_US', ProfileId = p.Id, UserName='standarduser@dimagi.com');
        insert u;

        Subscription_Renewal_Settings__c settings = Subscription_Renewal_Settings__c.getOrgDefaults();
        settings.Default_Business_Unit__c = 'Inc';
        settings.Default_Opportunity_Owner__c = 'FirstName LastName';
        settings.Error_Emails__c = 'dimagiErrors@dimagi.com';
        settings.Pro__c = 750;
        insert settings;
    }

    public static testMethod void shouldCreateOpps() {
        addTestData();
        addTestPricebooks();

        List<PricebookEntry> entries = [SELECT Id, Name, ProductCode, UseStandardPrice, UnitPrice, Pricebook2Id FROM PricebookEntry];
        System.debug('Entries ; ' + entries);

        Accounting_BillingAccount__c billingAccount1 = new Accounting_BillingAccount__c(Server_Name__c = 'CommCareHQ', account_type__c = 'Pro', is_active__c = true, created_by__c = 'test@dimagi.com', created_by_domain__c = 'domain_1', dimagi_contact__c = 'contact_1@dimagi.com');
        insert billingAccount1;
        Accounting_BillingAccount__c billingAccount2 = new Accounting_BillingAccount__c(Server_Name__c = 'CommCareHQ', account_type__c = 'Conventional 1', is_active__c = true, created_by__c = 'test@dimagi.com', created_by_domain__c = 'domain_2', dimagi_contact__c = 'contact_1@dimagi.com');
        insert billingAccount2;
        Accounting_BillingAccount__c billingAccount3 = new Accounting_BillingAccount__c(Server_Name__c = 'CommCareHQ', account_type__c = 'Conventional 2', is_active__c = true, created_by__c = 'test@dimagi.com', created_by_domain__c = 'domain_2', dimagi_contact__c = 'contact_1@dimagi.com');
        insert billingAccount3;
        Accounting_BillingAccount__c billingAccount4 = new Accounting_BillingAccount__c(Server_Name__c = 'CommCareHQ', account_type__c = 'Conventional 3', is_active__c = true, created_by__c = 'test@dimagi.com', created_by_domain__c = 'domain_2', dimagi_contact__c = 'contact_1@dimagi.com');
        insert billingAccount4;
        Accounting_BillingAccount__c billingAccount5 = new Accounting_BillingAccount__c(Server_Name__c = 'CommCareHQ', account_type__c = 'Free', is_active__c = true, created_by__c = 'test@dimagi.com', created_by_domain__c = 'domain_3', dimagi_contact__c = 'contact_1@dimagi.com');
        insert billingAccount5;

        Business_Unit__c bizUnit = new Business_Unit__c(Name = 'Test Business Unit 1');
        Opportunity opp = new Opportunity(Name = 'AAA Opportunity 1', Business_Unit_Owner__c = bizUnit.Id, StageName = 'Stage 5 - Submitted',
                                                 CloseDate = date.today().addMonths(5), Probability = 30);
        insert opp;

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Domain__c domain1 = new Domain__c(Server_Name__c = 'CommCareHQ', Name = 'domain_1', cpAllWebUsers__c = 30, Account__c = testAccount.Id);
        insert domain1;
        Domain__c domain2 = new Domain__c(Server_Name__c = 'CommCareHQ', Name = 'domain_2', cpAllWebUsers__c = 22);
        insert domain2;
        Domain__c domain3 = new Domain__c(Server_Name__c = 'CommCareHQ', Name = 'domain_3', cpAllWebUsers__c = 11);
        insert domain3;
        Domain__c domain4 = new Domain__c(Server_Name__c = 'CommCareHQ', Name = 'domain_4', cpAllWebUsers__c = 111, Opportunity__c = opp.Id);
        insert domain4;

        Accounting_Softwareplan__c softwarePlan1 = new Accounting_Softwareplan__c(Server_Name__c = 'CommCareHQ', edition__c = 'Pro');
        insert softwarePlan1;
        Accounting_Softwareplan__c softwarePlan2 = new Accounting_Softwareplan__c(Server_Name__c = 'CommCareHQ', edition__c = 'Community');
        insert softwarePlan2;
        Accounting_Softwareplan__c softwarePlan3 = new Accounting_Softwareplan__c(Server_Name__c = 'CommCareHQ', edition__c = 'Conventional');
        insert softwarePlan3;

        Accounting_SoftwarePlanVersion__c planVersion1 = new Accounting_SoftwarePlanVersion__c(Server_Name__c = 'CommCareHQ', Accounting_SoftwarePlan__c = softwarePlan1.Id);
        insert planVersion1;
        Accounting_SoftwarePlanVersion__c planVersion2 = new Accounting_SoftwarePlanVersion__c(Server_Name__c = 'CommCareHQ', Accounting_SoftwarePlan__c = softwarePlan2.Id);
        insert planVersion2;
        Accounting_SoftwarePlanVersion__c planVersion3 = new Accounting_SoftwarePlanVersion__c(Server_Name__c = 'CommCareHQ', Accounting_SoftwarePlan__c = softwarePlan3.Id);
        insert planVersion3;

        Accounting_Subscription__c subscription1 = new Accounting_Subscription__c(Server_Name__c = 'CommCareHQ', is_trial__c = false, date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2017, 1, 1), service_type__c = 'Implementation', is_active__c = true,
                                                                                  Renewal_Opportunity_created__c = false, account__c = billingAccount1.Id, Accounting_subscriber_domain__c = domain1.Id, plan_version__c = planVersion1.Id);
        insert subscription1;
        Accounting_Subscription__c subscription2 = new Accounting_Subscription__c(Server_Name__c = 'CommCareHQ', is_trial__c = false, date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 11, 2), service_type__c = 'Other', is_active__c = true,
                                                                                  Renewal_Opportunity_created__c = false, account__c = billingAccount2.Id, Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion2.Id);
        insert subscription2;
        Accounting_Subscription__c subscription3 = new Accounting_Subscription__c(Server_Name__c = 'CommCareHQ', is_trial__c = false, date_start__c = Date.newInstance(2016, 6, 1), date_end__c = Date.newInstance(2016, 12, 3), service_type__c = 'Other', is_active__c = true,
                                                                                  Renewal_Opportunity_created__c = false, account__c = billingAccount3.Id, Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion2.Id);
        insert subscription3;
        Accounting_Subscription__c subscription4 = new Accounting_Subscription__c(Server_Name__c = 'CommCareHQ', is_trial__c = false, date_start__c = Date.newInstance(2016, 12, 3), date_end__c = Date.newInstance(2017, 1, 20), service_type__c = 'Other', is_active__c = true,
                                                                                  Renewal_Opportunity_created__c = false, account__c = billingAccount4.Id, Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion2.Id);
        insert subscription4;
        Accounting_Subscription__c subscription5 = new Accounting_Subscription__c(Server_Name__c = 'CommCareHQ', is_trial__c = false, date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2017, 5, 1), service_type__c = 'Product', is_active__c = true,
                                                                                  Renewal_Opportunity_created__c = false, account__c = billingAccount5.Id, Accounting_subscriber_domain__c = domain3.Id, plan_version__c = planVersion3.Id);
        insert subscription5;
        Accounting_Subscription__c subscription6 = new Accounting_Subscription__c(Server_Name__c = 'CommCareHQ', is_trial__c = false, date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2017, 1, 1), service_type__c = 'Product', is_active__c = true,
                                                                                  Renewal_Opportunity_created__c = false, account__c = billingAccount5.Id, Accounting_subscriber_domain__c = domain4.Id, plan_version__c = planVersion3.Id);
        insert subscription6;
        Accounting_Subscription__c subscription7 = new Accounting_Subscription__c(Server_Name__c = 'CommCareHQ', is_trial__c = false, date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2017, 1, 12), service_type__c = 'Product', is_active__c = true,
                                                                                  Renewal_Opportunity_created__c = false, account__c = billingAccount5.Id, Accounting_subscriber_domain__c = domain4.Id, plan_version__c = planVersion3.Id);
        insert subscription7;

        Test.startTest();
        RenewalSubscriptionsBatch batchJob = new RenewalSubscriptionsBatch(Date.newInstance(2016, 12, 1));
        List<Accounting_Subscription__c> futureList = batchJob.getFutureSubscriptions();
        System.assertEquals(1, futureList.size());
        List<Accounting_Subscription__c> renewalList = batchJob.getSubscriptionsForRenewal(new Set<String>());
        System.assertEquals(3, renewalList.size());
        Database.executeBatch(batchJob, 50);
        Test.stopTest();

        List<Opportunity> opps = [SELECT Id, Name, Prior_Dimagi_contact__c, Subscriptions_web_users__c, Fogbugz_Probability__c, Duration_months__c,
                                  Expected_Buffer__c, of_Execution_budget_for_GS__c, CloseDate, Domain_Name__c, Product_Text__c,
                                  StageName, Implementation_Type__c, Opportunity_Owning_Entity__c, Contract_Owner_BU__c,
                                  Implementing_Business_Unit__c, Opportunity_Source__c, Owner.Name FROM Opportunity ORDER BY Name DESC];
        System.assertEquals(3, opps.size());
        Opportunity opp1 = opps.get(0);

        System.assertEquals('contact_1@dimagi.com', opp1.Prior_Dimagi_contact__c);
        System.assertEquals('Test Account - Pro - Renewal', opp1.Name);
        System.assertEquals(30, opp1.Subscriptions_web_users__c);
        System.assertEquals(30, opp1.Fogbugz_Probability__c);
        System.assertEquals(12, opp1.Duration_months__c);
        System.assertEquals(100, opp1.Expected_Buffer__c);
        System.assertEquals(0, opp1.of_Execution_budget_for_GS__c);
        System.assertEquals(Date.newInstance(2017, 1, 1), opp1.CloseDate);
        System.assertEquals(domain1.Id, opp1.Domain_Name__c);
        System.assertEquals('Stage 3 - Prospect', opp1.StageName);
        System.assertEquals('Self Service', opp1.Implementation_Type__c);

        Business_Unit__c bu = [SELECT Id FROM Business_Unit__c WHERE Name = 'INC'];
        System.assertEquals(bu.Id, opp1.Opportunity_Owning_Entity__c);
        System.assertEquals(bu.Id, opp1.Contract_Owner_BU__c);
        System.assertEquals(bu.Id, opp1.Implementing_Business_Unit__c);
        System.assertEquals('FirstName LastName', opp1.Owner.Name);

        System.debug([SELECT Id FROM OpportunityLineItem]);
        List<OpportunityLineItem> opp1Products = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opp1.Id];
        System.assertEquals(2, opp1Products.size());

        opp1Products = [SELECT Id, Quantity, UnitPrice FROM OpportunityLineItem WHERE OpportunityId =: opp1.Id and ProductCode = 'Pro'];
        System.assertEquals(1, opp1Products.size());
        System.assertEquals(12, opp1Products.get(0).Quantity);
        System.assertEquals(750, opp1Products.get(0).UnitPrice);

        Opportunity opp2 = opps.get(1);

        System.assertEquals('contact_1@dimagi.com', opp2.Prior_Dimagi_contact__c);
        System.assertEquals('domain_2 - Community - Renewal', opp2.Name);
        System.assertEquals(22, opp2.Subscriptions_web_users__c);
        System.assertEquals(30, opp2.Fogbugz_Probability__c);
        System.assertEquals(12, opp2.Duration_months__c);
        System.assertEquals(100, opp2.Expected_Buffer__c);
        System.assertEquals(0, opp2.of_Execution_budget_for_GS__c);
        System.assertEquals(Date.newInstance(2017, 1, 20), opp2.CloseDate);
        System.assertEquals(domain2.Id, opp2.Domain_Name__c);
        System.assertEquals('Stage 3 - Prospect', opp2.StageName);
        System.assertEquals('Self Service', opp2.Implementation_Type__c);

        System.assertEquals(bu.Id, opp2.Opportunity_Owning_Entity__c);
        System.assertEquals(bu.Id, opp2.Contract_Owner_BU__c);
        System.assertEquals(bu.Id, opp2.Implementing_Business_Unit__c);
        System.assertEquals('FirstName LastName', opp2.Owner.Name);

        List<OpportunityLineItem> opp2Products = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opp2.Id];
        System.assertEquals(2, opp2Products.size());

        opp2Products = [SELECT Id, Quantity, UnitPrice FROM OpportunityLineItem WHERE OpportunityId =: opp2.Id and ProductCode = 'Community'];
        System.assertEquals(1, opp2Products.size());
        System.assertEquals(12, opp2Products.get(0).Quantity);
        System.assertEquals(0, opp2Products.get(0).UnitPrice);

        futureList = batchJob.getFutureSubscriptions();
        System.assertEquals(1, futureList.size());
        renewalList = batchJob.getSubscriptionsForRenewal(new Set<String>());
        System.assertEquals(0, renewalList.size());
        batchJob.start(null);
        batchJob.execute(null, renewalList);

        opps = [SELECT Id, Name, Prior_Dimagi_contact__c, Subscriptions_web_users__c, Fogbugz_Probability__c, Duration_months__c,
                                  Expected_Buffer__c, of_Execution_budget_for_GS__c, CloseDate, Domain_Name__c, Product_Text__c,
                                  StageName, Implementation_Type__c, Opportunity_Owning_Entity__c, Contract_Owner_BU__c,
                                  Implementing_Business_Unit__c, Opportunity_Source__c, Owner.Name FROM Opportunity ORDER BY Name DESC];
        System.assertEquals(3, opps.size());

        List<Domain__c> domains = [SELECT Id, Opportunity__c FROM Domain__c WHERE Opportunity__c != ''];
        System.assertEquals(3, domains.size());
    }

    private static void addTestPricebooks() {
        Id pricebookId = Test.getStandardPricebookId();

        Product2 productAdvanced = new Product2(Name = 'Hosting: Advanced', ProductCode = 'Advanced', Family = 'Hosting');
        insert productAdvanced;
        Product2 productCommunity = new Product2(Name = 'Hosting: Community', ProductCode = 'Community', Family = 'Hosting');
        insert productCommunity;
        Product2 productEnterprise = new Product2(Name = 'Hosting: Enterprise', ProductCode = 'Enterprise', Family = 'Hosting');
        insert productEnterprise;
        Product2 productPro = new Product2(Name = 'Hosting: Pro', ProductCode = 'Pro', Family = 'Hosting');
        insert productPro;
        Product2 producStandard = new Product2(Name = 'Hosting: Standard', ProductCode = 'Standard', Family = 'Hosting');
        insert producStandard;
        Product2 hosting = new Product2(Name = 'Managed Hosting', ProductCode = 'Managed Hosting', Family = 'Hosting');
        insert hosting;
        Product2 reseller = new Product2(Name = 'Reseller', ProductCode = 'Reseller', Family = 'Hosting');
        insert reseller;
        Product2 commCare = new Product2(Name = 'CommCare', ProductCode = 'CommCare', Family = 'Product');
        insert commCare;

        PricebookEntry productAdvancedPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productAdvanced.Id, UnitPrice = 1000, IsActive = true);
        insert productAdvancedPrice;
        PricebookEntry productCommunityPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productCommunity.Id, UnitPrice = 0, IsActive = true);
        insert productCommunityPrice;
        PricebookEntry productEnterprisePrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productEnterprise.Id, UnitPrice = 2000, IsActive = true);
        insert productEnterprisePrice;
        PricebookEntry productProPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productPro.Id, UnitPrice = 3000, IsActive = true);
        insert productProPrice;
        PricebookEntry producStandardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = producStandard.Id, UnitPrice = 500, IsActive = true);
        insert producStandardPrice;
        PricebookEntry producCommCarePrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = commCare.Id, UnitPrice = 650000, IsActive = true);
        insert producCommCarePrice;
        PricebookEntry hostingPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = hosting.Id, UnitPrice = 2000, IsActive = true);
        insert hostingPrice;
        PricebookEntry resellerPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = reseller.Id, UnitPrice = 2000, IsActive = true);
        insert resellerPrice;

        Pricebook2 dimagiPB = new Pricebook2(Name = 'Dimagi', isActive = true);
        insert dimagiPB;

        PricebookEntry productAdvancedPrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = productAdvanced.Id, UnitPrice = 1000, IsActive = true);
        insert productAdvancedPrice2;
        PricebookEntry productCommunityPrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = productCommunity.Id, UnitPrice = 0, IsActive = true);
        insert productCommunityPrice2;
        PricebookEntry productEnterprisePrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = productEnterprise.Id, UnitPrice = 2000, IsActive = true);
        insert productEnterprisePrice2;
        PricebookEntry productProPrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = productPro.Id, UnitPrice = 3000, IsActive = true);
        insert productProPrice2;
        PricebookEntry producStandardPrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = producStandard.Id, UnitPrice = 500, IsActive = true);
        insert producStandardPrice2;
        PricebookEntry producCommCarePrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = commCare.Id, UnitPrice = 650000, IsActive = true);
        insert producCommCarePrice2;
        PricebookEntry hostingPrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = hosting.Id, UnitPrice = 2000, IsActive = true);
        insert hostingPrice2;
        PricebookEntry resellerPrice2 = new PricebookEntry(Pricebook2Id = dimagiPB.Id, Product2Id = reseller.Id, UnitPrice = 2000, IsActive = true);
        insert resellerPrice2;
    }
}