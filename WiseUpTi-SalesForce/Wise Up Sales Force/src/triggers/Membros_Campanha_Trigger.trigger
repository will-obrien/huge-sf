/*

    Trigger Membros_Campanha_Trigger
    Classe de teste: Membros_Campanha_Trigger_Teste
    Autor: Mario Reis
    Data de criação: 03/06/2016
    Overview: Trigger para verificar os membros da campanha

*/

trigger Membros_Campanha_Trigger on CampaignMember (after insert, after update) {

    System.debug(LoggingLevel.ERROR, '__ [trg Lead_Trigger after update] - Start');

    if(Triggers__c.getOrgDefaults().Membros_Campanha_Trigger__c == false) return;
    
    if(Trigger_Controller.Membros_campanha_controller == false) return;

    Trigger_Controller.Membros_campanha_controller = false;

    Set<Id> setCM = new Set<Id>();

    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){

        List<CampaignMember> listaMC = [SELECT CampaignId, ContactId, LeadId, Name, Status FROM CampaignMember WHERE Id IN: trigger.new];

        if(listaMC.size() > 0){
            Boolean possuiLeads = Membros_Campanha_Handler.verificarDuplicidadeLeads(listaMC);
            if(!possuiLeads){
                Boolean possuiContas = Membros_Campanha_Handler.verificarDuplicidadeContas(listaMC);
            }
        } 
    }

}