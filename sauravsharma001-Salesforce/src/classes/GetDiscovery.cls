@RestResource(urlMapping='/v2/discovery/*')
global without sharing class GetDiscovery extends XedeObject {

    private void discovery(RestRequest request, RestResponse response)
    {
        list<string> uriParts = request.requestUri.split('/');
        
        if (uriParts.size() < 4) {
            response.responseBody = Blob.ValueOf(JSON.SerializePretty('Missing URI part'));
            return;
        }
        
        if (uriParts[3].equalsIgnoreCase('xml')) {
            XedeTestData aLib = new XedeTestData('Open311Text');
            string xmlString = aLib.find('discoveryXml');
            system.assert(String.IsNotBlank(xmlString), 'empty resource for xml reply');
            response.responseBody = Blob.ValueOf(xmlString);
            response.addHeader('Content-Type','text/xml; charset=utf-8');
            system.debug(xmlString);
        }
        
        else {
            String callback= RestContext.request.params.get('callback');
           // String xmlString = aLib.find('discoveryJson');
            String xmlString = formatResponse(callback);
            system.assert(String.IsNotBlank(xmlString), 'empty resource for json reply');
            response.responseBody = Blob.ValueOf(xmlString);  
            if(callback == null)
                response.addHeader('Content-Type','application/json; charset=utf-8');    
            else
                response.addHeader('Content-Type','application/javascript');        
            system.debug(xmlString);
        }
    }
    
    @HttpGet
    global static void doGet() {
        GetDiscovery aRest = new GetDiscovery();        
        aRest.handleRequest(RestContext.request, RestContext.response);     
    }
 
    @HttpPost
    global static void doPost() {                    
        GetDiscovery aRest = new GetDiscovery();
        aRest.handleRequest(RestContext.request, RestContext.response);        
    }

    public void handleRequest(RestRequest request, RestResponse response)
    {
        system.debug(request);
        
        discovery(request, response);
    }
    
    public static String formatResponse(String callback) { 
       String response = null;
       String changeSet = '2014-10-01T03:00:00-05:00';
       JSONGenerator gen = JSON.createGenerator(true);
       String url = 'http://api.phila.gov/open311/v2/discovery.json';
       String url1 = 'http://api.phila.gov/test-open311/v2/discovery.json';
       String url2 = 'http://api.phila.gov/staging-open311/v2/discovery.json'; 
       List<String> format = new List<String>();
       format.add('application/json');                        
       format.add('text/xml');
       gen.writeStartObject(); 
       gen.writeObjectField('changeset',changeSet);
       gen.writeObjectField('contact', 'You can email or call for assistance Saurav.Sharma@in.unisys.com');
       gen.writeObjectField('key_service', 'You can request a key here: https://philadelphia.secure.force.com/apps/AppKeyRegistrationMain');
       gen.writeFieldName('endpoints');       
       gen.writeStartArray();
       
       gen.writeStartObject(); 
       gen.writeObjectField('specification','http://wiki.open311.org/GeoReport_v2');
       gen.writeObjectField('url',url);
       gen.writeObjectField('changeset',changeSet);
       gen.writeObjectField('type','production');
       gen.writeObjectField('formats',format);      
       gen.writeEndObject();
       
       gen.writeStartObject(); 
       gen.writeObjectField('specification','http://wiki.open311.org/GeoReport_v2');
       gen.writeObjectField('url',url1);
       gen.writeObjectField('changeset',changeSet);
       gen.writeObjectField('type','test');
       gen.writeObjectField('formats',format);      
       gen.writeEndObject();
       
       gen.writeStartObject(); 
       gen.writeObjectField('specification','http://wiki.open311.org/GeoReport_v2');
       gen.writeObjectField('url',url2);
       gen.writeObjectField('changeset',changeSet);
       gen.writeObjectField('type','dev');
       gen.writeObjectField('formats',format);      
       gen.writeEndObject();
       
       gen.writeEndArray();
       gen.writeEndObject();
         
       response = gen.getAsString();
       if(callback != null)    {
           response = callback + '(' + response + ' );';
       }
       return response ;
    }
    
    public GetDiscovery() {} // is public for unit testing purposes
}