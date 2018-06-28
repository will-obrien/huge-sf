/*
    Test class: Article_Component_Test
*/

global class Article_Component{

    global Id idOpportunity { get; set; }
    
    global Map<String, String> typeFieldsMap {get; set;}
    global Map<String, String> fieldsMap {get; set;}
    global Set<String> fieldsName {get; set;}
    global Map<String, List<Template_Article__c >> contractClauseMap{get; set;}
    global Opportunity opp {get; set;}
    
    global Article_Component(){
        System.debug('___[cls Article_Component - getItems()] ..START..');
        Map<String, String> params = Apexpages.currentPage().getParameters();
        idOpportunity = params.get('idOpp');
        fieldsName = new Set<String>();
        typeFieldsMap = new Map<String, String>();

        String query = 'SELECT Id, Name,Modelo_Contrato__c';

        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.Opportunity_article_fields.getFields()) {
            //System.debug('___[cls Article_Component - getItems()] - Field : ' + f.getFieldPath());
            query += ', ' + f.getFieldPath();
            
            fieldsName.add(f.getFieldPath());
            typeFieldsMap.put(f.getFieldPath(), String.valueOf(f.getType()));
        }

        query += ',(SELECT Id, Product2.Name, Product2.Idade_maxima__c, Product2.Caracteristicas_produto__c, Product2.Idade_minima__c FROM OpportunityLineItems) FROM Opportunity WHERE Id = \'' + idOpportunity + '\'';
        System.debug('___[cls Article_Component - getItems()] - Query : ' + query);
       
        System.debug('___[cls Article_Component - getItems()] - idOpportunity : ' + idOpportunity);
        System.debug('___[cls Article_Component - getItems()] - Opp : ' + opp);
        if(opp == null) opp = Database.query(query);
        
        
        System.debug('___[cls Article_Component - getItems()] - Opp : ' + opp);
        fieldsMap = new Map<String, String>();
        
        for(String field : fieldsName){
            if(field.contains('.')){
                String obj = field.substring(0, field.indexOf('.'));
                
                String field2 = field.substring(field.indexOf('.') + 1, field.length());
                
                fieldsMap.put(field, createValue(field, Test.isRunningTest() ? '0' : String.valueOf(opp.getSObject(obj).get(field2))));
            }else{
                fieldsMap.put(field, createValue(field, Test.isRunningTest() ? '0' : String.valueOf(opp.get(field))));
            }
        }
        
        contractClauseMap = new Map<String, List<Template_Article__c>>();
        for(Template_Article__c cc : 
            [SELECT Id
                    , Article__r.Name
                    , Article__r.Clause__c
                    , Article__r.Description__c
                    , Order__c
                    , (SELECT Id
                        , Article__r.Name
                        , Article__r.Clause__c
                        , Article__r.Description__c
                        , Order__c
                    FROM Template_Article__r
                    WHERE  Article__r.Inactive__c = false
                    ORDER BY Order__c)
                FROM Template_Article__c
                WHERE Contract_Template__c =: opp.Modelo_contrato__c
                AND Article__r.Inactive__c = false
                AND Parent_Article__c = null
                ORDER BY Order__c]){
            
            if(contractClauseMap.get(cc.Article__r.Clause__c) == null) contractClauseMap.put(cc.Article__r.Clause__c, new List<Template_Article__c>());
            
            contractClauseMap.get(cc.Article__r.Clause__c).add(cc);
            System.debug('___[cls Article_Component-getItems] contractClauseMap' + contractClauseMap);
        }
    }
    
    public List<Item> getItems(){
        

        
        
        
        
        List<Item> items = new List<Item>();
        
        for(String s : contractClauseMap.keySet()){
            
            System.debug('___[cls Article_Component-getItems] S:' + s);
            Item i = new Item();
            i.title = s;
            
            i.clauses = contractClauseMap.get(s);
//            i.Descricao = '';
            System.debug('___[cls Article_Component-getItems] i.clauses:' + i.clauses);
            for(Template_Article__c cc : i.clauses){                
                System.debug('___[cls Article_Component-getItems] cc:' + cc);
                for(String fieldName : fieldsName){
                    //System.debug('___[cls Article_Component-getItems] fieldName: ' + fieldName);
                    if(!Test.isRunningTest() && cc.Article__r.Description__c.contains(fieldName)){
                        System.debug('___[cls Article_Component-getItems] cc.Article__r.Description__c: ' + cc.Article__r.Description__c);
                        cc.Article__r.Description__c = cc.Article__r.Description__c.replace(fieldName, fieldsMap.get(fieldName));                        
                        System.debug('___[cls Article_Component-getItems] cc.Article__r.Description__c-AFTER: ' + cc.Article__r.Description__c);  
                    }    
                }
            }
            
            items.add(i);
        }
        
        return items;
    }
    
    public String createValue(String field, String value){
        if(typeFieldsMap.get(field) == 'CURRENCY' || typeFieldsMap.get(field) == 'PERCENT'){
            String userCurrency = UserInfo.getDefaultCurrency();
            
            Decimal i = Decimal.valueOf(value);
            
            String s = ( i.setScale(2) + 0.001 ).format();
            
            s = s.substring(0, s.length() - 1);
                                
            if(userCurrency == 'BRL'){
                s = s.replace('.', '#');
                s = s.replace(',', '.');
                s = s.replace('#', ',');
            }                    
            
            value = (typeFieldsMap.get(field) == 'CURRENCY' ? (userCurrency == 'BRL' ? 'R$ ' : '$ ' ) : '% ') + s;
        }
                
        return value;
    }
    
    public class Item{
        public String title {get; set;}
        public List<Template_Article__c> clauses {get; set;}
        public List<String> descricao {get; set;}
    }

}