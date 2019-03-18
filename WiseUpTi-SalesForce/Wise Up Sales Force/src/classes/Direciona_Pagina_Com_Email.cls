/*
    Overview: Define e redireciona para página correta de acordo com o curso.
    Autor: Sergio Migueis
    Classe de teste: Direciona_Pagina_Com_Email_Teste
*/

global without sharing class Direciona_Pagina_Com_Email{

    public afinance__Transaction__c tr {get;set;}
    
    
    public Opportunity opp {get; set;}
    
    public Contact ct {get;set;}
    
    public String inicioCurso {
    get{
        return opp.Data_inicio_curso__c.day() + '/' + opp.Data_inicio_curso__c.month() + '/' + opp.Data_inicio_curso__c.year();
    }
        set;
    }
    


    public Direciona_Pagina_Com_Email(){
        opp = [
            SELECT Id
            , Account.Name
            , Account.CPF__pc
            , Account.PersonEmail
            , Account.PersonHomePhone
            , Account.Phone
            , Account.PersonContactId
            , Unidade_curso__r.Name
            , Unidade_curso__r.Phone
            , Unidade_curso__r.CNPJ__c
            , Valor_investimento_unico__c
            , afinancecielo__Opcao_Pagamento_Unico__r.Name
            , Data_inicio_curso__c
            FROM Opportunity WHERE Id =: ApexPages.currentPage().getParameters().get('idOpp')
        ];
    }
     
    
    public Direciona_Pagina_Com_Email(afinancecielo.Confirmar_Pagamento controller){
        System.debug(' Proposta - PDF ');
        carregaDados();
    }
    
    public void carregaDados(){
        String trId = ApexPages.currentPage().getParameters().get('idTR');
        String trIdUnt = ApexPages.currentPage().getParameters().get('idTRunt');
        if(trId != null){
            tr = carregaTR(trId);                       
        }else{
            tr = carregaTR(trIdUnt);
        }
        
    }
    
    public PageReference redirect(){
        if(tr.afinance__Opportunity__c != null && tr.afinance__Payment_date__c != null){
            if(tr.afinance__Opportunity__r.Unidade_matriculadora__r.Bandeira__c.Contains('Wise Up')){                
                //enviar o email
                OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
                EmailTemplate templateId = [Select id from EmailTemplate where name = 'wu - confirmação pagamento'];           
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id); 
                mail.setSaveAsActivity(false);
                mail.setOrgWideEmailAddressId(owa.id);
                mail.setTargetObjectId(tr.afinance__Opportunity__r.Account.PersonContactId);
                mail.setWhatId(tr.afinance__Opportunity__c);
                allmsg.add(mail);
                Messaging.SendEmailResult[] result = Messaging.sendEmail(allmsg,false); 
                System.debug(result);              
                PageReference requestPage = Page.confirmacao_pagamento_wise_up;
                requestPage.getParameters().put('idOpp',tr.afinance__Opportunity__c);
                requestPage.setRedirect(true);
                return requestPage;
            } else{                 
                //enviar o email
                OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
                EmailTemplate templateId = [Select id from EmailTemplate where name = 'ym - confirmação pagamento'];           
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id); 
                mail.setSaveAsActivity(false);
                mail.setOrgWideEmailAddressId(owa.id);
                mail.setTargetObjectId(tr.afinance__Opportunity__r.Account.PersonContactId);
                mail.setWhatId(tr.afinance__Opportunity__c);
                allmsg.add(mail);
                Messaging.SendEmailResult[] result = Messaging.sendEmail(allmsg,false);  
                System.debug(result);                                 
                PageReference requestPage = Page.confirmacao_pagamento_you_move;
                requestPage.getParameters().put('idOpp',tr.afinance__Opportunity__c);
                requestPage.setRedirect(true);
                return requestPage;
            }
        }
        return null;
    }
    
    public static afinance__Transaction__c carregaTR(String idt){
        
        return [
                SELECT Id
                ,afinance__Opportunity__c
                ,afinance__Opportunity__r.Unidade_matriculadora__r.Bandeira__c
                ,afinance__Payment_date__c
                ,afinance__Opportunity__r.Account.PersonContactId
                FROM afinance__Transaction__c
                WHERE Id =: idt
            ];
    }
    
}