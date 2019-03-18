global class QuickAccountContact 
{                 
	public static String globalCaseID = '';
	public static String globalFirstName = '';
	public static String globalLastName = '';
	public static String globalWebEmail = '';
	public static String globalWebPhone = '';
	public static String globalWebCompany = '';
	
	public static String updateCase(String contactID, String accountID)
	{
		Case cs = new Case(Id = globalCaseID);
		cs.ContactId = contactID;
		cs.AccountId = accountID;
		update cs;
		return 'Account and Contact created, case successfully updated';
	}
	
	public static String updateCase(String accountID)
	{
		Case cs = new Case(Id = globalCaseID);
		cs.AccountId = accountID;
		update cs;
		return 'Account created, case successfully updated';
	}
	
	public static String createContact(String accountID)
	{
		//verify this contact is not already attached to the account with first name, last name, and email
		if(globalLastName != '')
		{
			Contact[] c1 =[select Id, Name FROM Contact WHERE AccountId =:accountID AND FirstName =:globalFirstName AND LastName=:globalLastName AND Email=:globalWebEmail];
			if(c1.size() > 0)
			{
				//don't create a new contact, just update the case
				return updateCase(c1[0].Id, accountID);
				//return 'updated case';
				
			}
			else{
				//create a new contact
				Contact c = new Contact(AccountId = accountID, FirstName = globalFirstName, LastName = globalLastName, Email = globalWebEmail, Phone = globalWebPhone);
				insert c;
				return updateCase(c.Id, accountID);
				//return 'created contact and updated case';
			}
		}
		else
		{
			return updateCase(accountID);
		}
	}
	
  webService static String createContactAndAccount(String caseID, String webName, String webCompany, String webEmail, String webPhone) 
  {
    	globalCaseID = caseID;
		globalWebEmail = webEmail;
		globalWebPhone = webPhone;
		globalWebCompany = webCompany;

  if(webName != '')
    {
    	String[] SplitName = webName.split(' ', -2);

    		if(SplitName.size() > 0)
			{	
				if(SplitName.size() == 1)
				{
					globalLastName = SplitName[0];
				}
				else if(SplitName.size() > 2)
				{
					globalFirstName = SplitName[0];
					Integer num = 0;
					for (num = 1; num < SplitName.size(); num++)
					{
						globalLastName = globalLastName + ' ' +SplitName[num];
					}
				}
				else
				{
					//it equals 2
					globalFirstName = SplitName[0];
					globalLastName = SplitName[1];
				}
			}//end of If String is > 0
			
    else //string is < 0
    {
    	//return 'there is no first or last name found';
    	
    }
}//end of If webName != null
	if(webCompany != '')
	{
		//create account if not already in there
		Account[] a1 =[select Id, Name FROM Account WHERE Name = :webCompany];
		if(a1.size() > 0)
		{
			//return 'matching account found';
			return createContact(a1[0].Id);
		}
		else
		{
			//create Account
			Account a = new Account(Name = globalWebCompany);
			insert a;
			return createContact(a.Id);
		}
	} 
	else{return 'web company is blank, cannot create an account/contact';}
}
//end of method
 static testMethod void createContactAndAccount() {
    Case c = new Case();
    c.Status = 'new';
    c.Origin = 'Phone';
    insert c;
    createContactAndAccount(c.Id, 'Test', 'TestCompany', 'test@email.com', '000-000-0000');
   
   Case c1 = new Case();
    c1.Status = 'new';
    c1.Origin = 'Phone';
    insert c1;
    createContactAndAccount(c1.Id, 'Test R Name', 'TestCompany', 'test@email.com', '000-000-0000');
    
    Case c2 = new Case();
    c2.Status = 'new';
    c2.Origin = 'Phone';
    insert c2;
    createContactAndAccount(c2.Id, 'Test', 'TestCompany', 'test@email.com', '000-000-0000');
   
    Case c3 = new Case();
    c3.Status = 'new';
    c3.Origin = 'Phone';
    insert c3;
    createContactAndAccount(c3.Id, 'Test Name','', 'test@email.com', '000-000-0000');
    
    Case c4 = new Case();
    c4.Status = 'new';
    c4.Origin = 'Phone';
    insert c4;
    createContactAndAccount(c4.Id,' ', 'Test Company2', 'test@email.com', '000-000-0000');
    
  }

}
//end of class