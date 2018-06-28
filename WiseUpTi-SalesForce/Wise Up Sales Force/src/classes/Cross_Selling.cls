public class Cross_Selling {

    public sObject sobj                 { get; set; }
    public Id sObjId                    { get; set; }
    public List<List<Produto>> paginas  { get; set; }

    public Decimal itensPagina          { get; set; } //deve ser múltiplo de e menor/igual a 12 

    public Boolean erro                 { get; set; }
    public Boolean refresh              { get; set; }

    private Set<Id> produtosNoPai;
    private List<sObject> produtosInserir;

    private Boolean form;

    private String msgErro;
    private String nomeItensFilhos;
    private String query;


    public Cross_Selling() {
        // por se tratar de componente, o construtor ainda não recebe os parâmetros.
        // para isso, usamos um segundo método   
        erro = false;
        refresh = false;
        itensPagina = Composicao_Produtos_Permissao__c.getInstance().Itens_Pagina__c;
        paginas = new List<List<Produto>>();

        form = ApexPages.currentPage().getParameters().get('form') == 'true'; // " == 'true' " previne contra nulos
        sObjId = ApexPages.currentPage().getParameters().get('Id');

        if(sObjId.getSobjectType() == Schema.getGlobalDescribe().get('Opportunity'))    iniciaOpp();
        if(sObjId.getSobjectType() == Schema.getGlobalDescribe().get('Order'))          iniciaOrder();
        if(sObjId.getSobjectType() == Schema.getGlobalDescribe().get('Quote'))          iniciaQuote();

        system.debug('___ [csl Cross_Selling - construtor] sobj -'+sobj);

        produtosNoPai = new Set<Id>();

        //verifica produtos que já estão na oportunidade/cotação/pedido. 
        for(sObject li : sobj.getSObjects(nomeItensFilhos+'s')){
            produtosNoPai.add((Id)li.getSObject('PricebookEntry').get('Product2Id'));
        }

        preencheLista();
    }

    //================================================
    //              métodos de apoio

    public void iniciaOpp(){
        nomeItensFilhos = 'OpportunityLineItem';
        msgErro = 'Não existem produtos de Cross Selling para esta oportunidade';

        //Seleciona a oportunidade em contexto
        String query = 'SELECT'+
                            ' Id'+
                            ', PriceBook2Id'+
                            ', (SELECT'+
                                    ' OpportunityId'+
                                    ', PriceBookEntryId'+
                                    ', PricebookEntry.Product2Id'+
                                    ', PricebookEntry.Product2.Name'+
                                    ', Quantity'+
                                ' FROM OpportunityLineItems)'+
                        ' FROM Opportunity'+
                        ' WHERE ID = :sObjId';


        sobj = Database.query(query);
    }


    public void iniciaOrder(){
        nomeItensFilhos = 'OrderItem';
        msgErro = 'Não existem produtos de Cross Selling para este pedido';
        
        //Seleciona o pedido em contexto
        String query = 'SELECT'+
                            ' Id'+
                            ', PriceBook2Id'+
                            ', (SELECT'+
                                    ' OrderId'+
                                    ', PriceBookEntryId'+
                                    ', PricebookEntry.Product2Id'+
                                    ', PricebookEntry.Product2.Name'+
                                    ', Quantity'+
                            ' FROM OrderItems)'+
                        ' FROM Order'+
                        ' WHERE ID = :sObjId';

        sobj = Database.query(query);
    }


    public void iniciaQuote(){      
        nomeItensFilhos = 'QuoteLineItem';
        msgErro = 'Não existem produtos de Cross Selling para esta cotação';

        //Seleciona a cotação em contexto
        String query = 'SELECT'+
                            ' Id'+
                            ', PriceBook2Id'+
                            ', (SELECT'+
                                    ' QuoteId'+
                                    ', PriceBookEntryId'+
                                    ', PricebookEntry.Product2Id'+
                                    ', PricebookEntry.Product2.Name'+
                                    ', Quantity'+
                                ' FROM QuoteLineItems)'+
                        ' FROM Quote'+
                        ' WHERE ID = :sObjId';


        sobj = Database.query(query);       
    }

    public void preencheLista(){

        //verifica produtos complementares que ainda não foram adicionados de cada produto
        Set<Id> setProdutos = new Set<Id>();
        List<Composicao_Produto__c> produtosRelacionados = new List<Composicao_Produto__c>();
        for(Composicao_Produto__c cp : [SELECT
                                            Produto_Filho__c
                                            , Produto_Pai__c
                                            , Controla_Quantidade__c
                                        FROM Composicao_Produto__c
                                        WHERE Funcao__c = 'Cross selling'
                                        AND Produto_Pai__c IN :produtosNoPai
                                        AND Produto_Filho__c NOT IN :produtosNoPai
                                        ORDER BY Produto_Filho__r.Name]){
            
            if(setProdutos.add(cp.Produto_Filho__c)) produtosRelacionados.add(cp);

        }
        

        system.debug('___ [csl Cross_Selling - preencheLista()] produtosRelacionados -'+produtosRelacionados);


        //cria mapa de Entradas de Catálogo de Preço dos produtos relacionados
        Map<Id, PriceBookEntry> precoProdutos = new Map<Id, PriceBookEntry>();
        for(PriceBookEntry pbe : [SELECT Id, Product2Id, Product2.Name, UnitPrice FROM PriceBookEntry WHERE Product2Id IN : setProdutos AND PriceBook2Id = :(Id)sobj.get('PriceBook2Id')]) 
            precoProdutos.put(pbe.Product2Id, pbe);


        if(precoProdutos.size() == 0){
            erro = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, msgErro));
            return;
        }


        system.debug('___ [csl Cross_Selling - preencheLista()] precoProdutos -'+precoProdutos);

        //Cria lista de produtos para exibir na página
        List<Produto> produtos = new List<Produto>();
        integer i = 1;
        for(Composicao_Produto__c cp : produtosRelacionados){
            if((precoProdutos.get(cp.Produto_Filho__c) != null))produtos.add(new Produto(cp, nomeItensFilhos, sObjId, precoProdutos.get(cp.Produto_Filho__c)));
            if(i == itensPagina){ //quando uma página está completa, adiciona todos os itens e inicia a próxima página
                paginas.add(produtos);
                produtos = new List<Produto>();
                i = 0;            
            }
            i++;
        } // final for composicao
        if(produtos.size() > 0 ) paginas.add(produtos); //adiciona itens da última página

        system.debug('___ [csl Cross_Selling - preencheLista()] paginas -'+paginas);

    }


    public void verificaQuantidades(){

        system.debug('___ [csl Cross_Selling - verificaQuantidades()] **chamado** ');

        for(List<Produto> pagina : paginas){
            for(Produto prod : pagina){
                if(prod.quantidade > 0){
                    prod.produto.put('Quantity', prod.quantidade);
                    prod.adicionar = true;
                }
            }
        }

        if(!form) salvar();
    }

    public PageReference salvar(){

        system.debug('___ [csl Cross_Selling - salvar()] **chamado** ');

        List<sObject> itensInserir = new List<sObject>();

        for(List<Produto> produtos : paginas){
            for(Produto prod : produtos){
                system.debug('___ [cls Cross_Selling - salvar()] produto - '+prod);
                if(prod.adicionar) itensInserir.add(prod.produto);
            }
        }

        system.debug('___ [csl Cross_Selling - salvar()] itensInserir - '+itensInserir );

        try{
            insert itensInserir;
        }catch(Exception e){
            erro = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Houve um erro ao adicionar os produtos: '+e.getMessage()+' (linha '+e.getLineNumber()+')'));
        }

        refresh = !form;
        return null;
    }




//===============================================
//              classe interna

    public class Produto{

        public SObject produto              { get; set; }
        
        public Boolean adicionar            { get; set; }
        public String nomeproduto           { get; set; }
        public Decimal quantidade           { get; set; }

        public Produto(Composicao_Produto__c cp, String objName, Id sObjectId, PriceBookEntry pbe){
            system.debug('___ [cls Produto - iniciaOpp()] ***novo item relacionado****\nComposição do Produto'+cp+'\n'+sObjectId.getSobjectType()+': '+sObjectId+'\nPricebookEntry'+pbe);

            produto = Schema.getGlobalDescribe().get(objName).newSobject();

            if(objName == 'OpportunityLineItem')    produto.put('OpportunityId', sObjectId);
            if(objName == 'OrderItem')              produto.put('OrderId', sObjectId);
            if(objName == 'QuoteLineItem')          produto.put('QuoteId', sObjectId);

            produto.put('PriceBookEntryId', pbe.Id);
            produto.put('UnitPrice', pbe.UnitPrice);

            nomeProduto = pbe.Product2.Name;
            adicionar = false;

            system.debug('___ [cls Produto - iniciaOpp()] produto adicionado - '+this);
        }
    }
}