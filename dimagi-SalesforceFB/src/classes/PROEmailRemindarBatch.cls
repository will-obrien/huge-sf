global class PROEmailRemindarBatch implements Database.Batchable<DContract__c>, Database.Stateful {

    PROEmailContractFilterHelper contractFilterHelper = null;
    PROEmailProcessHelper processHelper = null;
    Id orgWideId;
    String managmentTeamEmail;
    Map<Id, SFDC_Employee__c> businessUnitEmpMap = new Map<Id, SFDC_Employee__c>();
    PROEmailContractSnoozeHelper snoozeHelperObj;

    private List<DContract__c> firstNagProcessed;
    private List<DContract__c> secondNagProcessed;
    private List<DContract__c> thirdNagProcessed;
    private List<DContract__c> fourthNagProcessed;

    public PROEmailRemindarBatch() {
        snoozeHelperObj = new PROEmailContractSnoozeHelper();
        List<PRO_Email_Remindar_Settings__c> settingList = PRO_Email_Remindar_Settings__c.getALL().values();
        contractFilterHelper = new PROEmailContractFilterHelper();

        if (settingList != null && settingList.size() > 0) {
            PRO_Email_Remindar_Settings__c settings = settingList[0];
            contractFilterHelper.FirstNagDays = Integer.ValueOf(settings.First_Nag_Days__c);
            contractFilterHelper.SecondNagDays = Integer.ValueOf(settings.Second_Nag_Days__c);
            contractFilterHelper.ThirdNagDays = Integer.ValueOf(settings.Third_Nag_Days__c);
            contractFilterHelper.FourthNagDays = Integer.ValueOf(settings.Fourth_Nag_Days__c);
            managmentTeamEmail = settings.Management_Team_Email__c;
        }

        OrgWideEmailAddress orgWideAddress = [SELECT Id FROM OrgWideEmailAddress WHERE
                                                        Address = 'dimagi-salesforce@dimagi.com' LIMIT 1];
        orgWideId = orgWideAddress.Id;
        List<SFDC_Employee__c> empList = [SELECT Id, Email_Address__c, Business_Unit__c FROM SFDC_Employee__c
                                          WHERE Business_Unit__c != null AND Title__c = 'company director'];

        for (SFDC_Employee__c emp:empList) {
            if (!businessUnitEmpMap.containsKey(emp.Business_Unit__c)) {
                businessUnitEmpMap.put(emp.Business_Unit__c, emp);
            }
        }

        processHelper = new PROEmailProcessHelper(orgWideId, managmentTeamEmail, businessUnitEmpMap);

        firstNagProcessed = new List<DContract__c>();
        secondNagProcessed = new List<DContract__c>();
        thirdNagProcessed = new List<DContract__c>();
        fourthNagProcessed = new List<DContract__c>();
    }

    global List<DContract__c> start(Database.BatchableContext context) {
        return GetContract();
    }

    global void execute(Database.BatchableContext context, List<DContract__c> contracts) {

        List<DContract__c> firstNagContract = new List<DContract__c>();
        List<DContract__c> secondNagContract = new List<DContract__c>();
        List<DContract__c> thirdNagContract = new List<DContract__c>();
        List<DContract__c> fourthNagContract = new List<DContract__c>();

        firstNagContract.addAll(contractFilterHelper.filter(contracts,PROEmailContractFilterType.FirstNag));
        secondNagContract.addAll(contractFilterHelper.filter(contracts,PROEmailContractFilterType.SecondNag));
        thirdNagContract.addAll(contractFilterHelper.filter(contracts,PROEmailContractFilterType.ThirdNag));
        fourthNagContract.addAll(contractFilterHelper.filter(contracts,PROEmailContractFilterType.FourthNag));

        if (firstNagContract.size() > 0) {
            snoozeHelperObj.SetFirstNegSent(firstNagContract);
        }
        if (secondNagContract.size() > 0) {
            snoozeHelperObj.SetSecondNegSent(secondNagContract);
        }
        if (thirdNagContract.size() > 0) {
            snoozeHelperObj.SetThirdNegSent(thirdNagContract);
        }
        if (fourthNagContract.size() > 0) {
            snoozeHelperObj.SetFourthNegSent(fourthNagContract);
        }

        firstNagProcessed.addAll(firstNagContract);
        secondNagProcessed.addAll(secondNagContract);
        thirdNagProcessed.addAll(thirdNagContract);
        fourthNagProcessed.addAll(fourthNagContract);
    }

    global void finish(Database.BatchableContext context) {
            processHelper.processFirstNag(firstNagProcessed);
            processHelper.processSecondNag(secondNagProcessed);
            processHelper.processThirdNag(thirdNagProcessed);
            processHelper.processFourthNag(fourthNagProcessed);
    }

    /*
        Get All contract where at least one PRO is created and 
        require report out.
    */
    private List<DContract__c> GetContract() {
        List<DContract__c> contractList;
        if (Test.isRunningTest()) {
            contractList = [SELECT Id, Name, Last_Report_Out_Date__c, Last_Report_Out_Status__c, Is_Snooze__c, Is_First_Nag_Sent__c,
                                    Snooze_Days__c, Snooze_Date__c, First_Nag_Sent_Date__c , OwnerId, Owner.Name,Owner.Email,
                                    Backstop__c, Backstop__r.FirstName, Backstop__r.LastName, Backstop__r.Email,
                                    Project_Manager__c, Project_Manager__r.FirstName, Project_Manager__r.LastName, Project_Manager__r.Email,
                                    Prime_Contracting_Business_Unit__c, Last_Report_Out_Created_Date__c,
                                    In_Charge_Of_Report_Out__c, Field_Manager__c, Field_Manager__r.FirstName, Field_Manager__r.LastName, CreatedDate
                                    FROM DContract__c
                                    WHERE Requires_Report_Out__c = 'Yes' AND Workflow_Escalation_Enabled__C = true LIMIT 30];
        } else {
            contractList = [SELECT Id, Name, Last_Report_Out_Date__c, Last_Report_Out_Status__c, Is_Snooze__c, Is_First_Nag_Sent__c,
                                    Snooze_Days__c, Snooze_Date__c, First_Nag_Sent_Date__c , OwnerId, Owner.Name,Owner.Email,
                                    Backstop__c, Backstop__r.FirstName, Backstop__r.LastName, Backstop__r.Email,
                                    Project_Manager__c, Project_Manager__r.FirstName, Project_Manager__r.LastName, Project_Manager__r.Email,
                                    Prime_Contracting_Business_Unit__c, Last_Report_Out_Created_Date__c,
                                    In_Charge_Of_Report_Out__c, Field_Manager__c, Field_Manager__r.FirstName, Field_Manager__r.LastName, CreatedDate
                                    FROM DContract__c
                                    WHERE Requires_Report_Out__c = 'Yes' AND Workflow_Escalation_Enabled__C = true];
        }

       return contractList;
    }
}