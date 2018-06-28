public class MyHelloWorld {
   public static void applyDiscount(Pricebook2[] books) {
      for (Pricebook2 b :books){
         b.Price__c *= 0.9;
      }
   }
}