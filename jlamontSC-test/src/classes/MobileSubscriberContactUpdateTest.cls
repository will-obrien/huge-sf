@isTest
private class MobileSubscriberContactUpdateTest {

    static testMethod void myUnitTest() {
    	List<Contact> contactList = new List<Contact>();
        Contact contact1 = new Contact(
        	FirstName = 'Test1',
        	LastName = 'Contact1',
        	Phone = '415-323-4567',
			Mobile_Subscriber__c = true
        );
        contactList.add(contact1);

        Contact contact2 = new Contact(
        	FirstName = 'Test2',
        	LastName = 'Contact2',
        	Phone = '415-543-6751',
			Mobile_Subscriber__c = true
        );
        contactList.add(contact2);

        Contact contact3 = new Contact(
        	FirstName = 'Test3',
        	LastName = 'Contact3',
        	Phone = '1213-349-4321',
			Mobile_Subscriber__c = true
        );
        contactList.add(contact3);

        insert contactList;
        
        List<Mobile_Integration_Request__c> miList = new List<Mobile_Integration_Request__c>();
        miList.add(new Mobile_Integration_Request__c(
        	Contact__c = contact1.Id,
        	Phone__c = contact1.Phone,
        	Phone_Key__c = getPhoneDigits(contact1.Phone)
        ));
        miList.add(new Mobile_Integration_Request__c(
        	Contact__c = contact2.Id,
        	Phone__c = contact2.Phone,
        	Phone_Key__c = getPhoneDigits(contact2.Phone)
        ));
        miList.add(new Mobile_Integration_Request__c(
        	Contact__c = contact3.Id,
        	Phone__c = contact3.Phone,
        	Phone_Key__c = getPhoneDigits(contact3.Phone)
        ));
        insert miList;        

        contactList.clear();

        Contact updatedContact1 = new Contact(
        	Id=contact1.Id,
        	Phone = '510-434-9876'
        );
        contactList.add(updatedContact1);
        
        Contact updatedContact2 = new Contact(
        	Id=contact2.Id,
        	Phone = ''
        );
        contactList.add(updatedContact2);
        
        Contact updatedContact3 = new Contact(
        	Id=contact3.Id,
        	MailingCountry = 'USA'
        );
        contactList.add(updatedContact3);
        
        update contactList;

        List<Mobile_Integration_Request__c> requestList = [
        	select Contact__c, Phone__c, Phone_Key__c from Mobile_Integration_Request__c
        	where Contact__c = :contact3.Id
        ];
        System.assertEquals(1, requestList.size());
    }
	private static String getPhoneDigits(String phone) {
		if(String.isEmpty(phone)) {
			return '';
		}
		String phoneDigits = phone.replaceAll('\\D+', '');
		if(phoneDigits.length() == 11) {
			phoneDigits = phoneDigits.substring(1);
		}
		return phoneDigits;
	}
}