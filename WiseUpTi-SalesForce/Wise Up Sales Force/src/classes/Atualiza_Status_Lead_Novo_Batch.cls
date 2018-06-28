global class Atualiza_Status_Lead_Novo_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts{

    global String query;
        
    global Database.QueryLocator start(Database.BatchableContext BC){
               
        system.debug(LoggingLevel.ERROR,'[Atualiza_Status_Lead_Novo_Batch - start] - query: ' +query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Trigger_Controller.Lead_trigger = false;
        
        List<String> listaLeads = new List<String>();
        
        system.debug(LoggingLevel.ERROR,'[Atualiza_Status_Lead_Novo_Batch - execute] - scope: ' +scope);
        
        for(sobject s : scope){
            Lead l = (Lead) s;
            listaLeads.add(l.Id);
        }
        
        system.debug(LoggingLevel.ERROR,'[Atualiza_Status_Lead_Novo_Batch - execute] - listaLeads: ' +listaLeads);
        
        if(listaLeads.size() > 0){ 
//            update listaLeads;
            ProspectUpdate.NoFutureIntegrateLead(listaLeads, 'Enviar para Ometznet');
        }
        
        system.debug(LoggingLevel.ERROR,'[Atualiza_Status_Lead_Novo_Batch - finish]');
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug(LoggingLevel.ERROR,'[Atualiza_Preco_Padrao_Batch - execute] - finish...');
    }

}