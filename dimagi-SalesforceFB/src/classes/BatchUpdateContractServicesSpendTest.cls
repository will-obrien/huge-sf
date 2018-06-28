@isTest
public class BatchUpdateContractServicesSpendTest {

    @isTest
    public static void shouldUpdateServicesSpendFieldValue() {
        DContract__c dcontract1 = new DContract__c(
            Name = 'Sample Test Name 1 ',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'No'
        );
        insert dcontract1;
        DContract__c dcontract2 = new DContract__c(
            Name = 'Sample Test Name 2',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'No'
        );
        insert dcontract2;
        DContract__c dcontract3 = new DContract__c(
            Name = 'Sample Test Name 3 ',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = dcontract2.Id
        );
        insert dcontract3;
        DContract__c dcontract4 = new DContract__c(
            Name = 'Sample Test Name 4',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = dcontract2.Id
        );
        insert dcontract4;
        DContract__c dcontract5 = new DContract__c(
            Name = 'Sample Test Name 5',
            Status__c = 'Active',
            Requires_Report_Out__c = 'No',
            Intracompany_Sub_contract__c = 'Yes',
            Parent_Contract__c = dcontract2.Id
        );
        insert dcontract5;

        Map<Id, Decimal> batchData = new Map<Id, Decimal> { dcontract1.Id => 100, dcontract2.Id => 200, dcontract3.Id => 10, dcontract4.Id => 35};

        Test.startTest();
        BatchUpdateContractServicesSpend obj = new BatchUpdateContractServicesSpend(batchData);
        Database.executeBatch(obj, 200);
        Test.stopTest();

        List<DContract__c> contracts = [SELECT Name, Services_Spend__c FROM DContract__c ORDER BY Name];

        System.assertEquals('Sample Test Name 1', contracts.get(0).Name);
        System.assertEquals('Sample Test Name 2', contracts.get(1).Name);
        System.assertEquals('Sample Test Name 3', contracts.get(2).Name);
        System.assertEquals('Sample Test Name 4', contracts.get(3).Name);
        System.assertEquals('Sample Test Name 5', contracts.get(4).Name);

        System.assertEquals(100, contracts.get(0).Services_Spend__c);
        System.assertEquals(245, contracts.get(1).Services_Spend__c);
        System.assertEquals(10, contracts.get(2).Services_Spend__c);
        System.assertEquals(35, contracts.get(3).Services_Spend__c);
        System.assertEquals(null, contracts.get(4).Services_Spend__c);
    }
}