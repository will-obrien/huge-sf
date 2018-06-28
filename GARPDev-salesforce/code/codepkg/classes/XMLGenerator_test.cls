@isTest
public class XMLGenerator_test {

    static Account acc ;
    static Opportunity opp; 
    
    static void testData(){ 
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(Shipping_Street__c = 'test \n test \n test',amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        list<Opportunity> lstOpp = new list<Opportunity>{opp};
        test.startTest();
        XMLGenerator.internationalShipping(lstOpp);
        XMLGenerator.domesticShipping(lstOpp);
        XMLGenerator.writeExcelBody(lstOpp);
        XMLGenerator.invoicelessXML(lstOpp);
        test.stopTest();
    }
}