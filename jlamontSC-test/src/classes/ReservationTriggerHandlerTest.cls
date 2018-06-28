@isTest
private class ReservationTriggerHandlerTest {

	@isTest
	private static void addExplorerPreferenceTest() {

		Account a = new Account(Name = 'Test Account');
		insert a;

		Contact c = new Contact(FirstName = 'Test',LastName = 'Contact',AccountId = a.Id, Email = 'test@sierraclub.org');
		insert c;

		Reservation__c r = new Reservation__c(Name = 'Test Reservation',Contact__c = c.Id);
		insert r;


	}
}