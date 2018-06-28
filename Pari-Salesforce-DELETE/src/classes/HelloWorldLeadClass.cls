public class HelloWorldLeadClass {
    public static void helloWorld(List<lead> leads){
        for(lead l: leads){
			l.hello__c = 'World';
           // l.City = 'San Francisco';
        }
    }
}