public class ThinkingInApex {

/*	First example
	private static Boolean IsUserSpecialChecked = false;
	private static Boolean UserIsSpecial = false;
	
	public static Boolean IsUserSpecial()
	{
		if(IsUserSpecialChecked) return UserIsSpecial;
		
		User u = [Select UserIsSpecial__c from User where ID = :UserInfo.getUserId()];
    	UserIsSpecial = u.UserIsSpecial__c;
    	IsUserSpecialChecked = true;
    	return UserIsSpecial;
		
	}
*/

	private static Boolean UserCacheLoaded = false;
	private static Boolean UserIsSpecial = false;
	private static String UserTimeZone = null;	

	public static Boolean IsUserSpecial()
	{
		if(UserCacheLoaded) return UserIsSpecial;
		CacheUserInfo();
		return UserIsSpecial;	
	}

	public static String UserTimeZone()
	{
		if(UserCacheLoaded) return UserTimeZone;
		CacheUserInfo();
		return UserTimeZone;	
	}

	
	private static void CacheUserInfo()
	{
		if(UserCacheLoaded) return;
		User u = [Select UserIsSpecial__c, TimeZoneSidKey from User where ID = :UserInfo.getUserId()];
    	UserIsSpecial = u.UserIsSpecial__c;
    	UserTimeZone = u.TimeZoneSidKey;
		UserCacheLoaded = true;
	}
	
	
	public static List<Contact> AssociateContacts = null;
	
	public static void AfterInsertOpportunity(List<Opportunity> newlist, Map<ID, Opportunity> newmap)
	{

/* Uncomment this code to test example code in "Thinking In Apex - Static Variables"

		if(AssociateContacts!=null) CreateSomeContactRoles(newlist, AssociateContacts);
		
		List<OpportunityContactRole> ocrs = [SELECT ID, ContactID, IsPrimary, OpportunityID from OpportunityContactRole where OpportunityID in :newmap.keyset()];

		Set<ID> OcrOpportunities = new Set<ID>();

		for(OpportunityContactRole ocr: ocrs) OcrOpportunities.add(ocr.OpportunityID);
		
		for(Opportunity op: newlist)
		{
			if(! OcrOpportunities.contains(op.id)) op.addError('Opportunity Contact Role is required to create an opportunity');
		}
		
		// Other functionality
*/		
	}

/*	
	private static void CreateSomeContactRoles(List<Opportunity> ops, List<Contact> cts)
	{
		List<OpportunityContactRole> newocrs = new List<OpportunityContactRole>();
		
		for(Integer x = 0; x< ops.size(); x++)
		{
			newocrs.add(new OpportunityContactRole(OpportunityID = ops[x].id, ContactID = cts[x].id, IsPrimary = true));
		}

		insert newocrs;		
		
	}
*/

}