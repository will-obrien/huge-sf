@isTest
public class XMLCreator_test {

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
        XMLCreator.DomesticExam(lstShipInfo);
        XMLCreator.DomesticProctored(lstShipInfo);
        XMLCreator.InvoiceForExam(lstShipInfo);
        XMLCreator.InvoiceLessExam(lstShipInfo);
        XMLCreator.InvoiceLessProctored(lstShipInfo);
        XMLCreator.InvoiceProctored(lstShipInfo);
        test.stopTest();       
    }
}