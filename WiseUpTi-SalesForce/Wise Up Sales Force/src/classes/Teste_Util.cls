/*
Classe Util para testes

*gerado pelo software Util
*/
@isTest(seeAllData=true)
public class Teste_Util{
    
    public static void createParams(){
        Triggers__c tr = new Triggers__c();
        tr.Oportunidade_Trigger__c = true;
        tr.Oli_trigger__c = true;
        tr.Membros_Campanha_trigger__c = true;
        insert tr;
    
    }
 
    public static void newControleAtribuicaoComercial(String Name, Id Fila, Integer DayliLimit){
        ControleAtribuicaoComercial__c CAC2 = new ControleAtribuicaoComercial__c();
        CAC2.LimiteLeads__c = DayliLimit;
        CAC2.Name = Name;
        CAC2.IdFilaRoleta__c = Fila;
        INSERT CAC2;  
        
        
    }
        
    public static Lead newLead(){
        Lead lead = new Lead();
        lead.LastName = 'Lead Teste';
        lead.Company = 'Empresa Teste';
        lead.Status = 'Novo';
        lead.LeadSource = 'Teste';

        insert lead;
        
        return
            [SELECT Id
             , Name
             , LastName
             , Company
             FROM Lead
             WHERE Id =: lead.Id];
    }
    public static Lead newLead(String RecordTypeName, String LeadSource){
        Lead lead = new Lead();
        lead.LastName = 'Lead Teste';
        lead.Company = 'Empresa Teste';
        lead.Status = 'Novo';
        lead.LeadSource = LeadSource;
        lead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        lead.Email = String.ValueOf(system.now().format('YYYYMddhmsSSS'))+ Math.random() + '@email.com';

        return lead;
       
    }
    
    public static Contact newContact(String accountId){
        Contact con = new Contact();
        con.LastName = 'Contato Teste';
        con.AccountId = accountId;
        
        insert con;
        
        return
            [SELECT Id
             , Name
             , LastName
             , AccountId
             , Account.Name
             FROM Contact
             WHERE Id =: con.Id];
    }
    
    public static Account newAccount(){
        Account acc = new Account();
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Física').getRecordTypeId();
        acc.FirstName = 'Conta';
        acc.LastName = ' Teste';
        acc.Genero__pc = Contact.SObjectType.Genero__c.getDescribe().getPickListValues().get(0).getValue();    
        acc.ID_ometznet__c = '123321';
        acc.Data_nascimento__pc = System.Today().addYears(-20);
        insert acc;
        
        return 
            [SELECT Id
             , FirstName
             , LastName
             , Genero__pc
             , RecordTypeId
             FROM Account
             WHERE Id =: acc.Id];
    }
    
    public static Account newAccountPJ(){
        Account acc = new Account();
        acc.Name = 'Conta Teste';
        acc.CNPJ__c = '05.807.857/0001-31';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Jurídica').getRecordTypeId();
        acc.ID_ometznet__c = '4321';
        insert acc;
        
        return
            [SELECT Id
             , Name
             , CNPJ__c
             , RecordTypeId
             FROM Account
             WHERE Id =: acc.Id];
    }
    
    public static User newUser(){
        User u = new User();
        u.Alias = 'user';
        u.CommunityNickname = 'NickName';
        u.Email = 'email@user.com';
        u.FirstName = 'Usuario';
        u.LastName = 'LastName';  
        u.Username = 'username@user.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'America/Chicago';
        
        return u;
    }
    
    public static Account newAccountPJSemInserir(){
        Account acc = new Account();
        acc.Name = 'Conta Teste';       
        acc.CNPJ__c = '20.173.841/0001-08';
        acc.Phone = '+55 00 0000 0000';
        acc.Status__c = 'Ativo';
        acc.Bandeira__c = 'Wise Up';
        acc.Cidade_endereco_cobranca__c = 'Curitiba';
        acc.Estado_endereco_cobranca__c = 'PR';
        acc.Pais_endereco_cobranca__c = 'Brasil';
        return acc;
    }
    
    public static Lead newLeadNotInserted(){
        Lead lead = new Lead();
        lead.LastName = 'Lead Teste';
        lead.Company = 'Empresa Teste';
        
        return lead;
    }    
    public static Lead newLeadSemInserir(){
        Lead lead = new Lead();
        lead.LastName = 'Lead Teste';
        lead.Company = 'Empresa Teste';
        lead.LeadSource = 'Novo';
        lead.Email = 'teste@email.com';
        lead.Phone = '+55 99 99999 9999';
        lead.Rua_endereco__c = 'abc';
        lead.Numero_endereco__c = '123';
        lead.Complemento_endereco__c  = 'abc';
        lead.Bairro_endereco__c  = 'abc';
        lead.Cidade_endereco__c = 'São paulo';
        lead.Estado_endereco__c = 'SP';
        lead.CEP_endereco__c = '80620-340';
        lead.Pais_endereco__c = 'Brasil';
        return lead;
    }    
    
    public static Account newAccountFranquia(){
        Account acc = new Account();
        acc.Name = 'Conta Teste';
        acc.CNPJ__c = '05.807.857/0001-31';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Franquias').getRecordTypeId();
        acc.ID_ometznet__c = '54321';
        acc.Catalogo_precos__c = Test.getStandardPriceBookId();
        acc.Type = 'Franquia';
        insert acc;
        
        return
            [SELECT Id
             , Name
             , CNPJ__c
             , RecordTypeId
             FROM Account
             WHERE Id =: acc.Id];
    }    
    public static Campaign newCampaign(){
        Campaign cam = new Campaign();
        cam.Name = 'Teste';
        cam.isActive = true;
        insert cam;
        return cam;
    }
    
    public static CampaignMember newCampaignMember(Id campaignId, Id leadId){
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = campaignId;
        cm.LeadId = leadId;
        
        insert cm;
        return cm;
    }
    
    public static Opportunity newOpportunity(String AccountId){
        Date data = system.today(); 
        data = data.addMonths(1);
        Integer mes = data.month();
        Integer ano = data.year();
        Date dataCurso = date.newInstance(ano, mes, 05);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Oportunidade Teste';
        opp.AccountId = AccountId;
        opp.CloseDate = data;
        opp.Data_inicio_curso__c = dataCurso;
        opp.StageName = Opportunity.SObjectType.StageName.getDescribe().getPickListValues().get(0).getValue();
        opp.Status_integracao_OmetzPlatform__c = null;
        opp.Responsavel__c = null;
        
        opp.afinancecielo__Valor_Unico_Cartao__c = 123321;
        
        insert opp;
        
        return
            [SELECT Id
             , Name
             , AccountId
             , Account.Name
             , CloseDate
             , StageName
             FROM Opportunity
             WHERE Id =: opp.Id];
    }
    
    public static Opportunity newOpportunity(String AccountId, String UnidadeId){
        Date data = system.today(); 
        data = data.addMonths(1);
        Integer mes = data.month();
        Integer ano = data.year();
        Date dataCurso = date.newInstance(ano, mes, 05);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Oportunidade Teste';
        opp.AccountId = AccountId;
        opp.CloseDate = data;
        opp.Data_inicio_curso__c = dataCurso;
        opp.StageName = Opportunity.SObjectType.StageName.getDescribe().getPickListValues().get(0).getValue();
        opp.Status_integracao_OmetzPlatform__c = null;
        opp.Responsavel__c = null;
        opp.Unidade_curso__c = UnidadeId;
        opp.afinancecielo__Valor_Unico_Cartao__c = 123321;
        
        insert opp;
        
        return
            [SELECT Id
             , Name
             , AccountId
             , Account.Name
             , CloseDate
             , StageName
             FROM Opportunity
             WHERE Id =: opp.Id];
    }
    
    public static Product2 newProduct2(){
        return newProduct2('1');
    }
    
    public static Product2 newProduct2(String codigo){
        Product2 prod = new Product2();
        prod.Name = 'Produto Teste ' + codigo;
        prod.isActive = true;
        //        prod.Id_Ometznet__c = codigo;
        
        insert prod;
        
        return 
            [SELECT Id
             , Name
             , IsActive
             , Id_ometznet__c
             FROM Product2
             WHERE Id =: prod.Id];
    }
    
    public static PricebookEntry newPricebookEntry(String product2Id){
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPriceBookId();
        pbe.Product2Id = product2Id;
        pbe.UseStandardPrice = false;
        pbe.IsActive = true;
        pbe.UnitPrice = 100;
        
        insert pbe;
        
        return
            [SELECT Id
             , PriceBook2Id
             , Product2Id
             , IsActive
             , UnitPrice
             FROM PriceBookEntry
             WHERE Id =: pbe.Id];
    }
    
    public static OpportunityLineItem newOpportunityLineItem(String opportunityId, String pricebookEntryId){
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.OpportunityId = opportunityId;
        oppli.PricebookEntryId = pricebookEntryId;
        oppli.UnitPrice = 1;
        oppli.Quantity = 1;
        
        insert oppli;
        
        return
            [SELECT Id
             , OpportunityId
             , Opportunity.Name
             , PriceBookEntryId
             , UnitPrice
             , Quantity
             FROM OpportunityLineItem
             WHERE Id =: oppli.Id];
    }
    
    public static User newPortalUser(String idContato){
        Id idPerfilPortal = 
            [SELECT Id 
             FROM Profile 
             WHERE Name = 'Partner Community User'
             LIMIT 1].Id;
        
        User u = new User();
        u.Email = 'usuarioteste@usuarioteste.com';
        u.UserName = u.Email;
        u.FirstName = 'Usuario';
        u.LastName = 'Teste';
        u.Alias = 'uTeste';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'pt_BR';
        u.ProfileId = idPerfilPortal;
        u.ContactId = idContato;
        u.LocaleSidKey = 'pt_BR';
        u.TimeZoneSidKey = 'America/Sao_Paulo';
        u.CompanyName = 'Wise Up';
        
        insert u;
        
        return
            [SELECT Id
             , Name
             , FirstName
             , LastName
             , Email
             , UserName
             , Alias
             , ContactId
             FROM User
             WHERE Id =: u.Id];
    }
    
    public static void ativarTriggers(){
        Triggers__c t = new Triggers__c();
        insert t;
    }
    
}