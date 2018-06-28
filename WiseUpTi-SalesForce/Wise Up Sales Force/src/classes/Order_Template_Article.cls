/*
    Test class: Order_Template_Article_Test
*/

public class Order_Template_Article{

    public String variavel {get; set;}
    public String typeSelected {get; set;}

    private String inicialOrder;
    
    public List<Item> getItems(){
        List<Item> items = new List<Item>();

        Template_Article__c templateArticle = 
            [SELECT Id
                , Name
                , Order__c
            FROM Template_Article__c
            WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
            
        inicialOrder = templateArticle.Order__c;
        
        for(Template_Article__c tc : 
                [SELECT Id
                    , Article__r.Name
                    , Order__c
                FROM Template_Article__c
                WHERE Article__r.Inactive__c = false
                AND Parent_Article__c =: templateArticle.Id
                ORDER BY Order__c]){
            Item i = new Item();
            i.id = tc.Id;
            i.name = tc.Article__r.Name;
            i.order = String.valueOf(tc.Order__c);
            items.add(i);
        }
        
        return items;
    }
    
    public void saveOrder(){
        List<Template_Article__c> templateArticles = new List<Template_Article__c>();
        
        Integer i = 1;
        
        for(String s : variavel.split(',')){
            Template_Article__c tc = new Template_Article__c();
            tc.Id = s;
            tc.Order__c = inicialOrder + '.' + i;

            templateArticles.add(tc);

            i ++;
        }
        
        try{
            if(templateArticles.size() > 0) update templateArticles;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, System.Label.OMSG01));
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
    public class Item{
        public String id {get; set;}
        public String name {get; set;}
        public String order {get; set;}
    }

}