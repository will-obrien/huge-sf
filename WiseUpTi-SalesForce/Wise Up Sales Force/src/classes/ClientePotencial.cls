public class ClientePotencial {

    public String studentName {get; set;} 
    public String studentBorn {get; set;}
    public String studentCpf {get; set;}
    public String clientName {get; set;}
    public String clientCpf { get; set; }
    
    public ClientePotencial(){
        
    }
    
    public ClientePotencial(Lead base){
    
        this.studentName = base.Name;
        this.studentBorn = base.Data_nascimento__c.Year() + '-' + base.Data_nascimento__c.Month() + '-' + base.Data_nascimento__c.Day();
        this.studentCpf = base.CPF__c.replace('.','').replace('-',''); 
    
    }

    public ClientePotencial(Account base){
        this.studentName = base.Name;
        this.studentBorn = base.PersonBirthdate.Year() + '-' + base.PersonBirthdate.Month() + '-' + base.PersonBirthdate.Day();
        this.studentCpf = base.CPF__pc.replace('.','').replace('-','');
    }

    public void setResponsavel(String clientName, String clientCPF){
        this.clientName = clientName;
        this.clientCpf = clientCPF.replace('.','').replace('-','');
    }

    public String serializeToJson(){
        return JSON.serialize(this);        
    }

    public String serializeToMultipart(){
        return Integracao_Util.Serialize_multipart(this);
    }


    public static void validaCPFLead(String leadId, String clientName, String clientCPF){
        Lead l = [SELECT Id, Name, Data_nascimento__c, CPF__c, CPF_validado__c FROM Lead WHERE Id=: leadId];
        ClientePotencial cliente = new ClientePotencial(l);
        if(clientName != null && clientCPF != null) cliente.setResponsavel(clientName,clientCPF);
        Map<String, String> headers = new Map<String,String>();
        headers.put('Cache-Control','no-cache');
        headers.put('Accept', 'application/json');
        headers.put('Content-Type', 'application/x-www-form-urlencoded');
        String AmbienteName = OrganizationDAO.IsSandbox() ? 'Staging' : 'Production';
        Dados_integracao__c dados = Dados_integracao__c.getAll().get(AmbienteName);
        String body = cliente.serializeToMultipart();
        Log_integracao__c log = SFRequest.doIt(leadId, l.Name, 'OmetzPlatform', dados.URL_chamada__c + dados.Validacao_cpf_teens__c, body, 'POST', headers);
        try{
            Integracao_Util.RequestResult req = (Integracao_Util.RequestResult)JSON.deserialize(log.XML_resposta__c,Integracao_Util.RequestResult.class);
            if(req.value) l.CPF_validado__c = true;
        }catch(Exception ex){
        }
        update l;
        upsert log;
    }

    @Future(callout = true)
    public static void futureValidaCPFLead(String leadId, String clientName, String clientCPF){
        Trigger_Controller.Accoutn_Controller = false;
        validaCPFLead(leadId,clientName,clientCPF);
    }


    public static Log_integracao__c validaCPFAccount(Account acc, String clientName, String clientCPF){        
        ClientePotencial cliente = new ClientePotencial(acc);
        if(clientName != null && clientCPF != null) cliente.setResponsavel(clientName,clientCPF);
        Map<String, String> headers = new Map<String,String>();
        headers.put('Cache-Control','no-cache');
        headers.put('Accept', 'application/json');
        headers.put('Content-Type', 'application/x-www-form-urlencoded');
        String AmbienteName = OrganizationDAO.IsSandbox() ? 'Staging' : 'Production';
        Dados_integracao__c dados = Dados_integracao__c.getAll().get(AmbienteName);
        String body = cliente.serializeToMultipart();
        Log_integracao__c log = SFRequest.doIt(acc.Id, acc.Name, 'OmetzPlatform', dados.URL_chamada__c + dados.Validacao_cpf_teens__c, body, 'POST', headers);
        try{
            Integracao_Util.RequestResult req = (Integracao_Util.RequestResult)JSON.deserialize(log.XML_resposta__c,Integracao_Util.RequestResult.class);
            if(req.value) acc.CPF_validado__c = true;
        }catch(Exception ex){
            Integracao_Util.errorAccountResult req = (Integracao_Util.errorAccountResult)JSON.deserialize(log.XML_resposta__c,Integracao_Util.errorAccountResult.class);
            acc.Status_integracao_ometznet__c = req.message;
        }
        return log;
    }
    
    private static List<Log_integracao__c> logs = new List<Log_integracao__c>();
    @future(callout = true)
    public static void futureIntegrateAcc(List<String> accIds){
        Trigger_Controller.Accoutn_Controller = false;
        List<Account> accs = [SELECT Id, Idade__pc, Name, PersonBirthdate, CPF__pc, CPF_validado__c, Status_integracao_ometznet__c , (SELECT Idade__c, Name, CPF__c FROM Contacts) FROM Account WHERE Id in: accIds];
        List<Account> upAccs = new List<Account>();
        for(Account acc : accs){
            try{
                String clientName, clientCPF;
                if(acc.Contacts.size() > 0 && acc.Idade__pc < 18){
                    for(Contact c : acc.Contacts){
                        if(c.Idade__c >= 18){
                            clientName = c.name;
                            clientCpf = c.CPF__c;
                        }
                    }
                }
                logs.add(validaCPFAccount(acc,clientName,clientCPF));
                System.debug('___cls ClientePOtencial - conta' + acc); 
                upAccs.add(new Account(Id = acc.Id, CPF_validado__c = acc.CPF_validado__c , Status_integracao_ometznet__c = acc.Status_integracao_ometznet__c ));
            }catch(Exception ex){
                system.debug('cls__ ClientePotencial - erro: ' + ex.getMessage() + '-' + ex.getLineNumber());
            }
        }
        insert logs;
        update upAccs;
    }
    
    
    public static void handleMinor(Map<Id, ID> mapMenorResponsavel){
        List<Id> menoresId = new List<Id>();
        menoresId.addAll(mapMenorResponsavel.keySet());
        List<Id> responsaveisId = new List<Id>();
        for(Id key : mapMenorResponsavel.keySet()){
            responsaveisId.add(mapMenorResponsavel.get(key));
        }
        List<Account> menores = new List<Account>();
        Map<Id, Id> mapMenorIdResponsavelConta = new Map<Id, Id>();
        //Buscar as contas
        menores = [SELECT Id, CPF__pc, CPF_validado__c, PersonBirthDate, Name FROM Account WHERE Id in: menoresId];
        //Verificar se o menor está validado
        for(Account menor : menores){
            if(!menor.CPF_validado__c){
                mapMenorIdResponsavelConta.put(menor.Id, mapMenorResponsavel.get(menor.Id));            
                
            }
        }
        //Se não estiver fazer a chamada future
        futureValidateMenor(mapMenorIdResponsavelConta);
        
    }
    
    @future(callout = true)
    public static void futureValidateMenor(Map<Id, ID> mapMenorResponsavel){        
        Trigger_Controller.Accoutn_Controller = false;
        system.debug('cls__ ClientePotencial - map: ' + mapMenorResponsavel);
        List<Account> accs = [SELECT Id, Idade__pc, Name, PersonBirthdate, CPF__pc, CPF_validado__c FROM Account WHERE Id in: mapMenorResponsavel.keySet()];
        List<Id> responsaveisId = new List<Id>();
        for(Id key : mapMenorResponsavel.keySet()){
            responsaveisId.add(mapMenorResponsavel.get(key));
        }
        system.debug('cls__ ClientePotencial - resIDs: ' + responsaveisId);
        List<Contact> respos = [SELECT Id, Name, Birthdate, CPF__c FROM Contact WHERE Id in: responsaveisId];
        List<Account> upAccs = new List<Account>();
        for(Account acc : accs){
            system.debug('cls__ ClientePotencial - conta: ' + acc);
            try{
                String clientName, clientCPF;
                system.debug('cls__ ClientePotencial - responsaveis: ' + respos);
                for(Contact res : respos){
                    if(res.Id == mapMenorResponsavel.get(acc.Id)){ 
                        system.debug('cls__ ClientePotencial - responsável : ' + res);                                   
                        clientName = res.Name;
                        clientCPF = res.CPF__c;
                    }
                }
                logs.add(validaCPFAccount(acc,clientName,clientCPF));
                upAccs.add(new Account(Id = acc.Id, CPF_validado__c = acc.CPF_validado__c  ));
            }catch(Exception ex){
                system.debug('cls__ ClientePotencial - erro: ' + ex.getMessage() + '-' + ex.getLineNumber());
            }
        }
        insert logs;
        Trigger_Controller.Accoutn_controller = false;
        update upAccs;        
    }


   



}