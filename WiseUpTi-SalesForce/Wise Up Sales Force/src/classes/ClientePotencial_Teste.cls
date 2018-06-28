@isTest
public class ClientePotencial_Teste{
    public static testmethod  void teste(){
        ClientePotencial pop = new ClientePotencial();
        pop.studentName = '';
        pop.studentCPF = '';
        pop.clientName = '';
        pop.clientCPF = '';
        pop.studentBorn = '';
        pop.setResponsavel('','');
        pop.serializeToJson();
        pop.serializeToMultipart();
        
        Lead l = Teste_Util.newLead();
        l.Data_Nascimento__c = System.today();
        l.CPF__c = '520.358.443-55';
        update l;
        try{
            new ClientePotencial(l);
            ClientePotencial.validaCPFLead(l.Id, '', '');
        }catch(Exception ex){
        }
        
        Account acc = Teste_Util.newAccount();
        acc.PersonBirthDate = System.today();
        acc.cpf__pc= '520.358.443-55';
        update acc;
        try{
            new ClientePotencial(acc);
            ClientePotencial.futureIntegrateAcc(new List<string> {acc.Id});
        }catch(Exception ex){
        }
    }
}