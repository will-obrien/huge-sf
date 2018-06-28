public class WorldMapController{
    public Map<String,String> country{get;set;}
    Public Map<String,String> state{get;set;}
     Public Map<String,String> city{get;set;}
    public String selectedvalue{get;set;}
    public String selectedState{get;set;}
  
    Public List<World__c> record{get;set;}
    public WorldMapController(){
        country = new Map<String,String>();
        state = new Map<String,String>();
        city= new Map<String,String>();
        state.put('--None--','');
        city.put('__None--','');
        record = [select Country__c from World__c];
        System.debug('###############'+record);
        for( World__c w : record){          
           
            country.put(w.country__c,w.country__c);            
        }
      }  
        
        public void go(){
         System.debug('#########------->######'+selectedvalue);
             state.clear();
             List<World__c> stateList = [ select state__c from world__c where country__c =:selectedvalue];
             
            for(World__c w : stateList){
                
                state.put(w.state__c,w.state__c);
               
            }
        }
        public void statego(){
            city.clear();
            List<World__c> record = [ select city__c from World__c where state__c =:selectedState ];
            for(World__c wc : record){
                city.put(wc.city__c,wc.city__c);
            }
        }
}