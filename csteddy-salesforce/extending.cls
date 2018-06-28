public class extending {

    private final Card__c card;
    private final Address__c[] addr;

    public extending(ApexPages.StandardController stdcontroller) {
        this.card = (Card__c)stdController.getRecord();
//      Get all Address records that are linked to the Card object that we are processing
        this.addr = [SELECT Card__c, City__c, ContactName__c, Country__c, Email__c, Fax__c, Index__c, Phone1__c, Phone2__c, Phone3__c, PostCode__c, Salutation__c, State__c, Street__c, UID__c
                     FROM Address__c WHERE Card__c = :this.card.Id];
    for (Address__c a:this.addr) {
        system.debug(a); }
        system.debug(this.addr.size());
    option = '1';
    }

 

    public String option { get; set; }

}
