@isTest
public class TestClass_AddMember {
    
    static testmethod void testMyCode() {
        
        Campaign__c newCampaign = new Campaign__c(Name = 'Test Campaign');
        insert newCampaign;
        
        Campaign__c fetchCampaign = [	select	Id
                                    	from	Campaign__c];
                                    	//limit	1	];
        
        Contact newContact = new Contact(	//FirstName = 'New',
                                         	LastName = 'Test Contact'
                                        	//Title = 'Test Title',
                                        	//Phone = '9999999999',
                                        	//Email='vik@sfdc.org');
                                        	);
        insert newContact;
        
        Contact fetchContact = [	select	Id
                               		from	Contact];
                               		//limit	1	];

        Campaign_Member__c newCampaignMember = new Campaign_Member__c(	Campaigns__c = newCampaign.Id,
                                                                      	Contact__c = fetchContact.Id,
                                                                     	Status__c = 'Nominated'	);
        insert newCampaignMember;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(fetchCampaign);
        
        Class_AddMember.ContactWrapper wrapperInstance = new Class_AddMember.ContactWrapper(fetchContact, true);
        //wrapperInstance.selected = True;
        
        
        Class_AddMember testInstance1 = new Class_AddMember(sc);
        testInstance1.fieldVal1 = 'Salutation';
        testInstance1.operatorVal1 = 'starts with';
        testInstance1.value1 = 'm';
        testInstance1.fieldVal2 = 'Title';
        testInstance1.operatorVal2 = 'contains';
        testInstance1.value2 = 'e';
        testInstance1.getFields();
        testInstance1.getOperators();
        testInstance1.getContacts();
        testInstance1.getSelected();
        testInstance1.GetSelectedContacts();
        testInstance1.addNewMembers();
        testInstance1.fetchContacts();
        
        Class_AddMember testInstance2 = new Class_AddMember(sc);
        testInstance2.fieldVal1 = 'Title';
        testInstance2.operatorVal1 = 'equals';
        testInstance2.value1 = '';
        testInstance2.fieldVal2 = 'Department';
        testInstance2.operatorVal2 = 'not equal to';
        testInstance2.value2 = '';
        testInstance2.getFields();
        testInstance2.getOperators();
        testInstance2.getContacts();
        testInstance2.getSelected();
        testInstance2.GetSelectedContacts();
        testInstance2.addNewMembers();
        testInstance2.fetchContacts();
        
        Class_AddMember testInstance3 = new Class_AddMember(sc);
        testInstance3.fieldVal1 = 'Department';
        testInstance3.operatorVal1 = 'not equal to';
        testInstance3.value1 = '';
        testInstance3.fieldVal2 = 'Title';
        testInstance3.operatorVal2 = 'equals';
        testInstance3.value2 = 'cfo';
        testInstance3.getFields();
        testInstance3.getOperators();
        testInstance3.getContacts();
        testInstance3.getSelected();
        testInstance3.GetSelectedContacts();
        testInstance3.addNewMembers();
        testInstance3.fetchContacts();
        
        Class_AddMember testInstance4 = new Class_AddMember(sc);
        testInstance4.fieldVal1 = 'Title';
        testInstance4.operatorVal1 = 'contains';
        testInstance4.value1 = 'e';
        testInstance4.fieldVal2 = 'Salutation';
        testInstance4.operatorVal2 = 'starts with';
        testInstance4.value2 = 'm';
        testInstance4.getFields();
        testInstance4.getOperators();
        testInstance4.getContacts();
        testInstance4.getSelected();
        testInstance4.GetSelectedContacts();
        testInstance4.addNewMembers();
        testInstance4.fetchContacts();
        
        Class_AddMember testInstance5 = new Class_AddMember(sc);
        testInstance5.fieldVal1 = '--None--';
        testInstance5.operatorVal1 = '--None--';
        testInstance5.value1 = '';
        testInstance5.fieldVal2 = 'Title';
        testInstance5.operatorVal2 = 'equals';
        testInstance5.value2 = 'ceo';
        testInstance5.getFields();
        testInstance5.getOperators();
        testInstance5.getContacts();
        testInstance5.getSelected();
        testInstance5.GetSelectedContacts();
        testInstance5.addNewMembers();
        testInstance5.fetchContacts();
        
      
        
       

    }
}