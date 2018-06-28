public class ProductRequest {

    public Integer pkProductDefault {get; set;}
    public String product {get; set;}
    public String state {get; set;}
    public String city {get; set;}
    public String unit {get; set;}
    public Double minEnrollment {get; set;}
    public Double maxEnrollment {get; set;}
    public Double scholarshipEnrollment {get; set;}
    public Double minMonthPayment {get; set;}
    public Double maxMonthPayment {get; set;}
    public Double scholarshipMonthPayment {get; set;}
    public String user {get; set;}
    public String status {get; set;}
    public String created {get; set;}
    public String edited {get; set;}
    
    
    

    public ProductRequest(){

    }
    
    @future(callout = true)
    public static void futureIntegrateOli(List<Id> oliIds){
        List<OpportunityLineItem> olis = [
              SELECT Id
              , Opportunity.Id
              , Opportunity.Id_Ometznet__c
              , Opportunity.Unidade_curso__r.Id_Ometznet__c
              , Product2.Id_Ometznet__c
              , Product2.name
              , Valor_minimo__c
              , UnitPrice
              , Forma_cobranca__c
              FROM OpportunityLineItem
              WHERE Id in: oliIds
        ];
        for(OpportunityLineItem oli : olis)
        {
            try{
                ProductRequest req = ProductRequest.getValues(oli.Opportunity.Unidade_curso__r.Id_Ometznet__c, oli.Product2.Id_Ometznet__c.replaceAll('[^0-9]', ''), oli.opportunity.Id_Ometznet__c, oli.Product2.name);
                if(oli.Forma_cobranca__c == 'Recorrente')
                {
                    oli.unitPrice = req.maxMonthPayment;
                    oli.Valor_minimo__c = req.minMonthPayment * 12;
                    oli.Valor_unitario_periodo__c = req.minMonthPayment * 12;
                } else{
                    oli.unitPrice = req.maxEnrollment;
                    oli.Valor_minimo__c = req.minEnrollment;
                    oli.Valor_unitario_periodo__c = req.minEnrollment;
                }
            }
            catch(Exception ex){
                System.debug('cls__ ProductRequest erro: ' + ex.getMessage() + '-' + ex.getLineNumber());
            }
        }
        if(olis.size() > 0) update olis;
        if(logs.size() > 0 ) insert logs;
    }
    private static List<Log_integracao__c> logs = new List<Log_integracao__c>();
    public static ProductRequest getValues(String unitValue, String productId, String salesforceId, String prodName){
        
        String AmbienteName = OrganizationDAO.IsSandbox() ? 'Staging' : 'Production';
        Dados_integracao__c dados = Dados_integracao__c.getAll().get(AmbienteName);
        Map<String,String> headers = new Map<String,String>();
        headers.put('Accept','application/json');
        Log_integracao__c log = SFRequest.doIt(salesforceId, '', 'OmetzPlatform', dados.URL_chamada__c + dados.Product_values_unit_copy__c + unitValue + '?productId=' + productId, null, 'GET',headers);
        logs.add(log);
        log.xml_Resposta__c = log.xml_resposta__c.replace('pkProductDefault','pkProductDefault1'); //remover quando eles arrumarem o servidor.
        ProductRequest prod = (ProductRequest) JSON.deserialize(log.xml_resposta__c, ProductRequest.class);
        return prod;
    }

}