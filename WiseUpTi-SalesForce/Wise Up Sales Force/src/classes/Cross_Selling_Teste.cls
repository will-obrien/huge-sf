/*
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Cross_Selling_Teste {
    
    static testMethod void testeOportunidade() {
        Account conta = Teste_Util.newAccount();
        
        PricebookEntry pbe1 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('1').Id);
        PricebookEntry pbe2 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('2').Id);
        PricebookEntry pbe3 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('3').Id);
        PricebookEntry pbe4 = Teste_Util.newPricebookEntry(Teste_Util.newProduct2('4').Id);
        
        Composicao_Produto__c cp1 = Composicao_Teste.newComposicao_Produto(pbe1.Product2Id, pbe2.Product2Id, 'Complementar', 'Qualquer quantidade');
        Composicao_Produto__c cp2 = Composicao_Teste.newComposicao_Produto(pbe1.Product2Id, pbe3.Product2Id, 'Complementar', 'Mesma quantidade do item');
        Composicao_Produto__c cp3 = Composicao_Teste.newComposicao_Produto(pbe1.Product2Id, pbe4.Product2Id, 'Complementar', 'No máximo a quantidade do item');
        
        Opportunity oportunidade = Teste_Util.newOpportunity(conta.Id);
        
        Teste_Util.newOpportunityLineItem(oportunidade.Id, pbe1.Id);
        Teste_Util.newOpportunityLineItem(oportunidade.Id, pbe2.Id);

        PageReference pg = ApexPages.currentPage();
        
        pg.getParameters().put('Id', oportunidade.Id);
        
        Test.setCurrentPage(pg);

        Cross_Selling classe = new Cross_Selling();

/*
        Cross_Selling testeOpp = new Cross_Selling();
        testeOpp.paginas[0][0].quantidade = 20;
*/
        classe.verificaQuantidades(); 

        classe.salvar();
        
        try{
            classe.iniciaOrder();
            
            classe.iniciaQuote();
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, '___ [cls Cross_Selling_Teste - testeOportunidade()] - ERROR: '+ e.getMessage());
        }
    }

/*
    public static void testaCotacao(){

        inicial();
        oppId = newObjeto('Opportunity');

        String objName = 'Quote';
        Id idPai = newObjeto(objName);
        newItem(objName, idPai, pbe1.Id, 10.50, 10);

        PageReference pg = new PageReference('paginaTeste');
        pg.getParameters().put('id', idPai);
        Test.setCurrentPage(pg);

        Cross_Selling testeQuote = new Cross_Selling();
    }


    public static void testaPedido() {
        
        inicial();

        String objName = 'Order';
        Id idPai = newObjeto(objName);
        newItem(objName, idPai, pbe1.Id, 10.50, 10);

        PageReference pg = new PageReference('paginaTeste');
        pg.getParameters().put('id', idPai);
        Test.setCurrentPage(pg);

        Cross_Selling testeOrder = new Cross_Selling();

    }

    

    public static Id newObjeto(String sObjName){
        
        SObject sObj = Schema.getGlobalDescribe().get(sObjName).newSobject();

        sObj.put('Name', 'Teste');
        sObj.put('PriceBook2Id', (Id) Test.getStandardPricebookId());
        
        if (sObjName == 'Opportunity'){
            sObj.put('CloseDate', System.today());
            sObj.put('StageName', 'Em Teste');
        }
        if (sObjName == 'Quote'){
            sObj.put('OpportunityId', oppId);
        }
        if (sObjName == 'Order'){
            sObj.put('EffectiveDate', System.today());
            sObj.put('Status', 'Draft');
            sObj.put('AccountId', acc.Id);
        }

        insert sObj;
        return sObj.Id;
    }
    
    public static void newItem(String sObjName, Id idPai, Id pbeId, Decimal valor, Integer quantidade){
        
        String itemName = sObjName+(sObjName == 'Order' ? '' : 'Line')+'Item';
        SObject item = Schema.getGlobalDescribe().get(itemName).newSobject();

        item.put(sObjName+'Id', idPai);
        item.put('PriceBookEntryId', pbeId);
        item.put('UnitPrice', valor);
        item.put('Quantity', quantidade);
        
        insert item;
    }*/
    
}