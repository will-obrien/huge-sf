@isTest
public class QuoteHistoryHandlerTest{
    static testMethod void testtrackChanges() {

            Account a = new Account();
            a.Name = 'Account XYZ - Random Account';
            a.OwnerId = '005a0000009lTTN';
            insert a;
        
            Opportunity o = new Opportunity();
            o.AccountId = a.id;
            o.Name = 'Crazy Test Opportunity';
            o.StageName = 'Qualification';
            o.CloseDate = date.today();
            insert o;
        
            Quote q = new Quote();
            q.OpportunityId = o.id;
            q.Name = 'Quote Name - Test';
            q.SC_Auto_Renewal__c = true;
            q.SC_Auto_renewal_Interval_in_months__c = 12;
            q.File_Store_Contract_Status__c = 'Active';
            q.ContractType__c = 'Contract';
            q.Status = QCStatusValues__c.getInstance(PGIQuoteStatusEnum.Draft.name()).StatusValue__c;
            insert q;
            
        Test.startTest();
        q.SC_Auto_Renewal__c = false;
        q.SC_Auto_renewal_Interval_in_months__c = 6;
        q.File_Store_Contract_Status__c = 'Expired';
        q.ContractType__c = 'Email Order';
        q.Status = QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c;
        update q;
        Test.stopTest();
        
        List<Quote_History__c> qh = [SELECT id, Old_Value__c, New_Value__c, Field_Name__c FROM Quote_History__c WHERE Quote__c = :q.id];
            for (Quote_History__c qhAssert : qh) {
                
               /* if (qhAssert.Field_Name__c == 'SC_Auto_Renewal__c'){
                    System.assertEquals('1',qhAssert.Old_Value__c);
                    System.assertEquals('0',qhAssert.New_Value__c);
                }/*
                if (qhAssert.Field_Name__c == 'SC_Auto_renewal_Interval_in_months__c'){
                    System.assertEquals('12',qhAssert.Old_Value__c);
                    System.assertEquals('6',qhAssert.New_Value__c);
                }*/
                if (qhAssert.Field_Name__c == 'File_Store_Contract_Status__c') {
                    System.assertEquals('Active',qhAssert.Old_Value__c);
                    System.assertEquals('Expired',qhAssert.New_Value__c);
                }
                if (qhAssert.Field_Name__c == 'ContractType__c') {
                    System.assertEquals('Contract',qhAssert.Old_Value__c);
                    System.assertEquals('Email Order',qhAssert.New_Value__c);
                }
                if (qhAssert.Field_Name__c == 'Status') {
                    System.assertEquals(QCStatusValues__c.getInstance(PGIQuoteStatusEnum.Draft.name()).StatusValue__c,qhAssert.Old_Value__c);
                    System.assertEquals(QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c,qhAssert.New_Value__c);
                }
            }
    }
}