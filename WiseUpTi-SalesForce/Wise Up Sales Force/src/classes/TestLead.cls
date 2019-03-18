@isTest
public class TestLead{
    
    public static testmethod void WUP_AtribuicaoLead(){
        
        System.runAs(UserDAO.getUsuarioSistema()) {
            List<Lead> leads = new List<Lead>();
            Teste_Util.createParams();
            Teste_Util.newControleAtribuicaoComercial('Wise Up', GroupDAO.getGroupQueueByName('Wise Up').Id, 1);
            Lead l = Teste_Util.newLead('Wise Up', 'Web');
            l.Cidade_endereco__c = 'Curitiba';
            l.Estado_endereco__c = 'PR';
            l.Bairro_endereco__c = 'Portão';
			leads.add(l);

            Lead l2 = Teste_Util.newLead('Wise Up', 'Web');
            l2.Cidade_endereco__c = 'São Paulo';
            l2.Estado_endereco__c = 'SP';
            l2.Bairro_endereco__c = 'Centro';
			leads.add(l2);
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            Database.insert(leads, dmo);
            
            UPDATE leads;
            DELETE leads;
            UNDELETE leads;
        }
    }
    
    public static testmethod void MS_AtribuicaoLead(){
        Test.startTest();
        
        Id FilaMsAuto = GroupDAO.getGroupQueueByName('meuSucesso #AUTO').Id;
        
        System.runAs(UserDAO.getUsuarioSistema()) {
            Teste_Util.createParams();
            Teste_Util.newControleAtribuicaoComercial('meuSucesso #AUTO', FilaMsAuto, 1);
            List<Lead> leads = new List<Lead>();

            for(Integer i = 0; i < 120; i++){
                Lead l = Teste_Util.newLead('meuSucesso.com', 'Funil de Vendas');
                leads.add(l);       
            }

            Database.DMLOptions dmo = new Database.DMLOptions();

            dmo.assignmentRuleHeader.useDefaultRule = true;
            dmo.optAllOrNone = false;

            Database.SaveResult[] Srs = Database.insert(leads, dmo);

            system.debug('Leads12: ' + leads);
            for(Lead l : leads){
                l.OwnerId = FilaMsAuto;                   
            }
            system.debug('4');
            
            UPDATE leads;
        }
        
        Test.stopTest(); 
    }
    
    /*public static testmethod void testAtribuicaoLeadWUP(){
ControleAtribuicaoComercial__c CAC = new ControleAtribuicaoComercial__c();
CAC.LimiteLeads__c = 35;
CAC.Name = 'Wise Up';
CAC.IdFilaRoleta__c = '00G36000001crT7';
INSERT CAC;

User sistema = UserDAO.getUsuarioSistema();

Account acc = Teste_Util.newAccountPJSemInserir();
acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Franquias').getRecordTypeId();
INSERT acc;

Contact ctt = Teste_Util.newContact(acc.Id);

User comercial1 = Teste_Util.newUser();
comercial1.CompanyName = 'Wise Up';
comercial1.ProfileId = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Partner Community' LIMIT 1].Id;
comercial1.Username = 'teste'+system.now().getTime()+'@gmail.com';
comercial1.email = 'teste'+system.now().getTime()+'@gmail.com';
//comercial1.UserRoleId = [SELECT Id FROM UserRole LIMIT 1].Id;
comercial1.ContactId = ctt.Id;
comercial1.Department = 'Comercial';
comercial1.CompanyName = 'Wise Up';
//comercial1.UserType = 'PowerPartner';

INSERT comercial1;

system.runAs(sistema){

Database.DMLOptions dmo = new Database.DMLOptions();
dmo.assignmentRuleHeader.useDefaultRule= true;
Teste_Util.createParams();

List<Lead> ls = new List<Lead>();
Integer index = 0;
for(Integer i = 0; i <= 40; i++){

Lead l = Teste_Util.newLeadSemInserir();
l.recordTypeId = RecordTypeDAO.mapByNameRecordTypeBySobjectType('Lead').get('Wise Up').Id;
l.LeadSource = 'Web';
l.City = 'São Paulo';
l.Cidade_endereco__c = 'São Paulo';
l.DataAtribuicaoComercial__c = system.now();
//l.Data_Disponibilizacao_Lead__c = system.now().addDays(-1);
l.Status = 'Novo';
//l.Id_meu_sucesso__c = 'email'+system.now().millisecond()+'@gmail.com';
ls.add(l);
}

insert ls;  

}

}
public static testmethod void testAtribuicaoLeadMS(){
ControleAtribuicaoComercial__c CAC = new ControleAtribuicaoComercial__c();
CAC.LimiteLeads__c = 35;
CAC.Name = 'meuSucesso #AUTO';
CAC.IdFilaRoleta__c = '00G36000001crTC';
INSERT CAC;

User sistema = UserDAO.getUsuarioSistema();

Account acc = Teste_Util.newAccountPJSemInserir();
acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Jurídica').getRecordTypeId();
INSERT acc;

Contact ctt = Teste_Util.newContact(acc.Id);


User comercial1 = Teste_Util.newUser();
comercial1.CompanyName = 'meuSucesso.com';
comercial1.ProfileId = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Partner Community' LIMIT 1].Id;
comercial1.Username = 'teste'+system.now().getTime()+'@gmail.com';
comercial1.email = 'teste'+system.now().getTime()+'@gmail.com';
comercial1.ContactId = ctt.Id;
comercial1.Department = 'Comercial';
comercial1.CompanyName = 'meuSucesso.com';

INSERT comercial1;

system.runAs(sistema){

Database.DMLOptions dmo = new Database.DMLOptions();
dmo.assignmentRuleHeader.useDefaultRule= true;
Teste_Util.createParams();
List<Lead> ls = new List<Lead>();

for(Integer i = 0; i <= 40; i++){

Lead l = Teste_Util.newLeadSemInserir();
l.recordTypeId = RecordTypeDAO.mapByNameRecordTypeBySobjectType('Lead').get('meuSucesso.com').Id;
l.LeadSource = 'Funil de Vendas';
l.DataAtribuicaoComercial__c = system.now();
l.Data_Disponibilizacao_Lead__c = system.now().addDays(-1);

l.Status = 'Novo';
ls.add(l);
}

insert ls;           


}

}

// public static testMethod void testLeadBatchMS(){
// ControleAtribuicaoComercial__c CAC = new ControleAtribuicaoComercial__c();
// CAC.LimiteLeads__c = 35;
// CAC.Name = 'meuSucesso #AUTO';
// CAC.IdFilaRoleta__c = '00G36000001crTC';
// INSERT CAC;

// BatchLeadsForaDoFunil a = new BatchLeadsForaDoFunil();
// Database.executeBatch(a);
// }

public static testMethod void testLeadBatchWUP(){
ControleAtribuicaoComercial__c CAC = new ControleAtribuicaoComercial__c();
CAC.LimiteLeads__c = 35;
CAC.Name = 'Wise Up';
CAC.IdFilaRoleta__c = '00G36000001crT7';
INSERT CAC;

Atualiza_Status_Lead_Novo.AtualizaLeadEnviarOmetzNet();
}*/
    
    
}