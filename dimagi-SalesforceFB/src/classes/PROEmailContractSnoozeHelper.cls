public class PROEmailContractSnoozeHelper {

    List<DContract__c> firstNegFailedReocrds; 
    List<DContract__c> secondNegFailedReocrds;
    List<DContract__c> thirdNegFailedReocrds; 
    List<DContract__c> fourthNegFailedReocrds;
    List<String> toAddresses;

    public PROEmailContractSnoozeHelper() {
        firstNegFailedReocrds = new List<DContract__c>();
        secondNegFailedReocrds = new List<DContract__c>();
        thirdNegFailedReocrds = new List<DContract__c>();
        fourthNegFailedReocrds = new List<DContract__c>();
        toAddresses = new List<String>();

        List<PRO_Email_Remindar_Settings__c> settingList=PRO_Email_Remindar_Settings__c.getALL().values();
        PRO_Email_Remindar_Settings__c settings = settingList[0];

        if (settings.Error_Email__c != null && settings.Error_Email__c.contains(',')) {
            for(String email : settings.Error_Email__c.split(',')) {
                toAddresses.add(email);
            }
        } else if (settings.Error_Email__c != null) {
            toAddresses.add(settings.Error_Email__c);
        }
    }

    /*
        Snooze contratc to given days.
    */
    public void SnoozeContractByOwnerId(Id ownerId,integer snoozeDays){

        List<DContract__c> contractList = [SELECT id FROM DContract__c
                                           WHERE Is_First_Nag_Sent__c = true
                                           AND((In_Charge_Of_Report_Out__c='Project Manager' AND  Project_Manager__C=:ownerId) OR
                                           (In_Charge_Of_Report_Out__c='Field Manager' and  Field_Manager__C=:ownerId) OR
                                           (In_Charge_Of_Report_Out__c='Backstop' and  Backstop__C=:ownerId))];
        if (contractList.size() > 0) {
           SnoozeContract(contractList,snoozeDays);
        }
    }

    public void SnoozeContract(Id contractId,integer snoozeDays) {
        List<DContract__c> contractList = [SELECT id FROM DContract__c WHERE Id =: contractId and Is_First_Nag_Sent__c = true];
        if( contractList.size() > 0) {
          SnoozeContract(contractList,snoozeDays);
        }
    }

    public void SnoozeContract(List<DContract__c> contracts,integer snoozeDays) {

        for (DContract__c contract : contracts) {
            contract.Is_Snooze__c = true;
            contract.Snooze_Date__c = Date.Today();
            contract.Snooze_Days__c = snoozeDays;
            contract.Is_First_Nag_Sent__c = false;
            contract.First_Nag_Sent_Date__c = null;
            contract.Second_Nag_Sent_Date__c = null;
            contract.Third_Nag_Sent_Date__c = null;
            contract.Fourth_Nag_Sent_Date__c = null;
        }

        update contracts;
    }

    /*
        Set First Nag Set when First nag is sent to Contract Owner.
    */
    public void SetFirstNegSent(List<DContract__c> contracts){

        for (DContract__c contract : contracts) {
            contract.Is_Snooze__c = false;
            contract.Snooze_Date__c = null;
            contract.Snooze_Days__c = null;
            contract.Is_First_Nag_Sent__c = true;
            contract.First_Nag_Sent_Date__c = Date.Today();
        }

        List<Database.SaveResult> updateResults = Database.update(contracts, false);
        String failedDML = '';

        for (Integer i = 0; i < updateResults.size(); i++) {
            if (!updateResults.get(i).isSuccess()) {
                // DML operation failed
                Database.Error error = updateResults.get(i).getErrors().get(0);
                failedDML = error.getMessage();
                System.debug('Failed ID'+contracts.get(i).Id);
                firstNegFailedReocrds.add(contracts.get(i));
            }
        }

        if (firstNegFailedReocrds.size() > 0 && toAddresses.size() > 0) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('');
            mail.setSubject('');

            String htmlBody = 'First reminder was failed to sent on the following records.<br/>';
            htmlBody += '<b>Error:</b> '+failedDML+'<br/><br/>';
            htmlBody += '<b>Records:</b> <br/>';

            for (DContract__c contract : firstNegFailedReocrds) {
                htmlBody +=  '<b>Name:</b> ' + contract.Name  + ' - <b>Id:</b> ' + contract.Id + '<br/>';
            }

            mail.setUseSignature(false);
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    public void SetSecondNegSent(List<DContract__c> contracts) {
        for (DContract__c contract : contracts) {
            contract.Second_Nag_Sent_Date__c = Date.today();
        }
        update contracts;

        List<Database.SaveResult> updateResults = Database.update(contracts, false);
        String failedDML = '';

        for (Integer i = 0; i < updateResults.size(); i++) {
            if (!updateResults.get(i).isSuccess()) {
                // DML operation failed
                Database.Error error = updateResults.get(i).getErrors().get(0);
                failedDML = error.getMessage();
                System.debug('Failed ID' + contracts.get(i).Id);
                secondNegFailedReocrds.add(contracts.get(i));
            }
        }

        if (secondNegFailedReocrds.size() > 0 && toAddresses.size() > 0) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('');
            mail.setSubject('');
            String htmlBody = 'Second reminder was failed to sent on the following records.<br/>';
            htmlBody += '<b>Error:</b> ' + failedDML + '<br/><br/>';
            htmlBody += '<b>Records:</b> <br/>';

            for(DContract__c contract : secondNegFailedReocrds) {
                htmlBody +=  '<b>Name:</b> ' + contract.Name + ' - <b>Id:</b> ' + contract.Id + '<br/>';
            }

            mail.setUseSignature(false);
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    public void SetThirdNegSent(List<DContract__c> contracts) {
        for (DContract__c contract : contracts) {
            contract.Third_Nag_Sent_Date__c = Date.today();
        }
        update contracts;

        List<Database.SaveResult> updateResults = Database.update(contracts, false);
        String failedDML = '';

        for (Integer i = 0; i < updateResults.size(); i++) {
            if (!updateResults.get(i).isSuccess()) {
                // DML operation failed
                Database.Error error = updateResults.get(i).getErrors().get(0);
                failedDML = error.getMessage();
                System.debug('Failed ID' + contracts.get(i).Id);
                thirdNegFailedReocrds.add(contracts.get(i));
            }

        }

        if (thirdNegFailedReocrds.size() > 0 && toAddresses.size() > 0) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('');
            mail.setSubject('');

            String htmlBody = 'Third reminder was failed to sent on the following records.<br/>';
            htmlBody += '<b>Error:</b> ' + failedDML + '<br/><br/>';
            htmlBody += '<b>Records:</b> <br/>';
            for (DContract__c contract : thirdNegFailedReocrds) {
                htmlBody +=  '<b>Name:</b> ' + contract.Name + ' - <b>Id:</b> ' + contract.Id + '<br/>';
            }

            mail.setUseSignature(false);
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    public void SetFourthNegSent(List<DContract__c> contracts) {
        for (DContract__c contract : contracts) {
            contract.Fourth_Nag_Sent_Date__c = Date.today();
        }
        update contracts;

        List<Database.SaveResult> updateResults = Database.update(contracts, false);
        String failedDML = '';

        for (Integer i = 0; i < updateResults.size(); i++) {
            if (!updateResults.get(i).isSuccess()) {
                // DML operation failed
                Database.Error error = updateResults.get(i).getErrors().get(0);
                failedDML = error.getMessage();
                System.debug('Failed ID' + contracts.get(i).Id);
                fourthNegFailedReocrds.add(contracts.get(i));
            }

        }

        if (fourthNegFailedReocrds.size() > 0 && toAddresses.size() > 0) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('');
            mail.setSubject('');

            String htmlBody = 'Fourth reminder was failed to sent on the following records.<br/>';
            htmlBody += '<b>Error:</b> '+failedDML+'<br/><br/>';
            htmlBody += '<b>Records:</b> <br/>';

            for (DContract__c contract : fourthNegFailedReocrds) {
                htmlBody +=  '<b>Name:</b> ' + contract.Name + ' - <b>Id:</b> ' + contract.Id + '<br/>';
            }

            mail.setUseSignature(false);
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    /**
     * Reset all email reminder fields of a contract.
     * This method is used in PRO Page to reset all fields of contract when new PRO is created.
     */
    public static void resetEmailReminder(Id contractId) {
        DContract__c contract = new DContract__c();
        contract.id = contractId;
        contract.Is_Snooze__c = false;
        contract.Snooze_Date__c = null;
        contract.Snooze_Days__c = null;
        contract.Is_First_Nag_Sent__c = false;
        contract.First_Nag_Sent_Date__c = null;
        contract.Second_Nag_Sent_Date__c = null;
        contract.Third_Nag_Sent_Date__c = null;
        contract.Fourth_Nag_Sent_Date__c = null;
        update contract;
    }
}