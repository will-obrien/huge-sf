/*
    Classe de testes: Conta_Trigger_Teste
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

trigger Conta_Trigger on Account (after insert, after update) {

    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
        if(Triggers__c.getOrgDefaults().Oportunidade_Trigger__c == false)return; //verificar o que est[a acontecendo
        
        if(Trigger_Controller.Accoutn_controller == false) return;
        
        Trigger_Controller.Accoutn_controller = false;

        List<String> accs = new List<String>();   
       
        for(Account acc: trigger.New){
            if(acc.isPersonAccount && acc.Idade__pc >= 18  &&
              acc.CPF__pc != '' && acc.CPF__pc <> null &&
              ((trigger.isUpdate && acc.CPF__pc <> trigger.oldMap.get(acc.Id).CPF__pc) || trigger.isInsert)){
                accs.add(acc.Id);
            }
        }
        
        if(accs.size() > 0) ClientePotencial.futureIntegrateAcc(accs);
    }
}