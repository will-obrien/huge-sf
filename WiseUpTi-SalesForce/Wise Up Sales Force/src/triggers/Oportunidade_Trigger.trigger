/*
    Classe de testes: Oportunidade_Trigger_Teste
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

trigger Oportunidade_Trigger on Opportunity (after update) {

    if(trigger.isAfter && trigger.isUpdate){
        if(Triggers__c.getOrgDefaults().Oportunidade_Trigger__c == false)return; //verificar o que est[a acontecendo
        
        if(Trigger_Controller.Oportunidade_Controller == false) return;
        
        Trigger_Controller.Oportunidade_Controller = false;
        List<String> oportunidades = new List<String>();

        Map<Id, ID> mapMenorResponsavel = new Map<Id,Id>(); //vamos mapear o menor e o responsável para validar o CPF
        
        for(Opportunity opp : trigger.New){
            if(opp.StageName != trigger.oldMap.get(opp.Id).StageName && opp.StageName == 'Matrícula paga'){
                oportunidades.add(opp.Id);
            }
            if(opp.Responsavel__c != null && opp.StageName == 'Trabalhando'){
                mapMenorResponsavel.put(opp.AccountId, opp.Responsavel__c);
            }
        }
        
        if(oportunidades.size() > 0)PreAplication.futureIntegrateOpp(oportunidades);
        
        if(mapMenorResponsavel.size() > 0) ClientePotencial.handleMinor(mapMenorResponsavel);
    }

}