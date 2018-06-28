@isTest
public class TimeCardTriggerControllerTest {

    static testMethod void shouldUpdateServicesSpend() {
        SFDC_Employee__c employeeObj = new SFDC_Employee__c(
            name = 'Sample Employee',
            Salary__c = 50000,
            Exchange_Rate__c = 1,
            Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
            Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24)
        );
        insert employeeObj;

        DContract__c dcontract = new DContract__c(
            Name = 'Sample Test Name',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'No'
        );
        insert dcontract;

        Test.startTest();

        Time_Card__c timeCardObj = new Time_Card__c(
            Total__c = 4,
            Date__c = Date.today().addMonths(-2),
            Employee__c = employeeObj.Id,
            Client__c = dcontract.Id
        );
        insert timeCardObj;

        Test.stopTest();

        DContract__c dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: dcontract.Id];
        System.assertEquals(230, dcontractFromDB.Services_Spend__c);
    }

    static testMethod void shouldUpdateParentServicesSpend() {
        SFDC_Employee__c employeeObj = new SFDC_Employee__c(
            name = 'Sample Employee',
            Salary__c = 50000,
            Exchange_Rate__c = 1,
            Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
            Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24)
        );
        insert employeeObj;

        DContract__c parent = new DContract__c(
            Name = 'Sample Parent',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'No'
        );
        insert parent;

        DContract__c child1 = new DContract__c(
            Name = 'Sample Child 1',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = parent.Id
        );
        insert child1;

        DContract__c child2 = new DContract__c(
            Name = 'Sample Child 2',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = parent.Id
        );
        insert child2;

        Test.startTest();

        Time_Card__c timeCardObj1 = new Time_Card__c(
            Total__c = 4,
            Date__c = Date.today().addMonths(-2),
            Employee__c = employeeObj.Id,
            Client__c = child1.Id
        );
        insert timeCardObj1;

        Time_Card__c timeCardObj2 = new Time_Card__c(
            Total__c = 8,
            Date__c = Date.today().addMonths(-2),
            Employee__c = employeeObj.Id,
            Client__c = child2.Id
        );
        insert timeCardObj2;

        Test.stopTest();

        DContract__c dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: parent.Id];
        System.assertEquals(690, dcontractFromDB.Services_Spend__c);

        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: child1.Id];
        System.assertEquals(230, dcontractFromDB.Services_Spend__c);

        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: child2.Id];
        System.assertEquals(460, dcontractFromDB.Services_Spend__c);
    }

    static testMethod void shouldUpdateServicesSpendInManyContracts() {
        SFDC_Employee__c employeeObj = new SFDC_Employee__c(
            name = 'Sample Employee',
            Salary__c = 50000,
            Exchange_Rate__c = 1,
            Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
            Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24)
        );
        insert employeeObj;

        DContract__c parent1 = new DContract__c(
            Name = 'Sample Parent',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'No'
        );
        insert parent1;

        DContract__c child1 = new DContract__c(
            Name = 'Sample Child 1',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = parent1.Id
        );
        insert child1;

        DContract__c child2 = new DContract__c(
            Name = 'Sample Child 2',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = parent1.Id
        );
        insert child2;

        DContract__c parent2 = new DContract__c(
            Name = 'Sample Parent',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'No'
        );
        insert parent2;

        DContract__c child3 = new DContract__c(
            Name = 'Sample Child 1',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = parent2.Id
        );
        insert child3;

        DContract__c child4 = new DContract__c(
            Name = 'Sample Child 2',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = parent2.Id
        );
        insert child4;

        Test.startTest();

        Time_Card__c timeCardObj1 = new Time_Card__c(
            Total__c = 8,
            Date__c = Date.today().addMonths(-2),
            Employee__c = employeeObj.Id,
            Client__c = child1.Id
        );
        insert timeCardObj1;

        Time_Card__c timeCardObj2 = new Time_Card__c(
            Total__c = 4,
            Date__c = Date.today().addMonths(-2),
            Employee__c = employeeObj.Id,
            Client__c = parent1.Id
        );
        insert timeCardObj2;

        Time_Card__c timeCardObj3 = new Time_Card__c(
            Total__c = 10,
            Date__c = Date.today().addMonths(-2),
            Employee__c = employeeObj.Id,
            Client__c = child3.Id
        );
        insert timeCardObj3;

        Time_Card__c timeCardObj4 = new Time_Card__c(
            Total__c = 8,
            Date__c = Date.today().addMonths(-2),
            Employee__c = employeeObj.Id,
            Client__c = child4.Id
        );
        insert timeCardObj4;

        Set<Id> ids = new Set<Id>();
        ids.add(child4.Id);
        ids.add(parent1.Id);
        TimeCardTriggerController.loadTimeCardsTotalAmountByContractIds(ids);

        Test.stopTest();

        DContract__c dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: parent1.Id];
        System.assertEquals(690, dcontractFromDB.Services_Spend__c);

        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: child1.Id];
        System.assertEquals(460, dcontractFromDB.Services_Spend__c);

        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: child2.Id];
        System.assertEquals(null, dcontractFromDB.Services_Spend__c);

        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: parent2.Id];
        System.assertEquals(1035, dcontractFromDB.Services_Spend__c);

        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: child3.Id];
        System.assertEquals(575, dcontractFromDB.Services_Spend__c);

        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: child4.Id];
        System.assertEquals(460, dcontractFromDB.Services_Spend__c);
    }
}