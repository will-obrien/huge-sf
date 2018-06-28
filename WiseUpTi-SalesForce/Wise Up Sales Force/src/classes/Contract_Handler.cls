/*
    Test class: Contract_Test
*/

public class Contract_Handler{

    public static void insertArticle(List<Contract> contracts){
        Set<Id> templateId = new Set<Id>();
        Set<Id> contractsId = new Set<Id>();
        
        for(Contract c : contracts){
            contractsId.add(c.Id);
            
            if(!String.isEmpty(c.Contract_Template__c)) templateId.add(c.Contract_Template__c);
        }
        
        delete
            [SELECT Id
            FROM Contract_Article__c
            WHERE Contract__c IN: contractsId];
        
        Map<Id, Contract_Template__c> templateMap = new Map<Id, Contract_Template__c>(
            [SELECT Id
                , Name
                , (SELECT Id
                    , Article__c
                    , Article__r.Description__c
                    , Can_be_Changed__c
                    , Can_be_Removed__c
                    , Parent_Article__c
                    , Article__r.Name
                    , Order__c
                FROM Template_Articles__r
                WHERE Article__r.Inactive__c = false
                ORDER BY Parent_Article__c)
            FROM Contract_Template__c
            WHERE Id IN: templateId]
        );
        
        List<Contract_Article__c> articles = new List<Contract_Article__c>();
        
        Map<Id, Integer> articleMap = new Map<Id, Integer>();
        
        for(Contract c : contracts){
                if(!String.isEmpty(c.Contract_Template__c)){
                for(Template_Article__c tc : templateMap.get(c.Contract_Template__c).Template_Articles__r){
                    if(String.isEmpty(tc.Parent_Article__c)){
                        Contract_Article__c cc = createContractArticle(c.Id, tc);
                            
                        articles.add(cc);
                        
                        articleMap.put(tc.Id, articles.size() - 1);
                    }
                }
            }
        }
        
        if(articles.size() > 0) insert articles;
        
        if(articleMap.size() > 0){
            List<Contract_Article__c> parentClauses = new List<Contract_Article__c>();
                
            for(Contract c : contracts){
                for(Template_Article__c tc : templateMap.get(c.Contract_Template__c).Template_Articles__r){
                    if(!String.isEmpty(tc.Parent_Article__c)){
                        Contract_Article__c cc = createContractArticle(c.Id, tc);
        
                        cc.Parent_Article__c = articles.get(articleMap.get(tc.Parent_Article__c)).Id;
                        
                        parentClauses.add(cc);
                    }
                }
            }
            
            if(parentClauses.size() > 0) insert parentClauses;
        }
    }
    
    private static Contract_Article__c createContractArticle(Id contractId, Template_Article__c tc){
        Contract_Article__c cc = new Contract_Article__c();
        cc.Contract__c = contractId;
        cc.Article__c = tc.Article__c;
        cc.Description__c = tc.Article__r.Description__c;
        cc.Can_be_Removed__c = tc.Can_Be_Removed__c;
        cc.Can_be_Changed__c = tc.Can_be_Changed__c;
        cc.Order__c = tc.Order__c;
        cc.Order_Lock__c = true;
                        
        return cc;
    }

}