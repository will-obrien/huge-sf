/**
 * This class provides functionality to Dimagi Project Report Outs Site.
 */
public with sharing class ProjectReportOutController {

    public String oauth_token { get; set; }
    public Integer selectedTab { get; set; }

    public String AUTH_URL = 'https://accounts.google.com/o/oauth2/auth';
    public String ACCESS_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token';
    private String OAUTH_CALLBACK_URL = '';
    private String clientId = '';
    private String clientSecret = '';
    private string domainName = '';
    private String sfInstanceName;
    private String currentLoginUser = '';
    public String currentLoginEmail { get; set; }

    public Map<Id,DContract__c> contractMap{get;set;}
    public Map<Id,List<DContract__c>> childContractMap;

    public String searchError { get; set; }
    public Boolean showDevWork { get; set; }

    public Boolean isAuthenticated { get; set;}
    public String password { get; set;}

    Map<string,integer> frequencyMap = new Map<string,integer>();
    public string seachProjectName { get; set; }
    public List<DContract__c> searchedProjects { get; set; }

    public ProjectReportOutController(Boolean forTest) {
        // constructor added for tests
    }

    public ProjectReportOutController() {
        disableTab = true;
        List<PRO_OAuth_Settings__c> googleSettings = PRO_OAuth_Settings__c.getALL().values();
        if (googleSettings != null && googleSettings.size() > 0) {
            clientId = googleSettings[0].ClientID__c;
            clientSecret = googleSettings[0].ClientSecret__c;
            domainName = googleSettings[0].Domain_Name__c;
            OAUTH_CALLBACK_URL = googleSettings[0].Auth_Callback_URL__c;
        }

        List<PRO_Frequency_Settings__C> proSettings = PRO_Frequency_Settings__C.getAll().values();
        for (PRO_Frequency_Settings__C proSet : proSettings) {
            frequencyMap.put(proSet.Name,Integer.valueOf(proSet.Frequency_In_Week__C));
        }

        if (ApexPages.currentPage().getParameters().get('state') != null
                && ApexPages.currentPage().getParameters().get('state') != 'null') {
            projectId = ApexPages.currentPage().getParameters().get('state');
        }

        if (projectId != null) {
            selectedTab = 2;
        } else {
            selectedTab = 0;
        }

        sfInstanceName = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');

        searchedProjects = new List<DContract__c>();
        seachProjectName = '';
        isAuthenticated = false;
        showDevWork = false;
    }



    /**
     *
     * Report Out Tab
     *
     */



    public String reportContractId {get; set;}
    public Project_Report_Out__c pro { get; set; }
    public DContract__c proTabContract { get; set; }
    public String lastProjectId { get; set; }
    public Decimal proTabContractPercntgethroughSOW { get; set; }
    public List<selectoption> statusList {
        get {
            return getPicklistValues(new Project_Report_Out__c(),'Status__c');
        }
        set;
    }
    public string toMeetSchedule { get; set; }
    public string stayWithinScope { get; set; }
    public string currentSystemUsage { get; set; }
    public string partnerRelationship { get; set; }
    public string status{
        get;set;
    }
    public Map<Id, DContract__C> contractIdName = new Map<Id, DContract__C> {};

    public void loadProjectReport() {
        pro = new Project_Report_Out__c();

        proTabContract = contractIdName.get(reportContractId);
        proTabContractPercntgethroughSOW = contractIdName.get(reportContractId).Percent_through_SOW_deliverables__c != null ?
                                                Integer.valueOf(contractIdName.get(reportContractId).Percent_through_SOW_deliverables__c) :
                                                Integer.valueOf(contractIdName.get(reportContractId).Percent_through_Contract__c);

        List<Project_Report_Out__c> prlist = new List<Project_Report_Out__c>(
            [SELECT Id, PM_email__c, Cap_planning_GDoc__c, Key_Accomplishments_Last_Two_Weeks__c,
            Key_Next_Steps_next_2_weeks__c, Client_Facing__c, Requires_Developer_Work__c, Ability_to_meet_Schedule__c,
            Ability_to_stay_within_Scope__c, Current_System_Usage__c, Partner_Relationship__c,
            Issues_Questions_Notables__c, Resource_Planning__c, Contract__r.Requires_Developer_Work__c,
            Project_Dashboard__c FROM Project_Report_Out__c
            WHERE Contract__c =: reportContractId ORDER BY lastmodifieddate DESC LIMIT 1]
        );

        pro.PM_email__c = currentLoginEmail;

        if (!prlist.isempty()) {
            lastProjectId = prlist[0].Id;

            pro.Report_Out_Date__c = System.today();
            pro.Key_Accomplishments_Last_Two_Weeks__c = prlist[0].Key_Accomplishments_Last_Two_Weeks__c;
            pro.Key_Next_Steps_next_2_weeks__c = prlist[0].Key_Next_Steps_next_2_weeks__c;
            pro.Issues_Questions_Notables__c = prlist[0].Issues_Questions_Notables__c;
            pro.Client_Facing__c = prlist[0].Client_Facing__c;
            pro.Requires_Developer_Work__c = prlist[0].Requires_Developer_Work__c;
            showDevWork = prlist[0].Contract__r.Requires_Developer_Work__c;
            pro.Project_Dashboard__c = prlist[0].Project_Dashboard__c;
            pro.Resource_Planning__c = '----';
            pro.Cap_planning_GDoc__c = prlist[0].Cap_planning_GDoc__c;
            toMeetSchedule = prlist[0].Ability_to_meet_Schedule__c;
            stayWithinScope = prlist[0].Ability_to_stay_within_Scope__c;
            currentSystemUsage = prlist[0].Current_System_Usage__c;
            partnerRelationship = prlist[0].Partner_Relationship__c;
        } else {
            DContract__c contractObj = [SELECT id,Requires_Developer_Work__c FROM DContract__c
                                        WHERE Id=:reportContractId LIMIT 1];

            lastProjectId = null;
            pro.Report_Out_Date__c = system.today();
            pro.Key_Accomplishments_Last_Two_Weeks__c = null;
            pro.Key_Next_Steps_next_2_weeks__c = null;
            pro.Issues_Questions_Notables__c = null;
            pro.Client_Facing__c = null;
            pro.Requires_Developer_Work__c = null;
            showDevWork = contractObj.Requires_Developer_Work__c;
            pro.Project_Dashboard__c = null;
            pro.Resource_Planning__c = '----';
            pro.Cap_planning_GDoc__c = null;
            toMeetSchedule = null;
            stayWithinScope = null;
            currentSystemUsage = null;
            partnerRelationship = null;
        }
    }

    public List<PROProject> getProContracts() {
        List<PROProject> proList = new List<PROProject>();

        DContract__c[] contracts = [SELECT Id, Name, Requires_Developer_Work__c, Last_Report_Out_Date__c, Last_Report_Out_Status__c,
                                    Percent_through_SOW_deliverables__c , Percent_through_Contract__c, Margin_by_Contract_Dates__c,
                                    Margin_by_SOW_Completed__c, Expected_Margin__c, Execution_Efficiency__c
                                    FROM DContract__c
                                    WHERE Requires_Report_Out__c = 'Yes' AND (
                                        (In_Charge_Of_Report_Out__c = 'Project Manager' AND Project_Manager__r.Email =: currentLoginEmail) OR
                                        (In_Charge_Of_Report_Out__c = 'Field Manager' AND Field_Manager__r.Email =: currentLoginEmail) OR
                                        (In_Charge_Of_Report_Out__c = 'Backstop' AND Backstop__r.Email =: currentLoginEmail)
                                        OR Owner.Email =: currentLoginEmail)
                                   ORDER BY Name];

        if (contracts.size() > 0 && reportContractId == null) {
            reportContractId = contracts[0].id;
            proTabContract = contracts[0];
            proTabContractPercntgethroughSOW = contracts[0].Percent_through_SOW_deliverables__c != null ? Integer.valueOf(contracts[0].Percent_through_SOW_deliverables__c) : Integer.valueOf(contracts[0].Percent_through_Contract__c);
            for(DContract__c dc:contracts) {
                contractIdName.put(dc.Id, dc);
            }

            loadProjectReport();
        }

        for (DContract__c dc:contracts) {
            PROProject prObj = new PROProject();
            prObj.Contract = dc;
            if(reportContractId != null && reportContractId != '') {
                prObj.cssClass = dc.id == reportContractId ? 'bgColorCls' : '';
            }

            proList.add(prObj);
        }
        return proList;
    }

    /**
     * Checks if the date entered is the second or fourth thursday.
     * @return True if the date format it's right, false otherwise.
     */
    public boolean validData() {
        if (reportContractId == null || reportContractId == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You must select a project.'));
            return false;
        }
        if (status== null || status== '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Status cannot be blank'));
            return false;
        }
        if (pro.PM_email__c == null || pro.PM_email__c == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Email cannot be blank'));
            return false;
        }
        if (pro.Report_Out_Date__c == null ) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Report out Date cannot be blank'));
            return false;
        }
        if (proTabContractPercntgethroughSOW == null ) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, '% Deliverables Completed'));
            return false;
        }
        return true;
    }

    public PageReference save() {
        PageReference page = null;
        try {
            if (validData()) {
                List<Project_Report_Out__c> proList = new list<Project_Report_Out__c>([SELECT Id, Name, Last_Report_ID__C, Contract_Snapshot__c, Contract__c,
                                                                                    Status__c, Ability_to_meet_Schedule__c, Ability_to_stay_within_Scope__c,
                                                                                    Current_System_Usage__c, Partner_Relationship__c, User_Name__C,
                                                                                    Key_Accomplishments_Last_Two_Weeks__c, Key_Next_Steps_next_2_weeks__c,
                                                                                    Issues_Questions_Notables__c, Client_Facing__c, Requires_Developer_Work__c,
                                                                                    Project_Dashboard__c, Resource_Planning__c, Cap_planning_GDoc__c, PM_email__c
                                                                                    FROM Project_Report_Out__c
                                                                                    WHERE Contract__c =: reportContractId AND Report_Out_Date__c =: pro.Report_Out_Date__c LIMIT 1]);

                Project_Report_Out__c proToUpdate = createPROToUpdate(proList.isEmpty() ? null : proList[0]);
                DContract__c dcontract = [SELECT Id, Name, Last_Report_Out_Status__c, Percent_through_SOW_deliverables__c, Budget_Used__c, of_Services_budget_for_GS__c, Total_Costs__c, Services_Spend__c,
                                        Buffer_by_SOW_Completed__c, Execution_Efficiency__c, Expected_Buffer__c, Direct_Costs_Total_Expenses__c, Net_Income_based_on_SOW_Completed__c, Product_Spend__c,
                                        GS_Execution_Budget__c, GS_Services_Completed__c, GS_Net_Income_to_Date__c, GS_Net_Income_to_Date_Handover__c, GS_Services_Completed_Handover__c,
                                        Project_Quality_Overall_Status__c, Customer_Satisfaction_of_services__c, GS_Project_Services_Budget_Handoff__c FROM DContract__c WHERE Id =: reportContractId];

                dcontract.Last_Report_Out_Status__c = status;
                dcontract.Percent_through_SOW_deliverables__c = proTabContractPercntgethroughSOW;

                PRO_Contract_Snapshot__c proContractSnapshot = createProSnapshot(proToUpdate.Contract_Snapshot__c == null ? null : proToUpdate.Contract_Snapshot__c, dcontract);

                Decimal percent = 0;
                if (status == 'Green') {
                    percent = 1;
                } else if (status == 'Yellow') {
                    percent = 0.5;
                }
                Decimal projectQuality = percent * (dcontract.GS_Execution_Budget__c != null ? dcontract.GS_Execution_Budget__c : 0);
                proContractSnapshot.Project_Quality_Overall_Status__c = projectQuality;
                dcontract.Project_Quality_Overall_Status__c = projectQuality;

                percent = 0;
                if (PartnerRelationship == 'Green') {
                    percent = 1;
                } else if (PartnerRelationship == 'Yellow') {
                    percent = 0.5;
                }
                Decimal customerSatisfaction = percent * (dcontract.GS_Execution_Budget__c != null ? dcontract.GS_Execution_Budget__c : 0);
                proContractSnapshot.Customer_Satisfaction_of_services__c = customerSatisfaction;
                dcontract.Customer_Satisfaction_of_services__c = customerSatisfaction;

                PROEmailContractSnoozeHelper.resetEmailReminder(reportContractId);
                upsert proContractSnapshot Id;
                proToUpdate.Contract_Snapshot__c = proContractSnapshot.Id;
                upsert proToUpdate Id;
                update dcontract;

                sendReportEmail(proToUpdate.id);
                page = new PageReference('/apex/ProjectReportOutSubmitted?id=' + proToUpdate.Id);
            }
        } catch(DmlException ex) {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getDmlMessage(0)));
             if (!Test.isRunningTest()) {
                EmailHelper.sendEmailFromException(BatchDefaultSettings__c.getOrgDefaults().Error_Emails__c.split(','), 'PRO errors', 'PRO save error', ex);
             }
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error trying to save. Please try again.'));
            if (!Test.isRunningTest()) {
                EmailHelper.sendEmailFromException(BatchDefaultSettings__c.getOrgDefaults().Error_Emails__c.split(','), 'PRO errors', 'PRO save error', e);
            }
        }
        return page;
    }

    public void sendReportEmail(string PROID){
        Id templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Project_Report_Out_VF' LIMIT 1].Id;
        List<Contact> contactList = new List<Contact>();
        OrgWideEmailAddress orgWideAddress = [SELECT Id FROM OrgWideEmailAddress WHERE 
                                              Address = 'dimagi-salesforce@dimagi.com' LIMIT 1];

        List<Contract_Contact__c> contractContactList= [SELECT id,Contact__C,Email__C,Type__c,Contact__r.Email,Contact__r.Id,Contact__r.Name,Contract__C FROM 
                                                        Contract_Contact__c WHERE Contract__C =: reportContractId];

        List<String> emailList = new List<String>();
        for (Contract_Contact__c conContact : contractContactList) {
            if(conContact.Type__C!='Email'){
                contactList.add(conContact.Contact__r);
            } else {
                emailList.add(conContact.Email__C);
            }
        }

        for (Contact con : contactList) {
            if (con != null && con.Email != null && con.Email.containsIgnoreCase('dimagi.com')) {
                emailList.add(con.Email);
            }
        }

        System.debug('Contact List Size: ' + contactList.size());

        if (contactList.size() > 0) {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTemplateId(templateId);
            msg.setTargetObjectId(contactList[0].Id);
            msg.setToAddresses(emailList);
            msg.setWhatId(PROID);
            msg.setSaveAsActivity(false);
            msg.setOrgWideEmailAddressId(orgWideAddress.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }
    }

    private Project_Report_Out__c createPROToUpdate(Project_Report_Out__c currentPRO) {
        pro.Contract__c = reportContractId;
        if (currentPRO != null) { // we must update PRO
            currentPRO.Name = contractIdName.get(pro.Contract__c).Name + ' - [' + pro.Report_Out_Date__c.format() + ']';
            currentPRO.Status__c = status;
            currentPRO.Ability_to_meet_Schedule__c = toMeetSchedule;
            currentPRO.Ability_to_stay_within_Scope__c = stayWithinScope;
            currentPRO.Current_System_Usage__c = currentSystemUsage;
            currentPRO.Partner_Relationship__c = partnerRelationship;
            currentPRO.User_Name__C = currentLoginUser;
            currentPRO.Report_Out_Date__c = pro.Report_Out_Date__c;
            currentPRO.Key_Accomplishments_Last_Two_Weeks__c = pro.Key_Accomplishments_Last_Two_Weeks__c;
            currentPRO.Key_Next_Steps_next_2_weeks__c = pro.Key_Next_Steps_next_2_weeks__c;
            currentPRO.Issues_Questions_Notables__c = pro.Issues_Questions_Notables__c;
            currentPRO.Client_Facing__c = pro.Client_Facing__c;
            currentPRO.Requires_Developer_Work__c = pro.Requires_Developer_Work__c;
            currentPRO.Project_Dashboard__c = pro.Project_Dashboard__c;
            currentPRO.Resource_Planning__c = pro.Resource_Planning__c;
            currentPRO.Cap_planning_GDoc__c = pro.Cap_planning_GDoc__c;
            currentPRO.PM_email__c = pro.PM_email__c;

            return currentPRO;
        } else {
            pro.Last_Report_ID__C = lastProjectId;
            pro.Name = contractIdName.get(pro.Contract__c).Name + ' - [' + pro.Report_Out_Date__c.format() + ']';
            pro.Status__c = status;
            pro.Ability_to_meet_Schedule__c = toMeetSchedule;
            pro.Ability_to_stay_within_Scope__c = stayWithinScope;
            pro.Current_System_Usage__c = currentSystemUsage;
            pro.Partner_Relationship__c = partnerRelationship;
            pro.User_Name__C = currentLoginUser;

            return pro;
        }
    }

    private PRO_Contract_Snapshot__c createProSnapshot(Id currentSnapshot, DContract__c dcontract) {
        PRO_Contract_Snapshot__c proContractSnapshot = new PRO_Contract_Snapshot__c();
        if (currentSnapshot != null) { // we must update snapshot
            proContractSnapshot.Id = currentSnapshot;
        }

        return SnapshotHelper.fillPROSnapshot(pro.Report_Out_Date__c, proContractSnapshot, dcontract, SnapshotHelper.getLastPROSnapshot(dcontract, currentSnapshot));
    }

     // Get a list of picklist values from an existing object field.
    private List<SelectOption> getPicklistValues(SObject obj, String fieldName) {
        List<SelectOption> options = new list<SelectOption>();
        Schema.sObjectType objType = obj.getSObjectType(); 
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : values) {
           options.add(new SelectOption(a.getValue(), ''));
        }

        options.add(new SelectOption('N/A', ''));

        return options;
    }



    /**
     *
     *
     * Submitted page
     *
     *
     */



    public Project_Report_Out__c submittedPro { get; set; }

    public PageReference submitAnother() {
        pro = new Project_Report_Out__c();
        deleteContactList.clear();
        loadProjectReport();

        PageReference newPage = new PageReference('/apex/ProjectReportOut');
        newPage.getParameters().put('oauth_token', oauth_token);
        newPage.setRedirect(true);
        return newPage ;
    }

    public void loadSubmittedPro() {
        String proId = ApexPages.currentPage().getParameters().get('id');

        if(proId != null) {
            submittedPro = [SELECT id,Name,Resource_Planning__c,Status__c,
                      Ability_to_meet_Schedule__c,Ability_to_stay_within_Scope__c,
                      Current_System_Usage__c,Partner_Relationship__c,
                      Key_Accomplishments_Last_Two_Weeks__c,
                      Key_Next_Steps_next_2_weeks__c,Issues_Questions_Notables__c,
                      Client_Facing__c,Requires_Developer_Work__c,Project_Dashboard__c
                      FROM Project_Report_Out__c
                      WHERE Id =: proId];
        }
    }



    /**
     *
     * Project Financial Data Tab
     *
     */



    public String contractUrl{ get; set; }
    public String financialContractId { get; set; }
    public String contractToAdd { get; set; }
    public String contractToRemove { get; set; }
    public List<ProjectExecutionStatus> executionStatusList { get; set; }
    public List<PROProjectTimeSpentHistory> timeSpendHistoryList { get; set; }
    public List<PROProjectBudget> proExpenseSpendList { get; set; }
    public List<PROProjectBudget> proBudgetList { get; set; }

    private Set<Id> excludeContractFromSearch = new Set<Id>();

    public List<PROProject> getProjectsForFinancialTab() {
        List<PROProject> proList = new List<PROProject>();
        Set<Id> customContractsIdsToAddInList = new Set<Id>();
        excludeContractFromSearch.clear();

        for (PRO_Searched_Contract__c obj : [SELECT id,Contract__c FROM PRO_Searched_Contract__c WHERE Email__c =: currentLoginEmail]) {
            customContractsIdsToAddInList.add(obj.Contract__c);
        }

        childContractMap = new Map<Id,List<DContract__c>>();
        contractMap = new Map<Id,DContract__c>([SELECT Id, Name, Requires_Developer_Work__c, Last_Report_Out_Date__c, Last_Report_Out_Status__c, Percent_through_SOW_deliverables__c,
                                            Burdened_Income_Budget__c, Direct_Costs_Travel_BUDGET__c, Direct_Costs_Total_Expenses__c, Percent_through_Contract__c,
                                            Product_Income_Budget__c, Services_Income__c, Product_Spend__c, Total_Amount_of_Contract__c, Direct_Costs_Sub_Contract_BUDGET__c,
                                            Internal_Sub_contract_BUDGET__c, Project_Other_BUDGET__c, Direct_Costs_Travel_Expenses__c, Direct_Costs_Sub_contract_Expenses__c,
                                            Internal_Sub_contract_Spend__c, Project_Other_Spent__c, Expected_Margin__c,Budget_Used__c, Margin_by_SOW_Completed__c,
                                            Margin_by_Contract_Dates__c, Execution_Efficiency__c, Buffer_by_SOW_Completed__c, Contract_Expense_BUDGET__c,
                                            (SELECT Id, Name, Requires_Developer_Work__c, Last_Report_Out_Date__c, Last_Report_Out_Status__c, Percent_through_SOW_deliverables__c,
                                            Burdened_Income_Budget__c, Direct_Costs_Travel_BUDGET__c, Direct_Costs_Total_Expenses__c, Percent_through_Contract__c,
                                            Product_Income_Budget__c, Services_Income__c, Product_Spend__c, Total_Amount_of_Contract__c, Direct_Costs_Sub_Contract_BUDGET__c,
                                            Internal_Sub_contract_BUDGET__c, Project_Other_BUDGET__c, Direct_Costs_Travel_Expenses__c, Direct_Costs_Sub_contract_Expenses__c,
                                            Internal_Sub_contract_Spend__c, Project_Other_Spent__c, Expected_Margin__c, Budget_Used__c ,Margin_by_SOW_Completed__c,
                                            Margin_by_Contract_Dates__c, Execution_Efficiency__c, Buffer_by_SOW_Completed__c, Contract_Expense_BUDGET__c FROM Contracts__r)
                                            FROM DContract__c
                                            WHERE Id IN : customContractsIdsToAddInList OR
                                                (In_Charge_Of_Report_Out__c='Project Manager' AND  Project_Manager__r.Email=:currentLoginEmail) OR
                                                (In_Charge_Of_Report_Out__c='Field Manager' AND  Field_Manager__r.Email=:currentLoginEmail) OR
                                                (In_Charge_Of_Report_Out__c='Backstop' AND  Backstop__r.Email=:currentLoginEmail)
                                            ORDER BY Name]);

        for (DContract__c dc : contractMap.values()) {
            if (dc.Contracts__r.size() > 0) {
                childContractMap.put(dc.Id,dc.Contracts__r);
            }
        }

        if (contractMap.values().size() > 0 && financialContractId == null) {
            financialContractId = contractMap.values()[0].id;
            loadContractBudgetAndSpentData();
        }

        for (DContract__c dc:contractMap.values()) {
            excludeContractFromSearch.add(dc.Id);
            PROProject prObj = new PROProject();
            prObj.Contract = dc;

            if (financialContractId != null && financialContractId != '') {
                prObj.cssClass = dc.id == financialContractId ? 'bgColorCls' : '';
            }

            if (customContractsIdsToAddInList.contains(dc.Id)) {
                prObj.customAdded = true;
            }
            proList.add(prObj);
        }

        return proList;
    }

    public void searchProject() {
        System.debug('seachProjectName: ' + seachProjectName);
        if (!seachProjectName.equals('')) {
            String soql = 'SELECT Id, Name, Last_Report_Out_Date__c FROM DContract__c WHERE (Requires_Report_Out__c = \'Yes\' OR Status__c = \'Active\') AND Id NOT IN :excludeContractFromSearch';
            soql += ' AND Name LIKE \'' + String.escapeSingleQuotes(seachProjectName) + '%\'';
            soql += ' LIMIT 20';
            System.debug('Final query: ' + soql);

            searchedProjects = Database.query(soql);

            if(searchedProjects.size() == 0) {
                searchError = 'No projects were found.';
            } else {
                searchError = '';
            }
        } else {
            searchedProjects.clear();
            searchError = '';
        }
    }

    public void addProjectToUserList() {
        try {
            PRO_Searched_Contract__c proSearchCon = new PRO_Searched_Contract__c(Email__c = currentLoginEmail, Contract__c = contractToAdd);
            insert proSearchCon;

            for (Integer i=0; i < searchedProjects.size() ; i++) {
                if (searchedProjects[i].Id == contractToAdd) {
                    searchedProjects.remove(i);
                    break;
                }
            }

            getProjectsForFinancialTab();
            seachProjectName = '';
            contractToAdd = '';
            contractToRemove = '';
        } catch (Exception e) {
            // TODO Apex MESSAGE!!!
            System.debug('Error occured: '+ e.getMessage());
        }
    }

    public void removeProjectFromUserList() {
        System.debug('contractToRemove: ' + contractToRemove);
        if (contractToRemove != '') {
            try { 
                delete [SELECT Id FROM PRO_Searched_Contract__c WHERE Email__c =: currentLoginEmail AND Contract__C =: contractToRemove];
                if (financialContractId == contractToRemove) {
                    financialContractId = null;
                }

                contractToRemove = '';
                getProjectsForFinancialTab();
            } catch (Exception e) {
                // TODO Apex MESSAGE!!!
                System.debug('Error occurred while deleting project: ' + e.getMessage());
            }
        }
    }

    public void loadContractBudgetAndSpentData() {
        proBudgetList = new List<PROProjectBudget>();
        Map<Id,List<Time_Card__c>> contractIdTimeCardsMap = new Map<Id,List<Time_Card__c>>();
        if( contractMap.containsKey(financialContractId)) {
            contractUrl = 'https://'+sfInstanceName+'/'+financialContractId;
            Set<Id> parentAndChildContractIds = new Set<Id>{financialContractId};
            DContract__c contractObj = contractMap.get(financialContractId);
            List<DContract__c> childContracts = childContractMap.containsKey(financialContractId) ? childContractMap.get(financialContractId) : null;

            Decimal Burdened_Income_Budget = contractObj.Burdened_Income_Budget__c!= null ? contractObj.Burdened_Income_Budget__c : 0;
            Decimal LaborSpent = 0;
            Decimal Contract_Expense_BUDGET = contractObj.Contract_Expense_BUDGET__c != null ? contractObj.Contract_Expense_BUDGET__c: 0 ;
            Decimal Direct_Costs_Total_Expenses = contractObj.Direct_Costs_Total_Expenses__c != null ? contractObj.Direct_Costs_Total_Expenses__c: 0 ;
            Decimal Product_Income_Budget = contractObj.Product_Income_Budget__c != null ? contractObj.Product_Income_Budget__c: 0 ;
            Decimal Product_Spend = contractObj.Product_Spend__c != null ? contractObj.Product_Spend__c: 0 ;
            Decimal Total_Amount_of_Contract = contractObj.Total_Amount_of_Contract__c != null ? contractObj.Total_Amount_of_Contract__c: 0 ;
            Decimal Percent_through_Contract = contractObj.Percent_through_Contract__c != null ? contractObj.Percent_through_Contract__c: 0 ;
            Decimal Percent_through_SOW_deliverables = contractObj.Percent_through_SOW_deliverables__c != null ? contractObj.Percent_through_SOW_deliverables__c: 0 ;
            Decimal Expected_Margin = contractObj.Expected_Margin__c != null ? contractObj.Expected_Margin__c: 0 ;

            if(childContracts != null && childContracts.size() > 0) {
                for(DContract__c childContract : childContracts) {
                    parentAndChildContractIds.add(childContract.Id);
                    Direct_Costs_Total_Expenses += childContract.Direct_Costs_Total_Expenses__c != null ? childContract.Direct_Costs_Total_Expenses__c: 0 ;
                }
            }

            for(Time_Card__c obj : [select Employee__r.Name,Date__c,Total__c,Time_card_cost__c,Client__c  from Time_Card__c where Client__c IN:parentAndChildContractIds]) {
                if(contractIdTimeCardsMap.containsKey(obj.Client__c)){
                    List<Time_Card__c> tempList = contractIdTimeCardsMap.get(obj.Client__c);
                    tempList.add(obj);
                    contractIdTimeCardsMap.put(obj.Client__c,tempList);
                }else{
                    contractIdTimeCardsMap.put(obj.Client__c,new List<Time_Card__c>{obj});
                }
            }

            for(Id contractId : parentAndChildContractIds) {
                List<Time_Card__c> timeEntries = contractIdTimeCardsMap.get(contractId);
                if(timeEntries != null && timeEntries.size() > 0) {
                    for(Time_Card__c obj : timeEntries) {
                        if(obj.Time_card_cost__c != null) {
                            LaborSpent += obj.Time_card_cost__c;
                        }
                    }
                }
            }

            Decimal a = Product_Income_Budget;
            Decimal b = Product_Spend;
            PROProjectBudget prbjObj1 = new PROProjectBudget();
            prbjObj1.categoryName = 'Product';
            prbjObj1.contractamount = Integer.valueOf(Product_Income_Budget);
            prbjObj1.spentAmount = Integer.valueOf(Product_Spend);
            prbjObj1.amountRemaining = Integer.valueOf(Product_Income_Budget - Product_Spend);
            prbjObj1.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proBudgetList.add(prbjObj1);

            a = Burdened_Income_Budget;
            b = LaborSpent;
            PROProjectBudget prbjObj2 = new PROProjectBudget();
            prbjObj2.categoryName = 'Services & Labor';
            prbjObj2.contractamount = Integer.valueOf(Burdened_Income_Budget);
            prbjObj2.spentAmount = Integer.valueOf(LaborSpent);
            prbjObj2.amountRemaining = Integer.valueOf(Burdened_Income_Budget - LaborSpent);
            prbjObj2.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proBudgetList.add(prbjObj2);

            a = Contract_Expense_BUDGET;
            b = Direct_Costs_Total_Expenses;
            PROProjectBudget prbjObj3 = new PROProjectBudget();
            prbjObj3.categoryName = 'Expense & Travel';
            prbjObj3.contractamount = Integer.valueOf(Contract_Expense_BUDGET);
            prbjObj3.spentAmount = Integer.valueOf(Direct_Costs_Total_Expenses);
            prbjObj3.amountRemaining = Integer.valueOf(Contract_Expense_BUDGET - Direct_Costs_Total_Expenses);
            prbjObj3.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proBudgetList.add(prbjObj3);

            a = Total_Amount_of_Contract;
            b = prbjObj1.spentAmount + prbjObj2.spentAmount + prbjObj3.spentAmount;//calculate manually
            PROProjectBudget prbjObj5 = new PROProjectBudget();
            prbjObj5.categoryName = 'Total';
            prbjObj5.contractamount = Integer.valueOf(Total_Amount_of_Contract);
            prbjObj5.spentAmount = Integer.valueOf(b);
            prbjObj5.amountRemaining = Integer.valueOf(Total_Amount_of_Contract - b);
            prbjObj5.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proBudgetList.add(prbjObj5);
        }

        loadProjectExecutionStatusList();
        loadHistoryOfTimeSpend(contractIdTimeCardsMap);
        loadContractExpenseSpend();
    }

    public void loadContractExpenseSpend() {
        proExpenseSpendList = new List<PROProjectBudget>();

        if( contractMap.containsKey(financialContractId) ){
            DContract__c contractObj = contractMap.get(financialContractId);
            List<DContract__c> childContracts = childContractMap.containsKey(financialContractId) ? childContractMap.get(financialContractId) : null;

            Decimal Direct_Costs_Travel_BUDGET = contractObj.Direct_Costs_Travel_BUDGET__c != null ? contractObj.Direct_Costs_Travel_BUDGET__c : 0 ;
            Decimal Direct_Costs_Sub_Contract_BUDGET = contractObj.Direct_Costs_Sub_Contract_BUDGET__c != null ? contractObj.Direct_Costs_Sub_Contract_BUDGET__c : 0 ;
            Decimal Internal_Sub_contract_BUDGET = contractObj.Internal_Sub_contract_BUDGET__c != null ? contractObj.Internal_Sub_contract_BUDGET__c : 0 ;
            Decimal Project_Other_BUDGET = contractObj.Project_Other_BUDGET__c != null ? contractObj.Project_Other_BUDGET__c : 0 ;

            Decimal Direct_Costs_Travel_Expenses = contractObj.Direct_Costs_Travel_Expenses__c != null ? contractObj.Direct_Costs_Travel_Expenses__c : 0 ;
            Decimal Direct_Costs_Sub_contract_Expenses = contractObj.Direct_Costs_Sub_contract_Expenses__c != null ? contractObj.Direct_Costs_Sub_contract_Expenses__c : 0 ;
            Decimal Internal_Sub_contract_Spend = contractObj.Internal_Sub_contract_Spend__c != null ? contractObj.Internal_Sub_contract_Spend__c : 0 ;
            Decimal Project_Other_Spent = contractObj.Project_Other_Spent__c != null ? contractObj.Project_Other_Spent__c : 0 ;

            Decimal Percent_through_SOW_deliverables = contractObj.Percent_through_SOW_deliverables__c != null ? contractObj.Percent_through_SOW_deliverables__c: 0 ;

            if(childContracts != null) {
                for(DContract__c childContract : childContracts) {
                    Direct_Costs_Travel_Expenses += childContract.Direct_Costs_Travel_Expenses__c != null ? childContract.Direct_Costs_Travel_Expenses__c : 0 ;
                    Direct_Costs_Sub_contract_Expenses += childContract.Direct_Costs_Sub_contract_Expenses__c != null ? childContract.Direct_Costs_Sub_contract_Expenses__c : 0 ;
                    Internal_Sub_contract_Spend += childContract.Internal_Sub_contract_Spend__c != null ? childContract.Internal_Sub_contract_Spend__c : 0 ;
                    Project_Other_Spent += childContract.Project_Other_Spent__c != null ? childContract.Project_Other_Spent__c : 0 ;

                    Percent_through_SOW_deliverables += childContract.Percent_through_SOW_deliverables__c != null ? childContract.Percent_through_SOW_deliverables__c: 0 ;
                }
            }

            Decimal a = Direct_Costs_Travel_BUDGET;
            Decimal b = Direct_Costs_Travel_Expenses;
            PROProjectBudget prbjObj1 = new PROProjectBudget();
            prbjObj1.categoryName = 'Expense Travel';
            prbjObj1.contractamount = Integer.valueOf( Direct_Costs_Travel_BUDGET );
            prbjObj1.spentAmount = Integer.valueOf( Direct_Costs_Travel_Expenses );
            prbjObj1.throughSOWDeliverable = Integer.valueOf( Direct_Costs_Travel_BUDGET - Direct_Costs_Travel_Expenses );
            prbjObj1.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proExpenseSpendList.add(prbjObj1);

            a = Direct_Costs_Sub_Contract_BUDGET;
            b = Direct_Costs_Sub_contract_Expenses;
            PROProjectBudget prbjObj2 = new PROProjectBudget();
            prbjObj2.categoryName = 'Expense External Subcontract';
            prbjObj2.contractamount = Integer.valueOf( Direct_Costs_Sub_Contract_BUDGET );
            prbjObj2.spentAmount = Integer.valueOf( Direct_Costs_Sub_contract_Expenses );
            prbjObj2.throughSOWDeliverable = Integer.valueOf( Direct_Costs_Sub_Contract_BUDGET - Direct_Costs_Sub_contract_Expenses );
            prbjObj2.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proExpenseSpendList.add(prbjObj2);

            a = Project_Other_BUDGET;
            b = Project_Other_Spent;//calculate manually
            PROProjectBudget prbjObj3 = new PROProjectBudget();
            prbjObj3.categoryName = 'Expense Other Direct Costs';
            prbjObj3.contractamount = Integer.valueOf( Project_Other_BUDGET );
            prbjObj3.spentAmount = Integer.valueOf( Project_Other_Spent );
            prbjObj3.throughSOWDeliverable = Integer.valueOf( Project_Other_BUDGET - Project_Other_Spent );
            prbjObj3.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proExpenseSpendList.add(prbjObj3);

            a = Internal_Sub_contract_BUDGET;
            b = Internal_Sub_contract_Spend;
            PROProjectBudget prbjObj4 = new PROProjectBudget();
            prbjObj4.categoryName = 'Expense Internal Subcontract';
            prbjObj4.contractamount = Integer.valueOf( Internal_Sub_contract_BUDGET );
            prbjObj4.spentAmount = Integer.valueOf( Internal_Sub_contract_Spend );
            prbjObj4.throughSOWDeliverable = Integer.valueOf( Internal_Sub_contract_BUDGET - Internal_Sub_contract_Spend );
            prbjObj4.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proExpenseSpendList.add(prbjObj4);

            a = prbjObj1.contractamount + prbjObj2.contractamount + prbjObj3.contractamount;
            b = prbjObj1.spentAmount + prbjObj2.spentAmount + prbjObj3.spentAmount;
            PROProjectBudget prbjObj5 = new PROProjectBudget();
            prbjObj5.categoryName = 'Total Costs (not including Internal subcontracts)';
            prbjObj5.contractamount = Integer.valueOf(a);
            prbjObj5.spentAmount = Integer.valueOf(b);
            prbjObj5.throughSOWDeliverable = Integer.valueOf( a - b );
            prbjObj5.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proExpenseSpendList.add(prbjObj5);

            a = prbjObj1.contractamount + prbjObj2.contractamount + prbjObj3.contractamount + prbjObj4.contractamount;
            b = prbjObj1.spentAmount + prbjObj2.spentAmount + prbjObj3.spentAmount + prbjObj4.spentAmount;
            PROProjectBudget prbjObj6 = new PROProjectBudget();
            prbjObj6.categoryName = 'Total Costs (including Internal subcontracts)';
            prbjObj6.contractamount = Integer.valueOf(a);
            prbjObj6.spentAmount = Integer.valueOf(b);
            prbjObj6.throughSOWDeliverable = Integer.valueOf( a - b );
            prbjObj6.prcntgUsed = a != 0 ? Math.round((b/a) * 100) : 0;
            proExpenseSpendList.add(prbjObj6);
        }
    }

    public void loadHistoryOfTimeSpend(Map<Id,List<Time_Card__c>> contractIdTimeCardsMap){
        PROProjectTimeSpentHistory projTmSpntHstryObj;
        Map<String,PROProjectTimeSpentHistory> laborWithHours = new Map<String,PROProjectTimeSpentHistory>();

        Date currentDate = Date.today();
        Integer currentMonth = currentDate.month();
        Integer currentYear = currentDate.year();
        Integer oneMonthAgo = currentDate.addMonths(-1).month();
        Integer oneMonthAgoYear = currentDate.addMonths(-1).year();
        Integer twoMonthAgo = currentDate.addMonths(-2).month();
        Integer twoMonthAgoYear = currentDate.addMonths(-2).year();

        Integer threeMonthAgo = currentDate.addMonths(-3).month();
        Integer threeMonthAgoYear = currentDate.addMonths(-3).year();

        Date moreThanThreeMonthAgo = currentDate.addMonths(-3);

        Decimal currentMonthTotalhours = 0;
        Decimal firstMonthTotalhours = 0;
        Decimal secondMonthTotalhours = 0;
        Decimal thirdMonthTotalhours = 0;
        Decimal moreThanThreeMonthTotalhours = 0;
        Decimal totalHours = 0;
        Decimal totalCost = 0;

        timeSpendHistoryList = new List<PROProjectTimeSpentHistory>();
        if( contractMap.containsKey(financialContractId) ){
            List<Time_Card__c> timeEntries = new List<Time_Card__c>();
            if(contractIdTimeCardsMap.containsKey(financialContractId)) {
                timeEntries.addAll(contractIdTimeCardsMap.get(financialContractId));
            }

            List<DContract__c> childContracts = childContractMap.containsKey(financialContractId) ? childContractMap.get(financialContractId) : null;

            if(childContracts != null) {
                for(DContract__c childContract : childContracts) {
                    if(contractIdTimeCardsMap.containsKey(childContract.Id))
                        timeEntries.addAll(contractIdTimeCardsMap.get(childContract.Id));
                }
            }

            if(timeEntries != null && timeEntries.size() > 0) {

                for(Time_Card__c  obj: timeEntries) {
                    String employeeName = obj.Employee__r.Name;
                    Date entryDate = obj.Date__c != null ? obj.Date__c : Date.today();
                    Integer entryDateMonth = obj.Date__c != null ? obj.Date__c.month() : 0;
                    Integer entryDateYear = obj.Date__c != null ? obj.Date__c.year() : 0;
                    Decimal totalHoursPerMonth = obj.Total__c != null ? obj.Total__c: 0;
                    Decimal laborCost = obj.Time_card_cost__c != null ? obj.Time_card_cost__c : 0;

                    if (laborWithHours.containsKey(employeeName)) {
                        projTmSpntHstryObj = laborWithHours.get(employeeName);
                        projTmSpntHstryObj.laborCost += laborCost;
                    } else {
                        projTmSpntHstryObj = new PROProjectTimeSpentHistory();
                        projTmSpntHstryObj.laborName = employeeName;
                        projTmSpntHstryObj.laborCost = laborCost;
                    }

                    totalHours += totalHoursPerMonth;
                    totalCost += laborCost;

                    if (entryDateMonth == currentMonth && entryDateYear == currentYear) {
                        projTmSpntHstryObj.currentMonthHours += totalHoursPerMonth;
                    } else if(entryDateMonth == oneMonthAgo && entryDateYear == oneMonthAgoYear ){
                        projTmSpntHstryObj.firstMonthHours += totalHoursPerMonth;
                    } else if(entryDateMonth == twoMonthAgo && entryDateYear == twoMonthAgoYear ) {
                        projTmSpntHstryObj.secondMonthHours += totalHoursPerMonth;
                    } else if(entryDateMonth == threeMonthAgo && entryDateYear == threeMonthAgoYear ) {
                        projTmSpntHstryObj.thirdMonthHours += totalHoursPerMonth;
                    }else if(entryDate < moreThanThreeMonthAgo) {
                        projTmSpntHstryObj.moreThanThreeMonthAgoHours += totalHoursPerMonth;
                    }

                    projTmSpntHstryObj.totalHourstoDate = projTmSpntHstryObj.currentMonthHours + projTmSpntHstryObj.firstMonthHours + projTmSpntHstryObj.secondMonthHours + projTmSpntHstryObj.thirdMonthHours + projTmSpntHstryObj.moreThanThreeMonthAgoHours;

                    laborWithHours.put(employeeName,projTmSpntHstryObj);
                }

                for (PROProjectTimeSpentHistory obj :laborWithHours.values()) {
                    timeSpendHistoryList.add(obj);
                    currentMonthTotalhours += obj.currentMonthHours;
                    firstMonthTotalhours += obj.firstMonthHours;
                    secondMonthTotalhours += obj.secondMonthHours;
                    thirdMonthTotalhours += obj.thirdMonthHours;
                    moreThanThreeMonthTotalhours += obj.moreThanThreeMonthAgoHours;
                }
            }
        }

        timeSpendHistoryList.sort();

        projTmSpntHstryObj = new PROProjectTimeSpentHistory();
        projTmSpntHstryObj.laborName = 'Total';
        projTmSpntHstryObj.currentMonthHours = currentMonthTotalhours;
        projTmSpntHstryObj.firstMonthHours = firstMonthTotalhours;
        projTmSpntHstryObj.secondMonthHours = secondMonthTotalhours;
        projTmSpntHstryObj.thirdMonthHours = thirdMonthTotalhours;
        projTmSpntHstryObj.moreThanThreeMonthAgoHours = moreThanThreeMonthTotalhours;
        projTmSpntHstryObj.totalHourstoDate = totalHours;
        projTmSpntHstryObj.laborCost = totalCost;
        timeSpendHistoryList.add(projTmSpntHstryObj);

    }

    public void loadProjectExecutionStatusList() {
        if( contractMap.containsKey(financialContractId) ){
            DContract__c contractObj = contractMap.get(financialContractId);

            ProjectExecutionStatus execStatus1 = new ProjectExecutionStatus();
            execStatus1.FieldName = 'Execution Efficiency';
            execStatus1.FieldValue = Integer.valueOf(contractObj.Execution_Efficiency__c);

            ProjectExecutionStatus execStatus2 = new ProjectExecutionStatus();
            execStatus2.FieldName = '% Budget Used';
            execStatus2.FieldValue = Integer.valueOf(contractObj.Budget_Used__c);

            ProjectExecutionStatus execStatus3 = new ProjectExecutionStatus();
            execStatus3.FieldName = '% of Work Completed';
            execStatus3.FieldValue = Integer.valueOf(contractObj.Percent_through_SOW_deliverables__c);

            ProjectExecutionStatus execStatus4 = new ProjectExecutionStatus();
            execStatus4.FieldName = '% Time into Contract';
            execStatus4.FieldValue = Integer.valueOf(contractObj.Percent_through_Contract__c);

            ProjectExecutionStatus execStatus5 = new ProjectExecutionStatus();
            execStatus5.FieldName = 'Buffer % by Work Completed';
            execStatus5.FieldValue = Integer.valueOf(contractObj.Buffer_by_SOW_Completed__c);

            executionStatusList = new List<ProjectExecutionStatus>{execStatus1, execStatus2, execStatus3, execStatus4, execStatus5};
            
        }
    }



    /**
     *
     * All Projects Tab
     *
     */



    public String projectId { get;set; }
    public List<Contract_Contact__c> contractContacts { get; set; }
    public List<Contract_Contact__c> contractContactsProject { get; set; }
    public String removeEmailId { get; set; }
    public Id removeContactId { get; set; }
    public DContract__c project { get; set; }
    public List<Project_Report_Out__c> LastRepotOuts { get; set; }
    public boolean enableAddButton{ get; set; }
    public string selectedProjectId { get; set; }
    private List<Contract_Contact__c> deleteContactList = new List<Contract_Contact__c>();

    public List<PROProject> getProjectsList() {

        List<PROProject> proList = new List<PROProject>();

        DContract__c[] contracts = [SELECT Id, Name, Requires_Developer_Work__c, Last_Report_Out_Date__c, Last_Report_Out_Status__c, Percent_through_Contract__c, Percent_through_SOW_deliverables__c
                                    FROM DContract__c
                                    WHERE Requires_Report_Out__c = 'Yes'
                                    ORDER BY Name];

        if (contracts.size() > 0 && selectedProjectId == null) {
            if (projectId != null) {
                selectedProjectId = projectId;
            } else {
                selectedProjectId = contracts[0].Id;
            }

            fillProjectDetails();
        }

        for (DContract__c dc : contracts) {
            PROProject prObj = new PROProject();
            prObj.Contract = dc;
            if (selectedProjectId != null && selectedProjectId != '') {
                prObj.cssClass = dc.id == selectedProjectId ? 'bgColorCls' : '';
            }
            proList.add(prObj);
        }

        return proList;
    }

    public void fillProjectDetails() {
        deleteContactList.clear();
        contractContacts = new List<Contract_Contact__c>();

        List<DContract__c> contractList = [SELECT Id, Project_Manager__c, Backstop__c, Field_Manager__c, In_Charge_Of_Report_Out__c FROM DContract__c
                                           WHERE Id =: selectedProjectId];

        if (contractList!=null && contractList.size() > 0) {
            project = contractList[0];
        }

        contractContactsProject = [SELECT Id, Contact__c, Contract__c, Type__c, Email__c FROM Contract_Contact__c WHERE Contract__c =: selectedProjectId AND Type__c NOT in('Person','Email')];
        contractContacts = [SELECT Id, Contact__c, Contract__c, Type__c, Email__c  FROM Contract_Contact__c WHERE Contract__c =: selectedProjectId AND Type__C in ('Person', 'Email') ORDER BY Type__c DESC];
        lastRepotOuts = [SELECT id,Name,status__c,Contract__r.Name,Contract__r.Last_Report_Out_Date__c,Report_Out_Date__c  FROM Project_Report_Out__c
                         WHERE Contract__C =: selectedProjectId ORDER BY Report_Out_Date__c DESC];
        enableAddButton = true;
    }

    public PageReference saveProjectOnly() {
        PageReference page = null;

        if (validateProject()) {
            try {
                update project;
            } catch (DmlException ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            }

            contractContactsProject = [SELECT Id, Contact__c, Contract__c, Type__c FROM Contract_Contact__c
                                       WHERE Contract__C =: selectedProjectId AND Type__c NOT IN('Person','Email')];
        }
        return page;
    }

    public PageReference saveProject() {
        PageReference page = null;
        page=saveProjectOnly();
        saveContact();

        return page;
    }

    public void saveContact() {
        List<Integer> removeIndex = new List<Integer>();
        if (contractContacts != null) {
            for (Integer index = 0; index < contractContacts.size(); index++) {
                Contract_Contact__c contContact = contractContacts[index];
                if (contContact.Contact__c != null || contContact.Email__c != null) {
                     upsert contContact;
                } else {
                    if (contContact.Id != null) {
                        removeIndex.add(index);
                        delete contContact;
                    }
                }
            }
        }

        for (Integer index = 0 ;index < removeIndex.size(); index++) {
            contractContacts.remove(removeIndex[index]);
        }

        if (deleteContactList.size() > 0) {
            delete deleteContactList;
            deleteContactList.clear();
        }
    }

    public Boolean validateProject() {
        if (selectedProjectId == null || selectedProjectId == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You must select a project.'));
            return false;
        }
        return true;
    }

    public void removeContact() {
        if (contractContacts.size() > 0) {
            Integer removeIndex = -1;
            for (Integer index = 0; index < contractContacts.size(); index++) {
                Contract_Contact__c ct = contractContacts[index];
                if (ct.Contact__c == removeContactId) {
                    if (ct.id != null) {
                        deleteContactList.add(ct);
                    }

                    removeIndex = index;
                    break;
                }
            }

            if (removeIndex == -1) {
                for (Integer index = 0; index < contractContacts.size(); index++) {
                    Contract_Contact__c ct = contractContacts[index];
                    if (ct.Type__c == 'Person' && ct.Contact__c == null) {
                        removeIndex=index;
                        break;
                    }
                }
            }

            if (removeIndex != -1) {
                contractContacts.remove(removeIndex);
            }
        }
    }

    public void removeEmail() {
        if (contractContacts.size() > 0) {
            Integer removeIndex = -1;

            for (Integer index = 0; index < contractContacts.size(); index++) {
                Contract_Contact__c ct = contractContacts[index];
                if (ct.Email__c == removeEmailId) {
                    if (ct.id != null) {
                        deleteContactList.add(ct);
                    }

                    removeIndex = index;
                    break;
                }
            }

            if (removeIndex == -1) {
                for (Integer index = 0; index < contractContacts.size(); index++) {
                    Contract_Contact__c ct = contractContacts[index];
                    if (ct.Type__c == 'Email' && ct.Email__c == null) {
                        removeIndex = index;
                        break;
                    }
                }
            }

            if (removeIndex != -1) {
                contractContacts.remove(removeIndex);
            }
        }
    }

    public void addContact() {
        addToContractContacts('Person');
    }

    public void addEmail() {
        addToContractContacts('Email');
    }

    public void addMe() {
        List<Contact> contList = [SELECT Id,Name FROM Contact WHERE Email =: currentLoginEmail];

        if (contList.size() > 0) {
            Contract_Contact__c contractContact = new Contract_Contact__c();
            contractContact.Contract__c = selectedProjectId;
            contractContact.Type__C = 'Person';
            contractContact.Contact__C = contList[0].id;
            contractContacts.add(contractContact);
        }
    }

    private void addToContractContacts(String contactType) {
        Contract_Contact__c contractContact = new Contract_Contact__c();
        contractContact.Contract__c = selectedProjectId;
        contractContact.Type__C = contactType;
        contractContacts.add(contractContact);
    }



    /**
     *
     * Auth
     *
     */



    public void initAction() {
        oauth_token = ApexPages.currentPage().getParameters().get('oauth_token');
        String oauth_verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
        String oauth_code = ApexPages.currentPage().getParameters().get('code');

        if (oauth_code != null) {
            oauth_token = getFromJSON(getAuthorizedReqToken(oauth_code),'access_token');
        }

        if (oauth_token != null) {
            String message = callForUserInfo(oauth_token);
            if (message != '') {
                isAuthenticated = true;
                currentLoginUser = message;
            }
        }
    }

    public PageReference authenticate() {
        PageReference authPage = null;

        oauth_token = ApexPages.currentPage().getParameters().get('oauth_token');
        String oauth_verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
        string oauth_code = ApexPages.currentPage().getParameters().get('code');

        if (oauth_code != null) {
            oauth_token = getFromJSON(getAuthorizedReqToken(oauth_code), 'access_token');

            String message=callForUserInfo(oauth_token);
            System.debug('message: ' + message);

            if (message != '') {
                isAuthenticated = true;
                currentLoginUser = message;
            }
        } else {
            String authURL = getUnauthorizedReqToken();
            authPage = new PageReference(authURL);
            authPage.setRedirect(false);
        }
        return authPage;
    }

    public PageReference authenticateButton() {
        Misc_Settings__c settings = Misc_Settings__c.getOrgDefaults();

        if (password == settings.Project_Report_Out_Password__c) {
            isAuthenticated = true;
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Wrong password.'));
        }

        return null;
    }

    public String getUnauthorizedReqToken() {
        String vf_url = this.OAUTH_CALLBACK_URL;
        String state = projectId; //Random String
        String body = 'client_id=' + this.clientId + '&redirect_uri=' + this.OAUTH_CALLBACK_URL + '&state=' + state;

        String retUrl = this.AUTH_URL + '?' + body + '&response_type=code&scope=profile+email';

        if (domainName != 'gmail.com') {
            retUrl = retUrl + '&hd=' + domainName;
        }

        return retUrl;
    }

    public static String getRandomNonce() {
        String allChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String nonce = '';
        for (Integer cnt = 0; cnt <= 9; cnt++) {
            Integer i = 1 + Math.Round(700.0 * Math.random() / 26);
            if (i <= 26) {
                i--;
                String newStr = allChars.substring(i, i + 1);
                nonce = nonce + newStr;
            } else {
                cnt--;
            }
        }

        return nonce;
    }

    public String getAuthorizedReqToken(String code) {
        String body = 'client_id=' + this.clientId + '&redirect_uri=' + this.OAUTH_CALLBACK_URL + '&client_secret=' + this.clientSecret + '&code=' + code + '&grant_type=authorization_code';
        String tokenResponse = basicAuthCallout(this.ACCESS_TOKEN_URL, '', body, 'POST');
        return tokenResponse;
    }

    public Boolean disableTab { get; set;}
    public string callForUserInfo(string token) {
        String userInfoURL = 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=' + token;
        String responseJSON = basicAuthCallout(userInfoURL, '', '', 'GET');
        String response = getFromJSON(responseJSON, 'name');
        currentLoginEmail = getFromJSON(responseJSON, 'email');

        String[] emails = Corporate_Dashboard_Settings__c.getOrgDefaults().Emails__c != null ? Corporate_Dashboard_Settings__c.getOrgDefaults().Emails__c.split(',') : new String[]{};
        for (String em: emails) {
            if (em == currentLoginEmail) {
                disableTab = false;
                break;
            }
        }

        return response;
    }

    public String basicAuthCallout(String endPoint, String header, String body, String method) {
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endPoint);
        req.setMethod(method);
        if (method == 'POST') {
            req.setBody(body);
        }
        Http http = new Http();

        HTTPResponse res = http.send(req);
        return res.getBody();
    }

    public string getFromJSON(String response, String fieldName){
        JSONParser parser = JSON.createParser(response);
        String accessToken='';

        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == fieldName)) {
                parser.nextToken();
                accessToken = parser.getText();
            }
        }
        return accessToken;
    }

    /**
     *
     *
     * Corporate Dashboard tab
     *
     *
     **/

    private List<Global_Metric_Graph__c> wamData;
    private List<Global_Metric_Graph__c> formData;
    private List<Global_Metric_Graph__c> userData;
    private List<Global_Metric_Graph__c> programData;
    private List<Global_Metric_Graph__c> performanceData;
    private List<Global_Metric_Graph__c> gsData;
    private List<Global_Metric_Graph__c> mrr;
    private List<Global_Metric_Graph__c> aggregateEff;
    private List<Global_Metric_Graph__c> icds;
    private Global_Metric_Graph__c oppExpectedRec;
    private Global_Metric_Graph__c evExpectedRec;
    private Global_Metric_Graph__c bufferEvGenRec;
    public DateTime dashboardRefreshTime { get; set;}

    public String getIcdsData() {
        if (this.icds == null) {
            this.icds = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c
                        FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.ICDS_GRAPHS ORDER BY Helper_Date__c];
        }
        if (this.icds != null) {
            return JSON.serialize(this.icds);
        }
        return '';
    }
    public void setIcdsData(String icds) {}

    public String getEvExpected() {
        if (this.evExpectedRec == null) {
            List<Global_Metric_Graph__c> rList = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c FROM Global_Metric_Graph__c
                                 WHERE Name =: CorporateDashboardHelper.EV_EXPECTED_GRAPH];
            this.evExpectedRec = rList.size () > 0 ? rList.get(0) : null;
        }
        if (this.evExpectedRec != null) {
            return JSON.serialize(this.evExpectedRec);
        }
        return '';
    }
    public void setEvExpected(String evValues) {}

    public String getOppExpected() {
        if (this.oppExpectedRec == null) {
            List<Global_Metric_Graph__c> rList = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c FROM Global_Metric_Graph__c
                                 WHERE Name =: CorporateDashboardHelper.OPP_EXPECTED_GRAPH];
            this.oppExpectedRec = rList.size () > 0 ? rList.get(0) : null;
        }
        if (this.oppExpectedRec != null) {
            return JSON.serialize(this.oppExpectedRec);
        }
        return '';
    }
    public void setOppExpected(String oppValues) {}

    public String getBufferEvGen() {
        if (this.bufferEvGenRec == null) {
            List<Global_Metric_Graph__c> rList = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c FROM Global_Metric_Graph__c
                                 WHERE Name =: CorporateDashboardHelper.EV_BUFFER_GEN_GRAPH];
            this.bufferEvGenRec = rList.size () > 0 ? rList.get(0) : null;
        }
        if (this.bufferEvGenRec != null) {
            return JSON.serialize(this.bufferEvGenRec);
        }
        return '';
    }
    public void setBufferEvGen(String buffValues) {}

    public String getAggregateEffData() {
        if (this.aggregateEff == null) {
            this.aggregateEff = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c FROM Global_Metric_Graph__c
                                 WHERE Name =: CorporateDashboardHelper.AGGREGATE_EFF_GRAPH];
        }
        if (this.aggregateEff != null) {
            return JSON.serialize(this.aggregateEff);
        }
        return '';
    }
    public void setAggregateEffData(String aggValues) {}

    public String getMrrData() {
        if (this.mrr == null) {
            this.mrr = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                        FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.MRR_GRAPH ORDER BY Helper_Date__c];
        }
        if (this.mrr != null) {
            return JSON.serialize(this.mrr);
        }
        return '';
    }
    public void setMrrData(String mrrValues) {}

    public String getGsGraphData() {
        if (this.gsData == null) {
            this.gsData = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c FROM Global_Metric_Graph__c
                                 WHERE Name =: CorporateDashboardHelper.GS_GRAPHS ORDER BY Helper_Date__c];
        }
        if (this.gsData != null) {
            return JSON.serialize(this.gsData);
        }
        return '';
    }
    public void setGsGraphData(String gsValues) {}

    public String getPerformanceGraphData() {
        if (this.performanceData == null) {
            this.performanceData = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                                    FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.PERFORMANCE_GRAPHS ORDER BY Helper_Date__c];
        }

        if (this.performanceData != null) {
            return JSON.serialize(this.performanceData);
        }
        return '';
    }
    public void setPerformanceGraphData(String performanceValues) {}

    public String getUserGraphData() {
        if (this.userData == null) {
            this.userData = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                             FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.USER_GRAPH ORDER BY Helper_Date__c];
        }
        if (this.userData != null) {
            return JSON.serialize(this.userData);
        }
        return '';
    }
    public void setUserGraphData(String userValues) {}

    public String getFormGraphData() {
        if (this.formData == null) {
            this.formData = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                             FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.FORM_GRAPH ORDER BY Helper_Date__c];
        }
        if (this.formData != null) {
            return JSON.serialize(this.formData);
        }
        return '';
    }
    public void setFormGraphData(String wamValues) {}

    public String getWamGraphData() {
        if (this.wamData == null) {
            this.wamData = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                             FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.WAM_GRAPH ORDER BY Helper_Date__c];
        }
        if (this.wamData != null) {
            return JSON.serialize(this.wamData);
        }
        return '';
    }
    public void setWamGraphData(String programValues) {}

    public String getProgramGraphData() {
        if (this.programData == null) {
            this.programData = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                             FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.PROGRAMS_GRAPH ORDER BY Helper_Date__c];
        }
        if (this.programData != null) {
            return JSON.serialize(this.programData);
        }
        return '';
    }
    public void setProgramGraphData(String programValues) {}

    public PageReference loadScaleData() {
        try {
            List<Global_Metric_Graph__c> metrics = [SELECT Id, CreatedDate FROM Global_Metric_Graph__c LIMIT 1];
            if (metrics.size() > 0) {
                this.dashboardRefreshTime = metrics.get(0).CreatedDate;
            }
        } catch (Exception ex) {
             EmailHelper.sendEmailFromException(BatchDefaultSettings__c.getOrgDefaults().Error_Emails__c.split(','), 'PRO Corporate Dashboard errors', 'PRO Corporate Dashboard error', ex);
        }
        return null;
    }



    /**
     *
     *
     * Internal classes
     *
     *
     **/

    public class PROProject {

        public PROProject() {}

        public DContract__c contract { get; set; }
        public Boolean customAdded { get; set; }
        public String CSSClass{ get; set; }
    }

    public class ProjectExecutionStatus {

        public String fieldName { get; set; }
        public Integer fieldValue {
            get {
                return (fieldValue == null) ? 0 : fieldValue;
            }
            set;
        }
    }

    public class PROProjectBudget {

        public PROProjectBudget() {}

        public String categoryName { get; set; }
        public Integer contractamount { get; set; }
        public Integer spentAmount { get; set; }
        public Integer amountRemaining { get; set; }
        public Integer prcntgUsed { get; set; }
        public Integer throughContract { get; set; }
        public Integer throughSOWDeliverable { get; set; }
    }

    public class PROProjectTimeSpentHistory implements Comparable {

        public String laborName { get; set; }
        public Decimal currentMonthHours {
            get {
                return (currentMonthHours == null) ? 0 : currentMonthHours;
            }
            set;
        }

        public Decimal firstMonthHours {
            get {
                return (firstMonthHours == null) ? 0 : firstMonthHours;
            }
            set;
        }

        public Decimal secondMonthHours {
            get {
                return (secondMonthHours == null) ? 0 : secondMonthHours;
            }
            set;
        }

        public Decimal thirdMonthHours {
            get {
                return (thirdMonthHours == null) ? 0 : thirdMonthHours;
            }
            set;
        }

        public Decimal moreThanThreeMonthAgoHours {
            get {
                return (moreThanThreeMonthAgoHours == null) ? 0 : moreThanThreeMonthAgoHours;
            }
            set;
        }

        public Decimal totalHourstoDate{
            get {
                return (totalHourstoDate == null) ? 0 : totalHourstoDate;
            }
            set;
        }

        public Decimal laborCost { get; set; }

        public Integer compareTo(Object objToCompare) {
            return Integer.valueOf(((PROProjectTimeSpentHistory)objToCompare).totalHourstoDate - totalHourstoDate);
        }
    }
}