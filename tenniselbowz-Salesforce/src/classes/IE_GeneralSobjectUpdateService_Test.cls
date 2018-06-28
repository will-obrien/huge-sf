/**
 * 
 */
@isTest
private class IE_GeneralSobjectUpdateService_Test {
	//@isTest(seeAllData=true)
    static testmethod void runTest() {
    	
    	Account a = new Account(Name='x');
    	insert a;
        // hit this service with some considerable volume
        list<Contact> contacts = new list<Contact>();
        for(Integer i = 0; i < 100; i++)
        {
        	contacts.add(new Contact(FirstName='yoda'+i
        							,LastName='masta'+i
        							,Email='yodamasta'+i+'@daikin.com'
        							,AccountId = a.Id));
        }
        
        insert contacts;
        
        List<IE_Integration_Field_Set__c> fieldList = new List<IE_Integration_Field_Set__c>{new IE_Integration_Field_Set__c(Name='Account', Field_List__c=('Record_Usage__c'))
																						   ,new IE_Integration_Field_Set__c(Name='Contact', Field_List__c=('IE_Contact__c,FirstName,LastName'))
																						   ,new IE_Integration_Field_Set__c(Name='Address__c', Field_List__c=('Record_Usage__c'))};
		
	  	insert fieldList;
        
		list<IE_GeneralSobjectUpdateService.Record> records = new list<IE_GeneralSobjectUpdateService.Record>();
        for(Contact c : contacts)
        {
        	IE_GeneralSobjectUpdateService.Record rec = new IE_GeneralSobjectUpdateService.Record();
    		rec.SFDCId=c.Id;
	    	IE_GeneralSobjectUpdateService.Field field = new IE_GeneralSobjectUpdateService.Field();
	    	field.name = 'FirstName';
	    	field.value = c.FirstName;
	    	
	    	
	    	IE_GeneralSobjectUpdateService.Field field2 = new IE_GeneralSobjectUpdateService.Field();
	    	field2.name = 'LastName';
	    	field2.value = c.LastName;
	    	
	    	IE_GeneralSobjectUpdateService.Field field3 = new IE_GeneralSobjectUpdateService.Field();
	    	field3.name = 'IE_Contact__c';
	    	field3.value = 'true';
	    	
	    	
	    	rec.fields = new list<IE_GeneralSobjectUpdateService.Field>{field,field2,field3};
	    	
	    	records.add(rec);
    	
        }
        
        Test.startTest();
        //run the test with volume
        IE_GeneralSobjectUpdateService.doPut(records);
        Test.stopTest();
    }
}