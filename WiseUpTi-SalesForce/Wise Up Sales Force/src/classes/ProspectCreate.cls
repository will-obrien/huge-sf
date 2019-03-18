public class ProspectCreate {
    
    public String applicationPk {get;set;}
    public String sourceSlug {get;set;}
    public String nomeCompleto {get;set;}
    public String pkUser {get; set;}
    public Boolean isFromSalesforce {get; set;}
    public Boolean isSalesforce {get; set;}
    
    public ProspectCreate(){
        
    }
    
    public ProspectCreate(Lead l){
        
        this.applicationPk = '318';
        this.sourceSlug = 'referido';
        this.nomeCompleto = l.Nome_Completo__c;
        this.pkUser = '0';
        this.isFromSalesforce = true;
        this.isSalesforce = false;
        
    }
    
    public String serializeToJson(){
        return JSON.serialize(this);        
    }
    
    public String serializeToMultipart(){
        return Integracao_Util.Serialize_multipart(this);
    }
    
    private static List<Log_integracao__c> logs = new List<Log_integracao__c>();
    
    @Future(callout = true)
    public static void futureIntegrateLead(List<String> lids){
        executar(lids);
    }
    
    public static void NoFutureIntegrateLead(List<String> lids){
        executar(lids);
    }
    
    private static void executar(List<String> lids){
        Trigger_Controller.Lead_trigger = false;
        
        system.debug('Ids recebidos: ' + lids);
        List<Lead> leads = [SELECT Id, Nome_Completo__c FROM Lead WHERE Id in: lids];
        for(Lead l: leads){
            
            try{
                system.debug('Lead antes: ' + l);
                logs.add(CreateProspect(l));

                system.debug('Lead depois: ' + l);
            }catch(Exception ex){
                system.debug('cls__ ProspectUpdate- erro: ' + ex.getMessage() + '-' + ex.getLineNumber());
            }
        }
        insert logs;
        Database.update(leads, false);
    }
    
    public static Log_integracao__c CreateProspect(Lead l){
        
        Map<String, String> headers = new Map<String,String>();
        headers.put('Cache-Control','no-cache');
        headers.put('Accept', 'application/json');
        headers.put('Content-Type', 'application/x-www-form-urlencoded');
        
        String AmbienteName = OrganizationDAO.IsSandbox() ? 'Staging' : 'Production';
        
        Dados_integracao__c dados = Dados_integracao__c.getAll().get(AmbienteName);
        ProspectCreate lpud = new ProspectCreate(l);
        String body = lpud.serializeToMultipart();
        
        Log_integracao__c log = SFRequest.doIt(l.Id, l.Id, 'OmetzPlatform', dados.URL_chamada__c + dados.Criacao_Lead_OmtezNet__c, body, 'POST', headers);
        
        System.debug('cls__ProspectCreate - log: ' + log);
        
        try{
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(log.XML_resposta__c);
            
            l.Id_Ometznet__c = String.valueOf(m.get('pkProspect'));
            //l.trg_Integrar_Lead_OmetzNet__c = false;

            update l;
            
            
        }catch(Exception ex){
            System.debug('cls__ ProspectUpdate - erro- ' + ex.getMessage() + ' - ' + ex.getLineNumber());
        }
        return log;
    }
    
    
}