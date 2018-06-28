/**
 * Controller for new Lead conversion button.
 */
public with sharing class LeadConversionController {

    private PageReference cancelPage = null;
    private Lead l;
    private Id leadId;

    public LeadConversionController(ApexPages.StandardController sc) {
        cancelPage = sc.cancel();
        this.leadId = sc.getId();
        this.l = fetchLeadById(sc.getId());
    }

    public LeadConversionController(Id leadId) {
        this.cancelPage = null;
        this.leadId = leadId;
        this.l = fetchLeadById(leadId);
    }

    public PageReference doConversion() {

        PageReference page = null;
        if (l != null) {
            page = convertLead();
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cannot find lead with ID : ' + this.leadId));
        }

        return page;
    }

    public PageReference goBack() {
        return cancelPage;
    }

    private PageReference convertLead() {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        if (l.account_name__c != null) {
            lc.setAccountId(l.account_name__c);
        } else {
            List<Account> accounts = [SELECT Id FROM Account WHERE Name =: l.Company];
            if (accounts.size() > 0) {
                lc.setAccountId(accounts.get(0).Id);
            }
        }

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        if (lcr.isSuccess()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Lead was converted.'));

            Id contactId = lcr.getContactId();
            if (contactId != null) {
                Contact newContact = [SELECT Id, Status__c FROM Contact WHERE Id =: contactId];
                newContact.Status__c = '1- Working - Active Opp Development';
                update newContact;
            }

            Id oppId = lcr.getOpportunityId();
            if (oppId != null) {
                Opportunity newOpp = [SELECT Id, StageName, Probability, of_Execution_budget_for_GS__c, Channel_Response__c, Implementation_Type__c, Renewal_expected__c,
                                             Opportunity_Source__c, Duration_months__c, Opportunity_Owning_Entity__c, CloseDate FROM Opportunity WHERE Id =: oppId];
                newOpp.StageName = 'Stage 3 - Prospect';
                newOpp.Probability = 20;
                newOpp.of_Execution_budget_for_GS__c = 0;
                newOpp.Channel_Response__c = 'Inside Sales';
                newOpp.Implementation_Type__c = 'Self Service';
                newOpp.Opportunity_Source__c = 'Inbound';
                newOpp.Duration_months__c = 12;
                newOpp.CloseDate = Date.today().addMonths(2).toStartofMonth().addDays(-1);
                newOpp.Renewal_expected__c = true;

                Business_Unit__c bu = [SELECT Id FROM Business_Unit__c WHERE Name = 'Inc' LIMIT 1];
                if (bu != null) {
                    newOpp.Opportunity_Owning_Entity__c = bu.Id;
                }

                update newOpp;
            }

            PageReference contrPage = new ApexPages.StandardController(l).view();
            contrPage.setRedirect(true);
            return contrPage;
        } else {
            Database.Error[] errors = lcr.getErrors();
            String message = '';
            if (errors.size() > 0) {
                message += errors[0].getMessage();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cannot conver lead : ' + message + '.'));
        }

        return null;
    }

    private Lead fetchLeadById(Id leadId) {
        return [SELECT Id, account_name__c, Company FROM Lead WHERE Id =: leadId];
    }
}