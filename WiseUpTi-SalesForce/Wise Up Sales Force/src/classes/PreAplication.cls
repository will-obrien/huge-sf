/*
Classe de testes: PreAplication_teste

Atualizado por: Jonathan Valoto
Data: 05/08/2016
*/

public class PreAplication{
    public String pkProspect        { get; set; } 
    public String pkUnitDestiny     { get; set; }
    public String pkUnitOrigin      { get; set; } 
    public String pkProductCountry  { get; set; } 
    //public String countryErpId      { get; set; }
    //public String ufErpId           { get; set; }
    public String pkVendor          { get; set; } 
    
    public String startDate         { get; set; } 
    public String firstPaymentDate  { get; set; } 
    public Double enrollmentValue   { get; set; } 
    public Double monthlyPayment    { get; set; } 
    
    public String clientCpf         { get; set; } 
    //public String clientRealName    { get; set; } 
    public String clientFirstName   { get; set; } 
    public String clientLastName    { get; set; } 
    //public String clientBirthDate   { get; set; } 
    //public String clientGenre       { get; set; } 
    //public String clientMaritalStatus   { get; set; } 
    //public String clientRg          { get; set; } 
    //public String clientDDD         { get; set; } 
    //public String clientPhoneNumber { get; set; } 
    //public String clientCellphoneNumber   { get; set; } 
    //public String clientEmail       { get; set; } 
    //public String clientCep         { get; set; } 
    //public String clientCountryErpId   { get; set; } 
    //public String clientCountry     { get; set; } 
    //public String clientUfErpId     { get; set; } 
    //public String clientCityErpId   { get; set; }
    //public String clientCity        { get; set; }
    //public String clientNeighborhood   { get; set; }
    //public String clientAddress     { get; set; }
    //public String clientAddressNumber    { get; set; }
    
    public String studentFirstName  { get; set; } 
    public String studentLastName   { get; set; } 
    public String studentBorn       { get; set; } 
    public String studentCpf        { get; set; } 
    //public String studentFatherName { get; set; }
    //public String studentMotherName { get; set; }
    //public String studentMaritalStatus { get; set; }
    //public String studentGenre      { get; set; }
    //public String studentRg         { get; set; }
    //public String studentAddress    { get; set; }
    //public String studentAddressNumber { get; set; }
    //public String studentNeighborhood { get; set; }
    //public String studentCity       { get; set; }
    //public String studentCep        { get; set; }
    //public String studentCountry    { get; set; }
    //public String studentEmail      { get; set; }
    //public String studentDdd        { get; set; }
    //public String studentPhoneNumber { get; set; }
    //public String studentCountryErpId { get; set; }
    //public String studentUfErpId { get; set; }
    //public String studentCityErpId { get; set; }
    
    
    
    //public PreAplication(Opportunity opp, String clientCPF, String clientRealName){
    public PreAplication(Opportunity opp){
        //tratamento do campo gênero
        //String genero = opp.Account.Genero__pc.substring(0, 1);
        //this.studentGenre = genero;
        
        //tratamento do campo estado civil
        /*Map<String, String> m= new Map<String, String>();
m.put('Solteiro', '1');            
m.put('Casado', '2');
m.put('Divorciado', '3');
m.put('Viúvo', '4');
m.put('Companheiro', '5');
String valorEstadoCivil = m.get(opp.Account.Estado_civil__pc);*/
        
        //tratamento dos campos da data de nascimento
        //String mes = String.valueOf(opp.Account.PersonBirthDate.Month());
        //String dia = String.valueOf(opp.Account.PersonBirthDate.Day());
        
        //if(mes.length() < 2){
        //    mes = '0' + mes;
        //}
        //if(dia.length() < 2){
        //    dia = '0' + dia;
        //}
        
        //tratamento de ddd e telefone
        List<String> fone = new List<String>();
        fone = opp.Account.Phone.split(' ');
        
        
        //tratamento do campo CPF
        
        
        //String cpfNewStudent;
        //if(opp.Account.CPF__pc != null){
        //	String cpfStudent = String.valueOf(opp.Account.CPF__pc);
        //	this.studentCpf = cpfStudent.replaceAll('[.-]','');
        //}
        
        //this.studentMaritalStatus = valorEstadoCivil;
        this.pkProspect = opp.Account.ID_ometznet__c;
        this.pkUnitDestiny   = opp.Unidade_curso__r.Id_Ometznet__c;
        this.pkUnitOrigin = opp.Unidade_matriculadora__r.Id_Ometznet__c;
        this.pkProductCountry = opp.OpportunityLineItems[0].Product2.Id_Ometznet__c.remove('M');
        //this.countryErpId = opp.Account.Country_erp_id__c;
        //this.ufErpId = opp.Account.UF_erp_id__c;
        
        this.pkVendor = opp.Owner.Id_ometznet__c;
        
        this.startDate = String.valueOf(opp.Data_inicio_curso__c);//.Year() + '-' + opp.Data_inicio_curso__c.Month() + '-' +opp.Data_inicio_curso__c.Day();
        this.firstPaymentDate = String.valueOf(opp.Vencimento_primeira_mensalidade__c); //.Year() + '-' + opp.Vencimento_primeira_mensalidade__c.Month() + '-' +opp.Vencimento_primeira_mensalidade__c.Day();
        this.enrollmentValue   = opp.valor_investimento_unico__c;  
        this.monthlyPayment = opp.valor_mensal__c;
        
        if(opp.Responsavel__c != null){
            this.clientCpf = opp.Responsavel__r.CPF__c.replaceAll('[.-]', '');
            this.clientFirstName = opp.Responsavel__r.FirstName;
            this.clientLastName = opp.Responsavel__r.LastName;
        }else{
            this.clientCpf = String.valueOf(opp.Account.CPF__pc).replaceAll('[.-]', '');
            this.clientFirstName = opp.Account.FirstName;
            this.clientLastName = opp.Account.LastName;          
        }
        
        //this.clientCpf = cpfNewClient;
        //this.clientRealName = clientRealName; 
        //this.clientFirstName = opp.Account.FirstName; 
        //this.clientLastName = opp.Account.LastName;
        //this.clientBirthDate = opp.Account.PersonBirthDate.Year() + '-' + mes + '-' + dia; 
        //this.clientGenre = genero;
        //this.clientMaritalStatus = valorEstadoCivil; 
        //this.clientRg = opp.Account.RG__pc;
        //this.clientDDD = fone[1];
        //this.clientPhoneNumber = fone[2] + '-' +fone[3]; 
        //this.clientEmail = opp.Account.PersonEmail;
        //this.clientCep = opp.Account.Cep_endereco_cobranca__c;
        //this.clientCountryErpId= opp.Account.Country_erp_id__c; 
        //this.clientCountry = opp.Account.Pais_endereco_cobranca__c;
        //this.clientUfErpId = opp.Account.Uf_erp_id__c; 
        //this.clientCityErpId = opp.Account.City_erp_id__c; 
        //this.clientCity = opp.Account.Cidade_endereco_cobranca__c;
        //this.clientNeighborhood = opp.Account.Bairro_endereco_cobranca__c;
        //this.clientAddress = opp.Account.Rua_endereco_cobranca__c;
        //this.clientAddressNumber = opp.Account.Numero_endereco_cobranca__c;
        
        
        this.studentBorn = String.valueOf(opp.Account.Data_nascimento__pc);//.Year() + '-' + mes + '-' + dia;
        this.studentFirstName = opp.Account.FirstName;
        this.studentLastName = opp.Account.LastName;  
        if(opp.Account.CPF__pc != null){
            String cpfStudent = String.valueOf(opp.Account.CPF__pc);
            this.studentCpf = cpfStudent.replaceAll('[.-]','');
        }       
        //this.studentCpf = cpfNewStudent;
        //this.studentFatherName = opp.Account.Nome_pai__pc;
        //this.studentMotherName = opp.Account.Nome_mae__pc;
        //this.studentRg = opp.Account.RG__pc;
        //this.studentAddress = opp.Account.Rua_endereco_cobranca__c;
        //this.studentAddressNumber = opp.Account.Numero_endereco_cobranca__c;
        //this.studentNeighborhood = opp.Account.Bairro_endereco_cobranca__c;
        //this.studentCity = opp.Account.Cidade_endereco_cobranca__c;
        //this.studentCep = opp.Account.Cep_endereco_cobranca__c;
        //this.studentCountry = opp.Account.Pais_endereco_cobranca__c;
        //this.studentEmail = opp.Account.PersonEmail;
        //this.studentDDD = fone[1];
        //this.studentPhoneNumber = fone[2] + '-' +fone[3];
        //this.studentCountryErpId = opp.Account.Country_erp_id__c;
        //this.studentUfErpId = opp.Account.Uf_erp_id__c;
        //this.studentCityErpId = opp.Account.City_erp_id__c;
        
    }
    
    public String serializeToMultipart(){
        return Integracao_Util.Serialize_multipart(this);
    }
    
    
    @Future(callout = true)
    public static void futureIntegrateOpp(List<Id> oppIds){
        String nome = '';
        String cpf = '';
        List<Opportunity> oportunidades = [SELECT Id
                                           , Name
                                           , Account.Idade__pc
                                           , Id_Ometznet__c
                                           , Unidade_curso__r.Id_Ometznet__c
                                           , Unidade_matriculadora__r.Id_Ometznet__c
                                           , OwnerId
                                           , StageName
                                           , Data_inicio_curso__c
                                           , Valor_investimento_unico__c
                                           , Valor_mensal__c
                                           , Account.FirstName
                                           , Account.LastName
                                           , Account.Data_nascimento__pc
                                           , Responsavel__r.Name
                                           , Responsavel__r.FirstName
             							   , Responsavel__r.LastName
                                           , Responsavel__r.CPF__c
                                           , Account.CPF__pc
                                           , Account.Nome_pai__pc
                                           , Account.Nome_mae__pc
                                           , Account.Genero__pc
                                           , Account.RG__pc
                                           , Account.Rua_endereco_cobranca__c
                                           , Account.Numero_endereco_cobranca__c
                                           , Account.Bairro_endereco_cobranca__c
                                           , Account.Cidade_endereco_cobranca__c
                                           , Account.Cep_endereco_cobranca__c
                                           , Account.Pais_endereco_cobranca__c
                                           , Account.Estado_civil__pc
                                           , Account.PersonEmail
                                           , Account.Phone
                                           , Account.Country_erp_id__c
                                           , Account.UF_erp_id__c
                                           , Account.City_erp_id__c
                                           , Account.ID_ometznet__c
                                           , Status_integracao_OmetzPlatform__c
                                           , Vencimento_primeira_mensalidade__c
                                           , Owner.Id_ometznet__c
                                           , (SELECT Product2.Id_Ometznet__c FROM OpportunityLineItems WHERE Product2.Forma_cobranca__c = 'Investimento único' LIMIT 1)               
                                           FROM Opportunity
                                           WHERE Id in: oppIds
                                          ];
        for(Opportunity opp : oportunidades){
            //tratamento do campo responsável__c
            if(opp.Responsavel__c == null || opp.Responsavel__c == ''){
                
                nome = opp.Account.FirstName;
                cpf = opp.Account.CPF__pc;
            }
            else{
                nome = opp.Responsavel__r.Name;
                cpf = opp.Responsavel__r.CPF__c;
            }
            
            try{
                
                integrateOpp(opp);
            }
            catch(Exception ex){
                System.debug('cls__ PreAplication : errorr: ' + ex.getMessage() + ' - Linha:' + ex.getLineNumber());
            }
        }
        
    }
    
    
    public static void integrateOpp(Opportunity opp){
        PreAplication cliente = new PreAplication(opp);
        system.debug('CLIENTE - '+cliente);
        system.debug('OPP - '+opp.Id_Ometznet__c);
        
        Map<String, String> headers = new Map<String,String>();
        headers.put('Cache-Control','no-cache');
        headers.put('Accept', 'application/json');
        headers.put('Content-Type', 'application/x-www-form-urlencoded');
        String AmbienteName = OrganizationDAO.IsSandbox() ? 'Staging' : 'Production';
        Dados_integracao__c dados = Dados_integracao__c.getAll().get(AmbienteName);
        String body = cliente.serializeToMultipart();
        Log_integracao__c log = SFRequest.doIt(opp.Id, opp.Name, 'OmetzPlatform', dados.URL_chamada__c + dados.Criacao_pre_matricula_adulto__c, body, 'POST', headers);
        try{
            Integracao_Util.OppRequestResult req = (Integracao_Util.OppRequestResult)JSON.deserialize(log.XML_resposta__c,Integracao_Util.OppRequestResult.class);
            if(req.success){
                opp.Status_integracao_OmetzPlatform__c = 'Sucesso na integração às ' + System.now();
                opp.Id_Ometznet__c = req.pkRequest;
            } else{
                opp.Status_integracao_OmetzPlatform__c = 'Falha na integração às ' + System.now() + ' - ';
            }
        }catch(Exception ex){
            opp.Status_integracao_OmetzPlatform__c = 'Falha na integração às ' + System.now() + ' - ' + ex.getMessage() + ' - Linha:' + ex.getLineNumber();
        }
        upsert log;
        update opp;
    }
    
}