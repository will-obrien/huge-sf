public class ContactOpportunityRelatedListExtension {
	public Contact contactRecord {get;set;}

public ContactOpportunityRelatedListExtension(ApexPages.StandardController controller) {
    this.contactRecord = (Contact)controller.getRecord();
}

}