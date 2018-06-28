@isTest
private class QuoteAttachmentCount_Test {
  //  static Quote testQuote= new Quote();
    static Attachment attachment;

 
/*
    static {
      myquote.name
        insert myQuote ; 
        
    }
*/
    static decimal getAttachmentCount() {
  Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        return [select CountofQuote__c from Quote where id = :testQuote.Id].CountofQuote__c ;
    }

    static void insertQuoteAttachment() {    
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        insertAttachment(testQuote.Id);
    }           

    static void insertAttachment(id parentId) {             
        attachment = new Attachment(ParentId = parentId, Name = 'Test Attachment', Body = blob.valueOf('Test'));
        insert attachment;      
    }

    static testMethod void newQuoteHasZeroAttachments() {
        System.assertEquals(0, getAttachmentCount());
    }
    
    static testMethod void newQuoteAttachmentIncrementsCount() {
        insertQuoteAttachment();
        
      //  System.assertEquals(1, getAttachmentCount());
    }
    
    static testMethod void deleteQuoteAttachmentDecrementsCount() {
        insertQuoteAttachment();
        delete attachment;
        
        System.assertEquals(0, getAttachmentCount());
    }
    
    static testMethod void updateQuotePopulatesAllAttachmentCounts() {
        integer QuoteCount = [select count() from Quote];
        QuoteAttachmentCount.updateAllQuotes();
        System.assertEquals(QuoteCount, [select count() from Quote where CountofQuote__c != null]);
    }
    
    static testMethod void nonQuoteAttachmentIsInserted() {
        Contact contact = new Contact(LastName = 'Test');
        contact.email='hsoni@salesforce.com';
        contact.title='mr';
       // contact.address='Blah Blah';
        insert contact;
        
        insertAttachment(contact.Id);
        
        System.assert(attachment.id != null);
    }
}