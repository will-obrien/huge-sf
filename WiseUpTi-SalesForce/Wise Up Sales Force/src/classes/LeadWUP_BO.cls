public class LeadWUP_BO {
    
    public User userSistema;
    
    public map<Id, User> mapComerciais = new map<Id, User>();
    //public map<String, Integer> mapLeadsPorComercial = new map<String, Integer>(); 
    public map<Id, Group> mapFilas = new map<Id, Group>();
    
    public List<Lead> oldLeadsList; 
    public List<Lead> newLeadsList;
    public Map<Id,Lead> oldLeadsMap;
    public Map<Id,Lead> newLeadsMap;
    
    //public Integer leadsLimit;
    public ControleAtribuicaoComercial__c CAC = new ControleAtribuicaoComercial__c();
    
    public LeadWUP_BO(User userSistema, map<Id, Lead> oldLeadsMap, map<Id, Lead> newLeadsMap){
        
        this.oldLeadsList = new List<Lead>(oldLeadsMap.Values());
        this.newLeadsList = new List<Lead>(newLeadsMap.Values());
        this.oldLeadsMap = new Map<Id, Lead>(oldLeadsMap);
        this.newLeadsMap = new Map<Id, Lead>(newLeadsMap);
        
        for(Group g : GroupDAO.listGroups()){
            mapFilas.put(g.Id, g);
        }
        
        this.userSistema = userSistema;
        
        List<User> Users = UserDAO.listUsersByDepartmentAndCompanyName('Comercial', 'Wise Up');
        for(User U : Users){
            this.mapComerciais.put(u.Id, u);
        }
        
        CAC = ControleAtribuicaoComercial__c.getInstance('Wise Up');
    }
    
    public void BU_ExecuteWFLead(){
        
        for(Lead l : newLeadsList){            
            
            if(l.WF_WUP_Devolver_lead_OmetzNet__c){
                
                l.Status = 'Enviar para Ometznet';
                l.WF_WUP_Devolver_lead_OmetzNet__c = false;
                ProspectUpdate.futureIntegrateLead(new List<String>{l.Id}, 'Enviar para Ometznet');
                
            }
            if(l.WF_WUP_Atribuir_diretor_comercial__c){
                
                if(UserInfo.getUserType() == 'PowerPartner'){
                    User usuario = UserDAO.getDiretorComercial(UserInfo.getUserId()); 
                    l.OwnerId = usuario.Contact.Account.Diretor_comercial__c;
                    l.WF_WUP_Atribuir_diretor_comercial__c = false;
                    //update l;
                }
                
            }
            
            if(l.WF_WUP_Integrar_lead_criado_SF__c){
                l.WF_WUP_Integrar_lead_criado_SF__c = false;
                ProspectCreate.FutureIntegrateLead(new List<String>{l.Id});    
            }
            
            
        }
    }
    
}