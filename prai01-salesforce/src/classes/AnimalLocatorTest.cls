@isTest
public class AnimalLocatorTest {

	@isTest static void testAnimalNameById() {
	    // Set mock callout class 
	    Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
	    // This causes a fake response to be sent
	    // from the class that implements HttpCalloutMock. 
	    String name = AnimalLocator.getAnimalNameById(1);
	    // Verify that the response received contains fake values
	    System.debug(name);
	    String expectedValue = 'chicken';
	    System.assertEquals(name, expectedValue);
	   
		}	
}