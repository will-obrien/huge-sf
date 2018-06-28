public with sharing class Open311Ext {

   public Static String url {get;set;} 
   public Static String params {get;set;} 
   public Static String method {get;set;} 
   public Static String result {get;set;}
   
   @RemoteAction
   public static String makeCallout(String baseUrl,String par, String meth) {
       System.debug('Making Callout');
       System.debug('URL: ' + baseUrl);
       System.debug('Params: ' + params);
       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setMethod('GET');
       if(par != null && par != '')
           request.setBody(par);
       request.setEndpoint(baseUrl);
       if (Test.isRunningTest())
          return 'Test Running';
       else    {
           try    {
               Httpresponse response = http.send(request);
               System.debug('Response: ' + response.getBody());
               result = response.getBody();
               return response.getBody();
           }
           catch(Exception ex)    {
               System.debug('Error Occured: ' + ex.getMessage());
               return ex.getMessage();
           }
       }             
   }

}