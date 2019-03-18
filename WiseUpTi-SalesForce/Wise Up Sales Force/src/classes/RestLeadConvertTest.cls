/*
    Teste para: RestLeadConvert
*/

@isTest
public class RestLeadConvertTest{

    static testMethod void RestLeadConvertTest1(){
        
        try{           

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            Lead lead = Teste_Util.newLead();
            lead.Status = 'Nutrindo';
            lead.CNPJ__c = '81.375.586/0001-70';
            update lead;
            
            req.requestURI = '/Lead/Converter/'+lead.Id;  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            
            Integracao_Util.restLeadConverterResult requestResult = RestLeadConvert.doGet();
        }
        catch(Exception ex){
            
        }

    }
    
    static testMethod void RestLeadConvertTest2(){
        
        try{           

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            Lead lead = Teste_Util.newLead();
            Account account = Teste_Util.newAccount();
            account.Id_meu_sucesso__c = '123456';
            update account;
            lead.Id_meu_sucesso__c = '123456';
            update lead;
            
            req.requestURI = '/Lead/Converter/'+lead.Id;  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            
            Integracao_Util.restLeadConverterResult requestResult = RestLeadConvert.doGet();
        }
        catch(Exception ex){
            
        }


    }


    static testMethod void RestLeadConvertTest3(){
        
        try{           

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
    
            Lead lead = Teste_Util.newLead();
            lead.Id_meu_sucesso__c = '123456';
            update lead;
    
            Account account = Teste_Util.newAccount();
    
            Opportunity opp = new Opportunity();
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Assinatura meusucesso.com').getRecordTypeId();
            opp.Name = 'Oportunidade Teste';
            opp.AccountId = account.Id;
            opp.CloseDate = System.today();
            opp.StageName = 'Trabalhando';
            opp.Id_meu_sucesso__c = '123456';
    
            insert opp;
    
            req.requestURI = '/Lead/Converter/'+lead.Id;  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
    
            Integracao_Util.restLeadConverterResult requestResult = RestLeadConvert.doGet();
        }
        catch(Exception ex){
            
        }

        

    }
    
    static testMethod void RestLeadConvertTest4(){
        
        try{           

              RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
    
            Lead lead = Teste_Util.newLead();
            Lead lead2 = Teste_Util.newLead();
            lead2.Id_meu_sucesso__c = lead.Id;
            update lead2;
    
            req.requestURI = '/Lead/Converter/'+lead.Id;  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
    
            Integracao_Util.restLeadConverterResult requestResult = RestLeadConvert.doGet();
        }
        catch(Exception ex){
            
        }
        

      

    }


    static testMethod void RestLeadConvertTest5(){
        
        
        try{           

             RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
    
            Lead lead = Teste_Util.newLead();
            Lead lead2 = Teste_Util.newLead();
            lead2.Id_meu_sucesso__c = lead.Id;
            update lead2;
    
            req.requestURI = '/Lead/Converter/'+lead2.Id;  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
    
            Integracao_Util.restLeadConverterResult requestResult = RestLeadConvert.doGet();
        }
        catch(Exception ex){
            
        }

       

    }

}