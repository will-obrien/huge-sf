@isTest
private class Atualiza_Status_Lead_Novo_Test {

    static testMethod void teste(){
       
        Lead lead = Teste_Util.newLead();
        
        Lead l = new Lead();
        l.FirstName = 'Teste';
        l.LastName = 'Inclusao123';
        insert l;
                       
        /*Atualiza_Status_Lead_Novo classe = new Atualiza_Status_Lead_Novo();
        SchedulableContext sc;
        classe.execute(sc);*/
        
        
        
        //classe.execute(null);
        /*String sch = '0 0 0 15 3 ? 2022';
        String jobID = system.schedule('Classe de teste', sch, classe);

        //String query = 'SELECT RecordTypeId, RecordType.Name, Status, CreatedDate FROM Lead WHERE Status = \'Novo\' AND RecordType.Name = \'Wise Up\'';
        String query = 'SELECT ' +
        'RecordTypeId, ' +
        'RecordType.Name, ' +
        'Status, ' +
        'CreatedDate ' +
        'FROM Lead ' +
        'WHERE Status = \'Novo\' AND RecordType.Name = \'Wise Up\' AND CreatedDate >: data';
        
        Atualiza_Status_Lead_Novo_Batch  c = new Atualiza_Status_Lead_Novo_Batch();
        c.query = query;
        
        Database.executeBatch(c);*/
    }

}