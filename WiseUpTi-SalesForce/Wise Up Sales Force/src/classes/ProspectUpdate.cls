public class ProspectUpdate{
    public String application {get;set;}
    public String prospectStatus {get;set;}
    public String reason {get;set;}
    public String vendorIdentifier {get; set;}
    public String pkProspect {get; set;}
    
     public ProspectUpdate(){
        
    }
    
    public ProspectUpdate(Lead l, String status){
    
        this.application = '318';
        this.prospectStatus = status;
        this.reason = l.Status;
        this.vendorIdentifier = l.OwnerId;
        this.pkProspect = l.Id_Ometznet__c;
        
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
        executar(lids, '');
    }
    
    @Future(callout = true)
    public static void futureIntegrateLead(List<String> lids, String status){
        executar(lids, '');
    }    
    
    public static void NoFutureIntegrateLead(List<String> lids, String status){
        executar(lids, status);
    }
    
    private static void executar(List<String> lids, String status){
        Trigger_Controller.Lead_trigger = false;
        
        List<Lead> leads = [SELECT Id, Status, Id_Ometznet__c, Motivo_envio_Ometznet__c FROM Lead WHERE Id in: lids];
         for(Lead l: leads){
             if(status != '') l.Status = status;
             
            try{
                system.debug('Lead antes: ' + l);
                logs.add(UpdateProspect(l));
                l.Status = 'Enviado para Ometznet';
                system.debug('Lead depois: ' + l);
            }catch(Exception ex){
                system.debug('cls__ ProspectUpdate- erro: ' + ex.getMessage() + '-' + ex.getLineNumber());
            }
        }
        insert logs;
        Database.update(leads, false);
    }
    
    public static Log_integracao__c UpdateProspect(Lead l){
        String Status = '';
        if(l.Status == 'Enviar para Ometznet'){
             Status = 'CONTACT';
             if(l.Motivo_envio_Ometznet__c == null){
                 l.Motivo_envio_Ometznet__c = 'Passadas 24 horas';
             }  
        }
        else if(l.Status == 'Não qualificado') Status = 'SF_ARCHIVED';
        else if(l.Status == 'Convertido') Status = 'SF_CONVERTED';
        else Status = 'SF_OPPORTUNITY';
        ProspectUpdate lpud = new ProspectUpdate(l, Status);
        if(l.Status != 'Convertido'){
            lpud.Reason =  l.Motivo_envio_Ometznet__c != null ? l.Motivo_envio_Ometznet__c : l.Status;
        } else {
            lpud.Reason = 'Convertido para conta, iniciando trabalhos da oportunidade em breve.';
        }
        Map<String, String> headers = new Map<String,String>();
        headers.put('Cache-Control','no-cache');
        headers.put('Accept', 'application/json');
        headers.put('Content-Type', 'application/x-www-form-urlencoded');
        String AmbienteName = OrganizationDAO.IsSandbox() ? 'Staging' : 'Production';
        Dados_integracao__c dados = Dados_integracao__c.getAll().get(AmbienteName);
        String body = lpud.serializeToMultipart();
        Log_integracao__c log = SFRequest.doIt(l.Id, l.Id, 'OmetzPlatform', dados.URL_chamada__c + dados.Atualizacao_status_prospect__c + l.Id_ometznet__c, body, 'POST', headers);
        System.debug('cls__ProspectUpdate - log: ' + log);
        try{
            Integracao_Util.RequestResult req = (Integracao_Util.RequestResult)JSON.deserialize(log.XML_resposta__c,Integracao_Util.RequestResult.class);   
            
        }catch(Exception ex){
            System.debug('cls__ ProspectUpdate - erro- ' + ex.getMessage() + ' - ' + ex.getLineNumber());
        }
        return log;
    }

    
}