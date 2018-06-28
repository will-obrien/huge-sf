public with sharing class MyHelloWorld {
    // This method updates the Description field for a list
	// of accounts to read "First Salesforce code in action".
	public static void addHelloWorld(Account[] accs){
		for (Account a:accs){
			if (a.Description != 'First Salesforce code in action')
			a.Description = 'First Salesforce code in action';
			}
		}
}