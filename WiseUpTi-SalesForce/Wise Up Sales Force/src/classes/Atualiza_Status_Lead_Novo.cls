public class Atualiza_Status_Lead_Novo {
    
    public static void AtualizaLeadEnviarOmetzNet() {
                   
        String query = 
        'SELECT ' +
        'RecordTypeId, ' +
        'RecordType.Name, ' +
        'Status, ' +
        'CreatedDate ' +
        'FROM Lead ' +
        'WHERE Status = \'Enviar para Ometznet\' AND RecordType.Name = \'Wise Up\' AND IsConverted = false LIMIT 100';

        Atualiza_Status_Lead_Novo_Batch a = new Atualiza_Status_Lead_Novo_Batch();
        a.query = query;
        Database.executeBatch(a);

    }
}