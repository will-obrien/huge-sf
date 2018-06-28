/*
    Test class: SFRequest_Test
*/

public class SFRequest{

    public static Log_integracao__c doPost(String idRegistro, String nomeRegistro, String sistema, String endPoint, String soapAction, String xmlEnvio){
        return doIt(idRegistro, nomeRegistro, sistema, soapAction, endPoint, xmlEnvio, 'POST');
    }
    
    public static Log_integracao__c doGet(String idRegistro, String nomeRegistro, String sistema, String endPoint){
        return doIt(idRegistro, nomeRegistro, sistema, '', endPoint, '', 'GET');
    }

    public static Log_integracao__c doIt(String idRegistro, String nomeRegistro, String sistema, String endPoint, String xmlEnvio, String method, Map<String,String> headers){
         Log_integracao__c log = new Log_integracao__c();
        log.Id_registro__c = texto(idRegistro);
        log.Nome_registro__c = texto(nomeRegistro);
        log.Sistema__c = texto(sistema);
        log.Endpoint__c = texto(endPoint);
        log.Data_hora_envio__c = System.now();
        if(xmlEnvio != null) log.XML_envio__c = (xmlEnvio.length() > 130000 ? xmlEnvio.substring(0, 130000) : xmlEnvio);
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setEndpoint(texto(endPoint));
        req.setMethod(texto(method));
        
        for(String header : headers.keySet()){
            req.setHeader(header, headers.get(header));
        }
        
        if(xmlEnvio != null) req.setBody(xmlEnvio);
        
        req.setTimeout(120000);
        
        String r = '';
        
        try{
            if(!Test.isRunningTest()) r = http.send(req).getBody();
        }catch(Exception e){
            r = e.getMessage();
            log.Exception__c = true;
        }

        log.Data_hora_resposta__c = System.now();
        
        log.XML_resposta__c = (r.length() > 130000 ? r.substring(0, 130000) : r);
        System.debug('cls__ SFRequest envio: ' + req.getBody());        
        System.debug('cls__ SFRequest headers: ' + headers);
        System.debug('cls__ SFRequest request: ' + req.toString());
        return log; 
    }
    
    private static Log_integracao__c doIt(String idRegistro, String nomeRegistro, String sistema, String soapAction, String endPoint, String xmlEnvio, String method){
        Log_integracao__c log = new Log_integracao__c();
        log.Id_registro__c = texto(idRegistro);
        log.Nome_registro__c = texto(nomeRegistro);
        log.Sistema__c = texto(sistema);
        log.SOAPAction__c = texto(soapAction);
        log.Endpoint__c = texto(endPoint);
        log.Data_hora_envio__c = System.now();
        log.XML_envio__c = (xmlEnvio.length() > 130000 ? xmlEnvio.substring(0, 130000) : xmlEnvio);
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setEndpoint(texto(endPoint));
        req.setMethod(texto(method));
        
        if(method.equals('POST')){
            req.setHeader('Content-type', 'text/xml;charset=utf-8');
            req.setHeader('SOAPAction', texto(soapAction));
            req.setBody(xmlEnvio);
        }
        
        req.setTimeout(120000);
        
        String r = '';
        
        try{
            if(!Test.isRunningTest()) r = http.send(req).getBody();
        }catch(Exception e){
            r = e.getMessage();
            log.Exception__c = true;
        }

        log.Data_hora_resposta__c = System.now();
        
        log.XML_resposta__c = (r.length() > 130000 ? r.substring(0, 130000) : r);
        System.debug('cls__ SFRequest envio: ' + req.getEndPoint());     
        System.debug('cls__ SFRequest request: ' + req.toString());
        
        return log;
    }
    
    public static Log_integracao__c createException(String idRegistro, String nomeRegistro, String nomeMetodo, Exception e){
        Log_integracao__c log = new Log_integracao__c();
        log.Id_registro__c = idRegistro;
        log.Nome_registro__c = nomeRegistro;
        log.SOAPAction__c = nomeMetodo;
        log.Data_hora_envio__c = System.now();
        log.Data_hora_resposta__c = System.now();
        log.Exception__c = true;
        log.XML_resposta__c = (e == null ? 'Exception null' : e.getLineNumber() + ': ' + e.getMessage() );
        
        return log;
    }
    
    public static void saveLogs(List<Log_integracao__c> logs){
        List<Database.SaveResult> lista = Database.insert(logs, false);

        for(Database.SaveResult sr : lista){
            for(Database.Error e : sr.getErrors()){
                System.debug(LoggingLevel.ERROR, '@@ ERROR (save log): ' + e.getMessage());
            }
        }
    }
    
    private static String texto(String texto){
        if(String.isEmpty(texto)) return '';
        return texto;
    }
    
    
 

}