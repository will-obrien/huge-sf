@isTest (seealldata=true)
private class TestForManaged {

    static testMethod void RecordTypeTest() {
    	// This will fail to work on any org that doesn't have record types defined on leads
    	// List<Lead> rtypes = [Select ID, RecordTypeID from Lead Limit 1];

		Boolean LeadHasRecordType = Schema.Sobjecttype.Lead.Fields.getMap().containskey('recordtypeid');
		
		String fieldstring = 'ID ';
		if(LeadHasRecordType) fieldstring += ', RecordTypeID ';
		List<Lead> rtypes = Database.Query('Select ' + fieldstring + ' from Lead Limit 1');
		if(rtypes.size()>0 && LeadHasRecordType)
		{
			system.debug(rtypes[0].get('RecordTypeID'));
		}    	
    	system.debug(fieldstring + ' ' + rtypes);
    }
    
    static testMethod void AddProduct()
    {
    	// Adding this line adds a Product2 dependency to the package
    	//List<Product2> aproduct = [Select ID from Product2 Limit 1];
    }
    
	static testmethod void TestPersonAccount()
	{
		PersonAccountSupport.IsPersonAccountOrg();
		PersonAccountSupport.getPersonAccountAlias('email');	// For code coverage
	}
	
	static testmethod void TestCorporateCurrency()
	{
		String corporate = CorporateCurrency;
	}
	
	private static Map<String,double> CachedCurrencyConversionMap = null;
	
	private static string m_CorporateCurrency = null;
	
	public static string CorporateCurrency {
		get {
			GetCurrencyConversionMap();
			return CorporateCurrency;
		}
	}
	
	public static Map<String, double> GetCurrencyConversionMap()
	{
		Boolean CurrencyTestMode = false;

		if(CachedCurrencyConversionMap!=null) return CachedCurrencyConversionMap;

		if(Test.isRunningTest() && !userinfo.isMultiCurrencyOrganization()) CurrencyTestMode = true;
		if(!userinfo.isMultiCurrencyOrganization() && !CurrencyTestMode) return null;

		List <SObject> ctypes = null;
		if(!CurrencyTestMode) ctypes  = database.query('Select conversionrate, isocode, iscorporate from currencytype');

		Map<String, double> isomap = new Map<String, double>();
		if(!CurrencyTestMode)
		{
			for(SObject ct: ctypes)
			{
				string ctcode = string.ValueOf(ct.get('isocode'));
				if(Boolean.valueof(ct.get('iscorporate'))) 
				{
					m_CorporateCurrency = ctcode;
				}
				double conversionrate = double.valueOf(ct.get('conversionrate'));
				if(conversionrate!=0) isomap.put(ctcode, 1/conversionrate);
			}
		}
		CachedCurrencyConversionMap = (CurrencyTestMode)? null: isomap;
		return CachedCurrencyConversionMap;	
	}	
    
}