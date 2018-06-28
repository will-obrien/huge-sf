/*
    Test class: Order_Contract_Article_Test
*/

public class Order_Contract_Article{

    public String variavel {get; set;}
    public String typeSelected {get; set;}
    public List<Item> items {get; set;}
    public boolean block {get; set;}
    
    private Map<Id, String> existOrderMap;

    public Order_Contract_Article(){
        List<Contract_Article__c> contractArticleList = 
            [SELECT Id 
            FROM Contract_Article__c 
            WHERE Order_Lock__c = false 
            AND Inactive__c = false
            AND Contract__c =: ApexPages.currentPage().getParameters().get('id')
            LIMIT 1];
            
        if(contractArticleList.size() == 0){
            block = true;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                System.Label.OMSG02));
        }else block = false;
    }

    public List<SelectOption> getTypes(){
        List<SelectOption> l = new List<SelectOption>();
        
            if(!block){
            for(AggregateResult ar : 
                    [SELECT Article__r.Clause__c clause
                    FROM Contract_Article__c
                    WHERE Contract__c =: ApexPages.currentPage().getParameters().get('id')
                    AND Inactive__c = false
                    AND Parent_Article__c = null
                    GROUP BY Article__r.Clause__c
                    ORDER BY Article__r.Clause__c]){
                l.add(new SelectOption((String) ar.get('clause'), (String) ar.get('clause')));
            }
        }
        
        return l;
    }
    
    public void search(){
        existOrderMap = new Map<Id, String>();
        
        items = new List<Item>();

        for(Contract_Article__c cc : 
                [SELECT Id
                    , Order__c
                    , Article__r.Name
                    , Order_Lock__c
                FROM Contract_Article__c
                WHERE Article__r.Inactive__c = false
                AND Contract__c =: ApexPages.currentPage().getParameters().get('id')
                AND Article__r.Clause__c =: typeSelected
                AND Parent_Article__c = null
                ORDER BY Order__c]){
            Item i = new Item();
            i.id = cc.Id;
            i.name = cc.Article__r.Name;
            i.order = cc.Order__c;
            i.locked = cc.Order_Lock__c;
            
            items.add(i);
            
            existOrderMap.put(cc.Id, String.isEmpty( cc.Order__c ) ? '' : cc.Order__c);
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
        
        List<Contract_Article__c> contractArticles = new List<Contract_Article__c>();
                
        for(String s : variavel.split(',')){
            Contract_Article__c cc = new Contract_Article__c();
            cc.Id = s;
            cc.Order__c = index + '.' + i;
            
            if(existOrderMap.get(cc.Id) != cc.Order__c){
                contractArticles.add(cc);
    
                idParent.add(s);
            }
            
            i ++;
        }
                
        try{
            if(contractArticles.size() > 0) update contractArticles;
            
            List<Contract_Article__c> child =
                [SELECT Id
                    , Parent_Article__c
                    , Parent_Article__r.Order__c
                    , Order__c
                FROM Contract_Article__c
                WHERE Parent_Article__c IN: idParent
                ORDER BY Parent_Article__r.Order__c];
                
            i = 1;
            
            String order = '';
            
            for(Contract_Article__c cc : child){
                if(order == '') order = cc.Parent_Article__r.Order__c;
                else if(order != cc.Parent_Article__r.Order__c){
                    order = cc.Parent_Article__r.Order__c;
                    i = 1;
                }
                
                cc.Order__c = order + '.' + i;
                
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
        public boolean locked {get; set;}
    }

}