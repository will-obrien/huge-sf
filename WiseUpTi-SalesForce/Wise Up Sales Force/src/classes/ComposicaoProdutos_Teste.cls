/*
Testes para
    trigger: Composicao_tipos_produtos
*/
@isTest
public class ComposicaoProdutos_Teste{

    private static PriceBookEntry pbePai;
    private static PriceBookEntry pbeFilhoCombo1;
    private static PriceBookEntry pbeFilhoCombo2;
    private static PriceBookEntry pbeFilhoCombo3;
    private static PriceBookEntry pbeFilhoObrigatorio;

    private static Decimal valorCombo = 100;
    private static Decimal valorObrig = 21;
    private static Integer qtde = 1;

    private static SObject itemReq;
    private static SObject itemCombo;

    private Static String objName;
    private static String objItemName;
    private static Id oppId;
//    private Static sObject item;
    
    static testMethod void ComposicaoProdutos(){
        Composicao_produtos_Permissao__c Param = new Composicao_produtos_Permissao__c();
        Param.Combos_itens_requeridos__c = false; //Não permite combos com itens requeridos
        Param.Composicao_cascata__c = false; //Não permite cadastro em cascata (A contém B que contém C)
        insert Param;
        
        //-- Produtos de composição --//
        pbePai = newPriceBookEntry('Combo pai teste', valorCombo);
        pbeFilhoCombo1 = newPriceBookEntry('Item1 combo teste',0);
        pbeFilhoCombo2 = newPriceBookEntry('Item2 combo teste',15);
        pbeFilhoCombo3 = newPriceBookEntry('Item3 combo teste',15); //cascata
        pbeFilhoObrigatorio = newPriceBookEntry('Requerido combo teste',valorObrig);

        //-- Composiçao --//
        Composicao_Produto__c compC1 = newComposicao_Produto(pbePai.Product2Id, pbeFilhoCombo1.Product2Id, 'Combo', '');
        Composicao_Produto__c compC2 = newComposicao_Produto(pbePai.Product2Id, pbeFilhoCombo2.Product2Id, 'Combo', '');
        try {
            // Testa parametro que não permite item obrigatorio num combo
            Composicao_Produto__c compErro = newComposicao_Produto(pbePai.Product2Id, pbeFilhoObrigatorio.Product2Id, 'Obrigatório', '');
        } catch (exception e) {
            System.debug('___ [cls Composicao_Teste - teste()] - EXCEPTION : Não permite itens requeridos em combo : ' + e);
        }
        System.debug('___ [cls Composicao_Teste - teste()] - Muda parametros para aceitar itens requeridos e combo ');
        Param.Combos_itens_requeridos__c = true;
        update Param; 
        Composicao_Produto__c compO = newComposicao_Produto(pbePai.Product2Id, pbeFilhoObrigatorio.Product2Id, 'Obrigatório', '');
        System.debug('___ [cls Composicao_Teste - teste()] - Parâmetro alterado. ');

        try {
            Composicao_Produto__c compC3Erro = newComposicao_Produto(pbeFilhoCombo1.Product2Id, pbeFilhoCombo3.Product2Id, 'Combo', '');
        } catch (exception e) {
            System.debug('___ [cls Composicao_Teste - teste()] - EXCEPTION : Não permite composição em cascata : ' + e);
        }
        System.debug('___ [cls Composicao_Teste - teste()] - Muda parametros para aceitar composição em cascata ');
        Param.Composicao_cascata__c = true;
        update Param;
        Composicao_Produto__c compC3 = newComposicao_Produto(pbeFilhoCombo1.Product2Id, pbeFilhoCombo3.Product2Id, 'Combo', '');
        System.debug('___ [cls Composicao_Teste - teste()] - Parâmetro alterado. ');
      
    }
    
    public static PriceBookEntry newPriceBookEntry(String nome, Decimal valor){
        Product2 p = new Product2();
        p.Name = nome;
        p.Isactive = True;
        insert p;

        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Product2Id = p.Id;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.UnitPrice = valor;
        pbe.IsActive = (valor > 0);
        insert pbe;
        return pbe;
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