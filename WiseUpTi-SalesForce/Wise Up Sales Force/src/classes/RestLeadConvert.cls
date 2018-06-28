/*
    Classe de teste: RestLeadConvertTest
    Autor: Sergio Migueis
    Overview: Converte o lead através da API.
    Classe de teste: RestLeadConvertTeste
    Alterações:
*/

@RestResource(urlMapping='/Lead/Converter/*')
global with sharing class RestLeadConvert {            
    
    @HttpGet
    global static Integracao_Util.restLeadConverterResult doGet() {
    

        System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - Start..');
        
        RestLeadConverter__c leadConverterConfig = RestLeadConverter__c.getOrgDefaults();

        Integracao_Util.restLeadConverterResult requestResult = new Integracao_Util.restLeadConverterResult();
        requestResult.value = false;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String leadIdMeuSucesso = null;
        Lead leadFinal = null;

        try{

            leadFinal = [SELECT Id, Id_meu_sucesso__c, OwnerId, Owner.Type FROM Lead WHERE Id_meu_sucesso__c =: leadId  LIMIT 1];            
            if(leadFinal != null){

                leadId = leadFinal.Id;
            } 

        } catch(Exception ex) {

            System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - Não conseguiu buscar pelo id meu sucesso');
            requestResult.message = ex.getMessage();

            try{
                leadFinal = [SELECT Id, Id_meu_sucesso__c, Owner.Type FROM Lead WHERE Id =: leadId  LIMIT 1];  
                leadId = leadFinal.Id;
            } catch(Exception etx) {
                System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - Não conseguiu buscar pelo id normal');
                requestResult.message = etx.getMessage();
                throw new MyException('Lead não encontrato', etx);
            } 

        } // Fim try/catch
        
        if(leadFinal == null) {
            throw new MyException('Lead não encontrato');        
        }else{
            if(leadFinal.Owner.Type == 'Queue'){
                try{                    
                    leadFinal.OwnerId = UserInfo.getUserId();
                    update leadFinal;
                } catch(Exception ex){
                    throw new MyException('Não conseguiu atribuir dono ao lead.', ex);                     
                }
            }
        
        }

        //Agora vamos verificar se já existe conta ou oportunidade com esse id externo.
        Opportunity opp = null;
        Account acc = null;

        try{
            opp = [SELECT Id, Id_meu_sucesso__c FROM Opportunity WHERE Id_meu_sucesso__c =: leadFinal.Id_meu_sucesso__c ];
        } catch(Exception ex){
            System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - Não achou opp');
        }

        try{
            acc = [SELECT Id, Id_meu_sucesso__c  FROM Account WHERE Id_meu_sucesso__c =: leadFinal.Id_meu_sucesso__c ];
        } catch(Exception ex){
            System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - Não achou opp');
        }

        if(acc != null){

            requestResult.message = 'Conta já existe.';            
            throw new MyException('Conta já existe');
        }

        if(opp != null){
          
            throw new MyException('Oportunidade já existe');  
        }

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        if(!Test.isRunningTest())lc.setDoNotCreateOpportunity(!leadConverterConfig.Gerar_oportunidade_conversao__c);
        else lc.setDoNotCreateOpportunity(true);
    
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);           
        Database.LeadConvertResult lcr ;
        
        Id opportunityId = null;

        try{

            lcr = Database.convertLead(lc);

            System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - lcr.isSuccess(): '+lcr.isSuccess());

            requestResult.value = true;

            Lead l = [SELECT Id, ConvertedAccountId, ConvertedOpportunityId, Id_meu_sucesso__c, Owner.Type FROM Lead WHERE Id =: leadId];
            leadIdMeuSucesso = l.Id_meu_sucesso__c;

            opportunityId = l.ConvertedOpportunityId;

            requestResult.message = 'Lead convertido com sucesso conta =  ' + l.ConvertedAccountId;
            requestResult.AccountId = l.ConvertedAccountId;
            requestResult.OpportunityId = l.ConvertedOpportunityId;

        } catch(exception ex) {

            System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - NOT CONVERTED');
            System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - ex.getMessage(): '+ex.getMessage());          
            throw new MyException('Erro ao converter lead ' + ex.getMessage() + ' ' + ex.getLineNumber() ,ex);         
        }
        
        /*try{
            if(opportunityId != null){            
                opp = [SELECT Id_meu_sucesso__c, Id FROM Opportunity WHERE Id =: opportunityId];
                opp.Id_meu_sucesso__c = leadIdMeuSucesso;
                update opp;
            }

        }catch(Exception ex){

            System.debug(LoggingLevel.ERROR, '__ [cls RestLeadConvert] - ERROR - ex.getMessage(): '+ex.getMessage());
        }*/

        return requestResult;
    }

}