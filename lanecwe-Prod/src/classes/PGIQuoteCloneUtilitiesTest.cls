@isTest
public class PGIQuoteCloneUtilitiesTest {
   @istest (seeAlldata = true)
    public static  void testGetCreatableFieldsOfQuote()
    {
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
         Product2 standardProduct = PGITestUtilities.getStdProduct();
         insert standardProduct;
         PricebookEntry standardPbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
         insert standardPbe;
         OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testopp.Id, standardPbe.Id);
         insert oli; 
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.status = QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c;
         insert testquote;
         String testquoteId = testquote.Id;
         PGIQuoteCloneUtilities.getCreatableFieldsOfQuote(testquoteId );
    }
    
     @istest (seeAlldata = true)
    public static  void testGetCreatableFieldsSOQL()
    {
         //Test Data
          //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
         Product2 standardProduct = PGITestUtilities.getStdProduct();
         insert standardProduct;
         PricebookEntry standardPbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
         insert standardPbe;
         OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testopp.Id, standardPbe.Id);
         insert oli;
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.status = QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c;
         insert testquote;
         String testquoteId = testquote.Id;
         string testSObj = 'QuoteLineItem';
         string testprodtype1 = 'Service';
         string testprodtype2 = 'Addon';
         PGIQuoteCloneUtilities.getCreatableFieldsSOQL(testquoteId ,testSObj ,testprodtype1  );
         PGIQuoteCloneUtilities.getCreatableFieldsSOQL(testquoteId ,testSObj ,testprodtype2  );
         PGIQuoteCloneUtilities testCloneUtil = new PGIQuoteCloneUtilities() ;
         String result = PGIQuoteCloneUtilities.getCreatableFieldsSOQL(testquoteId ,testSObj ,testprodtype1);       
    } 
    
    
}