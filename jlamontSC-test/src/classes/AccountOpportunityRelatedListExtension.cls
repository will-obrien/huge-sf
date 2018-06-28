public class AccountOpportunityRelatedListExtension {
public Account accontRecord {get;set;}

public AccountOpportunityRelatedListExtension(ApexPages.StandardController controller) {
    this.accontRecord = (Account)controller.getRecord();
}
}