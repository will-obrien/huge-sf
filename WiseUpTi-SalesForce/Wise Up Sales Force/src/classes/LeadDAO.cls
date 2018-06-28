public with sharing class LeadDAO {
    
    private static map<String, Integer> counterLeadQueue;
    
    public static map<String, Integer> counterLeadQueue(){
        
        if(counterLeadQueue == null){

            counterLeadQueue = new map<String, Integer>();
            
            for(AggregateResult agg : [SELECT COUNT(Id) Qtde, UsuarioComercialAtribuido__c Comercial, UsuarioComercialAtribuido__r.Name Nome FROM Lead WHERE DataAtribuicaoComercial__c = TODAY GROUP BY UsuarioComercialAtribuido__c, UsuarioComercialAtribuido__r.Name]){
                String Comercial = (String)agg.get('Comercial');
                Integer Qtde = (Integer)agg.get('Qtde');
                
                counterLeadQueue.put(Comercial, Qtde);
            }
        }
        
        return counterLeadQueue;
        
    }
}