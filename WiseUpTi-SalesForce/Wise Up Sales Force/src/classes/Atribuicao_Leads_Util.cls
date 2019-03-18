/*
    Atribuição dos Leads para os estados determinados pelo campo Área de Atuação do Usuário
*/

public class Atribuicao_Leads_Util{

    /*public static void exec(List<Lead> leads, String idFila){    
        
        system.debug('ROLETA ');
        Atribuicao_Leads_Controle.executar = false;
        
        idFila = idFila.substring(0, 15);

        Distribuicao_Leads__c params = Distribuicao_Leads__c.getAll().get(idFila);
        
        String ultimoFila = (params == null ? '' : params.Ultimo_fila__c);

        if(params == null){
            params = new Distribuicao_Leads__c();
            params.Name = idFila;
        }

        List<Id> idUsuarioFila = new List<Id>();
    
        for(GroupMember g :
                [SELECT UserOrGroupId 
                FROM GroupMember
                WHERE GroupId =: idFila]){
            if(!String.valueOf(g.UserOrGroupId).startsWith('00G')) idUsuarioFila.add(g.UserOrGroupId);
        }
        
        if(idUsuarioFila.size() == 0) return;

        String proximoFila = '';
        Integer indexProximo = 0;
        
        for(Integer i = 0; i < idUsuarioFila.size(); i ++){
            if(ultimoFila == '' || ultimoFila == null){
                proximoFila = idUsuarioFila.get(i);
                indexProximo = i;
                break;
            }else if(ultimoFila == idUsuarioFila.get(i)){
                try{
                    proximoFila = idUsuarioFila.get(i + 1);
                    indexProximo = i + 1;
                    break;   
                }catch(Exception e){
                    proximoFila = idUsuarioFila.get(0);
                    indexProximo = 0;
                    break;
                }
            }
        }

        if(proximoFila == '' || proximoFila == null){
            proximoFila = idUsuarioFila.get(0);
            indexProximo = 0;
        }

        List<Lead> listaLeads = new List<Lead>();
        
        for(Lead iLead : leads){
            Lead l = new Lead(Id = iLead.Id);
            l.OwnerId = idUsuarioFila.get(indexProximo);
            listaLeads.add(l);
            indexProximo ++;
            if(indexProximo > idUsuarioFila.size()-1) indexProximo = 0;
        }

        integer Ultimo = (indexProximo - 1) <= 0 ? idUsuarioFila.size() - 1 : (indexProximo - 1);
        
        if(idUsuarioFila.get(Ultimo) == null){
            params.Ultimo_fila__c = null;
        }else{
            params.Ultimo_fila__c = idUsuarioFila.get(Ultimo);
        }
        
        upsert params;
          
        if(listaLeads.size() > 0) update listaLeads;
    }*/
}