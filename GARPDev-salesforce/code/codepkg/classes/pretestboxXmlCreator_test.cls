@isTest
public class pretestboxXmlCreator_test {

    static Shipping_Boxes__c boxes ;
    static list<Shipping_Boxes__c> lstShipInfo;
    
    static void testData(){
        boxes = new Shipping_Boxes__c();
        insert boxes;
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        lstShipInfo = new list<Shipping_Boxes__c>{boxes};
        test.startTest();
        pretestboxXmlCreator.DomesticProctored(lstShipInfo);
        pretestboxXmlCreator.InvoiceProctored(lstShipInfo);
        pretestboxXmlCreator.InvoiceLessProctored(lstShipInfo);
        test.stopTest();       
    }
}