public with sharing class UpdateAccountAddressAsynch implements Queueable {
	private List<rC_Bios__Account_Address__c> addressesToUpdate;
	public UpdateAccountAddressAsynch(List<rC_Bios__Account_Address__c> addressesToUpdate) {
		this.addressesToUpdate = addressesToUpdate;
	}
	public void execute(QueueableContext context) {
		update addressesToUpdate;
	}
}