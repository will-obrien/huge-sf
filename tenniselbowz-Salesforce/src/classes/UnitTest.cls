/**
 * A library to facilitate writing quality unit tests.
 *
 * @author Krishna Kollu
 * @version 1.2, 12/21/2013
*/
@isTest
public class UnitTest {
	
	/* Exceptions */
	public class IllegalCharactersException extends Exception {}
	public class DividingException extends Exception {}
	public class InvalidTagException extends Exception {}
	public class DatabaseOperationException extends Exception {}
	public class AssertionException extends Exception {}
	public class InvalidAssignmentException extends Exception {}
	public class TestDataFinalizedException extends Exception {}
	public class TestDataNotFinalizedException extends Exception {}
	public class AnalyzeException extends Exception {}
	public class CustomAttributeException extends Exception {}
	public class IllegalSpecificationsException extends Exception {}
	
	public static Set<String> illegalCharacters = new Set<String> {':','-','>','<','+','!','*'};
	
	private static DataItems allItems = new DataItems();
	private static Map<String, List<DataItem>> tagsToDataItems = new Map<String, List<DataItem>>(); 
	private static Map<Schema.SObjectType, List<DataItem>> objTypeToDataItems = new Map<Schema.SObjectType, List<DataItem>>(); 
	private static Integer offset = 0;
	private static Boolean finishedInitalizingTestDataBool = false;
	
	/* Static Variables for AssignFrom */
	private static Map<List<Object>, Integer> specifiedValuesToIndexPointer = new Map<List<Object>, Integer>();
	
	/* Cache for Analyzing */
	private static Map<String, Set<Id>> tagsToIdsCache = new Map<String, Set<ID>>();
	private static Map<ID, DataItem> idToDataItem = new Map<ID, DataItem>();
	
	
	private static Set<ID> analyzeTagAndGetObjectIDs(String tag)
	{
		Set<ID> ids;
		if(!tagsToIdsCache.containsKey(getNormalizedTagName(tag)))
		{
			ids = new Set<ID>();
			assertTagIsValid(tag);
			for(DataItem o : tagsToDataItems.get(getNormalizedTagName(tag)))
			{
				ID id = o.getSObject().Id;
				if(id==null) throw new UnitTest.AnalyzeException('At least one of the data elements being analyzed has a null ID value. You can only analyze elements that have ID values specified.');
				ids.add(id);
			}
			tagsToIdsCache.put(getNormalizedTagName(tag),ids);
			return ids;
		}
		return tagsToIdsCache.get(getNormalizedTagName(tag));
	}
	 
	 /**
	  * Analyze test data with the specified tag.
	  * After this function is first called, you can longer add test data / assign test data / tag test data / etc.
	  * Note: There is no guarentee on the corectness of the analyze functions if you, through other means,
	       manipulate any test objects after the first call of analyze.
	  * @throws InvalidTagException 
	  * Indicates that the specified tag has not been defined
	 */
	 public static AnalyzeHandler analyze(String tag)
	 {
	 	assertTagIsValid(tag);
	 	lockdownData();
	 	return new AnalyzeHandler(tag);
	 }
	 
	 
	 private static void lockdownData()
	 {
	 	if(!finishedInitalizingTestDataBool)
	 	{
		 	finishedInitalizingTestDataBool = true;
		 	
		 	for(DataItem dt : allItems.items)
		 	{
		 		if(dt.getSObject().ID!=null)
		 			idToDataItem.put(dt.getSObject().ID,dt);
		 	}
	 	}
	 }
	 
	 /* Check to see if a property is an attribute */
     private static Boolean likeAttribute(String propertyName)
     {
        	if(propertyName.startsWith('*')&&propertyName.EndsWith('*'))
        	{
        		return true;
        	}
        	return false;
     }	 
	 
	 private static void assertTestDataNotFinalized()
	 {
	 	if(finishedInitalizingTestDataBool) throw new UnitTest.TestDataFinalizedException('You cannot modify test data after you have called UnitTest.analyze()');
	 }
	 
	 private static String getNormalizedTagName(String tag)
	 {
	 	return 'tag$'+tag.toLowerCase().trim();
	 }
	 
	 private static Boolean assertTagIsValid(String tag)
	 {
	 	if(UnitTest.tagsToDataItems.containsKey(getNormalizedTagName(tag)))
        { 
            return true;
        }
        throw new InvalidTagException('There is no tag defined in this unit test with the label "' + tag +'". Please check the spelling of your tag name. Note that tag names are not case sensitive.');
	 }
	 
	 private static Boolean assertObjectTypeIsValid(Schema.SobjectType objType)
	 {
	 	if(objTypeToDataItems.containsKey(objType))
	 		return true;
	 	throw new InvalidTagException('There are no objects defined in this unit test of the following SObjectType: ' + objType);
	 }
	 
	 /*
	 Precondition: items cannot be null or empty. 
	 Asserts that the objects are of the same sobject type
	 */
	 private static void assertSameSObjectType(List<DataItem> items)
	 {
	 	Schema.SObjectType objType = items[0].getSObject().getSObjectType();
	 	for(Integer i = 1; i < items.size(); i++)
	 	{
	 		if(items[i].getSObject().getSObjectType()!=objType)
	 		    throw new DatabaseOperationException('The current operation is invalid for a context of multiple sobject types. Found both ' + items[i].getSObject().getSObjectType() + ' and ' + objType);
	 	}
	 }
	 
	 /*
	 Precondition: items cannot be null or empty, and startIndexInclusive, endIndexInclusive < size of list
	 */
	 private static List<DataItem> extractFromIndicies(List<DataItem> items, Integer startIndexInclusive, Integer endIndexInclusive)
         {
         	System.debug(LoggingLevel.ERROR,startIndexInclusive+';'+endIndexInclusive);
            List<DataItem> extract = new List<DataItem>();
            for(Integer i = startIndexInclusive; i <= endIndexInclusive; i++)
            {
                extract.add(items[i]);
            }
            return extract;
         }
         
     /**
      * Begin the process of creating test data. 
      * Note: This function does not create test data.
      * Test Data is only created when the function single or many is called on the returned DataCreation object
      * @param dataGenerator the specified implementation of datagenerator to use for creating data
      * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
      * @return a datacreation class to use for creating test data.
     */    
     public static DataCreation createTestData(DataGenerator dataGenerator)
     {
     	assertTestDataNotFinalized();
        return new DataCreation(dataGenerator);
     }
	 
	 /**
	  * Adds the specified SObjects to the UnitTest container.
	  * @param objs the specified SObjects
	  * @return the DataItems wrapper for the specified SObjects
	  * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
	 */
	 public static DataItems addData(List<SObject> objs)
	 {
	 	assertTestDataNotFinalized();
	 	List<DataItem> objWrappers = new List<DataItem>();
        for(Sobject obj : objs)
        {
            objWrappers.add(new DataItem(obj));
        }   
        
        UnitTest.allItems.items.addAll(objWrappers);
        
        return new DataItems(objWrappers);
	 }
	 
	  /**
	   * Out of all test data, return those data items that have the specified tag. 
	   * Note that tagging is case insensitive
	   * @param tag the specified tag
	   * @return only DataItems with the specified tag
	   * @throws InvalidTagException 
	   * Indicates that the specified tag has not been defined
      */
	 public static DataItems get(String tag)
	 {
	 	assertTagIsValid(tag);
	 	return new DataItems(tagsToDataItems.get(getNormalizedTagName(tag)));
	 }
	 
	 /**
	  * Out of all test data, return the ids of the data items that have the specified tag
	  * Note that tagging is case insensitive
	  * @param tag the specified tag
	  * @return only ids of the DataItems with the specified tag
	  * @throws InvalidTagException 
	  * Indicates that the specified tag has not been defined
	  */
	 public static Set<ID> getIds(String tag)
	 {
	 	return Pluck.ids(get(tag).getList());
	 }
	 
	 /**
	   * Out of all test data, return those data items that are of the specified SObject Type
	   * @param tag the specified sObject type
	   * @return only DataItems of the specified SObject Type
	   * @throws InvalidTagException
	   * Indicates that there are no test objects of the specified object type
      */
	 public static DataItems get(Schema.SObjectType objType)
	 {
	 	assertObjectTypeIsValid(objType);
	 	return new DataItems(objTypeToDataItems.get(objType));
	 }
	 
	 /**
	  * Use this when you would like to perform external operations based on each data item
	  * with the specified tag, such as creating related records.
	  * @throws InvalidTagException
	  * Indicates that the specified tag has not been defined
	  * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
	  */
	 public static ForEachHandler forEach(String tag)
	 {
	 	assertTestDataNotFinalized();
	 	assertTagIsValid(tag);
		return new ForEachHandler(get(tag).items);
	 }
	 
	 /**
	  * Set the current context to all the test data
	  * @return return all test data
	  */
	 public static DataItems allData()
	 {
	 	return allItems;
	 }
	 
	 /**** Assertion Functions *****/
	 
	 /**
	  * Asserts that the expected set is the same as the actual set.
	  *
	  * @throws AssertionException if the assertion fails
	  * @throws AnalyzeException if either the expectedSet or the actualSet is null
	  */
	 public static void assertSetEquals(Set<Object> expectedSet, Set<ID> actualSet, String highlevelMessage)
	 {
	 	if(expectedSet==null)
	 		throw new AnalyzeException('The expected set is null, and the actual set is ' + actualSet);
	 		
	 	if(actualSet==null)
	 		throw new AnalyzeException('The actual set is null, even though the expected set is ' + expectedSet);	
	 		
	 	if(expectedSet.size()!=actualSet.size())
	     	throw new AssertionException(assertionMessage(highlevelMessage,'Technical Details: The size of the expected set, ' + expectedSet.size() + ', does not match the size of the actual set, ' + actualSet.size()));
	 
	 	for(ID id : actualSet)
	 	{
	 		if(!expectedSet.contains(id))
	 			throw new AssertionException(assertionMessage(highlevelMessage,'Technical Details: One of the elements of the actual set, the ID ' + id + ' is not contained in the expected set ' + expectedSet));
	 	}	
	 }
	  
	 private static String assertionMessage(String highlevelMessage, String technicalDetails)
	 {
	 	return highlevelMessage + '\n*' + technicalDetails;
	 }
	 
	 public class DataItemForAnalysis {
	 	private DataItem myItem;
	 	
	 	private DataItemForAnalysis(DataItem item)
	 	{
	 		this.myItem = item;
	 	} 
	 	
	 	/*
	 	 * Return the value for the specified property for the selected DataItem.
	 	 * @throws CustomAttributeException if the property is a custom attribute and you have not initalized the custom attribute.
	 	*/
	 	public Object getPropertyValue(String property)
	 	{
	 		return myItem.getPropertyValue(property);
	 	}
	 	
	 	/**
	 	 * Search all test data for an object with the ID contained in the specified property for this data item.
	 	 * @throws CustomAttributeException if the property is a custom attribute and you have not initalized the custom attribute.
	 	 * @throws AnalyzeException if the value contained in the property is not an ID
	 	 * @throws AnalyzeException if there are no test objects with the ID contained in the specified property for this data item.
	 	*/
	 	public DataItemForAnalysis traverse(String property)
	 	{
	 		Object idToTraverseTo =  myItem.getPropertyValue(property);
	 		if(idToTraverseTo instanceOf ID)
	 		{
	 			if(UnitTest.idToDataItem.containsKey((ID) idToTraverseTo))
	 				return new DataItemForAnalysis(UnitTest.idToDataItem.get((ID) idToTraverseTo));
	 			throw new AnalyzeException('The property ' + property + ' does not contain an ID value that links to any test data. The following ID was found ' + idToTraverseTo);
	 		}
	 		throw new AnalyzeException('The property ' + property + ' does not contain an ID value. Instead the following value was found: ' + idToTraverseTo);
	 	}
	 	
	 	/**
	 	 * Return the SObject that is associated with the selected DataItem
	 	*/
	 	public SObject getSObject()
	 	{
	 		return myItem.getSObject();
	 	}
	 }
	 
	 public class AnalyzeHandler{
	 	private String contextTag;
	 	
	 	private AnalyzeHandler(String tag)
	 	{
	 		this.contextTag = tag;
	 	}
	 	
	 	/**
	 	 * For all the test data being analyzed, select the data item that corresponds to the following ID
	 	 * @throws AnalyzeException if one of the test elements being analyzed has a null ID,
	 	 * or if the specified ID does not belong to one of the test data elements being analyzed
	     * @return a DataItemForAnalysis class for analyzing the selected test datum
	 	*/
	 	public DataItemForAnalysis selectByID(Id id)
	 	{
	 		if(!hasID(id))
	 		{
	 			throw new AnalyzeException(contextTag + ' does not include the specified ID: ' + id );
	 		}
	 		return new DataItemForAnalysis(UnitTest.idToDataItem.get(id));
	 	}
	 	
	 	/**
	 	 * For all the test data in the context, extract a MAP of the ID of the datum to the specified property. 
	 	 * Recall a property can either be a field or a custom attribute.
	 	 * @throws AnalyzeException if one of the test elements being analyzed has a null ID.
	 	 * @return a map from id to the specified property for all items being analyzed
	 	*/
	 	public Map<ID, Object> extractMapIDTo(String property)
	 	{
	 		UnitTest.analyzeTagAndGetObjectIDs(contextTag);
	 		Map<ID, Object> retMap = new Map<ID, Object>();
	 		for(DataItem di : UnitTest.get(contextTag).items)
	 		{
	 			retMap.put(di.getSObject().ID, di.getPropertyValue(property));
	 		}
	 		return retMap;
	 	}
	 	
	 	/**
		 * Assert the elements being analyzed against the specified list of objects.
		 *  
		 * The assertion passes iff the elements being analyzed have the same number of elements as the list of objects,
		 * if every element in the analyzed context and in the specified list of objects has a non-null ID,
		 * and iff every ID in the analyzed context is contained in the list of objects.
		 
		 * @param comparedObjs the specified list of objects to compare against the context
		 * @throws AssertionException if the assertion fails
		 * @throws AnalyzeException if one of the test elements being analyzed has a null ID.
		 * @return the same AnalyzeHandler class for future analysis
		 */
		 public AnalyzeHandler assertEquivalence(List<SObject> comparedObjs, String highlevelMessage)
	     {
	     	Set<ID> contextIds = UnitTest.analyzeTagAndGetObjectIDs(contextTag);
	     	
	     	if(contextIds.size()!=comparedObjs.size())
	     		throw new AssertionException(assertionMessage(highlevelMessage,'Technical Details: The size of all "' + contextTag + '", ' +  contextIds.size() + ', is different from ' +  comparedObjs.size() + ', the size of the list of specified objects'));
	     	
	     	for(SObject obj : comparedObjs)
	     	{
	     		if(obj.ID==null)
	     		{
	     			throw new AssertionException('The assertequivalence function may only be used with lists that have no null IDs');
	     		}
	     		if(!contextIds.contains(obj.ID))
	     		{
	     			throw new AssertionException(assertionMessage(highLevelMessage,'Technical Details: The id of the following object was not found in the context:\n'+obj));
	     		}
	     	}
	     	    
	     	return this;
	     }
	     
	     /**
	      * Returns true iff the items being analyzed include the following ID 
	      * @throws AnalyzeException if one of the test elements being analyzed has a null ID.
	     */
	     public Boolean hasID(ID id)
	     {
	     	return UnitTest.analyzeTagAndGetObjectIDs(contextTag).contains(id);
	     }
	     
	 }
	 
	 public class DataCreation{
		 DataGenerator specifiedDataGenerator;
		 
		 private DataCreation(DataGenerator specifiedDataGenerator)
		 {
		 	UnitTest.assertTestDataNotFinalized();
		 	this.specifiedDataGenerator = specifiedDataGenerator;
		 }
		 
		 /**
		  * Create the specified number of records
		  */
		 public DataItems many(Integer howMany) {
		 	return UnitTest.addData(specifiedDataGenerator.generateData(howMany));	
		 }
		 
		 /**
		  * Create just a single record
		  */
		 public DataItems single(){
		 	return UnitTest.addData(specifiedDataGenerator.generateData(1));  
		 }
		 
	}
	
	public interface DataGenerator {
		List<SObject> generateData(Integer howMany);
	}
	
	private class DataAndRelatedItem {
		private DataItem relatedItem;
		private DataItems data;
		
		private DataAndRelatedItem(DataItem relatedItem, DataItems data)
		{
			this.data = data;
			this.relatedItem = relatedItem;
		}
	}
	
	public class DataItemsWithRelatedDataItem
	{
		private List<DataAndRelatedItem> dataAndRelatedItems;
		
		private DataItemsWithRelatedDataItem(List<DataAndRelatedItem> dataAndRelatedItems)
		{
			this.dataAndRelatedItems = dataAndRelatedItems;
		}
		
		/**
		 * Copy over a property value from related test data. 
		 * @param specifications : define the source property from related items
		 *						as well as the destination property.
		 * If the specified destination property is an uninitalizied custom attribute, this function 
		 * will initialize that property.
		 * Precondition:
		 *	Specifications must be formatted as such <i>SOURCEPROPERTY->DESTINATIONPROPERTY</i>
		 *	The source property belongs to all related objects
		 *	If the destination property is a field, it belongs to all new objects
		 * @throws IllegalSpecificationsException if the specifications are not correctly formatted
		 * @return the same DataItemsWithRelatedDataItem for copying further properties or tagging data
		*/
		public DataItemsWithRelatedDataItem copyProperty(String specifications)
		{
			String[] split = specifications.split('->');
			if(split.size()!=2) throw new IllegalSpecificationsException('Specifications must be formatted as such:\n SOURCEPROPERTY->DESTINATIONPROPERTY');
			String sourceProperty = split[0].trim();
			String destinationProperty = split[1].trim();
			Boolean isDestinationPropertyCustomAttribute = UnitTest.likeAttribute(destinationProperty);
			for(DataAndRelatedItem d : dataAndRelatedItems)
			{
				Object sourceValue = d.relatedItem.getPropertyValue(sourceProperty);
				if(isDestinationPropertyCustomAttribute) d.data.newAttribute(destinationProperty).assign(sourceValue);
				else d.data.property(destinationProperty).assign(sourceValue);
			}
			return this;
		}
		
		/**
		  * Adds the specified tag. (Does not modify the tag of related objects)
		  * @param tagName the specified tag name.
		  * @return same DataItemsWithRelatedDataItem, following tag assignment
		  * @throws IllegalCharactersException
		  * Indicates that there was an illegal character in your tag name.
		  * The below seven characters count as illegal characters
		  *   1) :
          *   2) -
          *   3) >
          *   4) <
          *   5) +
          *   6) !
          *   7) *
          * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
		  *	@return the same DataItemsWithRelatedDataItem for copying further properties or tagging data
		 */
		public DataItemsWithRelatedDataItem tag(String tag)
		{
			for(DataAndRelatedItem d : dataAndRelatedItems)
			{
				d.data.tag(tag);
			}
			return this;
		}
	}
	 
	 public class ForEachHandler {
	 	private List<DataItem> items;
	 	
	 	/**
	 	 * For each of the test items selected, use specified data generator to create X number of test data records,
	 	 * where X is specified in howMany.
	 	 *
	 	 * Each of the test items currently selected with the be related data for the new items.
	 	 * @param howMany specifies how many records to create per each record of data selected via the forEach construct
	 	 * @param specifiedDataGenerator the specified test data generator
	 	 * @return a DataItemsWithRelatedDataItem linking each selected item in forEach with the specified number of new records
		 *
	 	*/
	 	public DataItemsWithRelatedDataItem create(Integer howMany, DataGenerator specifiedDataGenerator)
	 	{
	 		DataCreation myDataCreation = new DataCreation(specifiedDataGenerator);
	 		List<DataAndRelatedItem> dataAndRelatedItems = new List<DataAndRelatedItem>();
	 		for(DataItem relatedItem : items)
	 		{
	 			dataAndRelatedItems.add(new DataAndRelatedItem(relatedItem,myDataCreation.many(howMany)));
	 		}
	 		return  new DataItemsWithRelatedDataItem(dataAndRelatedItems);
	 	}
	 	
	 	private ForEachHandler(List<DataItem> items)
	 	{
	 		this.items = items;
	 	}
	 }
	 
	 public class PropertyHandler {
	 	private DataItems items;
	 	private String property;
	 	
	 	private PropertyHandler(DataItems items, String property)
	 	{
	 		UnitTest.assertTestDataNotFinalized();
	 		this.items = items;
	 		this.property = property;
	 	}
	 	
	 	/**
	 	 * Assign the given property of the elements in context with the IDs of elements with the specified tag.
	 	 * If and only if there are more elements in context than there are elements with the specified tag, 
	 	 * this function will repeat and recycle ID assignments.
	 	 * This function is not idempotent. If called multiple times with the same specified tag, 
	 	 * it may assign different values. Consequently, it ensures that multiple calls of assignFrom
	 	 * can traverse the whole span of elements with the specified tag.
	 	 * @param tag the specified tag
		 * @return the context
		 * @throws InvalidAssignmentException
		 * Indicates that there is at least one element with the specified tag that has a null ID value
		 * @throws InvalidTagException
		 * Indicates that the specified tag has not been assigned to any data elements
	 	*/
	 	public DataItems assignFrom(String tag)
	 	{
	 		UnitTest.assertTagIsValid(tag);
	 		List<ID> ids = new List<ID>();
	 		for(SObject obj : UnitTest.get(tag).getList())
	 		{
	 			if(obj.ID==null)
	 				throw new InvalidAssignmentException('At least one of the test records tagged as "' + tag + '" has a null ID. Please make sure that "' + tag + '" records are inserted into the database before you attempt to assign their ID values to test records\nTechnical Details: The following object has a null ID ' + obj);
	 			ids.add(obj.ID);
	 		}
	 		return assignFrom(ids);
	 	}
	 	
	 	/**
	 	 * Assign the given property of the elements in context with the value of the specified property for that element
	 	 * @throws CustomAttributeException if the property is a custom property and has not been initalized
	 	 * @return the context of test data selected, following assignments
	 	 */
	 	public DataItems copyFromProperty(String specifiedProperty)
	 	{
	 		for(DataItem di : items.items)
	 		{
	 			di.assignProperty(property,di.getPropertyValue(specifiedProperty));
	 		}
	 		return this.items;
	 	}
	 	
	 	/**
	 	 * Assign the given property of the elements in context with one of the specified values
	 	 * This function will attempt to assign every specified value to an element in context before
	 	 * it repeats assignment. This function accepts null values.
	 	 * This function is not idempotent. If called multiple times with the same specified tag, 
	 	 * it may assign different values. Consequently, it ensures that multiple calls of assignFrom
	 	 * can traverse the whole span of specified elements.
	 	 * @param values the list of specified values
	 	 * @return the context of test data, following assignments
		 * @throws InvalidAssignmentException
		 * Indicates that the specifed values is either a null or empty list.
	 	*/
	 	public DataItems assignFrom(List<Object> values)
	 	{
	 		if(values==null)
	 		{
	 			throw new InvalidAssignmentException('You cannot assign the property ' + property + ' from a null list of possible values');
	 		}
	 		else if(values.isEmpty())
	 		{
	 			throw new InvalidAssignmentException('You cannot assign the property ' + property + ' from an empty list of possible values');
	 		}
	 		
	 		Integer valuesIndex = 0;
	 		if(specifiedValuesToIndexPointer.containsKey(values))
	 		{
	 			valuesIndex = specifiedValuesToIndexPointer.get(values);
	 		}
	 		for(DataItem di : items.items)
	 		{
	 			di.assignProperty(property,values[Math.mod(valuesIndex++,values.size())]);
	 		}
	 		specifiedValuesToIndexPointer.put(values, valuesIndex);
	 		
	 		return this.items;
	 	}
	 	
	 	 /**
		  * For each SObject in this context, assign the specified
		  * value to the property.
		  * <dt><b>Precondition:</b><dd>
		  * Property must be a valid property for each SObject type in this context
		  * @param value the specified value
		  * <dt><b>Precondition:</b><dd>
          * For each sObject type in DataItems, for the specified property, 
          * the type of value must match the type of the field.
		  * @return same dataitems, following field-value assignments.
		  * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
		  */
		 public DataItems assign(Object value){
		 	UnitTest.assertTestDataNotFinalized();
		 	for(DataItem item : items.items)
		 	{
		 		item.assignProperty(property,value);
		 	}
		 	return items;
		 }
	 }
	
	 public class DataItems{
		 private List<DataItem> items;
		 
		 private DataItems()
		 {
		 	items = new List<DataItem>();
		 }
		 
		 private DataItems(List<DataItem> dataItems)
         {
            items = dataItems;
         }
		 
		 private List<DataItem> getDataItemElements()
		 {
		 	return items;
		 }
		 
		 /**
		  * Returns a class that may be used to perform operations on the properties 
		  * of the data elements in the context. Recall that a property is either a field
		  * or a custom attribute.
		  * @throws CustomAttributeException if you have not initalized the custom attribute.
		  * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
		 */
		 public PropertyHandler property(String property)
		 {
		 	return new PropertyHandler(this,property);
		 }
		 
		 /**
		  * Initalizes a custom attribute for the selected context. 
		  * If certain elements of the context already have the custom attribute, then this function does not reset the attribute values.
		  * @throws CustomAttributeException if the custom attribute name does not begin and end with an asterisk
		 */
		 public PropertyHandler newAttribute(String customAttributeName)
		 {
		 	for(DataItem dt : items)
		 	{
		 		if(!dt.hasAttribute(customAttributeName)) 
		 			dt.newAttribute(customAttributeName);
		 	}
		 	return new PropertyHandler(this,customAttributeName);
		 }
		 
		 /**
		  * Simulate inserting the context into the database by populating the ID fields of the objects
		  * @throws DatabaseOperationException 
		  * This indicates that one of the elements with the specified tag already has its ID field populated,
		  * or that all of the dataitems aren't of the same SObjectType
		  * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
		  */
		 public void dummyInsert()
		 {
		 	 UnitTest.assertTestDataNotFinalized();
		 	 UnitTest.assertSameSObjectType(this.items);
		 	 List<SObject> objects = getList();
		 	 String Id_Prefix = objects[0].getSObjectType().getDescribe().getKeyPrefix();
             for( Integer i = 0; i < objects.size(); i++ )
             {
             	  if(objects[i].id!=null)
             	     throw new DatabaseOperationException('There is at least one object in the context that already has an ID specified.');
                  String idSuffix = String.valueOf( offset ).leftPad(12);
                  idSuffix = idSuffix.replace( ' ', '0' );
                  
                  objects[i].id= Id_Prefix + idSuffix;
                  UnitTest.offset+=1;
            }
		 	
		 }
		 
		 /**
		  * In the given context, return those data items that have the specified tag. 
		  * Note that tagging is case insensitive
		  * @param tag the specified tag
		  * @return only DataItems with the specified tag
		  * @throws InvalidTagException 
		  * Indicates that the specified tag has not been defined
		  */
		 public DataItems filter(String tag)
		 {
		 	assertTagIsValid(tag);
		 	
			List<DataItem> qualifyingItems = new List<DataItem>();
			for(DataItem item : items)
			{
			   if(item.hasTag(tag))
			   {
			      qualifyingItems.add(item);
			   }
			}
			return new DataItems(qualifyingItems);
		 }
		 
		 /**
          * In the given context, return those data items of the specified sobject type
          * @param sType the specified sobject type
          * @return only DataItems of the specified sobject type
          * @throws InvalidTagException
          * Indicates that there are no objects of the following type defined in the unit test
          */
         public DataItems filter(Schema.SObjectType sType)
         {
         	UnitTest.assertObjectTypeIsValid(sType);
            List<DataItem> qualifyingItems = new List<DataItem>();
            for(DataItem item : items)
            {
               if(item.getSObject().getSObjectType() == sType)
               {
                  qualifyingItems.add(item);
               }
            }
            return new DataItems(qualifyingItems);
         }
         
         /**
          * Inserts all of the objects in this context.
          * @throws DatabaseOperationException if all of the dataitems aren't of the same SObjectType
          * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
         */
         public void insertAll()
         {
         	UnitTest.assertTestDataNotFinalized();
         	UnitTest.assertSameSObjectType(this.items);
         	insert getList();
         }
         
         /**
          * Updates all of the objects in this context.
          * @throws DatabaseOperationException if all of the dataitems aren't of the same SObjectType
         */
         public void updateAll()
         {
            UnitTest.assertSameSObjectType(this.items);
            update getList();
         }
         
         /** 
          * Deletes all of the objects in this context.
          * @throws DatabaseOperationException if all of the dataitems aren't of the same SObjectType
         */
         public void deleteAll()
         {
            UnitTest.assertSameSObjectType(this.items);
            delete getList();
         }
		 
		 /**
		  * Adds the specified tag to each SObject in this context.
		  * @param tagName the specified tag name.
		  * @return same dataitems, following tag assignment
		  * @throws IllegalCharactersException
		  * Indicates that there was an illegal character in your tag name.
		  * The below seven characters count as illegal characters
		  *   1) :
          *   2) -
          *   3) >
          *   4) <
          *   5) +
          *   6) !
          *   7) *
          * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
		 */
		 public DataItems tag(String tagName)
		 {
		 	for(DataItem dt : items)
		 	{
		 		dt.addTag(tagName);
		 	}
		 	return this;
		 }
		 
		 /**
		  * Return all the SObjects in this context
		  */
		 public List<SObject> getList()
		 {
		 	List<SObject> objects = new List<SObject>();
		 	
		 	for(DataItem item : this.items)
		 	{
		 		objects.add(item.getSObject());
		 	}
		 	return objects;
		 }
		 
		/**
	 	 * For all the test data in the context, extract a map with the following specifications.
	 	 * This function cannot be called with specifications that would result in multiple unique 
	 	 * values for a given key.
	 	 *
	 	 * @param specifications : specify the properties from which to draw out the keys and values
		 *Precondition:
		 *	Specifications must be formatted as such <i>KEYPROPERTY->VALUEPROPERTY</i>
		 *	The key and value property must belong to all objects
		 * @throws IllegalSpecificationsException if the specifications are not correctly formatted
		 *		or if the specifications would result in there being multiple unique values for a given key
	 	*/
	 	
	 	public Map<Object, Object> extractMap(String specifications)
	 	{
	 		String[] split = specifications.split('->');
			if(split.size()!=2) throw new IllegalSpecificationsException('Specifications must be formatted as such:\n KEYPROPERTY->VALUEPROPERTY\n For instance ID->AccountID');
			String sourceProperty = split[0].trim();
			String destinationProperty = split[1].trim();
	 		Map<Object, Object> retMap = new Map<Object, Object>();
	 		for(DataItem di : this.items)
	 		{
	 			Object key = di.getPropertyValue(sourceProperty);
	 			Object value = di.getPropertyValue(destinationProperty);
				if(retMap.containsKey(key) && retMap.get(key)!=value) throw new IllegalSpecificationsException('The specifications ' + specifications + ' are illegal because there are multiple values for ' + destinationProperty + ' for the ' + sourceProperty + ' key ' + key + '\n The Extract Map function cannot not overwrite existing key-value pairs. Use the extractPropertyValues functions');
	 			retMap.put(key, value);
	 		}
	 		return retMap;
	 	}
		 
		/**
	 	 * For all the test data in the context, extract a map of the desired property values,
	 	 * grouped by the key property.
	 	 *
	 	 * @param specifications : specify the properties from which to draw out the keys and set of values
		 * Precondition:
		 *	Specifications must be formatted as such <i>KEYPROPERTY->DESIREDPROPERTY</i>
		 *	The key and desired property must belong to all objects
		 * @throws IllegalSpecificationsException if the specifications are not correctly formatted
	 	*/
	 	
	 	public Map<Object, Set<Object>> extractPropertyValues(String specifications)
	 	{
	 		String[] split = specifications.split('->');
			if(split.size()!=2) throw new IllegalSpecificationsException('Specifications must be formatted as such:\n KEYPROPERTY->DESIREDPROPERTY\n For instance ID->AccountID');
			String sourceProperty = split[0].trim();
			String destinationProperty = split[1].trim();
	 		Map<Object, Set<Object>>  retMap = new Map<Object, Set<Object>>();
	 		for(DataItem di : this.items)
	 		{
	 			Object key = di.getPropertyValue(sourceProperty);
	 			Object value = di.getPropertyValue(destinationProperty);
	 			if(!retMap.containsKey(key)) retMap.put(key, new Set<Object>());
	 			retMap.get(key).add(value);
	 		}
	 		return retMap;
	 	}
	 	 
		 /**
		  * For each SObject in this context, assign the specified
		  * property to the specified field.
		  * @param property the api name of the specified field
		  * <dt><b>Precondition:</b><dd>
		  * Property must be a valid property for each test object in this context
		  * @param value the specified value
		  * <dt><b>Precondition:</b><dd>
          * For each sObject type in DataItems, for the specified property, 
          * the type of value must match the type of the field.
		  * @return same dataitems, following field-value assignments.
		  * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
		  */
		 public DataItems assign(String property, Object value){
		 	return property(property).assign(value);
		 }
		 
		 /**
		  * Out of the items in the current context, only return those that do not have the specified tag
		  * @param tag the specified tag
		  * @return DataItems without the specified tag
		  * @throws InvalidTagException 
          * Indicates that the specified tag has not been defined.
		  */
		 public DataItems minus(String tag) {
		 	assertTagIsValid(tag);
		 	List<DataItem> qualifyingItems = new List<DataItem>();
            for(DataItem item : items)
            {
                if(!item.hasTag(tag))
                {
                    qualifyingItems.add(item);
                }
            }
            return new DataItems(qualifyingItems);
		 }
		
		 /**
          * Create a DataDivider object for the purpose of dividing data evenly 
          * and tagging objects that belong to different divisions
          * @param howManyDivisions How many divisions should the DataItems be broken down into?
          * @return the DataDivider object
          * @throws DividingException if:
          * You specify more divisions that the number of data elements,
          * or you specify 0 divisions, or you specify negative divisions.
          * @throws TestDataFinalizedException if you've already signaled that you have finished initalizing test data.
         */
		 public DataDivider divide(Integer howManyDivisons) {
		 	return new DataDivider(howManyDivisons,items);
		 }
		 
	}
	
	public class DataDivider {
		 Map<Integer,List<DataItem>> itemsByPartion;
		 Integer partionIndex;
		 
		 /*
		  * Labels an unlabeled division with the specified tag. 
		  * Note that this means that all objects that belong to that division will be tagged with the specified tag.
		  * @param tag the specified tag
		  * @return the datadivider object
		  * @throws DividingException
		  *  Indicates that there are no more divisions to label.
		 */
		 public DataDivider part(String tag) {
		 	if(itemsByPartion.containsKey(partionIndex))
		 	{
			 	for(DataItem di: itemsByPartion.get(partionIndex))
			 	{
			 	    di.addTag(tag);	
			 	}
			 	partionIndex++;
			 	return this;
		 	}
		 	throw new DividingException('You cannot tag any more partions because you have already tagged all the partitions you have divided the data into. ');
		 }
		 
		 private DataDivider(Integer howManyDivisions, List<DataItem> items) 
		 {
		 	 UnitTest.assertTestDataNotFinalized();
		 	 if(howManyDivisions==0)
             {
                throw new DividingException('You cannot divide test data into zero partitions. You must divide into at least one partition');
             }
             else if(howManyDivisions<0)
             {
                throw new DividingException('You cannot divide test data into a negative number of partitions. You must divide into at least one partition');
             }
             else if(howManyDivisions>items.size())
             {
                throw new DividingException('You cannot divide test data into more partitions than there are data elements. You are attempting to divide into ' + howManyDivisions + ' divisions when there are just ' + items.size() + ' data elements');
             }
		 	 itemsByPartion = new Map<Integer,List<DataItem>>();
		 	 Integer itemsForFirstDivision = items.size() / howManyDivisions + Math.mod(items.size(),howManyDivisions);
		 	 itemsByPartion.put(1,UnitTest.extractFromIndicies(items,0,itemsForFirstDivision-1));
		 	 
		 	 if(howManyDivisions>1)
		 	 {
		 	    Integer itemsPerEveryOtherDivision = items.size() / howManyDivisions;
			 	Integer index = itemsForFirstDivision;
			 	for(Integer divisionNumber = 2; divisionNumber <=howManyDivisions; divisionNumber++)
			 	{
			 		itemsByPartion.put(divisionNumber,UnitTest.extractFromIndicies(items,index,index+itemsPerEveryOtherDivision-1));
			 		index += itemsPerEveryOtherDivision;
			 	}
		 	 }
		 	 
		 	 partionIndex = 1;
		 	 
		 }
	}
	
	class DataItem {
        private SObject myObject;
        private Set<String> tags;
        private Map<String, Object> customAttributes;
        
        private DataItem(SObject myObject)
        {
        	this.myObject = myObject;
        	tags = new Set<String>();
        	customAttributes = new Map<String, Object>();
        	
	        Schema.SObjectType objType = myObject.getSObjectType();
	        if(!UnitTest.objTypeToDataItems.containsKey(objType)) 
	        	UnitTest.objTypeToDataItems.put(objType, new List<DataItem>());
	        UnitTest.objTypeToDataItems.get(objType).add(this);
        }
        
        private void assignProperty(String property, Object value)
        {
        	if(likeAttribute(property))
        	{
        		if(!hasAttribute(property)) throw new CustomAttributeException('The custom attribute ' + property + ' has not been defined for all relevant test data');
        		customAttributes.put(property,value);
        	}
        	else 
        	{
        		myObject.put(property,value);
        	}
        }
        
        private void newAttribute(String attributeName)
        {
        	if(!likeAttribute(attributeName)) throw new CustomAttributeException('Attribute names must begin and end with an asterisk. The following attribute name is invalid: ' + attributeName);
        	customAttributes.put(attributeName,null);
        }
        
        private Boolean hasAttribute(String attributeName)
        {
        	return customAttributes.containsKey(attributeName);
        }
        
        private Object getPropertyValue(String property)
        {
        	if(likeAttribute(property))
        	{
        		if(!hasAttribute(property)) throw new CustomAttributeException('The custom attribute ' + property + ' has not been defined for all relevant test data');
        		return customAttributes.get(property);
        	}
        	else
        	{
        		return myObject.get(property);
        	}
        }
        
        private SObject getSObject()
        {
        	return myObject;
        }
        
        private void addTag(String tag)
        {
        	UnitTest.assertTestDataNotFinalized();
        	String normalizedTag = UnitTest.getNormalizedTagName(tag);
        	if(!tags.contains(normalizedTag))
        	{
        		for(String illegalCharacter : illegalCharacters)
        		{
	        		assertAgainstIllegalCharacterInTag(tag,illegalCharacter);
        		}
	        	
	        	if(!UnitTest.tagsToDataItems.containsKey(normalizedTag)) 
	        		UnitTest.tagsToDataItems.put(normalizedTag, new List<DataItem>());
	        	UnitTest.tagsToDataItems.get(normalizedTag).add(this);
	        	
        		tags.add(normalizedTag);
        	}
        }
        
        private void assertAgainstIllegalCharacterInTag(String tag, String illegalCharacter)
        {
        	if(tag.contains(illegalCharacter))
                throw new IllegalCharactersException('The specified tag "' + tag + '" has the illegal character ' + illegalCharacter);
        }
        
        private Boolean hasTag(String tag)
        {
        	return tags.contains(UnitTest.getNormalizedTagName(tag));
        }
    }
}