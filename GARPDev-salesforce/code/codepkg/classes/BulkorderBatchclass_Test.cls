@isTest(seeAllData=false)
public class BulkorderBatchclass_Test {

     
   
    static Bulk_Orders__c bo;
    static Bulk_Orders__c bo1;
    static Bulk_Orders__c bo2;
    
   
    
    static void testData() {
        
      
        
        bo = new Bulk_Orders__c (Ups_Stage__c='New Order',Weight__c = '30',Country_Code_for_UPS__c='US',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True);
        insert bo;
        
        bo1 = new Bulk_Orders__c (Ups_Stage__c='New Order',Weight__c = '30',Country_Code_for_UPS__c='GR',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True);
        insert bo1;
        
        bo2 = new Bulk_Orders__c (Ups_Stage__c='New Order',Weight__c = '30',Country_Code_for_UPS__c='IN',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True);
        insert bo2;
        
        
    }
    
    static testMethod void unitTest_1(){
        
        testdata();
        test.startTest();
        BulkorderBatchclass b = new BulkorderBatchclass();
        ID batchprocessid  = Database.executeBatch(b);      
        test.stopTest();
              
        
    }
    
}