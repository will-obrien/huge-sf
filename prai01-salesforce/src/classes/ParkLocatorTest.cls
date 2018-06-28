@isTest
public class ParkLocatorTest {

    @isTest static void testCallout(){
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String country  = 'United States';
        String[] result = ParkLocator.Country(country);
        
        System.assertEquals(3, result.size());
    }
}