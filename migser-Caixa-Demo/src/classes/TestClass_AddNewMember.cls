@isTest
public class TestClass_AddNewMember {
    
    static testmethod void testMyCode() {
        
        Campaign__c newCampaign = new Campaign__c(Name = 'Test Campaign');
        insert newCampaign;
        
        //Campaign__c fetchCampaign = [	select	Idfrom	Campaign__c];
                                    	//limit	1	];
        
        Contact newContact = new Contact(//FirstName = 'New',
                                        LastName = 'Test Contact',
										Salutation = 'Mr',
                                        Title = 'Test Title'
                                        //Phone = '9999999999',
                                        //Email='vik@sfdc.org');
                                        );
        insert newContact;
        
        //Contact fetchContact = [	select Id from Contact	];
                               		//limit	1	];

        
        Campaign_Member__c conMember = new Campaign_Member__c(Campaigns__c = newCampaign.Id,
                                                              Contact__c = newContact.Id,
                                                              Member_Name__c = 'Test Member',
                                                              Status__c = 'Nominated',
                                                              Type__c = 'Contact'
                                                             );
        insert conMember;
        
        Lead newLead = new Lead(//FirstName = 'New',
                                LastName = 'Test Lead',
            					Company = 'Test Company',
            					Status = 'Pending',
                                Title = 'Test Title',
            					Salutation = 'Mr'
                                //Phone = '9999999999',
                                //Email='vik@sfdc.org');
        						);
        insert newLead;
        
        //Lead fetchLead = [	select Id from Lead ];
        
        Campaign_Member__c leaMember = new Campaign_Member__c(Campaigns__c = newCampaign.Id,
                                                              Lead__c = newLead.Id,
                                                              Member_Name__c = 'Test Member',
                                                              Status__c = 'Nominated',
                                                              Type__c = 'Lead'
                                                             );
        insert leaMember;
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newCampaign);
        
        Class_AddNewMember.ContactWrapper conWrapper = new Class_AddNewMember.ContactWrapper(newContact, true);
        //wrapperInstance.selected = True;
        
        Class_AddNewMember.LeadWrapper leaWrapper = new Class_AddNewMember.LeadWrapper(newLead, true);
        
        Class_AddNewMember leaInstance1 = new Class_AddNewMember(sc);
        leaInstance1.MemberType = 'Lead';
        leaInstance1.MemberStatus = 'Sent';
        leaInstance1.fieldVal1 = 'Salutation';
        leaInstance1.operatorVal1 = 'starts with';
        leaInstance1.value1 = 'm';
        leaInstance1.fieldVal2 = 'Title';
        leaInstance1.operatorVal2 = 'contains';
        leaInstance1.value2 = 'e';
        leaInstance1.showContactTable = True;
        leaInstance1.fetchFields();        
        leaInstance1.getLeads();
        leaInstance1.getSelected();
        leaInstance1.getSelectedLeads();
        leaInstance1.addNewMembers();
        leaInstance1.fetchMembers();
        
        Class_AddNewMember conInstance1 = new Class_AddNewMember(sc);
        conInstance1.MemberType = 'Contact';
        conInstance1.MemberStatus = 'Sent';
        conInstance1.fieldVal1 = 'Salutation';
        conInstance1.operatorVal1 = 'starts with';
        conInstance1.value1 = 'm';
        conInstance1.fieldVal2 = 'Title';
        conInstance1.operatorVal2 = 'contains';
        conInstance1.value2 = 'e';
        conInstance1.showContactTable = True;
        conInstance1.fetchFields();        
        conInstance1.getContacts();
        conInstance1.getSelected();
        conInstance1.getSelectedContacts();
        conInstance1.addNewMembers();
        conInstance1.fetchMembers();
      
        
        Class_AddNewMember leaInstance2 = new Class_AddNewMember(sc);
        leaInstance2.MemberType = 'Lead';
        leaInstance2.MemberStatus = 'Sent';
        leaInstance2.fieldVal1 = 'Title';
        leaInstance2.operatorVal1 = 'equals';
        leaInstance2.value1 = '';
        leaInstance2.fieldVal2 = 'Company';
        leaInstance2.operatorVal2 = 'not equal to';
        leaInstance2.value2 = '';
        leaInstance2.fetchFields();
        leaInstance2.getLeads();
        leaInstance2.getSelected();
        leaInstance2.getSelectedLeads();
        leaInstance2.addNewMembers();
        leaInstance2.fetchMembers();
        
        Class_AddNewMember conInstance2 = new Class_AddNewMember(sc);
        conInstance2.MemberType = 'Contact';
        conInstance2.MemberStatus = 'Sent';
        conInstance2.fieldVal1 = 'Title';
        conInstance2.operatorVal1 = 'equals';
        conInstance2.value1 = '';
        conInstance2.fieldVal2 = 'Department';
        conInstance2.operatorVal2 = 'not equal to';
        conInstance2.value2 = '';
        conInstance2.fetchFields();
        conInstance2.getContacts();
        conInstance2.getSelected();
        conInstance2.getSelectedContacts();
        conInstance2.addNewMembers();
        conInstance2.fetchMembers();
        
        Class_AddNewMember leaInstance3 = new Class_AddNewMember(sc);
        leaInstance3.MemberType = 'Lead';
        leaInstance3.MemberStatus = 'Sent';
        leaInstance3.fieldVal1 = 'Company';
        leaInstance3.operatorVal1 = 'not equal to';
        leaInstance3.value1 = '';
        leaInstance3.fieldVal2 = 'Title';
        leaInstance3.operatorVal2 = 'equals';
        leaInstance3.value2 = 'cfo';
        leaInstance3.fetchFields();
        leaInstance3.getLeads();
        leaInstance3.getSelected();
        leaInstance3.getSelectedLeads();
        leaInstance3.addNewMembers();
        leaInstance3.fetchMembers();
        
        Class_AddNewMember conInstance3 = new Class_AddNewMember(sc);
        conInstance3.MemberType = 'Contact';
        conInstance3.MemberStatus = 'Sent';
        conInstance3.fieldVal1 = 'Department';
        conInstance3.operatorVal1 = 'not equal to';
        conInstance3.value1 = '';
        conInstance3.fieldVal2 = 'Title';
        conInstance3.operatorVal2 = 'equals';
        conInstance3.value2 = 'cfo';
        conInstance3.fetchFields();
        conInstance3.getContacts();
        conInstance3.getSelected();
        conInstance3.getSelectedContacts();
        conInstance3.addNewMembers();
        conInstance3.fetchMembers();
        
        
        Class_AddNewMember leaInstance4 = new Class_AddNewMember(sc);
        leaInstance4.MemberType = 'Lead';
        leaInstance4.MemberStatus = 'Sent';
        leaInstance4.fieldVal1 = 'Title';
        leaInstance4.operatorVal1 = 'contains';
        leaInstance4.value1 = 'e';
        leaInstance4.fieldVal2 = 'Salutation';
        leaInstance4.operatorVal2 = 'starts with';
        leaInstance4.value2 = 'm';
        leaInstance4.fetchFields();
        leaInstance4.getLeads();
        leaInstance4.getSelected();
        leaInstance4.getSelectedLeads();
        leaInstance4.addNewMembers();
        leaInstance4.fetchMembers();
        
        Class_AddNewMember conInstance4 = new Class_AddNewMember(sc);
        conInstance4.MemberType = 'Contact';
        conInstance4.MemberStatus = 'Sent';
        conInstance4.fieldVal1 = 'Title';
        conInstance4.operatorVal1 = 'contains';
        conInstance4.value1 = 'e';
        conInstance4.fieldVal2 = 'Salutation';
        conInstance4.operatorVal2 = 'starts with';
        conInstance4.value2 = 'm';
        conInstance4.fetchFields();
        conInstance4.getContacts();
        conInstance4.getSelected();
        conInstance4.getSelectedContacts();
        conInstance4.addNewMembers();
        conInstance4.fetchMembers();
        
        
        Class_AddNewMember leaInstance5 = new Class_AddNewMember(sc);
        leaInstance5.MemberType = 'Lead';
        leaInstance5.MemberStatus = 'Sent';
        leaInstance5.fieldVal1 = '--None--';
        leaInstance5.operatorVal1 = '--None--';
        leaInstance5.value1 = '';
        leaInstance5.fieldVal2 = 'Title';
        leaInstance5.operatorVal2 = 'equals';
        leaInstance5.value2 = 'ceo';
        leaInstance5.fetchFields();
        leaInstance5.getLeads();
        leaInstance5.getSelected();
        leaInstance5.getSelectedLeads();
        leaInstance5.addNewMembers();
        leaInstance5.fetchMembers();
        
        Class_AddNewMember conInstance5 = new Class_AddNewMember(sc);
        conInstance5.MemberType = 'Contact';
        conInstance5.MemberStatus = 'Sent';
        conInstance5.fieldVal1 = '--None--';
        conInstance5.operatorVal1 = '--None--';
        conInstance5.value1 = '';
        conInstance5.fieldVal2 = 'Title';
        conInstance5.operatorVal2 = 'equals';
        conInstance5.value2 = 'ceo';
        conInstance5.fetchFields();
        conInstance5.getContacts();
        conInstance5.getSelected();
        conInstance5.getSelectedContacts();
        conInstance5.addNewMembers();
		conInstance5.fetchMembers();
        
    }
}