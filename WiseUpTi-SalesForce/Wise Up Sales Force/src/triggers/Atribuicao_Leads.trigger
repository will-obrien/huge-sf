/*
    Atribuição dos Leads para os estados determinados pelo campo Área de Atuação do Usuário

    Trabalha em conjunto com a classe: Atribuicao_Leads_Util
    
    Classe de teste: Atribuicao_Leads_Teste
*/

trigger Atribuicao_Leads on Lead (after update){
    
    /*if(!Atribuicao_Leads_Controle.executar) return;
   
    Set<Id> idFilas = new Set<Id>();
    List<Lead> leads = new List<Lead>();

    for(Group g : 
            [SELECT Id
            FROM Group 
            WHERE Type = 'Queue' 
                AND Name like '%#AUTO']){
        idFilas.add(g.Id);
    }
    
    for(Lead l : trigger.new){
        if(l.OwnerId != trigger.oldMap.get(l.Id).OwnerId){
            if(!l.IsConverted && idFilas.contains(l.OwnerId)) leads.add(l);
        }
    }

    if(leads.size() != 0) Atribuicao_Leads_Util.exec(leads, leads.get(0).OwnerId);*/
}