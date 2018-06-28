/**
 * Creates FogBugz cases for each Opportunity without case Id.
 */
global class CreateFBCasesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    private List<String> oppErrors;

    global CreateFBCasesBatch() {
        this.oppErrors = new List<String>();
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name, StageName, Fogbugz_Opened_By__c, Fogbugz_Probability__c, Amount, Owner.Name, IsClosed, Fogbugz_Ticket_Number__c FROM Opportunity WHERE IsClosed = false AND Fogbugz_Ticket_Number__c = \'\'');
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Opportunity> opps = new List<Opportunity>();
        FogBugzAPI fbAPI = new FogBugzAPI();
        System.debug('CreateFBCasesBatch scope: ' + scope.size());
        for (sObject so : scope) {
            Opportunity o = (Opportunity) so;
            FogBugzCase fbCase = FogBugzUtils.createFBCaseFromOpportunity(o);
            System.debug('CreateFBCasesBatch caseId before update: ' + fbCase);
            String fbCaseId = fbAPI.createCase(fbCase, o.IsClosed);
            if (fbCaseId != null) {
                o.Fogbugz_Ticket_Number__c = fbCaseId;
                opps.add(o);
                System.debug('CreateFBCasesBatch caseId after update: ' + fbCaseId);
            } else {
               oppErrors.add(o.Id + ' ' + o.Name + ' : CreateFBCasesBatch - Error while creating case');
               System.debug(LoggingLevel.ERROR, 'CreateFBCasesBatch - Error while creating case');
            }
        }
        if (opps.size() > 0) {
            update opps;
        }
     }

    global void finish(Database.BatchableContext info) {
        String body = 'Job Status : ' + DateTime.now() + '</br></br>';

        for (String line : this.oppErrors) {
            body += line + '</br>';
        }

        if (!Test.isRunningTest()) {
            EmailHelper.sendEmail(FogBugz_Settings__c.getOrgDefaults().Error_Email__c, 'CreateFBCasesBatch Job Status', body);
        }
    }
}