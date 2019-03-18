global class BatchLeadsForaDoFunil implements Database.Batchable<sObject> {
    
    global String query = 'SELECT Id, Leadsource, OwnerId, Prioridade__c FROM Lead WHERE Owner.Name IN (\'meuSucesso Live Class\', \'meuSucesso Aula Aberta\', \'meuSucesso Especiais\', \'meuSucesso Material Complementar\', \'meuSucesso Voe com os Anjos\') AND Data_Disponibilizacao_Lead__c < TODAY ORDER BY Data_Disponibilizacao_Lead__c DESC, UltimaIntegracao__c DESC, Prioridade__c';
    global ControleAtribuicaoComercial__c CAC = ControleAtribuicaoComercial__c.getInstance('meuSucesso #AUTO');
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        Integer SumLeads = [SELECT COUNT() FROM Lead WHERE UsuarioComercialAtribuido__c NOT IN (SELECT Id FROM User WHERE Department = 'Comercial' AND CompanyName = 'meuSucesso.com') AND DataAtribuicaoComercial__c = TODAY];
        
        Integer Comerciais = [SELECT COUNT() FROM User WHERE Department = 'Comercial' AND CompanyName = 'meuSucesso.com']; 
        Decimal LimitLeadCom = CAC.LimiteLeads__c;
        Integer Lim =  Integer.ValueOf(Math.abs((Comerciais * LimitLeadCom) - SumLeads));
        
        query = query + ' LIMIT ' + Lim;
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Lead> leadToUpdate = new List<Lead>();
        
        for(Lead l : (List<Lead>)Scope){
            Lead l2 = new Lead(Id = l.Id, OwnerId = CAC.IdFilaRoleta__c);     
            leadToUpdate.add(l2);
            system.debug('l2: ' + l2);
        }
        
        UPDATE leadToUpdate;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}