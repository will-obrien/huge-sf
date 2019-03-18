/*
    Test class for: SFRequest
*/

@isTest
public class SFRequest_Test{

    static testMethod void testePost(){
        List<Log_integracao__c> logs = new List<Log_integracao__c>();

        Log_integracao__c log = SFRequest.doPost('xxxAAA', 'Registro teste', 'teste', 'www.site.com/servico', 'insert', '<xml>envio</xml>');
        
        System.assertEquals(log.Id_registro__c, 'xxxAAA');
        System.assertEquals(log.Nome_registro__c, 'Registro teste');
        System.assertEquals(log.Endpoint__c, 'www.site.com/servico');
        System.assertEquals(log.Sistema__c, 'teste');
        System.assertEquals(log.SOAPAction__c, 'insert');
        System.assertEquals(log.XML_envio__c, '<xml>envio</xml>');
        
        logs.add(log);
        
        SFRequest.saveLogs(logs);
        
        logs = 
            [SELECT Id
            FROM Log_integracao__c];
            
        System.assertEquals(1, logs.size());
    }
    
    static testMethod void testeGet(){
        List<Log_integracao__c> logs = new List<Log_integracao__c>();

        Log_integracao__c log = SFRequest.doGet('xxxAAA', 'Registro teste', 'teste', 'www.site.com/servico');
        
        System.assertEquals(log.Id_registro__c, 'xxxAAA');
        System.assertEquals(log.Nome_registro__c, 'Registro teste');
        System.assertEquals(log.Endpoint__c, 'www.site.com/servico');
        System.assertEquals(log.Sistema__c, 'teste');
        
        logs.add(log);
        
        SFRequest.saveLogs(logs);
        
        logs = 
            [SELECT Id
            FROM Log_integracao__c];
            
        System.assertEquals(1, logs.size());
    }
    
    static testMethod void testeCreateException(){
        Log_integracao__c log = SFRequest.createException('xxx', 'registro', 'teste', null);
        
        System.assertEquals(log.Id_registro__c, 'xxx');
        System.assertEquals(log.Nome_registro__c, 'registro');
        System.assertEquals(log.SOAPAction__c, 'teste');
    }

}