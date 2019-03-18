public class ParkLocator {
 public static String[] Country(String country)
 {
   ParkService.ParksImplPort park = new ParkService.ParksImplPort();
   return park.byCountry(country);
  
 }
}