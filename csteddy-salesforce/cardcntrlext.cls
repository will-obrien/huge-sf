public class cardcntrlext {

    private final Card__c card;
    private final Address__c[] addr;
//    List<String> fieldNames = new list<String> { 'IsIndividual__c' , 'CompanyName__c' };
    private PageReference previousPage;
    private Address__c currentAddress;
    
    String method;
    
   
    ApexPages.StandardController sController;

    public cardcntrlext(ApexPages.StandardController stdcontroller) {
        sController = stdcontroller; 
//        sController.addfields(fieldNames);
//      Save referring page (but not if it's the new record recordtype selection page)
        String referring = ApexPages.currentPage().getHeaders().get('Referer');
        if (referring != null && !referring.contains('recordtypeselect')) previousPage = new PageReference(referring);
        this.card = (Card__c)stdController.getRecord();
//      Get all Address records that are linked to the Card object that we are processing
        this.addr = [SELECT Card__c, City__c, ContactName__c, Country__c, Email__c, Fax__c, Index__c, Phone1__c, Phone2__c, Phone3__c, PostCode__c, Salutation__c, State__c, Street__c, UID__c, Website__c
                     FROM Address__c WHERE Card__c = :this.card.Id ORDER BY Index__c];
    
    option = '1';
    }

    public Address__c getaddress() {

//      Search list of address objects for the current card object
//      option field points to active (currently displayed address)
            for (Integer a=0; a < this.addr.size(); a++) if (this.addr[a].Index__c == integer.valueOf(option)) {
            currentAddress = this.addr[a];
            return this.addr[a];
            }
//      If we drop through to here then we have displayed a new (non-existent) address, so we need to create a new object and add it to the list 
            addr.add(new Address__c(Index__c=integer.valueOf(option)));
            this.addr[this.addr.size()-1].Card__c = this.card.Id;
            this.addr[this.addr.size()-1].Name = option;
            
//           this.addr[this.addr.size()-1].UID__c = this.card.UID__c + option;   //now done by trigger
            currentAddress = this.addr[this.addr.size()-1];
            return this.addr[this.addr.size()-1];
            }
           
    public String option { get; set; }
 
    public Card__c getcard() { return this.card; }
    
  
    public PageReference debug() {

//    system.debug('Card = '+card);
    system.debug('Address = '+option);
    system.debug(getaddress());
//    ApexPages.Message m = new Apexpages.Message(ApexPages.Severity.INFO,'debug'); // does not work
    return null;
    }

//308 Negra Arroyo Lane

    public PageReference deleteCard() {
/*
    The standard controller !delete method is suitable for our purposes
    as it deletes both the card record and any asociated address records.
    However, we need to tell MYOB that a card has been deleted. At the moment
    the MYOB API does not support a delete of an actual record, so we will have to
    mark the record as Inactive.
*/
    
    PageReference pr = sController.delete(); 
    return pr;
    }
    
    public PageReference cancelEdit() {
    
    PageReference pr = sController.cancel();
    if (previousPage == null) return pr;
    return previousPage;
    
    }
    
              
    public PageReference ok() {
 
    



// Field validation
// Individual records require First Name and Last Name to be specified
    if (this.card.IsIndividual__c && (this.card.FirstName__c == null || this.card.FirstName__c =='')) {
        this.card.FirstName__c.adderror('First Name must be specified');
        return null;
        }
    if (this.card.IsIndividual__c && (this.card.LastName__c == null || this.card.LastName__c =='')) {
        this.card.LastName__c.adderror('Last Name must be specified');
        return null;
        }   
// If it is not and individual record then Company Name is mandatory
    if (this.card.IsIndividual__c != true && (this.card.CompanyName__c == null || this.card.CompanyName__c == '')) {
        this.card.CompanyName__c.adderror('Company Name must be specified');
        return null;
        }
    if (this.card.Id == null) {    
// Field defaults for a new record
    if (this.card.IsIndividual__c)  this.card.CompanyName__c = null;
    if (!this.card.IsIndividual__c) { this.card.FirstName__c = null; this.card.LastName__c = null; }
    if (this.card.Name == null || this.card.Name =='') this.card.Name = card.CompanyName__c;
    this.card.IsActive__c = true;
    method = 'POST'; // POST new records; PUT existing ones
    }
//  need to callout to MYOB API to insert/update record and get UID and RowVersion returned
//  as these need to be stuffed into the SF Card object
//  Build JSON string to insert new or update existing MYOB Card record
    String jsonstr = MYOB_JSON.supplier(this.card);
    System.debug(jsonstr);
    String jsonreply = endpoint.callEndPoint('v2',method,jsonstr,'/Contact/Supplier');
    JSONParser parser = JSON.createParser(jsonreply);
    // Advance to the start object marker.
    parser.nextToken();
    parser.nextValue();
    String fieldName = parser.getCurrentName();
    String fieldValue = parser.getText();
//  extract record GUID from URI
    this.card.UID__c = fieldValue.substringAfterLast('/');
//  Do we go back to MYOB to get the RowVersion information?
//    PageReference pr = sController.save();
    upsert this.card;
//    If this is a new record then we won't know the Id of the master card record until now.
//    So we need to update any address records to point to the master card.
    for (Address__c a:this.addr) {
        a.UID__c = this.card.UID__c + string.valueof(a.Index__c);
        if (a.Card__c == null) a.Card__c = this.card.Id;
            }
    try {
        system.debug(this.addr);
        upsert this.addr;
        }
    catch (DMLexception e) {
        ApexPages.addMessages(e);
        }
    if (ApexPages.hasMessages()) {
        return null;
        }
    else return previousPage;
    
    }

}
