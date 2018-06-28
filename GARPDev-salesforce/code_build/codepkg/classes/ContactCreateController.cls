public with sharing class ContactCreateController {
 
  // the contact record you are adding values to
  public Contact contact {
    get {
      if (contact == null)
        contact = new Contact();
      return contact;
    }
    set;
  }

  public Contact contact1 {
    get {
      if (contact1 == null)
        contact1 = new Contact();
      return contact1;
    }
    set;
  }

 
  public ContactCreateController() {
    // blank constructor
  }
 
 
 public PageReference Next1(){
        PageReference p ;
        p = new PageReference('/apex/memberRegisterPart2');
         p.setRedirect(false); 
        return p;
    }
 
  // save button is clicked
  public PageReference save() {

System.Debug('Save Contact!' + contact.lastName);
 
    try {
    

    Contact c = new Contact(
         Membership_Type__c = contact.Membership_Type__c,
         Title = contact.title,
         FirstName = contact.firstName,
         LastName = contact.lastName,
         Middle_Initial__c = contact.Middle_Initial__c,
         MailingCountry = contact.MailingCountry,
         Email = contact.email,
    
         MailingStreet = contact1.MailingStreet,
         MailingState = contact1.MailingState,
         MailingCity = contact1.MailingCity,
         MailingPostalCode = contact1.MailingPostalCode,
         HomePhone = contact1.HomePhone,
         OtherPhone = contact1.OtherPhone
    
      );
      
      insert c; // inserts the new record into the database
      
      
      
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new contact.'));
      return null;
    }
 
    // if successfully inserted new contact, then displays the thank you page.
    return Page.sfdcApp;
  }
 
}