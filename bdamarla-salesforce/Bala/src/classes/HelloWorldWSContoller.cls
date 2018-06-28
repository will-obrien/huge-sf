public class HelloWorldWSContoller{
    public String val{get;set;}
      public HelloWorldWSContoller()
      {
           val = HelloWorldWebService.sayHello();
      }     
}