/**
 
	This Class tests the bwDevUtility
	
	@Author : Michael Hendy
 */
@isTest
private class TestBwDevUtils {

    static testMethod void testStringToCurrency()
	{
		Double testDouble = 23344224.3;
		Decimal testDecimal = 2334433443.3399999;
		Decimal testDecimal2 = 40.0;		
		Integer testInteger = 400000;
		Long testLong = 55444555;
				
		try{
			BluewolfDevUtils.stringToCurrency('Blah Blah Blah', '$');
		}	
		catch(BluewolfDevUtils.reusableException re)
		{
			System.assert(re.getmessage().contains('Invalid String'));
		}
		
		System.assertEquals(BluewolfDevUtils.stringToCurrency(testDouble.format(), '$'), '$23,344,224.30');
		System.assertEquals(BluewolfDevUtils.stringToCurrency(testDecimal.format(), '$'), '$2,334,433,443.34');
		System.assertEquals(BluewolfDevUtils.stringToCurrency(testDecimal2.format(), '$'), '$40.00');
		System.assertEquals(BluewolfDevUtils.stringToCurrency(testInteger.format(), '$'), '$400,000.00');
		System.assertEquals(BluewolfDevUtils.stringToCurrency(testLong.format(), '$'), '$55,444,555.00');
			 
	}

	static testMethod void testBulkFlattening()
	{
		//Account test = [Select Id, Name from Account limit 1];
		List<Account>allAccts = new List<Account>();
		
		for (Integer i = 0; i < 3; i++)
		{
			allAccts.add(new Account(Name = 'Test BWDevUtils '+ i));
		}
		
		List<String> largeList = new List <String>();
		
		for(Integer I = 0; I < 3; I++)
		{
			largeList.add(allAccts[i].Name);	
		}
		
		BluewolfDevUtils test1 = new BluewolfDevUtils();
		
		String query = 'Select Id, Name from Account where Name in ' + BluewolfDevUtils.flattenListForQuery(largeList);
		
		String testAssertion = 'Select Id, Name from Account where Name in (\'Test BWDevUtils 0\',\'Test BWDevUtils 1\',\'Test BWDevUtils 2\') ';
		
		System.assertEquals(testAssertion, query);
		
		
		//Test passing an empty List
		List<String> testEmpty = new List<String>();
		
		try{
			BluewolfDevUtils.flattenListForQuery(testEmpty);
		}
		catch(BluewolfDevUtils.reusableException re){
				System.assert(re.getmessage().contains('Empty List Passed To BlueWolfDevUtils List Flattener'));
		}
			
	}
	
	static testMethod void testFlattening()
	{		
		List<String> allAcctsNames = new List<String>();
		List<Integer> allAcctsEmployeesCount = new List<Integer>();
		List<Date> allAcctsCreatedDates = new List<Date>();
		
		for (Integer i = 0; i < 3; i++)
		{			
			allAcctsNames.add('Test BWDevUtils '+ i);
			allAcctsEmployeesCount.add(i);
			allAcctsCreatedDates.add(Date.Today().addDays(i));
		}
		
		BluewolfDevUtils test1 = new BluewolfDevUtils();
				
		//Dates cast as objects will have the 00:00:00 appended
		//when converted to strings
		
		String namesExpected = '(\'Test BWDevUtils 0\',\'Test BWDevUtils 1\',\'Test BWDevUtils 2\') ';
		String employeeCountExpected = '(\'0\',\'1\',\'2\') ';
		String datesExpected = '(\''+ String.valueOf((Object)Date.Today().addDays(0))+ '\',\''+ String.valueOf((Object)Date.Today().addDays(1))+ '\',\''+ String.valueOf((Object)Date.Today().addDays(2))+ '\') ';
		
		System.assertEquals(namesExpected, BluewolfDevUtils.flattenListForQuery(allAcctsNames));
		System.assertEquals(employeeCountExpected, BluewolfDevUtils.flattenListForQuery(allAcctsEmployeesCount));
		System.assertEquals(datesExpected, BluewolfDevUtils.flattenListForQuery(allAcctsCreatedDates));
			
		List<String>names = new List<String>{'Test1', 'Test2', 'Test3'};
		
		String expected = '(\'Test1\',\'Test2\',\'Test3\') ';
		
		System.assertEquals(expected, BluewolfDevUtils.flattenListForQuery(names));		
	}
	
	
	
	
	//Test the pagename detection
	static testmethod void testPageNameDetection()
	{
				
		Test.startTest();
        String pageName = BluewolfDevUtils.getPageName('https://mySalesforceInstance/apex/HelloWorld');
        String pageNameWithParams = BluewolfDevUtils.getPageName('https://mySalesforceInstance/apex/HelloWorldParams?temp1=1&temp2=2');
        String invalidPageName = BluewolfDevUtils.getPageName('https://mySalesforceInstance/HelloWorldParams?temp1=1&temp2=2');
        String nullPageName = BluewolfDevUtils.getPageName(null);
        Test.StopTest();
        
        System.assertEquals('HelloWorld', pageName);
        System.assertEquals('HelloWorldParams', pageNameWithParams);
        System.assertEquals('', invalidPageName);
        System.assertEquals('', nullPageName);
	}

	static testMethod void testAddToPageParams_NotNull()
	{
		Case c = new Case(Subject='foo');
		PageReference ref = new PageReference('www.google.com');
		BluewolfDevUtils.addToPageParameters(ref, c, 'q', 'Subject');
		
		Map<String, String> refParams = ref.getParameters();
		System.assert(refParams.containsKey('q'));
		System.assertEquals('foo', refParams.get('q'));
	}
	
	static testMethod void testAddToPageParams_Null()
	{
		Case c = new Case(Subject='foo');
		PageReference ref = new PageReference('www.google.com');
		BluewolfDevUtils.addToPageParameters(ref, c, 'q', 'CaseNumber');
		
		Map<String, String> refParams = ref.getParameters();
		System.assert(refParams.isEmpty());		
	}


	
	
}