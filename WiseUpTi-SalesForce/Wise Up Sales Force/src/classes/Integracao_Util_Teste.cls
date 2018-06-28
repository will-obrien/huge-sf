@isTest
public class Integracao_Util_Teste{
    public static testmethod void teste(){
        Integracao_Util util = new Integracao_Util();
        Decimal test = 26;
        
        
        Integracao_Util.RequestResult res = new Integracao_Util.RequestResult();
        res.value = true;
        res.message = '';
        
        Integracao_Util.OppRequestResult ops = new Integracao_Util.OppRequestResult();
        ops.success = true;
        ops.pkRequest  = '';
        
        Integracao_Util.errorAccountResult error = new Integracao_Util.errorAccountResult();
        error.httpStatus = 'Ativo'; 
        error.code = '1';
        error.message = 'Testando errorAccountResult';
        error.cause = 'Teste';
        
        Integracao_Util.restLeadConverterResult restLead = new Integracao_Util.restLeadConverterResult();
        restLead.value = true; 
        restLead.AccountId = '1';
        restLead.message = 'Testando restLeadConverterResult';
        restLead.OpportunityId = 'Teste';
   
        Integracao_Util.Json_deserialize(ops );
        Integracao_Util.Serialize_multipart(res );
        
    }
    
    
}