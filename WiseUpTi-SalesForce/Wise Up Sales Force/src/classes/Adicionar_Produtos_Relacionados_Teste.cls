/*
    Classe de testes para a classe: Adicionar_Produtos_Relacionados
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Adicionar_Produtos_Relacionados_Teste{

    static testMethod void teste(){
        PricebookEntry pbe1 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('1').Id);
        PricebookEntry pbe2 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('2').Id);
        PricebookEntry pbe3 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('3').Id);
        PricebookEntry pbe4 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('4').Id);
        
        Composicao_Produto__c cp1 = newComposicao_Produto(pbe1.Product2Id, pbe2.Product2Id, 'Complementar', 'Qualquer quantidade');
        Composicao_Produto__c cp2 = newComposicao_Produto(pbe1.Product2Id, pbe3.Product2Id, 'Complementar', 'Mesma quantidade do item');
        Composicao_Produto__c cp3 = newComposicao_Produto(pbe1.Product2Id, pbe4.Product2Id, 'Complementar', 'No máximo a quantidade do item');

        Opportunity oportunidade = Teste_Util.newOpportunity(Teste_Util.newAccount().Id);
        
        Teste_Util.newOpportunityLineItem(oportunidade.Id, pbe1.Id);
        Teste_Util.newOpportunityLineItem(oportunidade.Id, pbe2.Id);
        
        PageReference pg = ApexPages.currentPage();
        pg.getParameters().put('Id', oportunidade.Id);
        Test.setCurrentPage(pg);
        
        Adicionar_Produtos_Relacionados classe = new Adicionar_Produtos_Relacionados();
        
        classe.produtos[0].itensRelacionados[0].adicionar = true;
        classe.produtos[0].itensRelacionados[0].quantidade = 0;

        classe.salvar();

        classe.produtos[0].itensRelacionados[0].quantidade = 10;
        classe.produtos[0].itensRelacionados[1].quantidade = 10;

        classe.salvar();
        classe.cancelar();
        
        classe.iniciaOrder();
        classe.iniciaQuote();
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