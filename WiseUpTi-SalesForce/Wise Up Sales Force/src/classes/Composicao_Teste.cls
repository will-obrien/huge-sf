/*
Testes para
    trigger: Composicao_Criacao_ItemOportunidade
    trigger: Composicao_Alteracao_ItemOportunidade
    trigger: Composicao_Exclusao_ItemOportunidade
    trigger: Composicao_Criacao_ItemCotacao
    trigger: Composicao_Alteracao_ItemCotacao
    trigger: Composicao_Exclusao_ItemCotacao
    trigger: Composicao_Criacao_ItemPedido
    trigger: Composicao_Alteracao_ItemPedido
    trigger: Composicao_Exclusao_ItemPedido
    classe: Composicao_Criacao 
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Composicao_Teste{

    static testMethod void teste(){
        PricebookEntry pbe1 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('1').Id);
        PricebookEntry pbe2 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('2').Id);
        PricebookEntry pbe3 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('3').Id);
        PricebookEntry pbe4 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('4').Id);
        PricebookEntry pbe5 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('5').Id);
        PricebookEntry pbe6 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('6').Id);
        
        Composicao_Produto__c cp1 = newComposicao_Produto(pbe1.Product2Id, pbe2.Product2Id, 'Complementar', 'Qualquer quantidade');
        Composicao_Produto__c cp2 = newComposicao_Produto(pbe1.Product2Id, pbe3.Product2Id, 'Complementar', 'Mesma quantidade do item');
        Composicao_Produto__c cp3 = newComposicao_Produto(pbe1.Product2Id, pbe4.Product2Id, 'Complementar', 'No máximo a quantidade do item');
        Composicao_Produto__c cp4 = newComposicao_Produto(pbe5.Product2Id, pbe6.Product2Id, 'Combo', '');
        
        Account conta = Teste_Util.newAccount();
        
        Opportunity oportunidade = Teste_Util.newOpportunity(conta.Id);
        
        OpportunityLineItem oli1 = Teste_Util.newOpportunityLineItem(oportunidade.Id, pbe1.Id);
        OpportunityLineItem oli2 = Teste_Util.newOpportunityLineItem(oportunidade.Id, pbe2.Id);
        
        oli1.UnitPrice = 200;
        
        try{
            update oli1;
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, '___ [cls Composicao_Teste - teste()] - ERROR: '+ e.getMessage());
        }
        
        try{
            delete oli2;
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, '___ [cls Composicao_Teste - teste()] - ERROR: '+ e.getMessage());
        }
    }
    
    public static Composicao_Produto__c newComposicao_produto(Id pPai, Id pFilho, String funcao, String controleQuantidade){
        Composicao_Produto__c comp = new Composicao_produto__c();
        comp.Produto_pai__c = pPai;
        comp.Produto_Filho__c = pFilho;
        comp.Funcao__c = funcao;
        comp.Controla_quantidade__c = controleQuantidade;
        insert comp;
        return comp;
    }
    
}