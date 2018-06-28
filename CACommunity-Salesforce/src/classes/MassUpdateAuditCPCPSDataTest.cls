@isTest
public class MassUpdateAuditCPCPSDataTest {

    
    static testmethod void testMassUpdateAuditCPCPSData1(){
        
        Account acc = new Account(Name = 'test 1', Auditor__c = 'Web Trust', Status__c = 'Removed', Type = 'Root', 
        EV_Policy_OID_s__c = 'Not EV', trust_bits__c = 'All Trust Bits Turned Off', SHA_1_Fingerprint__c = '198');
        Account acc1 = new Account(Name = 'test 2', Auditor__c = 'Web Trust');
        Account acc2 = new Account(Name = 'test 3', Auditor__c = 'Web Trust');
        insert new List<Account>{acc, acc1, acc2};
        
        PageReference pref = Page.MassUpdateAuditCPCPSData;
        Test.setCurrentPage(pref);
        
        ApexPages.currentPage().getParameters().put('Id', acc.Id);
        
        ApexPages.standardController stdCon = new ApexPages.standardController(acc);
        MassUpdateAuditCPCPSDataController obj = new MassUpdateAuditCPCPSDataController(stdCon);
        
        obj.redirectToAccount();
        obj.syncAccount();
    }
    
    static testmethod void testMassUpdateAuditCPCPSData2(){
        
        Account acc = new Account(Name = 'test 1', Auditor__c = 'Web Trust');
        insert acc;
        
        Account acc1 = new Account(Name = 'test 2', Auditor__c = 'ETSI TS 101 456', ParentId = acc.Id);
        Account acc2 = new Account(Name = 'test 3', Auditor__c = 'ETSI TS 102 042', ParentId = acc.Id);
        insert new List<Account>{acc1, acc2};
        
        PageReference pref = Page.MassUpdateAuditCPCPSData;
        Test.setCurrentPage(pref);
        
        ApexPages.currentPage().getParameters().put('Id', acc.Id);
        
        ApexPages.standardController stdCon = new ApexPages.standardController(acc);
        MassUpdateAuditCPCPSDataController obj = new MassUpdateAuditCPCPSDataController(stdCon);
        
        obj.syncAccount();
        obj.redirectToNextAccount();
        obj.redirectTosourceAccount();
    }
    
    static testmethod void testMassUpdateAuditCPCPSData3(){
        
        Account parentAcc = new Account(Name = 'test 1', Auditor__c = 'Web Trust');
        insert parentAcc;
        
        Account acc1 = new Account(Name = 'test 2', Auditor__c = 'ETSI TS 101 456', ParentId = parentAcc.Id);
        Account acc2 = new Account(Name = 'test 3', Auditor__c = 'ETSI TS 102 042', ParentId = parentAcc.Id);
        insert new List<Account>{acc1, acc2};
        
        PageReference pref = Page.MassUpdateAuditCPCPSData;
        Test.setCurrentPage(pref);
        
        ApexPages.currentPage().getParameters().put('Id', acc1.Id);
        
        ApexPages.standardController stdCon = new ApexPages.standardController(acc1);
        MassUpdateAuditCPCPSDataController obj = new MassUpdateAuditCPCPSDataController(stdCon);
        
        obj.syncAccount();
        obj.redirectToNextAccount();
        obj.redirectTosourceAccount();
    }
    
}