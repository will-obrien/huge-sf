public class accessableObj{
    public list<String> objlist{get;set;}
    public accessableObj(){
        objlist = new List<String>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
        List<String> apiNames = new List<String>();
        
        for(string objectApi: globalDescribe.keyset()){             
            apiNames.add(objectApi);
        }
        
        Schema.DescribeSobjectResult[] results  = Schema.describeSObjects(apiNames);
        for(Schema.DescribeSobjectResult describeResult  : results){                
            if(describeResult.isAccessible() && describeResult.iscreateable()) {
                System.debug('~~~~~~~~~~~~~~'+describeResult.getLabel());
                objlist.add(describeResult.getLabel());
        for(Schema.SobjectField  field: describeResult.fields.getMap().values()){
       // if(field.Describe().isAccessible()){
          // console.log(field.Describe().getLabel()+'~~~~~~~~~~~~~~~~~~~~is accessible');  
       // }
        }
        }
        } 
    }
}