/*

    Classe Membros_Campanha_Handler
    Classe de teste: Membros_Campanha_Handler_Teste
    Autor: Mario Reis
    Data de criação: 03/06/2016
    Overview: Classe para realizar funcionalidades referentes aos Membros da Campanha

*/

public class Membros_Campanha_Handler{

    public static boolean verificarDuplicidadeLeads(List<CampaignMember> listaMC){

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler - verificarDuplicidadeLeads] - Start');
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaMC: '+listaMC);

        Set<Id> listaIdLeadMC = new Set<Id>();
        Map<Id, CampaignMember> mapIdCM = new Map<Id, CampaignMember>();

        for(CampaignMember cm : listaMC){

            listaIdLeadMC.add(cm.LeadId);
            mapIdCM.put(cm.LeadId, cm);
        }

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaIdLeadMC: '+listaIdLeadMC);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - mapIdCM: '+mapIdCM);
    
        List<String> listaEmailLead = new List<String>();
        Map<String, CampaignMember> mapEmailCM = new Map<String, CampaignMember>();

        for(Lead l : [SELECT Id, Name, Email FROM Lead WHERE Id IN: listaIdLeadMC AND isConverted = false AND Email <> '']){

            listaEmailLead.add(l.Email);
            mapEmailCM.put(l.Email, mapIdCM.get(l.Id));
        }

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaEmailLead: '+listaEmailLead);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - mapEmailCM: '+mapEmailCM);
        
        Set<Id> listaIdLeadExcluir = new Set<Id>();
        List<Lead> listaLeadExcluir = new List<Lead>();
        List<CampaignMember> listaCMExcluir = new List<CampaignMember>();
        List<CampaignMember> listaCMAdicionar = new List<CampaignMember>();

        for(Lead l : [SELECT Id, Name, Email FROM Lead WHERE Email IN: listaEmailLead AND Id NOT IN: listaIdLeadMC AND isConverted = false AND Email <> '']){

            System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - l: '+l);

            if(mapEmailCM.get(l.Email) != null){

                CampaignMember cmExcluir = mapEmailCM.get(l.Email);
                CampaignMember cmAdicionar = new CampaignMember();

                if(cmExcluir.CampaignId != null) cmAdicionar.CampaignId = cmExcluir.CampaignId;
                if(cmExcluir.ContactId != null) cmAdicionar.ContactId = cmExcluir.ContactId;
                if(cmExcluir.LeadId != null) cmAdicionar.LeadId = l.Id;
                if(cmExcluir.Status != null) cmAdicionar.Status = cmExcluir.Status;

                listaIdLeadExcluir.add(cmExcluir.LeadId);
                listaCMAdicionar.add(cmAdicionar);
                listaCMExcluir.add(cmExcluir);
                
            }
        }

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaIdLeadExcluir: '+listaIdLeadExcluir);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaCMAdicionar: '+listaCMAdicionar);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaCMExcluir: '+listaCMExcluir);

        if(listaIdLeadExcluir.size() > 0) {

            for(Lead l : [SELECT Id FROM Lead WHERE Id IN: listaIdLeadExcluir]){

                listaLeadExcluir.add(l);
            }

            List<CampaignMember> listaUniqueExcluir = new List<CampaignMember>(); 
            Set<CampaignMember> listaSet = new Set<CampaignMember>();
 
            if(listaCMExcluir.size() > 0){ 
                for(CampaignMember a : listaCMExcluir){ 
                    if(listaSet.add(a)) listaUniqueExcluir.add(a); 
                }
            } 

            try{

                delete listaUniqueExcluir;
                delete listaLeadExcluir;
                insert listaCMAdicionar;
				
                return true;
            } catch(Exception e){

                System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - e.getMessage(): '+e.getMessage());
                
                return false;
            }
        }
        
        return false;
        
    } // Fim método verificarDuplicidade
	
    public static boolean verificarDuplicidadeContas(List<CampaignMember> listaMC){

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler - verificarDuplicidadeContas] - Start');
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaMC: '+listaMC);

        Set<Id> listaIdLeadMC = new Set<Id>();
        Map<Id, CampaignMember> mapIdCM = new Map<Id, CampaignMember>();

        for(CampaignMember cm : listaMC){

            listaIdLeadMC.add(cm.LeadId);
            mapIdCM.put(cm.LeadId, cm);
        }

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaIdLeadMC: '+listaIdLeadMC);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - mapIdCM: '+mapIdCM);
    
        List<String> listaEmailLead = new List<String>();
        Map<String, CampaignMember> mapEmailCM = new Map<String, CampaignMember>();

        for(Lead l : [SELECT Id, Name, Email FROM Lead WHERE Id IN: listaIdLeadMC AND isConverted = false AND Email <> '']){

            listaEmailLead.add(l.Email);
            mapEmailCM.put(l.Email, mapIdCM.get(l.Id));
        }

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaEmailLead: '+listaEmailLead);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - mapEmailCM: '+mapEmailCM);
        
        Set<Id> listaIdLeadExcluir = new Set<Id>();
        List<Lead> listaLeadExcluir = new List<Lead>();
        List<CampaignMember> listaCMExcluir = new List<CampaignMember>();
        List<CampaignMember> listaCMAdicionar = new List<CampaignMember>();

        for(Account a : [SELECT Id, Name, PersonContactId, PersonEmail FROM Account WHERE PersonEmail IN: listaEmailLead AND PersonContactId != null AND PersonEmail <> '']){

            System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - a: '+a);

            if(mapEmailCM.get(a.PersonEmail) != null){

                CampaignMember cmExcluir = mapEmailCM.get(a.PersonEmail);
                CampaignMember cmAdicionar = new CampaignMember();

                if(cmExcluir.CampaignId != null) cmAdicionar.CampaignId = cmExcluir.CampaignId;
                                                 cmAdicionar.ContactId = a.PersonContactId;
                if(cmExcluir.Status != null) cmAdicionar.Status = cmExcluir.Status;

                listaIdLeadExcluir.add(cmExcluir.LeadId);
                listaCMAdicionar.add(cmAdicionar);
                listaCMExcluir.add(cmExcluir);
                
            }
        }

        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaIdLeadExcluir: '+listaIdLeadExcluir);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaCMAdicionar: '+listaCMAdicionar);
        System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - listaCMExcluir: '+listaCMExcluir);

        if(listaIdLeadExcluir.size() > 0) {

            for(Lead l : [SELECT Id FROM Lead WHERE Id IN: listaIdLeadExcluir]){

                listaLeadExcluir.add(l);
            }

            List<CampaignMember> listaUniqueExcluir = new List<CampaignMember>(); 
            Set<CampaignMember> listaSet = new Set<CampaignMember>();
 
            if(listaCMExcluir.size() > 0){ 
                for(CampaignMember a : listaCMExcluir){ 
                    if(listaSet.add(a)) listaUniqueExcluir.add(a); 
                }
            } 

            try{

                delete listaUniqueExcluir;
                delete listaLeadExcluir;
                insert listaCMAdicionar;
                
				return true;
            } catch(Exception e){

                System.debug(LoggingLevel.ERROR, '__ [cls Membros_Campanha_Handler] - e.getMessage(): '+e.getMessage());
                
                return false;
            }
        }
        
        return false;
        
    } // Fim método verificarDuplicidade
}