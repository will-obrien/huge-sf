@isTest
private class AccountProcessorTest{
    
    @isTest private static void testAccountProcessor(){
       Account acct = new Account();
       acct.Name = 'B&G Landscape';
       insert acct;
       
       Contact cont = new Contact();
       cont.FirstName = 'Prakash';
       cont.LastName  = 'Rai';
       cont.AccountId = acct.Id;
       insert cont;
       
       List<Id> idToUpdate = new List<Id>();
       idToUpdate.add(acct.id);
       
       Test.startTest();
           AccountProcessor.countContacts(idToUpdate);
       Test.stopTest();
       
       Account acct1 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id=:acct.id LIMIT 1];
       System.assertEquals(Integer.valueOf(acct1.Number_of_Contacts__c),0, 'Expected one row');
    
    }
    
}