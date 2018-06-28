@isTest
public class TemperatureConverterTest {

    @isTest static void testWarmTemp() {
        Decimal  celsius = TemperatureConverter.FahrenheitToCelsius(70);
        System.assertEquals(21.11, celsius,'Expected value of 21.11');
    }
    
    @isTest static void testBoilingPoint() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(212);        
        System.assertEquals(100,celsius,'Boiling point temperature is not expected.');
    } 
    
   
    static TestMethod void testNegativeTemp(){
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(-10);
        System.assertEquals(-23.33, celsius,'Expected value is -23.33');
    }
}