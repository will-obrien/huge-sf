@istest
public class ProspectUpdate_teste{
    public testmethod static void teste(){
        ProspectUpdate up = new ProspectUpdate();
        up.application  = '';
        up.prospectStatus  = '';
        up.reason  = '';
        List<Id> leads = new List<Id>();
        List<Lead> toUpdate = new List<Lead>();
        List<Lead> toInsert = new List<Lead>();
        
        for(Integer i = 0; i < 5; i++){
            Lead l = Teste_Util.newLeadNotInserted();
            toInsert.add(l);
        }
        
        insert toInsert;
        
        for(Integer i = 0; i< 5; i++){
            Lead l = toInsert[i];
            if(i == 0) l.Status  = 'Enviar para Ometznet';
            if(i == 1) l.Status  = 'Não qualificado';
            if(i == 2) l.Status  = 'Convertido';
            toUpdate.add(l);
            leads.add(l.Id);
        }
        
        update toUpdate;
        try{
            ProspectUpdate.futureIntegrateLead(leads);
        }catch(Exception ex){
        }
   }  
}