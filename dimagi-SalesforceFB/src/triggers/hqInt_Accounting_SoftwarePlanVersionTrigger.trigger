trigger hqInt_Accounting_SoftwarePlanVersionTrigger on Accounting_SoftwarePlanVersion__c (after insert, after update) {
    String serverName = trigger.new[0].Server_Name__c;
    Map <String, DateTime> mapPlanIdToLastVersionDate = new Map <String, DateTime>();

    for(Accounting_SoftwarePlanVersion__c triggRec : trigger.new) {
        if (triggRec.Accounting_SoftwarePlan__c != null) {
            mapPlanIdToLastVersionDate.put(triggRec.Accounting_SoftwarePlan__c, null);
        }
    }
    
    for(Accounting_SoftwarePlanVersion__c softPlanVer : [SELECT id,Accounting_SoftwarePlan__c,date_created__c FROM Accounting_SoftwarePlanVersion__c
                                                            WHERE Accounting_SoftwarePlan__c in :mapPlanIdToLastVersionDate.keySet()
                                                            AND date_created__c  != null AND Server_Name__c =: serverName]) {
        dateTime date_created;
        dateTime PlanLastVersionDate;

        date_created = softPlanVer.date_created__c;
        PlanLastVersionDate = mapPlanIdToLastVersionDate.get(softPlanVer.Accounting_SoftwarePlan__c);

        if(PlanLastVersionDate == null)
            mapPlanIdToLastVersionDate.put(softPlanVer.Accounting_SoftwarePlan__c,date_created);
        else if(PlanLastVersionDate < date_created)
            mapPlanIdToLastVersionDate.put(softPlanVer.Accounting_SoftwarePlan__c,date_created);
    }

    list <Accounting_Softwareplan__c> listSoftwarePlan = new list <Accounting_Softwareplan__c>();
    for(String planId : mapPlanIdToLastVersionDate.keySet()) {
        String dateOfLastVerText = 'N/A';
        if(mapPlanIdToLastVersionDate.get(planId) != null)
            dateOfLastVerText = mapPlanIdToLastVersionDate.get(planId).format();

        Accounting_Softwareplan__c softwarePlan = new Accounting_Softwareplan__c(id = planId, Date_of_Last_Version__c = mapPlanIdToLastVersionDate.get(planId),
                                                                                    Date_of_Last_Version_Text__c = dateOfLastVerText);
        listSoftwarePlan.add(softwarePlan);
    }
    update listSoftwarePlan;
}