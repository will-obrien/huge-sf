// Note - this sample code uses variable Level2__c instead of Level__c to avoid
// conflict when installing an unmanaged package
public class PersonAccountSupport {

	@TestVisible public static Boolean FakePersonAccountDuringTest = false;

	private static Set<string> AccountFields = null;

    public static Boolean IsPersonAccountOrg()
    {
    	if(AccountFields==null) AccountFields = Schema.Sobjecttype.Account.fields.getMap().keyset();
    	return AccountFields.contains('personcontactid');
    }
    
    // Map from contact field to account field
    public static String getPersonAccountAlias(String fieldname)
	{
		fieldname = fieldname.ToLowerCase();	// Case insensitive
		
		// Unchanged - FirstName, LastName, etc.
		if(AccountFields.contains(fieldname)) return fieldname;

		// Replace aliased __c with __pc
		fieldname = fieldname.replace('__c', '__pc');
		if(AccountFields.contains(fieldname)) return fieldname;

		if(AccountFields.contains('person' + fieldname)) return ('person' + fieldname);

		return null;
	}
	
	public static void processContactTrigger1(Boolean isBefore, List<Contact> newlist, Map<ID, Contact> oldmap)
	{
		for(Contact ct: newlist)
		{
			if(ct.LeadSource=='Web' || ct.LeadSource=='Phone Inquiry') 
				ct.Level2__c = 'Primary'; 
				else ct.Level2__c = 'Secondary';
		}
	}
	
	public static List<ID> FakePersonContactIDs = null;
	
	private static Boolean UpdatingPersonContact = false;

	public static void processAccountTrigger1(Boolean isBefore, List<Account> newlist, Map<ID, Account> oldmap)
	{
		if(!IsPersonAccountOrg() && !FakePersonAccountDuringTest || UpdatingPersonContact) return;

		if(isBefore)
		{
			// Using before approach
			String leadsourcealias = getPersonAccountAlias('LeadSource');
			String levelalias = getPersonAccountAlias('Level2__c');
			for(Account act: newlist)
			{
				if(leadsourcealias!=null && levelalias!=null && (!FakePersonAccountDuringTest && act.get('PersonContactID')!=null))
				{	// Will only be valid on person accounts
					if(act.get(leadsourcealias)=='Web' || act.get(leadsourcealias)=='Phone Inquiry')
						act.put(levelalias,'Primary'); else act.put(levelalias,'Secondary');
				}
			}
		}
		else
		{	// Better approach can work on after trigger
			Set<ID> personcontactids = new Set<ID>();
			for(Integer x = 0; x<newlist.size(); x++)
			{
				if(FakePersonAccountDuringTest || newlist[x].get('PersonContactID')!=null ) 
					personcontactids.add( (FakePersonAccountDuringTest)? FakePersonContactIDs[x]: (ID)newlist[x].get('PersonContactID') );
			}
			if(personcontactids.size()==0) return;
			Map<ID, Contact> personcontacts = new Map<ID, Contact>([Select ID, LeadSource, Level2__c from Contact where ID in :personcontactids]);
			ProcessContactTrigger1(true, personcontacts.values(), personcontacts);
			UpdatingPersonContact = true;
			update personcontacts.values();
			UpdatingPersonContact = false;
		}
		
		
	}
	


}