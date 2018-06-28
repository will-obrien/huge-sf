@isTest
public class shippingXMLS_test {
    
    static Shipping_Boxes__c boxes ;
    static list<Shipping_Boxes__c> lstDomProctored;
    
    static void testData(){
        ShippingXMLS Ship = new ShippingXMLS();
        boxes = new Shipping_Boxes__c();
        boxes.Duplicate_Certificate__c  = true;
        insert boxes;
    }
    
    static testMethod void unitTest_7(){
        testData();
        test.startTest();
        lstDomProctored = new list<Shipping_Boxes__c>{boxes};
        ShippingXMLS.domesticProctoredXML(lstDomProctored);
        shippingXMLS.SendEmail('strDomesticExamXML', 'strDomesticProctoredXML', 'strDomesticCertXML', 'strInvoiceLessExamXML', 'strInvoiceLessProctoredExamXML', 'strInvoiceLessCertXML', 'strInvoiceExamXML', 'strInvoiceProctoredXML', 'strInvoiceCertXML');
        test.stopTest();
    }
    
    static testMethod void unitTest_6(){
        testData();
        test.startTest();
        lstDomProctored = new list<Shipping_Boxes__c>{boxes};
        ShippingXMLS.domesticExamXML(lstDomProctored);
        test.stopTest();
    }
    
    static testMethod void unitTest_5(){
        testData();
        test.startTest();
        lstDomProctored = new list<Shipping_Boxes__c>{boxes};
        ShippingXMLS.InvoiceExamXML(lstDomProctored);
        test.stopTest();
    }
    static testMethod void unitTest_4(){
        testData();
        test.startTest();
        lstDomProctored = new list<Shipping_Boxes__c>{boxes};
        ShippingXMLS.InvoiceLessExamXML(lstDomProctored);
        test.stopTest();
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        lstDomProctored = new list<Shipping_Boxes__c>{boxes};
        ShippingXMLS.getShippingInfo();
        ShippingXMLS.resetLists();
        test.stopTest();
    }
    
    static testMethod void unitTest_2(){
        testData();
        test.startTest();
        lstDomProctored = new list<Shipping_Boxes__c>{boxes};
        shippingXMLS.InvoiceLessProctoredExamXML(lstDomProctored);
        test.stopTest();
    }
    
    static testMethod void unitTest_3(){
        testData();
        test.startTest();
        lstDomProctored = new list<Shipping_Boxes__c>{boxes};
        shippingXMLS.InvoiceProctoredXML(lstDomProctored);
        test.stopTest();
    }
}