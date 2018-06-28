public class hqInt_ModelClass {

    //////////////////////// ACCOUNTING INVOICE MODEL CLASS ////////////////////////
    public class Accounting_Invoice {

        public String id;
        public String subscription;
        public Double tax_rate;
        public Double balance;
        public Date date_due; 
        public Date date_paid;
        public DateTime date_created;
        public Date date_received;
        public Date date_start;
        public Date date_end;
        public Boolean is_hidden;
        public Boolean is_hidden_to_ops;
        public Double applied_credit;
        public Double subtotal;

        public Accounting_Invoice__c createDbObject(Id subscriptionId, Id domainId, String softPlan, String serverName) {
            Accounting_Invoice__c accountingInvoiceObj = new Accounting_Invoice__c();
            accountingInvoiceObj.id__c = this.id;
            accountingInvoiceObj.Accounting_Subscription__c = subscriptionId;
            accountingInvoiceObj.tax_rate__c = this.tax_rate;
            accountingInvoiceObj.balance__c = this.balance;
            accountingInvoiceObj.date_due__c = this.date_due;
            accountingInvoiceObj.date_paid__c = this.date_paid;
            accountingInvoiceObj.date_created__c = this.date_created;
            accountingInvoiceObj.date_received__c = this.date_received;
            accountingInvoiceObj.date_start__c = this.date_start;
            accountingInvoiceObj.date_end__c = this.date_end;
            accountingInvoiceObj.is_hidden__c = this.is_hidden;
            accountingInvoiceObj.is_hidden_to_ops__c = this.is_hidden_to_ops;
            accountingInvoiceObj.Total__c = subtotal;
            accountingInvoiceObj.Total_Credits__c = applied_credit;
            accountingInvoiceObj.Project_Space__c = domainId;
            accountingInvoiceObj.Server_Name__c = serverName;
            accountingInvoiceObj.Softwareplan_Edition__c = softPlan;

            return accountingInvoiceObj;
        }
    }

    //////////////////////// ACCOUNTING SUBSCRIPTION MODEL CLASS ////////////////////////
    public class Accounting_Subscription {

        public String account;
        public String plan_version;
        public String id;
        public String salesforce_contract_id;
        public Date date_start;
        public Date date_end;
        public Date date_delay_invoicing;
        public DateTime date_created;
        public Boolean is_active;
        public Boolean do_not_invoice;
        public Boolean auto_generate_credits;
        public Boolean is_trial;
        public Boolean is_hidden_to_ops;
        public String service_type;
        public String pro_bono_status;
        public String funding_source;
        public String subscriber;

        public Accounting_Subscription__c createDbObject(Id billingAccountId, Id softPlanVerId, Id subscriberId, Id domainId, String serverName) {
            Accounting_Subscription__c accountingSubscriptionObj = new Accounting_Subscription__c();
            accountingSubscriptionObj.id__c = this.id;
            accountingSubscriptionObj.salesforce_contract_id__c = this.salesforce_contract_id;
            accountingSubscriptionObj.date_start__c = this.date_start;
            accountingSubscriptionObj.date_end__c = this.date_end;
            accountingSubscriptionObj.date_delay_invoicing__c = this.date_delay_invoicing;
            accountingSubscriptionObj.date_created__c = this.date_created;
            accountingSubscriptionObj.is_active__c = this.is_active;
            accountingSubscriptionObj.do_not_invoice__c = this.do_not_invoice;
            accountingSubscriptionObj.auto_generate_credits__c = this.auto_generate_credits;
            accountingSubscriptionObj.is_trial__c = this.is_trial;
            accountingSubscriptionObj.is_hidden_to_ops__c = this.is_hidden_to_ops;
            accountingSubscriptionObj.service_type__c = this.service_type;
            accountingSubscriptionObj.pro_bono_status__c = this.pro_bono_status;
            accountingSubscriptionObj.funding_source__c = this.funding_source;
            accountingSubscriptionObj.account__c = billingAccountId;
            accountingSubscriptionObj.plan_version__c = softPlanVerId;
            accountingSubscriptionObj.Accounting_Subscriber__c = subscriberId;
            accountingSubscriptionObj.Accounting_subscriber_domain__c = domainId;
            accountingSubscriptionObj.Server_Name__c = serverName;

            return accountingSubscriptionObj;
        }
    }

    public class Accounting_Subscriber {

        public string id;
        public string domain;
        public string organization;

        public Accounting_Subscriber__c createDbObject(Id domainId, String serverName) {
            Accounting_Subscriber__c accountingSubscriberObj = new Accounting_Subscriber__c();
            accountingSubscriberObj.id__c = this.id;
            if (this.domain != null && this.domain.length() > 80) {
                accountingSubscriberObj.domain__c = this.domain.subString(0, 80);
            } else {
                accountingSubscriberObj.domain__c = this.domain;
            }
            accountingSubscriberObj.organization__c = this.organization;
            accountingSubscriberObj.domain_lookup__c = domainId;
            accountingSubscriberObj.Server_Name__c = serverName;
            system.debug('--domainid--' + domainid);

            return accountingSubscriberObj;
        }
    }

    //////////////////////// ACCOUNTING BILLING ACCOUNT MODEL CLASS ////////////////////////
    public class Accounting_BillingAccount  {

        public String id;
        public String name;
        public String salesforce_account_id;
        public String created_by;
        public DateTime date_created;
        public Boolean is_auto_invoiceable;
        public String account_type;
        public String created_by_domain;
        public DateTime date_confirmed_extra_charges;
        public Boolean is_active;
        public String dimagi_contact;
        public String entry_point;
        public String last_payment_method;
        public String pre_or_post_pay;

        public Accounting_BillingAccount__c createDbObject(id billingContactId, String serverName) {
            Accounting_BillingAccount__c accountingBillingAccount = new Accounting_BillingAccount__c();
            accountingBillingAccount.id__c = this.id;
            if (this.name != null && this.name.length() > 80) {
                accountingBillingAccount.name = this.name.subString(0, 80);
            } else {
                accountingBillingAccount.name = this.name;
            }
            accountingBillingAccount.salesforce_account_id__c = this.salesforce_account_id;
            accountingBillingAccount.created_by__c = this.created_by;
            accountingBillingAccount.date_created__c = this.date_created;
            accountingBillingAccount.is_auto_invoiceable__c = this.is_auto_invoiceable;
            accountingBillingAccount.account_type__c = this.account_type;
            accountingBillingAccount.created_by_domain__c = this.created_by_domain;
            accountingBillingAccount.date_confirmed_extra_charges__c = this.date_confirmed_extra_charges;
            accountingBillingAccount.is_active__c = this.is_active;
            accountingBillingAccount.dimagi_contact__c = this.dimagi_contact;
            accountingBillingAccount.entry_point__c = this.entry_point;
            accountingBillingAccount.BillingContact__c = billingContactId;
            accountingBillingAccount.last_payment_method__c = this.last_payment_method;
            accountingBillingAccount.pre_or_post_pay__c = this.pre_or_post_pay;
            accountingBillingAccount.Server_Name__c = serverName;

            return accountingBillingAccount;
        }
    }

    //////////////////////// ACCOUNTING SOFTWARE PLAN MODEL CLASS ////////////////////////
    public class Accounting_SoftwarePlan {

        public String id;
        public String name;
        public String description;
        public String visibility;
        public String edition;

        public Accounting_Softwareplan__c createDbObject(String serverName) {

            Accounting_Softwareplan__c accountingSoftwarePlanObj = new Accounting_Softwareplan__c();
            accountingSoftwarePlanObj.id__c = this.id;
            accountingSoftwarePlanObj.name = this.name;
            accountingSoftwarePlanObj.description__c = this.description;
            accountingSoftwarePlanObj.edition__c = this.edition;
            accountingSoftwarePlanObj.visibility__c = this.visibility;
            accountingSoftwarePlanObj.Server_Name__c = serverName;

            return accountingSoftwarePlanObj;
        }
    }

    public class Accounting_SoftwareProductRate {

        public String id;
        public Boolean is_active;
        public Double monthly_fee;

        public Accounting_SoftwareProductRate__c createDbObject(String serverName) {
            Accounting_SoftwareProductRate__c softwareProductRate = new Accounting_SoftwareProductRate__c();
            softwareProductRate.id__c = this.id;
            softwareProductRate.is_active__c = this.is_active;
            softwareProductRate.monthly_fee__c = this.monthly_fee;
            softwareProductRate.Server_Name__c = serverName;

            return softwareProductRate;
        }
    }

    //////////////////////// ACCOUNTING SOFTWARE PLAN VERSION MODEL CLASS ////////////////////////
    public class Accounting_SoftwarePlanVersion {

        public String id;
        public String plan;
        public DateTime date_created;
        public Boolean is_active;
        public String[] feature_rates;
        public String[] product_rates;

        public Accounting_SoftwarePlanVersion__c createDbObject(Id planId, Id productRate, String serverName) {
            Accounting_SoftwarePlanVersion__c accountingSoftwarePlanVersionObj = new Accounting_SoftwarePlanVersion__c();
            accountingSoftwarePlanVersionObj.id__c = this.id;
            accountingSoftwarePlanVersionObj.Accounting_SoftwarePlan__c = planId;
            accountingSoftwarePlanVersionObj.date_created__c = this.date_created;
            accountingSoftwarePlanVersionObj.is_active__c = this.is_active;
            accountingSoftwarePlanVersionObj.FeatureRates__c = String.join(feature_rates,',');
            accountingSoftwarePlanVersionObj.Software_Product_Rate__c = productRate;
            accountingSoftwarePlanVersionObj.Server_Name__c = serverName;

            return accountingSoftwarePlanVersionObj;
        }
    }

    //////////////////////// ACCOUNTING FEATURERATE MODEL CLASS ////////////////////////
    public class Accounting_FeatureRate {

        public String id;
        public String feature;
        public Double monthly_fee;
        public Integer monthly_limit;
        public Double per_excess_fee;
        public DateTime date_created;
        public Boolean is_active;

        public Accounting_Featurerate__c createDbObject(String featureId, String serverName) {
            Accounting_Featurerate__c obj = new Accounting_Featurerate__c();
            obj.id__c = id;
            obj.date_created__c = date_created;
            obj.feature__c = featureId;
            obj.is_active__c = is_active; 
            obj.monthly_fee__c = monthly_fee;
            obj.monthly_limit__c = monthly_limit;
            obj.per_excess_fee__c = per_excess_fee;
            obj.Server_Name__c = serverName;

            return obj;
        }
    }

    //////////////////////// ACCOUNTING FEATURE MODEL CLASS ////////////////////////
    public class Accounting_Feature {

        public String id;
        public String name;
        public String feature_type;

        public accounting_feature__c createDbObject(String serverName) {
            Accounting_feature__c obj = new Accounting_feature__c();
            obj.id__c = id;
            obj.name = name;
            obj.feature_type__c = feature_type;
            obj.Server_Name__c = serverName;

            return obj;
        }
    }

    //////////////////////// ACCOUNTING BILLINGCONTACTINFO MODEL CLASS ////////////////////////
    public class Accounting_BillingContactInfo {

        public string account;
        public string first_name;
        public string last_name;
        public string emails;
        public string phone_number;
        public string company_name;
        public string first_line;
        public string second_line;
        public string city;
        public string state_province_region;
        public string postal_code;
        public string country;

        public Accounting_BillingContactInfo__c createDbObject(String serverName) {
            Accounting_BillingContactInfo__c obj = new Accounting_BillingContactInfo__c();
            obj.city__c = city;
            obj.company_name__c = company_name;
            obj.country__c = country;
            obj.emails__c = emails;
            obj.first_line__c = first_line;
            obj.first_name__c = first_name;
            obj.last_name__c = last_name;
            obj.phone_number__c = phone_number;
            obj.postal_code__c = postal_code;
            obj.second_line__c = second_line;
            obj.state_province_region__c = state_province_region;
            obj.accountid__c = account;
            obj.Server_Name__c = serverName;

            return obj;
        }
    }

    //////////////////////// ACCOUNTING LINE ITEM MODEL CLASS ////////////////////////
    public class Accounting_LineItem {

        public string id;
        public string invoice;
        public string feature_rate;
        public string base_description;
        public double base_cost;
        public string unit_description;
        public double unit_cost;
        public integer quantity; 
        public double subtotal;
        public double applied_credit;

        public Accounting_LineItems__c createDbObject(String invoiceId, String featurerateId, String serverName) {
            Accounting_LineItems__c obj = new Accounting_LineItems__c();
            obj.id__c = id;
            obj.invoice__c = invoiceId;
            obj.Accounting_FeatureRate__c = featurerateId;
            obj.base_description__c = base_description;

            obj.base_cost__c = base_cost;
            obj.unit_description__c = unit_description;
            obj.unit_cost__c = unit_cost;
            obj.quantity__c = quantity;

            obj.subtotal__c = subtotal;
            obj.applied_credit__c = applied_credit;
            obj.Server_Name__c = serverName;

            return obj;
        }
    }

    //////////////////////// accounting_paymentrecord MODEL CLASS ////////////////////////
    public class Accounting_PaymentRecord {

        public string id;
        public string payment_method;
        public DateTime date_created;
        public string transaction_id;
        public Double amount;

        public Accounting_Paymentrecord__c createDbObject(Id sfIdPaymentMethod, String serverName) {
            Accounting_Paymentrecord__c obj = new Accounting_Paymentrecord__c();
            obj.id__c = id;
            obj.payment_method__c = sfIdPaymentMethod;
            obj.amount__c = amount;
            obj.date_created__c = date_created;
            obj.transaction_id__c = transaction_id;
            obj.Server_Name__c = serverName;

            return obj;
        }
    }

    public class WRP_Accounting_PaymentRecord {
        public list <Accounting_PaymentRecord> objects;
    }

    //////////////////////// Accounting_PaymentMethod MODEL CLASS ////////////////////////
    public class Accounting_PaymentMethod {

        public string id;
        public string account;
        public string method_type;
        public string customer_id;
        public DateTime date_created;
        public string billing_admin;

        public Accounting_PaymentMethod__c createDbObject(Id sfIdBillAcc, Id sfIdBillAccAdmin, String serverName) {
            Accounting_PaymentMethod__c obj = new Accounting_PaymentMethod__c();
            obj.id__c = id;
            obj.account__c = sfIdBillAcc;
            obj.billing_admin__c = sfIdBillAccAdmin;
            obj.customer_id__c = customer_id;

            obj.date_created__c = date_created;
            obj.method_type__c = method_type;
            obj.Server_Name__c = serverName;

            return obj;
        }
    }

    //////////////////////// Accounting_BillingAccountAdmin MODEL CLASS ////////////////////////
    public class Accounting_BillingAccountAdmin {

        public string id;
        public string web_user;
        public string domain;

        public Accounting_BillingAccountAdmin__c createDbObject(String serverName) {
            Accounting_BillingAccountAdmin__c obj = new Accounting_BillingAccountAdmin__c();
            obj.id__c = id;
            obj.domain__c = domain;
            obj.web_user__c = web_user;
            obj.Server_Name__c = serverName;

            return obj;
        }
    } 

    ///////// THIS IS Wrapper class for Accounting_BillingAccountAdmin class///////////////
    public class WRP_Accounting_BillingAccountAdmin {
        public list <Accounting_BillingAccountAdmin> objects;
    }

    //////////////////////// Accounting_SubscriptionAdjustment MODEL CLASS ////////////////////////
    public class Accounting_SubscriptionAdjustment {

        public String id;
        public String subscription;
        public String reason;
        public String method;
        public DateTime date_created;

        public Accounting_SubscriptionAdjustment__c createDbObject(String subscriptionId, String serverName) {
            Accounting_SubscriptionAdjustment__c obj = new Accounting_SubscriptionAdjustment__c();
            obj.id__c = id;
            obj.subscription__c = subscriptionId;
            obj.reason__c = reason;
            obj.method__c = method;
            obj.date_created__c = date_created;
            obj.Server_Name__c = serverName;

            return obj;
        }
    } 

    public class WRP_Accounting_SubscriptionAdjustment {
        public list <Accounting_SubscriptionAdjustment> objects;
    }

    //////////////////////// Accounting_CreditAdjustment MODEL CLASS ////////////////////////
    public class Accounting_CreditAdjustment {

        public String id;
        public String credit_line;
        public String reason;
        public String note;

        public double amount;
        public String line_item;
        public String invoice;
        public DateTime date_created;

        public String web_user;
        public String payment_record;
        public String related_credit;

        public Accounting_CreditAdjustment__c createDbObject(String creditLineSfId, String invoiceSfId, String lineItemSfId, String paymentRecSfId,
                                                                String relatedCreditLineSfId, String serverName) {
            Accounting_CreditAdjustment__c obj = new Accounting_CreditAdjustment__c();
            obj.amount__c = amount;
            obj.credit_line__c = creditLineSfId;
            obj.date_created__c = date_created;
            obj.id__c = id;

            obj.invoice_id__c = invoiceSfId;
            obj.line_item_id__c = lineItemSfId;
            obj.note__c = note;
            obj.payment_record_id__c = paymentRecSfId;

            obj.reason__c = reason;
            obj.related_credit_id__c = relatedCreditLineSfId;
            obj.web_user__c = web_user;
            obj.Server_Name__c = serverName;

            return obj;
        }
    } 

    public class WRP_Accounting_CreditAdjustment {

        public list <Accounting_CreditAdjustment> objects;
    }

    //////////////////////// Accounting_CreditLine MODEL CLASS ////////////////////////
    public class Accounting_CreditLine {

        public String id;
        public String account;
        public String subscription;
        public DateTime date_created;

        public double balance;
        public String product_type;
        public String feature_type;
        public Boolean is_active;

        public Accounting_CreditLine__c createDbObject(String billingAccSfId, String subscriptionSfId, String serverName) {
            Accounting_CreditLine__c obj = new Accounting_CreditLine__c();
            obj.id__c = id;
            obj.account__c = billingAccSfId;
            obj.balance__c = balance;
            obj.date_created__c = date_created;

            obj.feature_type__c = feature_type;
            obj.is_active__c = is_active;
            obj.product_type__c = product_type;
            obj.Subscription__c = subscriptionSfId;
            obj.Server_Name__c = serverName;

            return obj;
        }
    } 

    public class WRP_Accounting_CreditLine {
        public list <Accounting_CreditLine> objects;
    }
}