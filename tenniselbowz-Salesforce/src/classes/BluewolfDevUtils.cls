public class BluewolfDevUtils {
public List<SObject> abstractSortingList {get; set;}
private static Pattern myPattern;	
private static Matcher myMatcher;
	
	static{		
		myPattern = pattern.compile('.*\\/apex\\/([^\\?]*).*');
	}
	
	public BluewolfDevUtils()
	{
		
	}
	
	//Custom Exception Class (control what error message gets displayed)
	public class reusableException extends Exception {}
	
	//Generic Wrapper List Sort
	/*
		Accepts a list of WrapperClass (that must implement the sortableInterface),
		A string that indicates the wrapper field to sortby
		And String that determines the order the list should be sorted in
		'ASC' --> sort ascending
		'DESC' --> sort Descending 	
	*/
	
	

	//SObject List Sort
	/*
		Accepts a list of StandardObjects,
		The field by which to sort,
		And String that determines the order the list should be sorted in
		'ASC' --> sort ascending
		'DESC' --> sort Descending 	
	*/
	public List<SObject> standardSortBy (List<SObject> incoming, String fieldName, String orderBy )
	{
				             
	        this.abstractSortingList = incoming.clone();
	        
	        this.abstractSortingList.clear();
	        
	        List<Object> sortedKeys = new List <Object>();
	           
	        
	       Map<Object, List<SObject>> bucketHolder = new Map<Object, List<SObject>>();
	       Integer index = 0;
	        
	       while(index < incoming.size())
	        {
	        	SObject objectAtIndex = incoming[index];
	        	
	        	Object currIndex = BluewolfDevUtils.getFieldValue(objectAtIndex, fieldName);
	        	
	        	if(bucketHolder.get(currIndex) == null)
	        	{
	        		List<SObject> newGenericList = this.abstractSortingList.clone();
	        		newGenericList.clear();
	        		bucketHolder.put(currIndex, newGenericList);
	        		sortedKeys.add(currIndex);
	        	}
	        	
	        	bucketHolder.get(currIndex).add(objectAtIndex);
	 	    
	 	    	index++;
	        }
	    
	        sortedKeys.sort();
	        
	        
	         if(orderBy.toLowerCase() == 'desc')
	        {
		        //Descending sort
	        	for (Integer I = sortedKeys.size()-1; I >=0; I--)
	        	{
	        		for(SObject sortObject : bucketHolder.get(sortedKeys[I]))
	        		this.abstractSortingList.add(sortObject);
	        	}
	        }
	        else
	        {
		        //Ascending Sort
		        for(Object sortedIndex : sortedKeys)
		        {
		        	for(SObject sortObject : bucketHolder.get(sortedIndex))
		        	this.abstractSortingList.add(sortObject);
		        }
	        }	        
	        return this.abstractSortingList;
	
	}

	
	
	//Standard list seek, pass the sobject list, the sobject you're searching for
	//and the fieldname of the sobject you want to match on 	
	public static Boolean standardListContains(List<SObject> hayStack, SObject needle, String fieldName)
	{
		for(SObject seeker : hayStack)
		{
			if(BluewolfDevUtils.getFieldValue(seeker, fieldName) == BluewolfDevUtils.getFieldValue(needle, fieldName))
			return true;
		}		
		return false;
	}
	
	//Returns the value of an sObject field
	public static Object getFieldValue(SObject obj, String fieldName)
	{
		String[] nesting = fieldName.split('\\.', 0);
		SObject parent = obj;
		Integer levelCounter = 0;
		
		try
		{
			while (levelCounter < nesting.size() - 1)
			{
				parent = parent.getSObject(nesting[levelCounter]);
				levelCounter++;
			}
			
			Object toReturn = parent.get(nesting[levelCounter]);
			return toReturn;
		}
		catch (exception re)
		{
			throw new reusableException('Invalid Field Name ' + nesting[levelCounter] + ' On Object '+ parent +' passed to the BluewolfDevUtils -> getFieldValue function ', re);			
		}
					
	}
	
	//Flatten list for a dynamic query
	public static String flattenListForQuery(List<Object> incoming)
	{
		//Empty lists will cause an invalid query
		if(incoming.size() == 0)
		{
			throw new reusableException('Empty List Passed To BlueWolfDevUtils List Flattener');

		}
		
		String query = '';	
	
		for(Object addToString : incoming)
		{
			query += '\'' + String.valueOf(addToString) + '\',';			
		}
		
		if(query != '')
		{
			query = query.substring(0, query.length()-1);

			query = '(' + query + ') ';
		}
		
		return query;
	}

	
	/*
	Converts a string to currency 
	(use the format function of any Decimal, Long, Integer or Double to obtain the string to pass)
	Adds trailing zeros as required
	
	Arguments Passed -- valueToConvert : String to be converted to currency
	                 -- CurrencySymbol : Symbol of currency to be prepended to the converted string e.g $ 	
	*/
	 public static String stringToCurrency(String valueToConvert, String currencySymbol)
	 {
	       Decimal toConvert = 0.0;
	       
	       //Large numbers, when formatted, contain commas
	       //We strip these before processing
	       valueToConvert = valueToConvert.replace(',', '');
	       
	       //If a garbage string (non-decimal/long/int/Double) is passed, it will get caught here
	       try{
	       		toConvert = Decimal.valueOf(valueToConvert);
	       }
	       catch(exception e)
	       {
	       		throw new reusableException('Invalid String '+valueToConvert+' passed to BluewolfDevUtils stringtoCurrency ', e);
	       }
	       
	       //Set the decimal places to 2
	       toConvert = toConvert.setScale(2);
       			
	       String toDisplay = toConvert.format();
	       
	       //Find the location on the '.' 			
	       if(toDisplay.indexOf('.') == toDisplay.length()-2 && toDisplay.length() > 1)
	    	toDisplay += '0';	
	    	else if(toDisplay.indexOf('.') == -1)
	    	toDisplay += '.00';
			       			
	      return currencySymbol+toDisplay;
	 }
   
    /*
	Returns the apex pagename from a string url 		
	@param String urlToCheck The Url to retrieve the Apex PageName from
		
	@return String 	
	*/
   public static String getPageName(String urlToCheck)
   {
   	
   	String pageName = '';
   	
   	if(urlToCheck == null)
   		return pageName;
   	   	
	myMatcher = myPattern.matcher(urlToCheck);
	
	if(myMatcher.find())
		pageName = myMatcher.group(1);
	
	   	
   	return pageName;
   }
   
   /*
	Detects and returns the current apex page name 		 	
			
	@return String 	
	*/
   public static String getPageName()
   {   	
   	return BluewolfDevUtils.getPageName(ApexPages.currentPage().getUrl());   	   	
   }

	/*
	Add the field specified to the page parameters, using the parameter name specified
	@param PageReference page The PageReference to add the param to
	@param SObject record The record containing the field we will be adding to the page parameters
	@param String key The name of the URL parameter we will be populating
	@param String field The name of the field on <i>record</i> we are putting into the url params
	
	@return void
	URL-safes the contents of the field before it's added to the page parameters
	*/ 
	public static void addToPageParameters(PageReference page, SObject record, String key, String field)
	{
		if(record.get(field) != null && record.get(field) != '')
		{
			page.getParameters().put(key, EncodingUtil.urlEncode(String.valueOf(record.get(field)), 'UTF-8'));
		}
	}
   
}