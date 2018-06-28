/**
* This class is for JS Remoting to AccountInfoJSR Page
*/

public with sharing class AccountInfoJSR
{
    @RemoteAction
    public static Account getAccountData(String accountId)
    {
        return [SELECT Id, Name, Phone, (SELECT Id, FirstName, LastName, Phone FROM Contacts) 
                FROM Account WHERE Id =: accountId][0];
    }
}