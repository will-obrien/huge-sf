public class Integracao_Oportunidade {

    public Integracao_Oportunidade(ApexPages.StandardController controller) {
          opp = 
            [SELECT Id
                    , Name
                    , Id_Ometznet__c
                    , Unidade_curso__r.Id_Ometznet__c
             		, Unidade_matriculadora__r.Id_Ometznet__c
                    , Data_inicio_curso__c
                    , Valor_investimento_unico__c
                    , Valor_mensal__c
                    , Account.FirstName
                    , Account.LastName
                    , Account.Data_nascimento__pc
                    , Responsavel__r.Name
             		, Responsavel__r.FirstName
             		, Responsavel__r.LastName
                    , Responsavel__r.CPF__c
                    , Account.CPF__pc
                    , Account.Nome_pai__pc
                    , Account.Nome_mae__pc
                    , Account.Genero__pc
                    , Account.RG__pc
                    , Account.Rua_endereco__pc
                    , Account.Numero_endereco__pc
                    , Account.Bairro_endereco__pc
                    , Account.Cidade_endereco__pc
                    , Account.Cep_endereco__pc
                    , Account.Pais_endereco__pc
                    , Account.PersonEmail
                    , Account.Phone
             		, Account.ID_ometznet__c
                    , Status_integracao_OmetzPlatform__c
                    , Vencimento_primeira_mensalidade__c
                    , StageName
                    , Owner.Id_ometznet__c
              		, (SELECT Product2.Id_Ometznet__c FROM OpportunityLineItems WHERE Product2.Forma_cobranca__c = 'Investimento único' LIMIT 1) 
            FROM Opportunity
            WHERE Id =: controller.getId()];
    }
    
     private Opportunity opp;
    
   
    
    public void integrar(){
        
        if(opp.StageName == 'Matrícula paga'){
            opp.Status_integracao_OmetzPlatform__c = null;   
            system.debug('Responsável ' + opp.Responsavel__c);
            PreAplication.integrateOpp(opp);
            //if(opp.Responsavel__c != null){
            //	PreAplication.integrateOpp(opp, opp.Responsavel__r.Name, opp.Responsavel__r.CPF__c);
            //}else{
            //    PreAplication.integrateOpp(opp, opp.Account.FirstName + ' ' + opp.Account.LastName, opp.Account.CPF__pc);
            //}
            
            if(opp.Status_integracao_OmetzPlatform__c == null) Pagina_Util.showError('Não foi possível executar a integração.');
            else if(opp.Status_integracao_OmetzPlatform__c.contains('Sucesso')) Pagina_Util.showConfirm('Oportunidade integrada com sucesso');
            else Pagina_Util.showError('Não foi possível integrar a oportunidade: ' + opp.Status_integracao_OmetzPlatform__c);      
        
        } else{
            Pagina_Util.showError('Somente oportunidades com matrícula paga podem ser enviadas ao OmetzNet');
        }
        
    }


}