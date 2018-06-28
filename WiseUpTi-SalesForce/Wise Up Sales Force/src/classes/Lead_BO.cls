public class Lead_BO {
    
 // public List<String> Departments = new List<String>();
    // public List<String> CompanyNames = new List<String>();
    // public List<HistoricoAtribuicaoLead__c> historyLeads = new  List<HistoricoAtribuicaoLead__c>();
    
    // public map<Id, Group> mapFilas = new map<Id, Group>();
    // public map<Id, RecordType> mapRecs = new map<Id, RecordType>();
    // public map<String, String> mapOwnerNames = new map<String, String>();
    // public map<String, Integer> mapLeadsPorComercial = new map<String, Integer>(); 
    // public map<String, map<Id, User>> mapComerciaisByCompany = new map<String, map<Id, User>>();
    
    // public List<HistoricoAtribuicaoLead__c> listHistAtribucaoLead = new List<HistoricoAtribuicaoLead__c>();
    
    // public LeadMS_BO MS_BO;
    // public LeadWUP_BO WUP_BO;
    
    // public List<Lead> oldLeadsList; 
    // public List<Lead> newLeadsList;
    // public Map<Id,Lead> oldLeadsMap;
    // public Map<Id,Lead> newLeadsMap;
    
    // public Lead_BO(User userSistema, map<Id, Lead> oldLeadsMap, map<Id, Lead> newLeadsMap){
        // this.oldLeadsList = new List<Lead>(oldLeadsMap.Values());
        // this.newLeadsList = new List<Lead>(newLeadsMap.Values());
        // this.oldLeadsMap = new Map<Id, Lead>(oldLeadsMap);
        // this.newLeadsMap = new Map<Id, Lead>(newLeadsMap);
        
        // mapOwnerNames.put(userSistema.Id, userSistema.Name);
        
        // Departments.add('Comercial');
        // CompanyNames.add('meuSucesso.com');
        // CompanyNames.add('Wise Up');
        
        // for(User U : UserDAO.listUsersByDepartmentsAndCompanyNames(Departments, CompanyNames)){
            // if(mapComerciaisByCompany.containsKey(u.CompanyName) ){
                // map<Id, User> m = mapComerciaisByCompany.get(u.CompanyName);
                // m.put(U.Id, U);
                // mapComerciaisByCompany.put(u.CompanyName, m);
            // }else{
                // mapComerciaisByCompany.put(u.CompanyName, new map<Id, User>{U.Id => U});
            // }
            // mapOwnerNames.put(u.Id, u.Name);
        // }
        
        // for(Group g : GroupDAO.listGroups()){
            // mapOwnerNames.put(g.Id, g.Name);
            // mapFilas.put(g.Id, g);
        // } 
        
        // map<String, Integer> mapLeadsPorComercial = LeadDAO.counterLeadQueue();
        
        // if(mapComerciaisByCompany.get('meuSucesso.com') != null)
            // MS_BO = new LeadMS_BO(userSistema, mapComerciaisByCompany.get('meuSucesso.com'), mapFilas, mapLeadsPorComercial);
        
        // if(mapComerciaisByCompany.get('Wise Up') != null)
            // WUP_BO = new LeadWUP_BO(userSistema, mapComerciaisByCompany.get('Wise Up'), mapFilas, mapLeadsPorComercial);
        
    // }   
    
    // public void process(Lead newLead, Lead oldLead){
        // priorizarLEAD(newLead, oldLead);
        // atribuirLEAD(newLead, oldLead);
    // }   
    
    // public void finish(){
        // system.debug('LOG  ' + historyLeads);
        // historyLeads.addAll(MS_BO.listHAL);
        // INSERT historyLeads;
    // }
    
    // private void priorizarLEAD(Lead newLead, Lead oldLead){
        // if(newLead.Prioridade__c > oldLead.Prioridade__c){
            // newLead.LeadSource = oldLead.LeadSource;
            
            // if(newLead.UsuarioComercialAtribuido__c != null){ //String.ValueOf(oldLead.OwnerId).startsWith('005')){
                // system.debug('Comercial já atribuido, retornar para 1º comercial atribuido.');
                // newLead.OwnerId = newLead.UsuarioComercialAtribuido__c;
            // }
        // }
    // }
    
    // private void atribuirLEAD(Lead newLead, Lead oldLead){
        // system.debug(LoggingLevel.INFO, 'Tipo de registro do Lead ' + mapRecs.get(newLead.RecordtypeId).Name);
        // if(newLead.OwnerId != oldLead.OwnerId){
            // novoLogAtribuicao(newLead, oldLead, '');
            // if(mapRecs.get(newLead.RecordtypeId).Name == 'Wise Up'){
                // String Status = WUP_BO.atribuirLeadWUP(newLead, oldLead);
                // novoLogAtribuicao(newLead, oldLead, Status);
            // }else if(mapRecs.get(newLead.RecordtypeId).Name == 'meuSucesso.com'){
                // String Status = MS_BO.atribuirLeadMS(newLead, oldLead);
                // novoLogAtribuicao(newLead, oldLead, Status);
            // } 
        // }
    // }
    
    // private void novoLogAtribuicao(Lead newLead, Lead oldLead, String Status){
        // HistoricoAtribuicaoLead__c h = new HistoricoAtribuicaoLead__c();
        
        // h.Lead__c = newLead.Id;
        // h.Data_Hora__c = system.now();
        // h.NovoProprietario__c = mapOwnerNames.containsKey(newLead.OwnerId) ? (String)mapOwnerNames.get(newLead.OwnerId) : '';
        // h.AntigoProprietario__c = mapOwnerNames.containsKey(oldLead.OwnerId) ? (String)mapOwnerNames.get(oldLead.OwnerId) : '';
        // h.TipoAntigoProprietario__c = String.ValueOf(oldLead.OwnerId.getSObjectType());
        // h.TipoNovoProprietario__c = String.ValueOf(newLead.OwnerId.getSObjectType());
        // h.Status__c = Status;
        
        // listHistAtribucaoLead.add(h);
    // }    
    
}