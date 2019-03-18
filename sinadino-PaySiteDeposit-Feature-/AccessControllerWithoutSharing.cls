public without sharing class AccessControllerWithoutSharing {
// ---------------------------------------------------------------------------
// AccessControllerWithoutSharing class for PaymentConnect
// Copyright: Linvio, Inc.
// URL: www.linvio.com
// Last Update: 04/04/2011 
// ---------------------------------------------------------------------------		
		public List<SObject> dbQuery(String query) { return Database.query(query); }
		public Database.SaveResult dbInsert(sObject obj) { return Database.insert (obj); }
		public Database.SaveResult dbUpdate(sObject obj) { return Database.update (obj); }
		public Database.DeleteResult dbDelete(sObject obj) { return Database.delete( obj); }
		public Database.SaveResult[] dbInsert(sObject[] objList) { return Database.insert (objList); }
		public Database.SaveResult[] dbUpdate(sObject[] objList) { return Database.update (objList); }
		public Database.DeleteResult[] dbDelete(sObject[] objList) { return Database.delete( objList); }
		
    private static testmethod void testAccessControllerWithout() {
    	AccessControllerWithoutSharing acwos = new AccessControllerWithoutSharing();
    	
    	String testMethodLabel = 'apexTestAccessControllerWithout';
    	Contact contact = new Contact(firstname = 'Lonnie', lastname = testMethodLabel,
    								mailingstreet = '120 Birmingham',
    								mailingcity = 'Cardiff',
    								mailingstate = 'CA',
    								mailingpostalcode = '92007',
    								mailingcountry = 'US',
    								email = 'lonnie'+testMethodLabel+'@apextest.com'
    								);
    	Contact contact2 = new Contact(firstname = 'Larry', lastname = testMethodLabel,
    								mailingstreet = '120 Birmingham',
    								mailingcity = 'Cardiff',
    								mailingstate = 'CA',
    								mailingpostalcode = '92007',
    								mailingcountry = 'US',
    								email = 'larry'+testMethodLabel+'@apextest.com'
    								);
    	
    	Contact[] contactList = new Contact[]{};
    	contactList.add(contact2);
    	

    	acwos.dbInsert(contact);
    	acwos.dbInsert(contactList);
    	acwos.dbUpdate(contact);
    	acwos.dbUpdate(contactList);
    	Contact[] contacts = acwos.dbQuery('Select id from Contact where lastname = \''+testMethodLabel+'\' Limit 50');
    	acwos.dbDelete(contact);
    	acwos.dbDelete(contactList);
    
    	System.assert(contacts <> null && contacts.size()>0, 'Expected list of inserted contacts to contain more than 0 contacts.');
    }		
		
}