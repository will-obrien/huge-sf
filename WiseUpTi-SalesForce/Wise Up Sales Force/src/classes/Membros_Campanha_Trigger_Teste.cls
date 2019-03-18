/*

    Classe de teste para: Trigger Membros_Campanha_Trigger Membros_Campanha_Handler
    Autor: Mario Reis
    Data de criação: 03/06/2016

*/

@isTest
public class Membros_Campanha_Trigger_Teste{

    public static testmethod void teste(){

        Teste_Util.createParams();

        List<CampaignMember> listaMC = new List<CampaignMember>();

        Lead lead1 = Teste_Util.newLead();
        lead1.Email = 'emaillead@email.com';
        update lead1;

        Campaign cam1 = Teste_Util.newCampaign();
        CampaignMember cm1 = Teste_Util.newCampaignMember(cam1.Id, lead1.Id);

        listaMC.add(cm1);

        Boolean retorno = Membros_Campanha_Handler.verificarDuplicidadeLeads(listaMC);

        Lead lead2 = Teste_Util.newLead();
        lead2.Email = 'emaillead@email.com';
        update lead2;

        Campaign cam2 = Teste_Util.newCampaign();
        CampaignMember cm2 = Teste_Util.newCampaignMember(cam2.Id, lead2.Id);

        listaMC = new List<CampaignMember>();
        listaMC.add(cm2);

        Boolean retorno2 = Membros_Campanha_Handler.verificarDuplicidadeLeads(listaMC);
    }
    
    public static testmethod void teste2(){

        Teste_Util.createParams();

        List<CampaignMember> listaMC = new List<CampaignMember>();

        Account conta = Teste_Util.newAccount();
        conta.PersonEmail = 'emailconta@email.com';
        update conta;

        Lead lead2 = Teste_Util.newLead();
        lead2.Email = 'emailconta@email.com';
        update lead2;

        Campaign cam2 = Teste_Util.newCampaign();
        CampaignMember cm2 = Teste_Util.newCampaignMember(cam2.Id, lead2.Id);

        listaMC = new List<CampaignMember>();
        listaMC.add(cm2);

        Boolean retorno = Membros_Campanha_Handler.verificarDuplicidadeContas(listaMC);
    }
}