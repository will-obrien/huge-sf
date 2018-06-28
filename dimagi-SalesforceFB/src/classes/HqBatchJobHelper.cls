/**
 * Helper class which is used to start and manage synchronization from CommCare servers.
 */
public class HqBatchJobHelper {

    /**
     * Starts Domains sunchronization.
     */
    public static void startDomainJob() {
        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();

        if (settings.Is_Domain_Job_Running__c == true) {
            return;
        }

        settings.Is_Domain_Job_Running__c = true;
        update settings;

        List<String> servers = getCommcareServers(false);
        if (servers.size() > 0) {
            String serverCode = servers.get(0);
            servers.remove(0);
            Database.executeBatch(new HqBatchFetchDataDomains(serverCode, servers), 1);
        }
    }

    /**
     * Ends Domains synchronization.
     */
    public static void endDomainJob() {
        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();

        if (settings.Is_Domain_Job_Running__c == false) {
            return;
        }

        settings.Is_Domain_Job_Running__c = false;
        update settings;
    }

    /**
     * Starts Accounting objects synchronization.
     */
    public static void startBatchJobs() {
        Date startDate = Date.today();

        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        settings.Job_Start_Date__c = startDate;
        if (settings.Is_Job_Running__c == true) {
            return;
        }
        settings.Is_Job_Running__c = true;

        update settings;

        List<String> servers = getCommcareServers(false);
        if (servers.size() > 0) {
            String serverCode = servers.get(0);
            servers.remove(0);
            if(!Test.IsRunningTest()) {
                runNextBatchJob(1, serverCode, servers);
            }
        }
    }

    /**
     * Ends Accounting objects synchronization.
     */
    public static void endBatchJobs() {
        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        settings.Is_Job_Running__c = false;
        settings.Server_Code__c = '';
        update settings;
    }

    /**
     * Runs next batch job for Accounting objects from the given server.
     */
    public static void runNextBatchJob(Integer batchToBeRun, String serverCode, List<String> nextServers) {
        Boolean lastBatch = false;

        try {
            if(batchToBeRun == 1) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_feature__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'accounting_features/', nextServers), 1);
            } else if (batchToBeRun == 2) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_Softwareplan__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'software_plan/', nextServers), 1);
            } else if (batchToBeRun == 3) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_Subscriber__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'subscriber/', nextServers), 1);
            } else if (batchToBeRun == 4) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_Featurerate__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'accounting_feature_rates/', nextServers), 1);
            } else if (batchToBeRun == 5) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_SoftwareProductRate__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'software_product_rate/', nextServers), 1);
            } else if (batchToBeRun == 6) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_SoftwarePlanVersion__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'software_plan_versions/', nextServers), 1);
            } else if (batchToBeRun == 7) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_PaymentMethod__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'accounting_payment_method/', nextServers), 1);
            } else if (batchToBeRun  == 8) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_BillingContactInfo__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'billing_contact_info/', nextServers), 1);
            } else if (batchToBeRun == 9) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_Paymentrecord__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'payment_record/', nextServers), 1);
            } else if (batchToBeRun == 10) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_Billingaccount__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'billing_account/', nextServers), 1);
            } else if (batchToBeRun == 11) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_Subscription__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'subscription/', nextServers), 1);
            } else if (batchToBeRun == 12) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_Invoice__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'invoice/', nextServers), 1);
            } else if (batchToBeRun == 13) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_LineItems__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'accounting_line_items/', nextServers), 1);
            } else if (batchToBeRun == 14) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_SubscriptionAdjustment__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'subscription_and_adjustment/', nextServers), 1);
            } else if (batchToBeRun == 15) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_CreditLine__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'credit_line/', nextServers), 1);
            } else if (batchToBeRun == 16) {
                Database.executeBatch(new HqBatchFetchDataObjects(batchToBeRun, Accounting_CreditAdjustment__c.SObjectType.getDescribe().getLabel(),
                                        serverCode, 'credit_adjustment/', nextServers), 1);
            } else if (nextServers.size() > 0) {
                HqBatchJobHelper.updateMissingRelations(serverCode);
                String newServerCode = nextServers.get(0);
                nextServers.remove(0);
                Database.executeBatch(new HqBatchFetchDataObjects(1, Accounting_feature__c.SObjectType.getDescribe().getLabel(), newServerCode,
                                        'accounting_features/', nextServers), 1);
            } else {
                HqBatchJobHelper.endBatchJobs();
                Database.executeBatch(new CalculateDomainsLifeTimeMRRBatch(), 100);
            }
        } catch (Exception e) {
            HqBatchJobHelper.endBatchJobs();
        }
    }

    public static List<String> getCommcareServers(Boolean skipBatchData) {
        List<String> servers = new List<String>();
        List<CommcareToSalesforceSettings__c> serverSettingsList = CommcareToSalesforceSettings__c.getAll().values();
        for (CommcareToSalesforceSettings__c serverSettings : serverSettingsList) {
            if (serverSettings.Skip_in_batch_job__c == false || skipBatchData == true) {
                servers.add(serverSettings.Name);
            }
        }
        return servers;
    }

    public static void updateMissingRelations(String serverName) {
        try {
            updateMissingSubscriberDomain(serverName);
            updateMissingSpaceLink(serverName);
            updateMissingSubscriptionDomain(serverName);
        } catch (Exception ex) {
            Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
            System.debug('Error: ' + ex);
            EmailHelper.sendEmailFromException(settings.Error_Emails__c.split(','), 'Commcare sync Error', 'Cannot update missing relations: ' + serverName, ex);
        }
    }

    private static void updateMissingSpaceLink(String serverName) {
        List<Accounting_Invoice__c> accountingInvoice = [SELECT id__c, Accounting_Subscription__r.Accounting_Subscriber__r.domain__c, Project_Space__c
                                                         FROM Accounting_Invoice__c WHERE Project_Space__c = '' AND Server_Name__c =: serverName];
        List<Accounting_Invoice__c> accountingInvoiceToUpdate = new List<Accounting_Invoice__c>();
        System.debug('---Accounting Invoice with blank domain relation link---' + accountingInvoice);
        if (accountingInvoice.size() == 0) {
            return;
        }

        Set<String> domainNames = new Set<String>();
        for(Accounting_Invoice__c ac : accountingInvoice) {
            if (ac.Accounting_Subscription__r != null && ac.Accounting_Subscription__r.Accounting_Subscriber__r != null) {
                domainNames.add(ac.Accounting_Subscription__r.Accounting_Subscriber__r.domain__c);
                accountingInvoiceToUpdate.add(ac);
            }
        }

        System.debug('---domainNames---' + domainNames);

        if (domainNames.size() > 0) {
            Map <String, Id> mapDomainNameId = new Map<String, Id>();
            for(Domain__c domain : [SELECT Id, Name FROM Domain__c WHERE Name in: domainNames AND Server_Name__c =: serverName]) {
                mapDomainNameId.put(domain.Name, domain.Id);
            }

            for (Accounting_Invoice__c ac : accountingInvoiceToUpdate) {
                Id domainId = mapDomainNameId.get(ac.Accounting_Subscription__r.Accounting_Subscriber__r.domain__c);
                if (domainId != null) {
                    ac.Project_Space__c = domainId;
                }
            }

            update accountingInvoiceToUpdate;
        }
    }

    private static void updateMissingSubscriberDomain(String serverName) {
        List<Accounting_Subscriber__c> subscribers = [SELECT domain__c, domain_lookup__c FROM Accounting_Subscriber__c WHERE domain_lookup__c = '' AND Server_Name__c =: serverName];
        System.debug('---Subscribers with blank domain relation---' + subscribers);

        if (subscribers.size() > 0) {
            Set<String> domainNames = new Set<String>();
            for (Accounting_Subscriber__c subscriber : subscribers) {
                domainNames.add(subscriber.domain__c);
            }
            System.debug('---domainNames---' + domainNames);

            if (domainNames.size() == 0) {
                return;
            }

            Map <String, Id> mapDomainNameId = new Map<String, Id>();
            for(Domain__c domain : [SELECT Id, Name FROM Domain__c WHERE Name in: domainNames AND Server_Name__c =: serverName]) {
                mapDomainNameId.put(domain.Name, domain.Id);
            }

            for (Accounting_Subscriber__c subscriber : subscribers) {
                Id domainId = mapDomainNameId.get(subscriber.domain__c);
                if (domainId != null) {
                    subscriber.domain_lookup__c = domainId;
                }
            }

            update subscribers;
        }
    }

    private static void updateMissingSubscriptionDomain(String serverName) {
        List<Accounting_Subscription__c> subscriptions = [SELECT Id, Name, Accounting_subscriber_domain__c, Accounting_Subscriber__r.domain__c FROM Accounting_Subscription__c
                                                          WHERE Accounting_subscriber_domain__c = '' AND Accounting_Subscriber__r.domain__c != '' AND Server_Name__c =: serverName];
        System.debug('---subscriptions with blank domain relation---' + subscriptions);

        if (subscriptions.size() > 0) {
            Set<String> domainNames = new Set<String>();
            for (Accounting_Subscription__c subscription : subscriptions) {
                domainNames.add(subscription.Accounting_Subscriber__r.domain__c);
            }
            System.debug('---domainNames---' + domainNames);

            if (domainNames.size() == 0) {
                return;
            }

            Map <String, Id> mapDomainNameId = new Map<String, Id>();
            for(Domain__c domain : [SELECT Id, Name FROM Domain__c WHERE Name in: domainNames AND Server_Name__c =: serverName]) {
                mapDomainNameId.put(domain.Name, domain.Id);
            }

            for (Accounting_Subscription__c subscription : subscriptions) {
                Id domainId = mapDomainNameId.get(subscription.Accounting_Subscriber__r.domain__c);
                if (domainId != null) {
                    subscription.Accounting_subscriber_domain__c = domainId;
                }
            }

            update subscriptions;
        }
    }
}