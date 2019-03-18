public class AppConfigSupport {
	
	private static AppConfig__c testconfig = null;
	
	public static AppConfig__c GetAppConfig()
	{
		if(Test.isRunningTest() && testconfig!=null) return testconfig;
		
		AppConfig__c theobject = AppConfig__c.getInstance('default');
		if(theobject==null || Test.isRunningTest()) 
		{
			theobject = new AppConfig__c();
			theobject.name = 'default';
			theobject.EnableDiagnostics__c = (Test.isRunningTest())? true: false;
			if(!Test.isRunningTest()) Database.Insert(theobject);
			else testconfig = theobject;
		}
		return theobject;
	}
	
	public static Boolean DiagnosticsEnabled
	{ 
		get
		{
			return GetAppConfig().EnableDiagnostics__c;
		}
	}
	
}