public class TemperatureConverter {
    //Takes a Fahrenheit temperature and returns the Celsius equivalent
    
    public static Decimal FahrenheitToCelsius(Decimal fh) {
        Decimal cs = (fh - 32) * 5/9;
        Decimal result;
        
        if (cs > 100) {
            result =  cs.setScale(3);
        }
        else
        {
            return cs.setScale(2); 
        }
        
        return result;
    }
}