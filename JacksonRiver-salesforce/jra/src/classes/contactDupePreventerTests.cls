/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class contactDupePreventerTests {

    static testMethod void testContactDupPreventer() {
        // First make sure there are no contacts already in the system 
        // that have the email addresses used for testing 
        Set<String> testEmailAddress = new Set<String>(); 
        testEmailAddress.add('test1@duptest.com'); 
        testEmailAddress.add('test2@duptest.com'); 
        testEmailAddress.add('test3@duptest.com'); 
        testEmailAddress.add('test4@duptest.com'); 
        testEmailAddress.add('test5@duptest.com'); 
        System.assert([SELECT count() FROM Contact WHERE Email IN :testEmailAddress] == 0);
        
        // Seed the database with some leads, and make sure they can // be bulk inserted successfully. 
        Contact contact1 = new Contact(LastName='Test1', Email='test1@duptest.com'); 
        Contact contact2 = new Contact(LastName='Test2', Email='test4@duptest.com'); 
        Contact contact3 = new Contact(LastName='Test3', Email='test5@duptest.com'); 
        Contact[] contacts = new Contact[] {contact1, contact2, contact3};
		insert contacts;
		OneTimeTriggerValidator.reset();
		
		contact2.Email = 'test2@duptest.com';
		contact3.Email = 'test3@duptest.com';
		update contacts;
		OneTimeTriggerValidator.reset();
		
		Contact dup1 = new Contact(LastName='Test1Dup', Email='test1@duptest.com');
		try {
			insert dup1;
			System.assert(false);
		} catch (DmlException e) {
			System.assert(e.getNumDml() == 1); 
			System.assert(e.getDmlIndex(0) == 0); 
			System.assert(e.getDmlFields(0).size() == 1); 
			System.assert(e.getDmlFieldNames(0)[0] == 'Email'); 
			System.assert(e.getDmlMessage(0).indexOf('A contact with this email address already exists.') > -1);	
		}
		OneTimeTriggerValidator.reset();
		
		dup1 = new Contact(Id = contact1.Id, LastName='Test1Dupe', Email='test2@duptest.com');
		try {
			update dup1;
			System.assert(false);
		} catch (DmlException e) {
			System.assert(e.getNumDml() == 1); 
			System.assert(e.getDmlIndex(0) == 0); 
			System.assert(e.getDmlFields(0).size() == 1); 
			System.assert(e.getDmlFieldNames(0)[0] == 'Email'); 
			System.assert(e.getDmlMessage(0).indexOf('A contact with this email address already exists.') > -1);	
		}		
    }
}