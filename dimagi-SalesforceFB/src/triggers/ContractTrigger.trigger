trigger ContractTrigger on DContract__c (after insert,after update,before insert,before update) {

    //Set Workflow Escalation Enabled
    if (Trigger.IsBefore) {
        for (DContract__c cont : Trigger.New) {
            DContract__c oldCont = null;

            if (Trigger.IsUpdate) {
                oldCont = Trigger.OldMap.get(cont.id);
            }

            if (oldCont == null || cont.Requires_Report_Out__c != oldCont.Requires_Report_Out__c){
                
                if (cont.Requires_Report_Out__c == 'Yes') {
                  cont.Workflow_Escalation_Enabled__c = true;
                } else {
                  cont.Workflow_Escalation_Enabled__c = false;
                }
            }
        }
    }

    if (Trigger.IsAfter) {
        List<Contract_Contact__c> upsertList = new List<Contract_Contact__c>();
        List<Contract_Contact__c> deleteList = new List<Contract_Contact__c>();

        List<PRO_Email_Remindar_Settings__c> settingList = PRO_Email_Remindar_Settings__c.getALL().values();
        String globalServicesBackstop;
        List<String> devWorkContacts = new List<String>();
        if (settingList != null && settingList.size() > 0) {
            PRO_Email_Remindar_Settings__c settings = settingList[0];
            globalServicesBackstop = settings.Global_Services_Backstop__c;
            devWorkContacts = settings.Dev_Work_Emails__c.split(',');
        }

        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email IN: devWorkContacts];
        List<Contact> VPOfGlobalServices;

        if (!String.isBlank(globalServicesBackstop)) {
            VPOfGlobalServices = [SELECT Id FROM Contact WHERE Email =: globalServicesBackstop];
        }
        if (VPOfGlobalServices == null || VPOfGlobalServices.size() == 0) {
            VPOfGlobalServices = [SELECT Id FROM Contact WHERE Title = 'VP of Global services'];
        }

        List<SFDC_Employee__c> chkEmpList = [SELECT Id, Contact__C, Employee_Status__c FROM
                                                SFDC_Employee__c WHERE Employee_Status__c = 'Terminated' AND Contact__C != null];

        Set<Id> inactiveContactList = new Set<Id>();

        for(SFDC_Employee__c emp: chkEmpList) {
            inactiveContactList.add(emp.Contact__c);
        }

        if (Trigger.IsInsert) {
            for(DContract__c cont : Trigger.New) {
                if (cont.Project_Manager__c != null && !inactiveContactList.contains(cont.Project_Manager__c)) {
                    upsertList.add(new Contract_Contact__c(Type__c = 'Project Manager', Contract__c = cont.id, Contact__c = cont.Project_Manager__c));
                }
                if (cont.Backstop__c != null && !inactiveContactList.contains(cont.Backstop__c)) {
                    upsertList.add(new Contract_Contact__c(Type__c = 'Backstop', Contract__c = cont.Id, Contact__c = cont.Backstop__c));
                }
                if (cont.Field_Manager__c != null && !inactiveContactList.contains(cont.Field_Manager__c)) {
                    upsertList.add(new Contract_Contact__c(Type__c = 'Field Manager', Contract__c=cont.id, Contact__c = cont.Field_Manager__c));
                }

                if (cont.Requires_Developer_Work__c) {
                    for (Contact c1 : contactList) {
                        upsertList.add(new Contract_Contact__c(Type__c='Person', Contract__c=cont.id, Contact__c=c1.id));
                    }
                }
            }
        }
        if (Trigger.IsUpdate) {

            Map<Id, SFDC_Employee__c> BusinessUnitEmpMap = new Map<Id,SFDC_Employee__c>();

            List<SFDC_Employee__c> empList = [SELECT Id, Email_Address__c, Business_Unit__c, Contact__c FROM SFDC_Employee__c
                                                WHERE Business_Unit__c != null AND Title__c = 'Country Director' AND Employee_Status__c != 'Terminated'];

            for (SFDC_Employee__c emp : empList) {
                if (!BusinessUnitEmpMap.containsKey(emp.Business_Unit__c)) {
                    BusinessUnitEmpMap.put(emp.Business_Unit__c, emp);
                }
            }

            //get PM,Backstop and FM.
            List<Contract_Contact__c> contContrList = [SELECT Id, Contact__c, Contract__c, Type__c
                                                            FROM Contract_Contact__c WHERE Contract__c =: Trigger.New AND Type__c NOT IN('Person','Email')];

            Map<Id,List<Contract_Contact__c>> contContrMap = new Map<Id, List<Contract_Contact__c>>();
            Map<Id,List<Contract_Contact__c>> contContrMapYellow = new Map<Id, List<Contract_Contact__c>>();
            Map<Id,List<Contract_Contact__c>> contContrMapRed = new Map<Id, List<Contract_Contact__c>>();

            for (Contract_Contact__c contr : contContrList) {
                if (contr.Type__c == 'Management' ) {
                    FillMap(contr, contContrMapRed);
                }
                else if (contr.Type__c == 'VP' || contr.Type__c == 'Country Director') {
                    FillMap(contr, contContrMapYellow);
                } else {
                    FillMap(contr, contContrMap);
                }
            }

            List<Contract_Contact__c> contContactListNew = [SELECT Id, Contact__c, Contract__c, Type__c FROM Contract_Contact__c
                                                                WHERE Contract__c =: Trigger.New AND Contact__c =: contactList];

            Map<Id, Set<Id>> contContrNewMap = new Map<Id, Set<Id>>();

            for (Contract_Contact__c contr : contContactListNew) {
                Set<Id> tempList = contContrNewMap.get(contr.Contract__c);
                if (tempList == null) {
                    tempList = new Set<id>();
                }
                tempList.add(contr.Contact__c);
                contContrNewMap.put(contr.Contract__c, tempList);
            }

            for (DContract__c cont : Trigger.New) {
                DContract__c oldContact = Trigger.OldMap.get(cont.id);

                if (cont.Project_Manager__c != oldContact.Project_Manager__c || cont.Backstop__c != oldContact.Backstop__c ||
                        cont.Field_Manager__c != oldContact.Field_Manager__c) {
                        List<Contract_Contact__c> tempList = contContrMap.get(cont.Id);
                        if (tempList != null) {
                            deleteList.addAll(tempList);
                        }

                        if (cont.Project_Manager__c != null && !inactiveContactList.contains(cont.Project_Manager__c)) {
                            upsertList.add(new Contract_Contact__c(Type__c = 'Project Manager', Contract__c = cont.Id, Contact__c = cont.Project_Manager__c));
                        }
                        if (cont.Backstop__c !=null && !inactiveContactList.contains(cont.Backstop__c)) {
                            upsertList.add(new Contract_Contact__c(Type__c = 'Backstop', Contract__c = cont.Id, Contact__c = cont.Backstop__c));
                        }
                        if (cont.Field_Manager__c !=null && !inactiveContactList.contains(cont.Field_Manager__c)) {
                            upsertList.add(new Contract_Contact__c(Type__c = 'Field Manager', Contract__c = cont.id, Contact__c = cont.Field_Manager__c));
                        }
                }

                //If Developer work is required then add ltse and czue to email list.
                if (cont.Requires_Developer_Work__c) {
                    Set<Id> tempList = contContrNewMap.get(cont.id);
                    for (Contact c : contactList) {
                        if (tempList == null || !tempList.Contains(c.id)) {
                            upsertList.add(new Contract_Contact__c(Type__c = 'Person', Contract__c = cont.id, Contact__c = c.id));
                        }
                    }
                }

                //If Last_Report_Out_Status__c is changed
                if (cont.Last_Report_Out_Status__c != oldContact.Last_Report_Out_Status__c) {
                    //Remove entry if last status is red.
                    if (oldContact.Last_Report_Out_Status__c == 'Red') {
                        List<Contract_Contact__c> tempList = contContrMapRed.get(cont.id);
                        if (tempList != null) {
                            deleteList.addAll(tempList);
                        }
                    }
                    //Remove entry if last status is Yellow.
                    if (oldContact.Last_Report_Out_Status__c == 'Yellow') {
                        List<Contract_Contact__c> tempList = contContrMapYellow.get(cont.Id);
                        if (tempList != null) {
                            deleteList.addAll(tempList);
                        }
                    }
                    //Add Management Email if status is red.
                    if (cont.Last_Report_Out_Status__c == 'Red') {
                        upsertList.add(new Contract_Contact__c(Type__c = 'Management', Contract__c = cont.id, Email__C = 'mgmt@dimagi.com'));
                    }
                    //Add VP and Country Director if status is Yellow.
                    if (cont.Last_Report_Out_Status__c == 'Yellow') {
                        //add VP
                        if (VPOfGlobalServices != null && VPOfGlobalServices.size() > 0) {
                            upsertList.add(new Contract_Contact__c(Type__c = 'VP', Contract__c = cont.id, Contact__c = VPOfGlobalServices[0].Id));
                        }
                        //Add Country director.
                        if (cont.Prime_Contracting_Business_Unit__c != null) {
                           SFDC_Employee__c emp = BusinessUnitEmpMap.get(cont.Prime_Contracting_Business_Unit__c);
                           if (emp != null && emp.Contact__c != null) {
                               upsertList.add(new Contract_Contact__c(Type__c = 'Country Director', Contract__c = cont.Id, Contact__c = emp.Contact__c));
                           }
                        }
                    }
                }
            }
        }

        if (upsertList.size() > 0) {
            upsert upsertList;
        }
        if (deleteList.size() > 0) {
            delete deleteList;
        }
    }

    public void FillMap(Contract_Contact__c contr, Map<Id, List<Contract_Contact__c>> contContrMap) {
        List<Contract_Contact__c> tempList = contContrMap.get(contr.Contract__c);
        if (tempList == null) {
            tempList = new List<Contract_Contact__c>();
        }
        tempList.add(contr);
        contContrMap.put(contr.Contract__c, tempList);
    }
}