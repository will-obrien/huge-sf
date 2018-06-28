/*
* Batch responsible for creating the PRO Contract Snapshot custom object for projects that
* are active but do not require a report out.
*/
global class PROContractSnapshotBatch implements Database.Batchable<DContract__c>, Database.Stateful {

    private Date currentDate;
    private List<PRO_Contract_Snapshot__c> failedReocrds = new List<PRO_Contract_Snapshot__c>();

    public PROContractSnapshotBatch(){
        this.currentDate = Date.today();
    }

    global List<DContract__c> start(Database.BatchableContext context) {
       return GetContract();
    }

    global void execute(Database.BatchableContext context, List<DContract__c> contracts) {
        try {
            List<PRO_Contract_Snapshot__c> insertList = new List<PRO_Contract_Snapshot__c>();
            Map<Id, PRO_Contract_Snapshot__c> oldSnapshots = SnapshotHelper.getOldPROSnapshot(contracts, this.currentDate);

            for (DContract__c dcontract : contracts) {
                PRO_Contract_Snapshot__c proContractSnapshot = new PRO_Contract_Snapshot__c();
                PRO_Contract_Snapshot__c oldSnapshot = new PRO_Contract_Snapshot__c();
                if (oldSnapshots.containsKey(dcontract.Id)) {
                    oldSnapshot = oldSnapshots.get(dcontract.Id);
                }
                proContractSnapshot = SnapshotHelper.fillPROSnapshot(this.currentDate, proContractSnapshot, dcontract, oldSnapshot);
                insertList.add(proContractSnapshot);
            }

            List<Database.SaveResult> insertResults = Database.insert(insertList, false);

            for(Integer i = 0; i < insertResults.size(); i++) {
                if (!insertResults.get(i).isSuccess()){
                    Database.Error error = insertResults.get(i).getErrors().get(0);
                    System.debug('DML error ' + error.getMessage());
                    System.debug('Failed to create snapshot for Contract: ' + insertList.get(i).Contract__c);
                    failedReocrds.add(insertList.get(i));
                }
            }

        } catch (Exception ex) {
            System.debug('ERROR:' + ex);
            if (!Test.isRunningTest()) {
                BatchDefaultSettings__c settings = BatchDefaultSettings__c.getOrgDefaults();
                EmailHelper.sendEmailFromException(settings.Error_Emails__c.split(','), 'PRO Snapshot error', 'PRO save error', ex);
            }
        }
    }

    global void finish(Database.BatchableContext context) {
        List<String> toAddresses = new List<String>();
        Contract_Snapshot_Settings__c settings = Contract_Snapshot_Settings__c.getOrgDefaults();

        if(settings.Error_Email__c != null) {
            for(String email : settings.Error_Email__c.split(',')) {
                toAddresses.add(email);
            }

            if(failedReocrds.size() > 0 && toAddresses.size() > 0) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('');
                mail.setSubject('Contract Snapshot Errors ' + Date.today().format());
                String htmlBody = 'Failed to save snapshopts for following contracts: <br/>';

                for(PRO_Contract_Snapshot__c snp : failedReocrds) {
                    htmlBody +=  '<b>Id:</b> ' + snp.Contract__c + '<br/>';
                }

                mail.setUseSignature(false);
                mail.setHtmlBody(htmlBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }

    private List<DContract__c> GetContract() {
        List<DContract__c> contractList = [SELECT Id, Name, Last_Report_Out_Status__c, Percent_through_SOW_deliverables__c, Budget_Used__c, of_Services_budget_for_GS__c, Total_Costs__c, Services_Spend__c,
                                                Buffer_by_SOW_Completed__c, Execution_Efficiency__c, Expected_Buffer__c, Direct_Costs_Total_Expenses__c, Net_Income_based_on_SOW_Completed__c, Product_Spend__c,
                                                GS_Net_Income_to_Date_Handover__c, GS_Execution_Budget__c, GS_Services_Completed__c, GS_Net_Income_to_Date__c, GS_Services_Completed_Handover__c,
                                                GS_Project_Services_Budget_Handoff__c FROM DContract__c WHERE Status__c = 'Active' AND Requires_Report_Out__c = 'No'];
       return contractList;
    }
}