/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class QuoteLineItemMinimumVRVGMTestClass {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    
     //String AccRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Latin America'].Id;
        
        Account a = new Account(Name = 'Test Account', Company_Type__c='Architect');
        insert a;

        Opportunity o = new Opportunity(Name = 'Test Opp', Vertical_Market__c='Financial / Office Space',StageName = 'D-Proposal/Bid-Not Daikin Specified', CloseDate = Date.today(), AccountId = a.Id, RecordTypeId='012C0000000HnEo', Local_Currency__c='USD');
        insert o;

        //Pricebook2 pb = [select Id from Pricebook2 where PriceBook2.Name = 'Standard Price Book'];
       	ID Pb='01s800000006K3p';

        Product2 p = new Product2(Name = 'Test Product',Product_Category__c='VRV', isActive = true);
        insert p;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb, Product2Id = p.Id, UnitPrice = 100, isActive = true);
        insert pbe;
        
        //OpportunityLineItem oli = new OpportunityLineItem(Quantity = 1, Item_Number__c='1', Equipment_Gross_Margin__c=14, UnitPrice = 100, Multiplier_PAR__c=1, Exchange_Rate__c=1, PriceBookEntryId = pbe.Id, OpportunityId=o.Id );
        //insert oli;
        
      

        Quote q = new Quote(Name = 'Test Quote', ExpirationDate=Date.today(),Margin_Approval_Status__c='Needs Review', Quote_Status__c='Draft', OpportunityId = o.Id, PriceBook2Id = pb);
        insert q;

        //QuoteLineItem qli = new QuoteLineItem(Equipment_Gross_Margin__c=14, QuoteId = q.Id, PriceBookEntryId = pbe.Id,  );
        //insert qli;
        
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, Item_Number__c='1', Equipment_Gross_Margin__c=14, UnitPrice = 100, Multiplier_PAR__c=1, Exchange_Rate__c=1, PriceBookEntryId = pbe.Id, QuoteID=Q.Id, Equipment_With_F_L__c =0 );
        insert qli;
        // Retrieve the new book
       q = [SELECT Minimum_VRV_GM__c FROM Quote WHERE Id =:q.Id];
       System.debug('Gross_Margin__c: ' + q.Minimum_VRV_GM__c);
       
       qli=[SELECT Equipment_Gross_Margin__c FROM QuoteLineItem WHERE Id =:qli.Id];
       System.debug('Equipment_Gross_Margin__c: ' + qli.Equipment_Gross_Margin__c);

       // Test that the trigger correctly updated the price
           system.assertEquals(14, q.Minimum_VRV_GM__c);
      
        delete qli;
    
    }
}