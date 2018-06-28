public with sharing class caseUpdateHandler 
{
    public static void updateCase(list<Case> caseList)
    {
        
        list<Account> Accts=[Select a.Id,
                                    a.PersonEmail__c,
                                    a.Email_Address__c, 
                                    (Select Id 
                                    From Contacts) 
                             From Account a 
                             where a.Id IN (Select AccountId 
                                            From Contact)
                             ];
        System.debug(Accts);
        list<Case> addCases = new list<Case>();
        for(Case newCase: caseList)
        {
            for(Account Acct : Accts)
            {
                if(newCase.Origin == 'Chat' || newCase.Origin == 'Email' ||newCase.Origin == 'Web')
                {
                    if(newCase.Supplied_Mail__c == Acct.PersonEmail__c || newCase.Supplied_Mail__c == Acct.Email_Address__c)
                    {
                        System.debug(newCase.Supplied_Mail__c + ' And the Id is ' + Acct.Id);
                        newCase.AccountId=Acct.Id;
                        for(Contact con1: Acct.Contacts)
                            newCase.ContactId=con1.Id;
                    }
                }
            }
        }
    }
}