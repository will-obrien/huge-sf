/*
    Classe de testes: Proposta_Teste
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

public class Proposta {
    private Opportunity opp;
    private Boolean qtdeContatoP;    
    
    public Opportunity oppty              {get; set;}
    public Id oppId                             { get; set; }
    public Id teste                             { get; set; }
    public Boolean erro                         { get; set; }    
    public List<OpportunityLineItem> iItem    { get; set;}

    public Boolean qtdItem                      { get; set;}
    
    public Decimal valUnico  {get; set; }
    public Decimal valMensal {get; set; }

    
        
    public Opportunity getOpp(){
        if(opp == null && oppId != null)
            carregaDados(oppId);
        return opp;
    }
     public Proposta(){}
     
    
    public Proposta(ApexPages.StandardController controller){
        System.debug(' Proposta - PDF ');
        carregaDados( controller.getId() );
    }
    
    public void carregaDados(Id id){
        String debug = '___ [cls proposta]';
        erro = true;
        if (id == null ) return;
        opp = [
            SELECT Id
            , afinancecielo__Opcao_Pagamento_Unico__r.Name
            , afinance__Payment_Option__r.Name
            , Amount
            , afinancecielo__Valor_Unico_Cartao__c
            , afinancecielo__Valor_Cobranca_Cartao__c
            , (SELECT Id, Name, Quantity, Subtotal, UnitPrice FROM OpportunityLineItems)
            FROM Opportunity
            WHERE Id  =: (oppId == null ? id : oppId)
        
        ];
        
        System.debug(debug + ' - itens: ' + opp.OpportunityLineItems); 
        iItem = opp.OpportunityLineItems; 
        valUnico = opp.afinancecielo__Valor_Unico_Cartao__c;
        valMensal = opp.afinancecielo__Valor_Cobranca_Cartao__c;
        System.debug(debug + ' - SELECT OK (opp) : ' + opp);  
        
          
        
    }
    
    public List<OpportunityLineItem> getItensToPage(){
        carregaDados(oppId);
        System.debug('cls___ PropostaFinance  -  items' + iItem);
        return iItem;
    }
}