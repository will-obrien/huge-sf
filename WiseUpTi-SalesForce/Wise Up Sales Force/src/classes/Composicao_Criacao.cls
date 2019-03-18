/*
    Classe teste: Composicao_Criacao_Teste
*/
public class Composicao_Criacao{

    public static String objName { get; set; }    
//    public SObject sobj        { get; set; }
    public static List<Produto> produtos;
    private static SObject sobj;

    public static Set<Id> idsProdutoPai; // = new Set<Id>();
    public static Set<Id> idsProdutoFilho; // = new Set<Id>();
    public static Set<Id> idsItens; // = new Set<Id>();
    
    private static Map<Id, List<Produto>> objetoItens;
    private static Map<Id, List<Composicao_Produto__c>> produtosRelacionados;
    private static Map<Id, Id> listaPreco;

    public static List<String> retorno;
    
    public static List<String> ItensOli(List<SObject> tNew){
        String dbug = '___ [cls Composicao_Criacao - ItensOli]';
        System.debug(dbug + ' ..START.. ' );
        produtos = new List<Produto>();
        objetoItens = new Map<Id, List<Produto>>();
        objName = 'OpportunityLineItem';
        retorno  = new List<String>();

        for (SObject oli: tNew){
            idsItens = new Set<Id>();
            idsProdutoPai = new Set<Id>();
            if (oli.get('Funcao__c') == null || oli.get('Funcao__c') == '') {
                System.debug(dbug + ' - oli.get(Funcao__c) : ' + oli.get('Funcao__c') );
                idsItens.add( oli.Id );
                idsProdutoPai.add( (Id) oli.get('Product2Id') );
                Produto prod = new Produto(oli);
    
                prod.nomeProduto = String.ValueOf(oli.get('Name'));
                prod.produtoId = (Id) oli.get('Product2Id');
                prod.objetoPaiId = (Id) oli.get('OpportunityId');
                prod.referenciaId = (Id) oli.get('Id');
                prod.quantidade = (Decimal) oli.get('Quantity');
                prod.valor = (Decimal) oli.get('UnitPrice');
                prod.erro = false;
    
                produtos.add(prod);
                
                if (objetoItens.get( (Id) oli.get('OpportunityId')) == null){
                    objetoItens.put( (Id) oli.get('OpportunityId'), new List<Produto>() );
                }
                objetoItens.get( (Id) oli.get('OpportunityId') ).add(prod);
            }
        }
        
        System.debug(dbug + ' - objetoItens: ' + objetoItens);
        System.debug(dbug + ' - produtos : ' + produtos );
        System.debug(dbug + ' - idsItens.size() : ' + idsItens.size() );
        System.debug(dbug + ' - retorno : ' + retorno );
        System.debug(dbug + ' ..END..' );
        if (idsItens.size() > 0)
            Itens();
        return retorno;
    }
    
/*    public static List<String> ItensQli(List<SObject> tNew){
        produtos = new List<Produto>();
        objetoItens = new Map<Id, List<Produto>>();
        objName = 'QuoteLineItem';
        retorno  = new List<String>();

        for (SObject oli: tNew){
            idsItens = new Set<Id>();
            idsProdutoPai = new Set<Id>();
            if (oli.get('Funcao__c') == null || oli.get('Funcao__c') == '') {
                System.debug( ' oli.get(Funcao__c) : ' + oli.get('Funcao__c') );
                idsItens.add( oli.Id );
                idsProdutoPai.add( (Id) oli.get('Product2Id') );
                Produto prod = new Produto(oli);
    
//                prod.nomeProduto = String.ValueOf(oli.get('Name'));
                prod.produtoId = (Id) oli.get('Product2Id');
                prod.objetoPaiId = (Id) oli.get('QuoteId');
                prod.referenciaId = (Id) oli.get('Id');
                prod.quantidade = (Decimal) oli.get('Quantity');
                prod.valor = (Decimal) oli.get('UnitPrice');
                prod.erro = false;
    
                produtos.add(prod);
                
                if (objetoItens.get( (Id) oli.get('QuoteId')) == null){
                    objetoItens.put( (Id) oli.get('QuoteId'), new List<Produto>() );
                }
                objetoItens.get( (Id) oli.get('QuoteId') ).add(prod);
            }
        }
        
        System.debug('idsItens.size() : ' + idsItens.size() );
        if (idsItens.size() > 0)
            Itens();
        return retorno;
    }    
    
    
    public static List<String> ItensOi(List<SObject> tNew){
        Set<Id> pbe = new Set<Id>();
        Map<Id, String> produtoMap = new Map<Id, String>();
        produtos = new List<Produto>();
        objetoItens = new Map<Id, List<Produto>>();
        objName = 'OrderItem';
        retorno  = new List<String>();

        for (SObject oi: tNew){
            pbe.add( (Id) oi.get('PriceBookEntryId') );
        }
        listaPreco = new Map<Id, Id>();
        for (PriceBookEntry p : [SELECT Id, IsActive, PriceBook2Id, Product2Id, Product2.Name FROM PriceBookEntry WHERE Id IN: pbe]){
            produtoMap.put(p.Id, p.Product2Id + '' + p.PriceBook2Id + '' + p.Product2.Name );
        }
        
        String idSF = '';
        String nomeprod = '';
        for (SOBject oi: tNew) {
            idsItens = new Set<Id>();
            idsProdutoPai = new Set<Id>();
            if (oi.get('Funcao__c') == null || oi.get('Funcao__c') == '') {
                System.debug( ' oi.get(Funcao__c) : ' + oi.get('Funcao__c') );
                idsItens.add( oi.Id );
                
                idSF = (Id) produtoMap.get((Id) oi.get('PriceBookEntryId')).subString(0,18);
                nomeprod = produtoMap.get((Id) oi.get('PriceBookEntryId'));
                nomeprod = nomeprod.substring(36, nomeprod.length() - 1);

                idsProdutoPai.add(idSF); 

                Produto prod = new Produto(oi);
                prod.nomeProduto = nomeprod ; //produtoMap.get((Id) oi.get('PriceBookEntryId')).substring(17, produtoMap.get((Id) oi.get('PriceBookEntryId')).length() - 18 ); //String.ValueOf(oi.get('Name'));
                prod.produtoId = idSF; //(Id) oi.get('Product2Id');
                prod.objetoPaiId = (Id) oi.get('OrderId');
                prod.referenciaId = (Id) oi.get('Id');
                prod.quantidade = (Decimal) oi.get('Quantity');
                prod.valor = (Decimal) oi.get('UnitPrice');
                idSF = (Id) produtoMap.get((Id) oi.get('PriceBookEntryId')).subString(18,36);
                System.debug('___ [cls Composicao_Criacao - ItensOi()] - idSF : ' + idSF);
                prod.pricebookId = idSF;
                prod.erro = false;
    
                produtos.add(prod);
                
                if (objetoItens.get( (Id) oi.get('OrderId')) == null){
                    objetoItens.put( (Id) oi.get('OrderId'), new List<Produto>() );
                }
                objetoItens.get( (Id) oi.get('OrderId') ).add(prod);

                listaPreco.put( (Id) oi.get('OrderId'), (Id) idSF);
            }
        }
        
        System.debug('idsItens.size() : ' + idsItens.size() );
        if (idsItens.size() > 0)
            Itens();
        return retorno;
    }    
*/

    public static Boolean Itens(){
    String dbug =  '___ [cls Composicao_Criacao - Itens()]';
        Map<String, PriceBookEntry> listaItens = new Map<String, PriceBookEntry>();
        Map<Id, Id> filhosMap = new Map<Id, Id>();
        
        String query = '';
        if (objName == 'OpportunityLineItem'){
            query = 'SELECT Id, Product2.Name, OpportunityId, Opportunity.Pricebook2Id '+
                    'FROM OpportunityLineItem '+
                    'WHERE Id IN : idsItens';
        }
        if (objName == 'QuoteLineItem'){
            query = 'SELECT Id, Product2.Name, QuoteId, Quote.Pricebook2Id '+
                    'FROM QuoteLineItem '+
                    'WHERE Id IN : idsItens';
        }


        //// SELECT 1º ////
        if (query <> ''){
            listaPreco = new Map<Id, Id>();
            for (SObject objetoPai : Database.query(query) ){
//        for (SObject objetoPai : [SELECT Id, Product2.Name, OpportunityId, Opportunity.Pricebook2Id FROM OpportunityLineItem WHERE Id IN : idsItens]){
                if (objName == 'OpportunityLineItem'){
                    listaPreco.put( (Id) objetoPai.get('OpportunityId'), (Id) objetoPai.getSObject('Opportunity').get('Pricebook2Id'));
                    for (Integer i = 0 ; i < objetoItens.get( (Id) objetoPai.get('OpportunityId') ).size() ; i++ ) { //(Produto p : objetoItens.get( objetoPai.get('OpportunityId')) ) {
                        objetoItens.get( (Id) objetoPai.get('OpportunityId') )[i].pricebookId = (Id) objetoPai.getSObject('Opportunity').get('Pricebook2Id');
                        objetoItens.get( (Id) objetoPai.get('OpportunityId') )[i].nomeProduto = (String) objetoPai.getSObject('Product2').get('Name');
                    }    
                }
                if (objName == 'QuoteLineItem'){
                    listaPreco.put( (Id) objetoPai.get('QuoteId'), (Id) objetoPai.getSObject('Quote').get('Pricebook2Id'));
                    for (Integer i = 0 ; i < objetoItens.get( (Id) objetoPai.get('QuoteId') ).size() ; i++ ) { //(Produto p : objetoItens.get( objetoPai.get('OpportunityId')) ) {
                        objetoItens.get( (Id) objetoPai.get('QuoteId') )[i].pricebookId = (Id) objetoPai.getSObject('Quote').get('Pricebook2Id');
                        objetoItens.get( (Id) objetoPai.get('QuoteId') )[i].nomeProduto = (String) objetoPai.getSObject('Product2').get('Name');
                    }    
                }
            }
        }
        System.debug(dbug + ' - objetoItens: ' + objetoItens);
        if ( listaPreco.size() == 0 )
            return false;



        produtosRelacionados = new Map<Id, List<Composicao_Produto__c>>();
        idsProdutoFilho = new Set<Id>();
        //// SELECT 2º ////
        for (Composicao_produto__c composicao : [SELECT Id, Produto_Filho__c, Produto_Pai__c, Funcao__c, Quantidade__c, Produto_Filho__r.Name
                                                 FROM Composicao_produto__c 
                                                 WHERE (Funcao__c = 'Obrigatório' OR Funcao__c = 'Combo' ) 
                                                 AND Produto_Pai__c IN : idsProdutoPai
                                                 ORDER BY Produto_Pai__c]){
            
            filhosMap.put(composicao.Produto_filho__c, composicao.Produto_Pai__c);
            idsProdutoFilho.add(composicao.Produto_Filho__c);
            System.debug(dbug + ' - composicao : ' + composicao);
            
            
            if (produtosRelacionados.get(composicao.Produto_Pai__c) == null) {
                produtosRelacionados.put(composicao.Produto_Pai__c, new List<Composicao_produto__c>());
            }
            produtosRelacionados.get(composicao.Produto_Pai__c).add(composicao);
        }
        
        System.debug(dbug + ' - produtosRelacionados : ' + produtosRelacionados);
        System.debug(dbug + ' - 01');
        if ( filhosMap.size() == 0 ) 
            return false;
        
        System.debug(dbug + ' - 02');
        Map<String, Decimal> precoMap = new Map<String, Decimal>();
        //// SELECT 3º ////
        System.debug(dbug + ' - listaPreco.Values() : ' + listaPreco.Values());
        System.debug(dbug + ' - idsProdutoFilho : ' + idsProdutoFilho);
        for (PriceBookEntry pbe: [SELECT Id, IsActive, Product2Id, PriceBook2Id, UnitPrice FROM PriceBookEntry WHERE PriceBook2Id IN : listaPreco.Values() AND Product2Id IN : idsProdutoFilho ]){
            // product + PB => esta na lista
            System.debug(dbug + ' - 03');
            if (pbe.IsActive) {
                System.debug(dbug + ' - 03');
                precoMap.put( pbe.Product2Id+''+pbe.PriceBook2Id, pbe.UnitPrice);
                for ( Id objPaiId : objetoItens.keySet() ){
                    System.debug(dbug + ' - 04');
                    if ( objetoItens.get(objPaiId)[0].pricebookId == pbe.PriceBook2Id ){
                        System.debug(dbug + ' - 05');    
                        listaItens.put(objPaiId + '' + pbe.Product2Id,  pbe);            
                    }
                }
            }
        }
        System.debug(dbug + ' - 10');
        if ( precoMap.size() == 0 )
            return false;

        System.debug(dbug + ' - 11');
        List<SObject> oldItens = new List<SObject>();
        Set<Id> olds = new Set<Id>();
        for (Produto so : produtos){
            so.valorComboVendido = 0;
            so.valorListaItens = 0;
            System.debug(dbug + ' - 01 valorComboVendido : ' + so.valorComboVendido);
            System.debug(dbug + ' - 01 produtosRelacionados: ' + produtosRelacionados);
            System.debug(dbug + ' - 01 so.produtoId: ' + so.produtoId);

            if (produtosRelacionados.get( so.produtoId ) <> null){
                for (Composicao_Produto__c cp : produtosRelacionados.get( so.produtoId ) ){ //Filhos
                    if ( precoMap.get(cp.Produto_Filho__c + '' + listaPreco.get(so.objetoPaiId)) == null ){
                        System.debug(dbug + ' ..OUT..');
                        retorno.add(so.referenciaId);
                        retorno.add('Atenção! O item ' + cp.Produto_Filho__r.Name + ' não está precificado neste catálogo de preços, verifique para prosseguir.');
                        so.erro = true;
                        return true;
                    }
    
                    if (cp.Funcao__c == 'Combo') {
                        so.valorComboVendido = so.valorComboVendido + (precoMap.get(cp.Produto_Filho__c + '' + listaPreco.get(so.objetoPaiId))*cp.Quantidade__c) ;
                        System.debug(dbug + ' - 02 valorComboVendido : ' + so.valorComboVendido);
                    }
    
                    if (cp.Funcao__c == 'Combo' && !olds.contains(so.produto.Id)) {
                        if (objName == 'OpportunityLineItem'){
                            oldItens = new List<OpportunityLineItem>();
                            oldItens.add(new OpportunityLineItem(id = so.produto.Id)); // Lista qli - old
                        }
    /*                    if (objName == 'QuoteLineItem'){
                            oldItens = new List<QuoteLineItem>();
                            oldItens.add(new QuoteLineItem(id = so.produto.Id)); // Lista qli - old
                        }
                        if (objName == 'OrderItem'){
                            oldItens = new List<OrderItem>();
                            oldItens.add(new OrderItem(id = so.produto.Id)); // Lista qli - old
                        }
    */                    
                        oldItens[oldItens.size()-1].put('Deletando__c',True);
                        olds.add(so.produto.Id);
                    }
                }
                
                for (Composicao_Produto__c cp : produtosRelacionados.get( so.produtoId ) ){ //Filhos
                    ItemRelacionado item = new ItemRelacionado(so, cp, listaItens.get(so.objetoPaiId + '' + cp.Produto_Filho__c) );
                    System.debug(dbug + ' - Item Relacionado Item: : ' + item);
                    so.ItensRelacionados.add(item);
                }
            }
        }
        
        System.debug(dbug + ' - 20');
        List<SObject> newItens = new List<SObject>();
        
        System.debug(dbug + ' - produto: ' + produtos);
        for (Produto p: produtos) {
            for (ItemRelacionado i : p.itensRelacionados) {
                newItens.add(i.produto);
            }
        }
        
        System.debug(dbug + ' - insert newItens : '+ newItens);
//        return false;

        if (newItens.size() > 0 ){
            if (oldItens.size() > 0 ){
                System.debug(dbug + ' - Lista para excluir : '+ oldItens);
                update oldItens; // atualizar o campo Deletando__c dos registros que serão excluidos
                delete oldItens;
            }
            System.debug(dbug + ' - insert newItens : '+ newItens);
            insert newItens;
        }
        return false;
    }
    

//==================================
//          classe de apoio
//==================================

    public class Produto{

        public sObject produto { get; set; }
        public Id pricebookId  { get; set; }
        public Id produtoId    { get; set; }
        public Id objetoPaiId  { get; set; }
        public Id referenciaId { get; set; }
        public Decimal quantidade { get; set; }
        public Decimal valor   { get; set; }
        public Decimal valorComboVendido { get; set; }
        public Decimal valorListaItens { get; set; }
        public Boolean erro    { get; set; }
        public String nomeProduto { get; set; }
        public List<ItemRelacionado> itensRelacionados  { get; set; }

        public Produto(sObject prod){
            this.produto = prod;
            itensRelacionados = new List<ItemRelacionado>();
        }

    }
    
    public class ItemRelacionado{

        public sObject produto  { get; set; }

        public ItemRelacionado(produto pPai, Composicao_Produto__c cp, PriceBookEntry pbe){

            produto = Schema.getGlobalDescribe().get(objName).newSobject();
            
            System.debug('___ [cls Composicao_Criacao - ItemRelacionado()] - objName : '+ objName);
            if(objName == 'OpportunityLineItem')  produto.put('OpportunityId', pPai.objetoPaiId);
            if(objName == 'OrderItem')            produto.put('OrderId', pPai.objetoPaiId);
            if(objName == 'QuoteLineItem')        produto.put('QuoteId', pPai.objetoPaiId);
            System.debug('___ [cls Composicao_Criacao - ItemRelacionado()] - pPai: '+ pPai);

            System.debug('___ [cls Composicao_Criacao - ItemRelacionado()] - valorComboVendido : '+ pPai.valorComboVendido);
            System.debug('___ [cls Composicao_Criacao - ItemRelacionado()] - valorListaItens : '+ pPai.valorListaItens);
            produto.put('PriceBookEntryId', pbe.Id);
            produto.put('Quantity', cp.Quantidade__c * pPai.quantidade);
            produto.put('Id_Item_pai__c', pPai.referenciaId);
//            produto.put('valor', pbe.UnitPrice);

/*            System.debug('-------' );
            System.debug('Quantidade do item no combo: ' + cp.Quantidade__c );
            System.debug('Quantidade do combo: ' + pPai.quantidade );
            System.debug('Quantidade do item na venda: ' + produto.get('Quantity') );
            System.debug('-------' );

            System.debug('Valor de lista do item : ' + pbe.UnitPrice );
            System.debug('Valor de total da lista : ' + (pbe.UnitPrice*(Decimal) produto.get('Quantity')) );
            System.debug('Valor do combo : ' + pPai.valorcomboVendido );
            System.debug('-------' );
            System.debug('Valor do combo vendido : ' + pPai.valor );
            System.debug('Valor do item na venda : ' + (pPai.valor * pbe.UnitPrice)/pPai.valorComboVendido);
            System.debug('Valor total do item na venda : ' + pbe.UnitPrice );

            System.debug('Quantidade: ' + produto.get('Quantity') );*/

            if ( cp.Funcao__c == 'Combo' ) {
                produto.put('Funcao__c', pPai.nomeProduto);
                produto.put('UnitPrice', (pPai.valor*pbe.UnitPrice) / (pPai.valorComboVendido) );
            }else{
                produto.put('Funcao__c', 'Requerido para ' + pPai.nomeProduto);
                produto.put('UnitPrice', pbe.UnitPrice );
            }

            system.debug('___ [cls Composicao_Criacao - ItemRelacionado()] produto - '+this);
        }
  }
    
}