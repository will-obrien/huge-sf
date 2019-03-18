@istest
public class TestGoingAsync2 {
	
	@istest
	public static void TestAddressVerification()
	{
		Test.StartTest();
		InitLeads();
		Test.StopTest();
	}


	public static List<Lead> InitLeads()
	{
		List<Lead> NewLeads = new List<Lead>();
		for(Integer x = 0; x<10; x++)
		{
			NewLeads.add(new Lead(Company = 'comp' + string.ValueOf(x), LastName = 'joe'+string.ValueOf(x)));
		}
		insert NewLeads;
		return NewLeads;
	}

}