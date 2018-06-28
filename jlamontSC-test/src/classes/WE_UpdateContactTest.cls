//
// (c) 2014 Appirio, Inc.
//
//  Test Class for AddUPRedirect 
//  3 July 2014    Parul Gupta     Original
//
@isTest
private class WE_UpdateContactTest {

    static testMethod void testWE_UpdateContact() {
    	
        //Create new contacts
        Contact testContact;
        List<Contact> contacts = new List<Contact>();
        for(Integer index = 0; index < 20; index++){
        	testContact = new Contact(LastName='Sierra' + index);
        	contacts.add(testContact);
        }
        insert contacts;
        
        //Create new results
        List<WE_FW8_NP__WESearchResult__c> lstResult = new List<WE_FW8_NP__WESearchResult__c>();
        WE_FW8_NP__WESearchResult__c testResult;
        
        for(Integer index = 0; index < 20; index++){
        	testResult = new WE_FW8_NP__WESearchResult__c();
        	testResult.WE_FW8_NP__Contact__c = contacts[index].id;        	
        	lstResult.add(testResult);
        }
        lstResult[0].WE_FW8_NP__Estimated_Gift_Capacity__c = '1';
        lstResult[1].WE_FW8_NP__Estimated_Gift_Capacity__c = '1000';
        lstResult[2].WE_FW8_NP__Estimated_Gift_Capacity__c = '2000';
        lstResult[3].WE_FW8_NP__Estimated_Gift_Capacity__c = '3000';
        lstResult[4].WE_FW8_NP__Estimated_Gift_Capacity__c = '5000';
        lstResult[5].WE_FW8_NP__Estimated_Gift_Capacity__c = '7500';
        lstResult[6].WE_FW8_NP__Estimated_Gift_Capacity__c = '10000';
        lstResult[7].WE_FW8_NP__Estimated_Gift_Capacity__c = '15000';
        lstResult[8].WE_FW8_NP__Estimated_Gift_Capacity__c = '20000';
        lstResult[9].WE_FW8_NP__Estimated_Gift_Capacity__c = '25000';
        lstResult[10].WE_FW8_NP__Estimated_Gift_Capacity__c = '30000';
        lstResult[11].WE_FW8_NP__Estimated_Gift_Capacity__c = '40000';
        lstResult[12].WE_FW8_NP__Estimated_Gift_Capacity__c = '50000';
        lstResult[13].WE_FW8_NP__Estimated_Gift_Capacity__c = '75000';
        lstResult[14].WE_FW8_NP__Estimated_Gift_Capacity__c = '100000';
        lstResult[15].WE_FW8_NP__Estimated_Gift_Capacity__c = '200000';
        lstResult[16].WE_FW8_NP__Estimated_Gift_Capacity__c = '500000';
        lstResult[17].WE_FW8_NP__Estimated_Gift_Capacity__c = '1000000';
        lstResult[18].WE_FW8_NP__Estimated_Gift_Capacity__c = '5000000';
             
        insert lstResult;
        
        //Once the data has been inserted, get the contact record back and check that the trigger
        //behaves as expected
        contacts = [select WE_Estimated_Giving_Capacity__c from Contact where Id=:contacts[0].Id];
        System.assert(contacts[0].WE_Estimated_Giving_Capacity__c != null);
    }
}