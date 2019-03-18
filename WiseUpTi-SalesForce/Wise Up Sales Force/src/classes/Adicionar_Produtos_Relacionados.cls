/*
    Classe de testes: Adicionar_Produtos_Relacionados_Teste
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

public class Adicionar_Produtos_Relacionados {

    public List<Produto> produtos   { get; set; }
    public SObject sobj             { get; set; }
    public String objName           { get; set; }
    
    private Id sObjId;

    private String msgErro;
    private String query;

    private Map<Id, List<Composicao_produto__c>> produtosRelacionados;
    private Map<Id, PriceBookEntry> precoProdutos;
    private Map<Id, Produto> itens;
    private Set<Id> produtosPais;

    public Adicionar_Produtos_Relacionados(){

        sObjId = ApexPages.currentPage().getParameters().get('Id');

        if(sObjId.getSobjectType() == Schema.getGlobalDescribe().get('Opportunity'))    iniciaOpp();
        if(sObjId.getSobjectType() == Schema.getGlobalDescribe().get('Order'))          iniciaOrder();
        if(sObjId.getSobjectType() == Schema.getGlobalDescribe().get('Quote'))          iniciaQuote();

        sobj = Database.query(query);

        produtosRelacionados = new Map<Id, List<sObject>>();
        produtosPais = new Set<Id>();
        itens = new Map<Id, Produto>();     

        //initializa mapas e classes de apoio. 
        for(sObject li : sobj.getSObjects(objName+'s')){
            String prodId = (String)li.getSObject('PriceBookEntry').get('Product2Id');
            system.debug('___ [csl Adicionar_Produtos_Relacionados - buscaPrecos()] prodId - '+prodId);

            produtosRelacionados.put(prodId, new List<sObject>());
            itens.put(li.Id, new Produto(li));
            produtosPais.add(prodId);
        }

        buscaPrecos();

        //Cria lista de produtos para exibir na página
        Set<Id> produtosNaPagina = new Set<Id>();
        //for(OpportunityLineItem oli : opp.OpportunityLineItems){
        for(sObject li : sobj.getSObjects(objName+'s')){
            String prodId = (String)li.getSObject('PriceBookEntry').get('Product2Id');
            
            for(Composicao_produto__c cp : produtosRelacionados.get(prodId)){
                Id produtoFilho = cp.Produto_Filho__c;
                system.debug('___ [csl Adicionar_Produtos_Relacionados - construtor()] Preço do Produto Filho - '+precoProdutos.get(produtoFilho));
                system.debug('___ [csl Adicionar_Produtos_Relacionados - construtor()] Preço do Produto Filho existe? - '+(precoProdutos.get(produtoFilho) != null ));
                if( precoProdutos.get(produtoFilho) != null){
                    produtosNaPagina.add(produtoFilho);
                    itens.get(li.Id).itensRelacionados.add(new ItemRelacionado(cp, objName, li, precoProdutos.get(produtoFilho)));
                }
            } // final for composicao
            produtos.add(itens.get(li.Id));
        } //  final for li

        System.debug(LoggingLevel.ERROR, '___ [csl Adicionar_Produtos_Relacionados - construtor()] produtosNaPagina: '+ produtosNaPagina);
        if(produtosNaPagina.isEmpty()) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, msgErro));
    }


    //================================================
    //              métodos de apoio

    public void iniciaOpp(){
        objName = 'OpportunityLineItem'; //não tem o S porque será usado mais para frente

        query = 'SELECT'+
                    ' Id'+
                    ', PriceBook2Id'+
                    ', (SELECT'+
                            ' OpportunityId'+
                            ', PriceBookEntry.Product2Id'+
                            ', PriceBookEntry.Product2.Name'+
                            ', Quantity'+
                        ' FROM OpportunityLineItems'+
                        ' ORDER BY PriceBookEntry.Product2.Name)'+
                ' FROM Opportunity'+
                ' WHERE ID = :sObjId';

        msgErro = 'Não existem produtos complementares para esta oportunidade';

    }

    public void iniciaOrder(){
        objName = 'OrderItem'; //não tem o S porque será usado mais para frente

        query = 'SELECT'+
                    ' Id'+
                    ', PriceBook2Id'+
                    ', (SELECT'+
                            ' OrderId'+
                            ', PriceBookEntry.Product2Id'+
                            ', PriceBookEntry.Product2.Name'+
                            ', Quantity'+
                        ' FROM OrderItems'+
                        ' ORDER BY PriceBookEntry.Product2.Name)'+
                ' FROM Order'+
                ' WHERE ID = :sObjId';

        msgErro = 'Não existem produtos complementares para este pedido';   
    }

    public void iniciaQuote(){
        objName = 'QuoteLineItem'; //não tem o S porque será usado mais para frente

        query = 'SELECT'+
                    ' Id'+
                    ', PriceBook2Id'+
                    ', (SELECT'+
                            ' QuoteId'+
                            ', PriceBookEntry.Product2Id'+
                            ', PriceBookEntry.Product2.Name'+
                            ', Quantity'+
                        ' FROM QuoteLineItems'+
                        ' ORDER BY PriceBookEntry.Product2.Name)'+
                ' FROM Quote'+
                ' WHERE ID = :sObjId';

        msgErro = 'Não existem produtos complementares para esta cotação';
    }

    public void buscaPrecos(){
        system.debug('___ [csl Adicionar_Produtos_Relacionados - buscaPrecos()] sobj -'+sobj);
        
        produtos = new List<Produto>();

        //verifica produtos complementares de cada Opportunity Line Item que ainda não estão na oportunidade
        Set<Id> setProdutos = new Set<Id>();
        for(Composicao_produto__c cp : [SELECT
                                        Produto_Filho__c
                                        , Produto_Pai__c
                                        , Controla_Quantidade__c
                                    FROM Composicao_Produto__c
                                    WHERE Funcao__c = 'Complementar'
                                    AND Produto_Pai__c IN :produtosPais
                                    AND Produto_Filho__c NOT IN :produtosPais
                                    ORDER BY Produto_Filho__r.Name]){
            setProdutos.add(cp.Produto_Filho__c);
            produtosRelacionados.get(cp.Produto_Pai__c).add(cp);
            
        }

        system.debug('___ [csl Adicionar_Produtos_Relacionados - buscaPrecos()] produtosRelacionados -'+produtosRelacionados);

        //cria mapa de Entradas de Catálogo de Preço dos produtos relacionados
        precoProdutos = new Map<Id, PriceBookEntry>();
        for(PriceBookEntry pbe : [SELECT Id, Product2Id, Product2.Name, UnitPrice FROM PriceBookEntry WHERE Product2Id IN : setProdutos AND PriceBook2Id = :(Id)sobj.get('PriceBook2Id')]) 
            precoProdutos.put(pbe.Product2Id, pbe);


        system.debug('___ [csl Adicionar_Produtos_Relacionados - buscaPrecos()] precoProdutos -'+precoProdutos);

    }

    public PageReference salvar(){
        Boolean erro = false;
        List<sObject> itensInserir = new List<sObject>();

        for(Produto produto : produtos){
            
            for(ItemRelacionado i : produto.itensRelacionados){
                system.debug('___ [cls Adicionar_Produtos_Relacionados - salvar()] i - '+i);
                i.mensagem = '';
                if(i.adicionar){

                    if(i.quantidade == null || i.quantidade == 0){
                        erro = true;
                        i.mensagem = 'Informe a quantidade';
                    }else if(i.controle == 'Mesma quantidade do item' && i.quantidade != i.quantidadePai){
                        erro = true;
                        i.mensagem = 'A quantidade deve ser a mesma indicada para o produto '+i.nomeproduto;
                    }else if(i.controle == 'No máximo a quantidade do item' && i.quantidade > i.quantidadePai){
                        erro = true;
                        i.mensagem = 'A quantidade deve ser igual ou menor à quantidade indicada para o produto '+(String)produto.produto.getSobject('PriceBookEntry').getSobject('Product2').get('Name');
                    }else{
                        i.produto.put('Quantity', i.quantidade);
                        itensInserir.add(i.produto);
                    }
                }//final if adicionar
            }//final for i
        }//final for oppLi


        if(erro)    return null;

        try{
            insert itensInserir;
            return new PageReference('/'+sObjId);
        }catch(Exception e){
            erro = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        
    }   

    public PageReference cancelar(){
        return new PageReference('/'+sObjId);
    }


//==================================
//          classe de apoio
    public class Produto{

        public sObject produto                          { get; set; }
        public List<ItemRelacionado> itensRelacionados  { get; set; }

        public Produto(sObject prod){
            this.produto = prod;
            itensRelacionados = new List<ItemRelacionado>();
        }

    }

    public class ItemRelacionado{

        public sObject produto  { get; set; }
        
        public Boolean adicionar        { get; set; }
        public String controle          { get; set; }
        public String nomeproduto       { get; set; }
        public String mensagem          { get; set; }
        public Id produtoId             { get; set; }
        public Decimal quantidade       { get; set; }
        public Decimal quantidadePai    { get; set; }

        public ItemRelacionado(Composicao_produto__c cp, String objName ,sObject prod, PriceBookEntry pbe){
            system.debug('___ [cls Adicionar_Produtos_Relacionados - construtor()] ***novo item relacionado****\n'+cp+'\n'+prod+'\n'+pbe);

            produto = Schema.getGlobalDescribe().get(objName).newSobject();

            if(objName == 'OpportunityLineItem')    produto.put('OpportunityId', prod.get('OpportunityId'));
            if(objName == 'OrderItem')              produto.put('OrderId', prod.get('OrderId'));
            if(objName == 'QuoteLineItem')          produto.put('QuoteId', prod.get('QuoteId'));

            produto.put('PriceBookEntryId', pbe.Id);
            produto.put('UnitPrice', pbe.UnitPrice);

            nomeProduto = pbe.Product2.Name;
            produtoId = pbe.Product2Id;
            controle = cp.Controla_Quantidade__c;
            quantidadePai = (Decimal)prod.get('Quantity');
            quantidade = (controle == 'Mesma quantidade do item' ? (Decimal)prod.get('Quantity') : 0);
            adicionar = false;

            system.debug('___ [cls Adicionar_Produtos_Relacionados - construtor()] produto adicionado - '+this);
        }
    }

}