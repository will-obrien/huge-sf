@isTest
public class BulkorderXML_Test {

    static Bulk_Orders__c bo;
    static void testdata()
    {
        
        bo = new Bulk_Orders__c (Ups_Stage__c='Sent to GT',Weight__c = '30',Country_Code_for_UPS__c='US',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True);
        insert bo;
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        list<Bulk_Orders__c> lstcerts = new list<Bulk_Orders__c>{bo};
        test.startTest();
        BulkorderXML.internationalShipping(lstcerts);
        BulkorderXML.domesticShipping(lstcerts);
        BulkorderXML.invoicelessXML(lstcerts);
        test.stopTest();
    }
    
}