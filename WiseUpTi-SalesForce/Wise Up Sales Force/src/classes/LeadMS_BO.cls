public class LeadMS_BO {
    
    public User userSistema;
    
    public ControleAtribuicaoComercial__c CAC = ControleAtribuicaoComercial__c.getInstance('meuSucesso #AUTO');
    
    
    public map<Id, User> mapComerciais = new map<Id, User>();
    public map<Id, Group> mapFilas = new map<Id, Group>();
    public map<String, Integer> mapLeadsPorComercial = new map<String, Integer>(); 
    public map<String, sObject> mapOwnerNames = new map<String, sObject>();
    
    public List<HistoricoAtribuicaoLead__c> listHAL = new List<HistoricoAtribuicaoLead__c>();
    public List<Lead> oldLeadsList; 
    public List<Lead> newLeadsList;
    public Map<Id,Lead> oldLeadsMap;
    public Map<Id,Lead> newLeadsMap;
    
    public LeadMS_BO(User userSistema, map<Id, Lead> oldLeadsMap, map<Id, Lead> newLeadsMap){
        
        this.oldLeadsList = new List<Lead>(oldLeadsMap.Values());
        this.newLeadsList = new List<Lead>(newLeadsMap.Values());
        this.oldLeadsMap = new Map<Id, Lead>(oldLeadsMap);
        this.newLeadsMap = new Map<Id, Lead>(newLeadsMap);
        
        for(Group g : GroupDAO.listGroups()){
            mapFilas.put(g.Id, g);
        }
        
        userSistema = userSistema;
        
        for(User U : UserDAO.listUsersByDepartmentAndCompanyName('Comercial', 'meuSucesso.com')){
            this.mapComerciais.put(u.Id, u);
        }
        
        mapLeadsPorComercial = LeadDAO.counterLeadQueue();
        
        List<sObject> f = mapFilas.values();
        List<sObject> c = mapComerciais.values();
        
        mapOwnerNames.putAll(f);
        mapOwnerNames.putAll(c);
        
        
    }
    
    public void roletaAtribuirLeadMS(){
        
        for(Lead newLead : newLeadsList){    

            Lead oldLead = oldLeadsMap.get(newLead.Id);
            
            priorizarLEAD(newLead, oldLead);

            if(newLead.Status == 'Novo' && newLead.OwnerId != oldLead.OwnerId && newLead.OwnerId == CAC.IdFilaRoleta__c && newLead.UsuarioComercialAtribuido__c == null){
                Integer next = 0;
                List<Id> sIds = new List<Id>(mapComerciais.KeySet());
                
                for(String sId : sIds){                
                    next++;
                    if(CAC.IdUltimoComercial__c == sId){
                        if(next > sIds.size() - 1){    	
                            CAC.IdUltimoComercial__c = sIds[0];
                        }else{
                            CAC.IdUltimoComercial__c = sIds[next];
                        }
                        break;
                    }    
                } 
                
                if(CAC.IdUltimoComercial__c == null){
                    CAC.IdUltimoComercial__c = sIds[0];
                }
                
                
                upsert CAC;
                
                newLead.OwnerId = CAC.IdUltimoComercial__c;

                system.debug('CAC.IdUltimoComercial__c: ' + CAC.IdUltimoComercial__c);
                
                if(limiteDiarioExcedido(CAC.IdUltimoComercial__c)){
                    novoLogAtribuicao(newLead, oldLead, 'Limite diário de leads atingido para o comercial (' + (String)mapOwnerNames.get(newLead.OwnerId).get('Name') + ')');
                    newLead.OwnerId = oldLead.OwnerId;   
                    newLead.Data_para_reatribuir_lead__c = Datetime.newInstance(system.today().addDays(1), Time.newInstance(0, 1, 0, 0));
                    newLead.UsuarioComercialAtribuido__c = null;
                    newLead.DataAtribuicaoComercial__c = null;                                         
                }else{
                    novoLogAtribuicao(newLead, oldLead, '');
                    newLead.OwnerId = CAC.IdUltimoComercial__c;    
                    newLead.Data_para_reatribuir_lead__c = null;
                    newLead.UsuarioComercialAtribuido__c = newLead.OwnerId;
                    newLead.DataAtribuicaoComercial__c = system.now();      
                }
                
            }else if(oldLead.UsuarioComercialAtribuido__c != null && newLead.OwnerId.getSObjectType() ==  Schema.Group.SObjectType){
                novoLogAtribuicao(newLead, oldLead, 'Lead já atribuido a comercial não pode retornar a uma fila.');
                newLead.OwnerId = oldLead.OwnerId;
            }
        }
        
        if(listHAL.size() > 0 ) INSERT listHAL;
        

    }
    
    private Boolean limiteDiarioExcedido(String comercialId){
        
        if(mapComerciais.containsKey(comercialId)){
            Integer sumLeadCom = mapLeadsPorComercial.get(comercialId) == null ? 1 : mapLeadsPorComercial.get(comercialId) + 1;
            
            if(sumLeadCom > CAC.LimiteLeads__c){
                return true;
            }else{
                return false;
            }
            Integer sumUpdate = mapLeadsPorComercial.get(comercialId) + 1;
            mapLeadsPorComercial.put(comercialId, sumUpdate);
        }
        
        return false;
        
    }
    
    private void priorizarLEAD(Lead newLead, Lead oldLead){
        if(newLead.Prioridade__c > oldLead.Prioridade__c){
            newLead.LeadSource = oldLead.LeadSource;
            
            if(newLead.UsuarioComercialAtribuido__c != null){ //String.ValueOf(oldLead.OwnerId).startsWith('005')){
                system.debug('Comercial já atribuido, retornar para 1º comercial atribuido.');
                newLead.OwnerId = newLead.UsuarioComercialAtribuido__c;
            }
        }
    }   

	private void novoLogAtribuicao(Lead newLead, Lead oldLead, String Status){
        HistoricoAtribuicaoLead__c h = new HistoricoAtribuicaoLead__c();
        
        h.Lead__c = newLead.Id;
        h.Data_Hora__c = system.now();
        h.NovoProprietario__c = mapOwnerNames.containsKey(newLead.OwnerId) ? String.valueOf(mapOwnerNames.get(newLead.OwnerId).get('Name')) : '';
        h.AntigoProprietario__c = mapOwnerNames.containsKey(oldLead.OwnerId) ? String.valueOf(mapOwnerNames.get(oldLead.OwnerId).get('Name')) : '';
        h.TipoAntigoProprietario__c = String.ValueOf(oldLead.OwnerId.getSObjectType());
        h.TipoNovoProprietario__c = String.ValueOf(newLead.OwnerId.getSObjectType());
        h.Status__c = Status;
        
        listHAL.add(h);
    }        
    
    
}