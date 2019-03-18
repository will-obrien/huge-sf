public class Tables_Cntrl {
    public Table__c table {get;set;}
    public Map<String,List<Table__c>> TableMap {get;set;}
    
    public Map<String,String> StringMap {get;set;}
    public Map<String,Accommodation__c> AccmMap {get;set;}
    
    public Tables_Cntrl () {
        
        StringMap = new Map<String,String>();
        //Accmmap = new Map<String,Accommodation__c>();
        TableMap = new Map<String,List<Table__c>>();
        
        for(Accommodation__c ac : [ Select id,name,Accommodation_Type__c,(Select id,name,Accommodation__c,Status__c from Tables__r order by Name) from Accommodation__c ] ){
            if(!TableMap.containsKey(ac.Name)){
                TableMap.put(ac.Name,new List<Table__c>());
                StringMap.put(ac.Name,ac.Accommodation_Type__c);
            }
            if(TableMap.containsKey(ac.Name)){
                TableMap.put(ac.Name,ac.Tables__r);
            }
        }
        table = new Table__c();
    }
    
    public pageReference save(){
        insert table;
        return null;  
    }
    public pageReference cancel() {
        return page.Hotel; 
    }
}