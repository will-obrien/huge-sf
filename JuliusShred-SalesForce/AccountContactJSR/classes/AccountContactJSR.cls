public class AccountContactJSR
{
    @RemoteAction
	public static Account getAccountData(String accountId)
	{
		return [SELECT Id, Name, (SELECT FirstName, LastName, Phone FROM Contacts)
                FROM Account
                WHERE Id =: accountId][0];
	}
}