public class ObjectFinderCtlr{
    public map<String,string> SobjMap{get;set;}
    
   public list<String> objlist{get;set;}
   public list<SelectOption> optlist{get;set;}
   public Integer count{get;set;}
    public ObjectFinderCtlr(){
        count = 0;
        objlist = new List<String>();
        optlist = new list<SelectOption>();
        
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
        List<String> apiNames = new List<String>();
        
        for(string objectApi: globalDescribe.keyset()){             
            apiNames.add(objectApi);
        }
        
        Schema.DescribeSobjectResult[] results  = Schema.describeSObjects(apiNames);
        for(Schema.DescribeSobjectResult describeResult  : results){                
            if( describeResult.isUndeletable()&& describeResult.isAccessible() && describeResult.iscreateable()&& describeResult.isSearchable() && describeResult.isQueryable()&& describeResult.isUpdateable() && describeResult.getKeyPrefix()!='' && describeResult.getKeyPrefix()!=null){              
            count ++;
            system.debug('**********'+describeResult.getKeyPrefix());  
           optlist.add(new SelectOption(describeResult.getKeyPrefix(),describeResult.getLabel()));
        }
        } 
     
    }
}