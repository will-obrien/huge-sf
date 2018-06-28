public class PROEmailProcessHelper {

    private PROEmailTemplateHelper emailTemplateObj;
    private Id orgwideId;
    private String managmentTeamEmail;
    private Map<Id, SFDC_Employee__c> businessUnitEmpMap;

    public PROEmailProcessHelper(Id orgwideId, String managmentTeamEmail, Map<Id,SFDC_Employee__c> businessUnitEmpMap) {
        this.orgwideId = orgwideId;
        this.managmentTeamEmail = managmentTeamEmail;
        this.emailTemplateObj = new PROEmailTemplateHelper();
        this.businessUnitEmpMap = businessUnitEmpMap;
    }

    /**
     * Process First Nag.
     * Send email to Project Incharge.
     */
    public void processFirstNag(List<DContract__c> contracts) {

        if (contracts.size() > 0) {
            Map<Id, List<DContract__c>> projectInchargeFirstNagMap = getProjectInCharge(contracts);
            List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();

            for(Id projectInchargeId : projectInchargeFirstNagMap.keySet()) {
                List<DContract__c> contractList = projectInchargeFirstNagMap.get(projectInchargeId);
                String name = getName(contractList[0]);
                emailMessageList.add(buildEmail('PRO Reminder',
                                                emailTemplateObj.GetProjectInchargeEmailTemplate(name, projectInChargeId, contractList, PROEmailContractFilterType.FirstNag),
                                                projectInchargeId));
            }

            if (emailMessageList.size() > 0) {
                Messaging.sendEmail(emailMessageList);
            }
        }
    }

    /**
     * This method is userd to process Second Nag.
     * 1. Send Email to Project In charge.
     * 2. Send Email to Backstop.
     */
    public void processSecondNag(List<DContract__c> contracts) {

        if (contracts.size() > 0) {
            Map<Id, List<DContract__c>> projectInchargeMap = getProjectInCharge(contracts);
            List<Messaging.SingleEmailMessage> ownerEmailMessageList = new List<Messaging.SingleEmailMessage>();

            for(Id projectInChargeId : projectInchargeMap.keySet()){
                List<DContract__c> contractList = projectInChargeMap.get(projectInchargeId);
                String name = getName(contractList[0]);
                ownerEmailMessageList.add(buildEmail('PRO Second Reminder',
                                                emailTemplateObj.GetProjectInchargeEmailTemplate(name, projectInChargeId, contractList, PROEmailContractFilterType.SecondNag),
                                                projectInchargeId));
            }

            if(ownerEmailMessageList.size()>0){
                Messaging.sendEmail(ownerEmailMessageList);
            }

            //Send Email to Backstop
            List<Messaging.SingleEmailMessage> backtopEmailMessageList = new List<Messaging.SingleEmailMessage>();
            Map<Id, List<DContract__c>> backstopMap = getBacktstopMap(contracts);

            for (Id backstopId : backstopMap.keySet()) {
                List<DContract__c> contractList = backstopMap.get(backstopId);
                String name='';

                if (contractList[0].backstop__r.FirstName != null) {
                    name = contractList[0].backstop__r.FirstName;
                } else{
                    name = contractList[0].backstop__r.LastName;
                }
                backtopEmailMessageList.add(buildEmail('PRO Second Reminder',
                                                emailTemplateObj.GetBackstopEmailTemplate(name, contractList),
                                                backstopId));
            }

            if (backtopEmailMessageList.size() > 0) {
                Messaging.sendEmail(backtopEmailMessageList);
            }
        }
    }

    /**
     *This email is used to Process Third Nag Contact.
     * 1. Send Email to Project In charge.
     * 2. Send Email to Project Manager.
     * 3. Send Email to Country Director.
     */
    public void processThirdNag (List<DContract__c> contracts) {

        if (contracts.size() > 0) {

            Map<Id, List<DContract__c>> projectInchargeMap = getProjectInCharge(contracts);
            List<Messaging.SingleEmailMessage> ownerEmailMessageList = new List<Messaging.SingleEmailMessage>();

            for(Id projectInChargeId : projectInchargeMap.keySet()){
                List<DContract__c> contractList = projectInChargeMap.get(projectInchargeId);
                ownerEmailMessageList.add(buildEmail('PRO Third Reminder(Project Incharge)',
                                                emailTemplateObj.GetThirdNagEmailTemplate(contractList),
                                                projectInChargeId));
            }

            if(ownerEmailMessageList.size()>0){
                Messaging.sendEmail(ownerEmailMessageList);
            }

            //Send Email To PM.
            Map<Id, List<DContract__c>> pmMap = getPMMap(contracts);
            List<Messaging.SingleEmailMessage> pmEmailMessageList =new List<Messaging.SingleEmailMessage>();

            for (Id pmId: pmMap.keySet()) {
                List<DContract__c> contractList = pmMap.get(pmId);

                pmEmailMessageList.add(buildEmail('PRO Third Reminder(PM)',
                                                emailTemplateObj.GetThirdNagEmailTemplate(contractList),
                                                pmId));
            }

            if (pmEmailMessageList.size() > 0) {
                Messaging.sendEmail(pmEmailMessageList);
            }

            //Send Email to County Director.
            Map<Id, List<DContract__c>> cdMap = getCountryDirectorMap(contracts);
            List<Messaging.SingleEmailMessage> cdEmailMessageList = new List<Messaging.SingleEmailMessage>();

            for(Id pmId: cdMap.keySet()){
                List<DContract__c> contractList = cdMap.get(pmId);
                SFDC_Employee__c emp = businessUnitEmpMap.get(pmId);

                if (emp != null) {
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    emailMsg.setHtmlBody(emailTemplateObj.GetThirdNagEmailTemplate(contractList));
                    emailMsg.subject = 'PRO Third Reminder(CD)';
                    emailMsg.setOrgWideEmailAddressId(this.orgwideId);
                    emailMsg.setToAddresses(new String[] { emp.Email_Address__c });
                    emailMsg.setSaveAsActivity(false);
                    cdEmailMessageList.add(emailMsg);
                }
            }

            if (cdEmailMessageList.size() > 0) {
                Messaging.sendEmail(cdEmailMessageList);
            }
        }
    }

    /**
     * This email is used to Process Third Nag Contact.
     * 1. Send Email to Project Incharge.
     * 2. Send Email to Project Manager.
     * 3. Send Email to Country Director.
     * 4. Send Email to Management Team.
     */
    public void processFourthNag(List<DContract__c> contracts) {

        if(contracts.size()>0){
            Map<Id, List<DContract__c>> projectInchargeMap = getProjectInCharge(contracts);
            List<Messaging.SingleEmailMessage> ownerEmailMessageList = new List<Messaging.SingleEmailMessage>();

            for(Id projectInChargeId : projectInchargeMap.keySet()){
                List<DContract__c> contractList = projectInChargeMap.get(projectInchargeId);
                ownerEmailMessageList.add(buildEmail('PRO Fourth Reminder(Project Incharge)',
                                                emailTemplateObj.GetFourthNagEmailTemplate(contractList),
                                                projectInchargeId));
            }

            if(ownerEmailMessageList.size()>0){
                Messaging.sendEmail(ownerEmailMessageList);
            }

            //Send Email To PM.
            Map<Id, List<DContract__c>> pmMap = getPMMap(contracts);
            List<Messaging.SingleEmailMessage> pmEmailMessageList =new List<Messaging.SingleEmailMessage>();

            for (Id pmId: pmMap.keySet()) {
                List<DContract__c> contractList = pmMap.get(pmId);

                pmEmailMessageList.add(buildEmail('PRO Fourth Reminder(PM)',
                                                emailTemplateObj.GetFourthNagEmailTemplate(contractList),
                                                pmId));
            }

            if (pmEmailMessageList.size() > 0) {
                Messaging.sendEmail(pmEmailMessageList);
            }

            //Send Email to County Director.
            Map<Id, List<DContract__c>> cdMap = getCountryDirectorMap(contracts);
            List<Messaging.SingleEmailMessage> cdEmailMessageList = new List<Messaging.SingleEmailMessage>();

            for(Id pmId: cdMap.keySet()){
                List<DContract__c> contractList = cdMap.get(pmId);
                SFDC_Employee__c emp = businessUnitEmpMap.get(pmId);

                if (emp != null) {
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    emailMsg.setHtmlBody(emailTemplateObj.GetThirdNagEmailTemplate(contractList));
                    emailMsg.subject = 'PRO Fourth Reminder(CD)';
                    emailMsg.setOrgWideEmailAddressId(this.orgwideId);
                    emailMsg.setToAddresses(new String[] { emp.Email_Address__c });
                    emailMsg.setSaveAsActivity(false);
                    cdEmailMessageList.add(emailMsg);
                }
            }

            if (cdEmailMessageList.size() > 0) {
                Messaging.sendEmail(cdEmailMessageList);
            }

            //Send Email to Managment Team.
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            emailMsg.setHtmlBody(emailTemplateObj.GetThirdNagEmailTemplate(contracts));
            emailMsg.subject = 'PRO Fourth Reminder(MT)';
            emailMsg.setOrgWideEmailAddressId(orgwideId);
            emailMsg.setToAddresses(new String[] { managmentTeamEmail });
            emailMsg.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMsg });
        }
    }

    private Map<Id, List<DContract__c>> getCountryDirectorMap(List<DContract__c> contracts) {
        Map<Id, List<DContract__c>> ownerMap = new Map<Id, List<DContract__c>>();

        for(DContract__c contract : contracts) {
            if (contract.Prime_Contracting_Business_Unit__c != null) {
                List<DContract__c> contractList = ownerMap.get(contract.Prime_Contracting_Business_Unit__c);
                if (contractList == null) {
                    contractList = new List<DContract__c>();
                }

                contractList.add(contract);
                ownerMap.put(contract.Prime_Contracting_Business_Unit__c, contractList);
            }
        }
        return ownerMap;
    }

    private Map<Id, List<DContract__c>> getOwnerMap(List<DContract__c> contracts) {
        Map<Id, List<DContract__c>> ownerMap = new Map<Id, List<DContract__c>>();
        
        for (DContract__c contract : contracts) {
            List<DContract__c> contractList = ownerMap.get(contract.OwnerId);
            if (contractList == null) {
                contractList = new List<DContract__c>();
            }

            contractList.add(contract);
            ownerMap.put(contract.OwnerId,contractList);
        }
        return ownerMap;
    }

    private Map<Id, List<DContract__c>> getProjectInCharge(List<DContract__c> contracts) {
        Map<Id, List<DContract__c>> ownerMap = new Map<Id, List<DContract__c>>();

        for (DContract__c contract : contracts) {
            String ownerId = '';
            if (contract.In_Charge_Of_Report_Out__c == 'Project Manager') {
                ownerId = contract.Project_Manager__c;
            } else if (contract.In_Charge_Of_Report_Out__c == 'Field Manager') {
                ownerId = contract.Field_Manager__c;
            } else if(contract.In_Charge_Of_Report_Out__c == 'Backstop') {
                ownerId = contract.Backstop__c;
            }

            if (ownerId != null && ownerId != '') {
                List<DContract__c> contractList = ownerMap.get(ownerId);
                if (contractList == null) {
                    contractList = new List<DContract__c>();
                }

                contractList.add(contract);
                ownerMap.put(ownerId,contractList);
            }
        }
        return ownerMap;
    }

    private Map<Id, List<DContract__c>> getBacktstopMap(List<DContract__c> contracts){
        Map<Id, List<DContract__c>> backtstopMap = new Map<Id, List<DContract__c>>();

        for (DContract__c contract: contracts) {
            if (contract.Backstop__c != null) {
                List<DContract__c> contractList = backtstopMap.get(contract.Backstop__c);
                if (contractList == null) {
                    contractList = new List<DContract__c>();
                }

                contractList.add(contract);
                backtstopMap.put(contract.Backstop__c, contractList);
            }
        }

        return backtstopMap;
    }

    private Map<Id, List<DContract__c>> getPMMap(List<DContract__c> contracts){
        Map<Id, List<DContract__c>> pmMap = new Map<Id, List<DContract__c>>();

        for (DContract__c contract: contracts) {
            if (contract.Project_Manager__c != null) {
                List<DContract__c> contractList = pmMap.get(contract.Project_Manager__c);
                if (contractList == null) {
                    contractList = new List<DContract__c>();
                }

                contractList.add(contract);
                pmMap.put(contract.Project_Manager__c,contractList);
            }
        }

        return pmMap;
    }

    private String getName(DContract__c contract) {
        String name = '';

        if(contract.In_Charge_Of_Report_Out__c == 'Project Manager') {
            if (contract.Project_Manager__r.FirstName != null) {
                name = contract.Project_Manager__r.FirstName;
            } else {
                name = contract.Project_Manager__r.LastName;
            }
        } else if (contract.In_Charge_Of_Report_Out__c == 'Field Manager') {
            if (contract.Field_Manager__r.FirstName != null) {
                name = contract.Field_Manager__r.FirstName;
            } else {
                 name = contract.Field_Manager__r.LastName;
            }
        } else if (contract.In_Charge_Of_Report_Out__c == 'Backstop') {
            if (contract.Backstop__r.FirstName != null) {
                name = contract.Backstop__r.FirstName;
            } else {
                name = contract.Backstop__r.LastName;
            }
        }
        return name;
    }

    private Messaging.SingleEmailMessage buildEmail(String subject, String body, Id targetId) {
        Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
        emailMsg.setHtmlBody(body);
        emailMsg.setTargetObjectId(targetId);
        emailMsg.subject = subject;
        emailMsg.setOrgWideEmailAddressId(this.orgwideId);
        emailMsg.setSaveAsActivity(false);
        return emailMsg;
    }
}