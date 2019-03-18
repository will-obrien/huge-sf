public class UpdateContactAccount
{
	//Why we're checking everything in constructor and not inside getter?
	//Well, we can check everything inside getter like in the commented code below 
	//It will work on the page side but we wont be able to test it
	public Account updateContactAccount
    {
        get
        {
            /*try
            {
                ID accountId = ApexPages.currentPage().getParameters().get('Id');
                if(!String.isBlank(accountId))
                {
                    List<Account> newContactList = [SELECT Id, Name, (SELECT FirstName, LastName, Phone FROM Contacts)
                                                    FROM Account
                                                    WHERE Id = :accountId];
                    if(!newContactList.isEmpty())
                    {
                        updateContactAccount = newContactList[0];
                    }
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'There is no Account with Id: ' + accountId));
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'Account Id was not given.'));
                }
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'Invalid Id.'));
            }*/
            return updateContactAccount; 
        }
        set
        {
            updateContactAccount = value;
        }
    }

	public updateContactAccount()
	{
		//Why we are using String not Id type?
		//We are using String type because ID type allows to assing only valid ID values (ID should be 18 or 15 long and include a-z A-Z 0-9 symbols)
		//If we'll try to assign another value there'll be a mistake
        //~~~~~
		//Can we change it from String to Id, and what we should do in that case?
		//Yes, we can.
		//To use ID type we need to include the initialisation of id varaibl into try{} block to catch the possible error like i did below
        try
        {
            ID accountId = ApexPages.currentPage().getParameters().get('Id');
            if(!String.isBlank(accountId))
            {
                List<Account> newContactList = [SELECT Id, Name, (SELECT FirstName, LastName, Phone FROM Contacts)
                								FROM Account
                                                WHERE Id = :accountId];
                if(!newContactList.isEmpty())
                {
                    updateContactAccount = newContactList[0];
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'There is no Account with Id: ' + accountId));
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'Account Id was not given.'));
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'Invalid Id.'));
        }
		
	}
	//Why we have two different ways of redirection inside saveRecord method and revertChanges method?
	//Because using the first way of redirection is the same thing that setRedirect(false) 
	//what meens that the view state is saving onserver-side so we still see the entered information after clicking "Cancel"
	//setting value to true makes redirect working through a client side
	public pageReference saveRecord()
	{
			update updateContactAccount;
			return ApexPages.currentPage();
	}

	public pageReference revertChanges()
	{
			PageReference pageURL = ApexPages.currentPage();
			pageURL.setRedirect(true);
			return pageURL;
	}
}