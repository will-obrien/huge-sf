/*
    Test class: Order_Contract_Template_Test
*/

public class Order_Contract_Template{

    public String variavel {get; set;}
    public String typeSelected {get; set;}
    public List<Item> items {get; set;}
    
    private String inicialOrder;
    private String type;
    
    public List<SelectOption> getTypes(){
        List<SelectOption> l = new List<SelectOption>();
        
        for(AggregateResult ar :
                [SELECT Article__r.Clause__c clause
                FROM Template_Article__c
                WHERE  Article__r.Inactive__c = false
                AND Contract_Template__c =: ApexPages.currentPage().getParameters().get('id')
                AND Article__r.Clause__c <> ''
                GROUP BY Article__r.Clause__c
                ORDER BY Article__r.Clause__c]){
            l.add(new SelectOption((String) ar.get('clause'), (String) ar.get('clause')));
        }
        
        return l;
    }
    
    public void search(){
        items = new List<Item>();

        Contract_Template__c template = 
            [SELECT Id
                , Name
                , Order__c
            FROM Contract_Template__c
            WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
            
        inicialOrder = template.Order__c;
        
        for(Template_Article__c tc : 
                [SELECT Id
                    , Article__r.Name
                    , Order__c
                FROM Template_Article__c
                WHERE Contract_Template__c =: ApexPages.currentPage().getParameters().get('id')
                AND Article__r.Clause__c =: typeSelected
                AND Article__r.Inactive__c = false
                AND Parent_Article__c = null
                ORDER BY Order__c]){
            Item i = new Item();
            i.id = tc.Id;
            i.name = tc.Article__r.Name;
            i.order = String.valueOf(tc.Order__c);
            items.add(i);
        }
    }
    
    public void saveOrder(){  
        Map<String, Integer> orderMap = new Map<String, Integer>();
        
        Integer i = 1;
        
        for(PickListEntry p : Article__c.Clause__c.getDescribe().getPickListValues()){
            orderMap.put(p.getValue(), i);
            
            i ++;
        }
        
        Integer index = orderMap.get(typeSelected);
        
        i = 1;

        Set<Id> idParent = new Set<Id>();
        
        List<Template_Article__c> templateArticles = new List<Template_Article__c>();
                
        for(String s : variavel.split(',')){
            Template_Article__c tc = new Template_Article__c();
            tc.Id = s;
            tc.Order__c = index + '.' + i;

            templateArticles.add(tc);

            i ++;
            
            idParent.add(s);
        }
                
        try{
            if(templateArticles.size() > 0) update templateArticles;
            
            List<Template_Article__c> child =
                [SELECT Id
                    , Parent_Article__c
                    , Parent_Article__r.Order__c
                    , Order__c
                FROM Template_Article__c
                WHERE Parent_Article__c IN: idParent
                ORDER BY Parent_Article__r.Order__c];
                
            i = 1;
            
            String order = '';
            
            for(Template_Article__c tc : child){
                if(order == '') order = tc.Parent_Article__r.Order__c;
                else if(order != tc.Parent_Article__r.Order__c){
                    order = tc.Parent_Article__r.Order__c;
                    i = 1;
                }
                
                tc.Order__c = order + '.' + i;
                
                i ++;
            }
            
            update child;
            
            search(); 
            
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