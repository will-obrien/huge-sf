public class countryStateCtlr{
    public String seelctedCountry{get;set;}
    public String seelctedstate{get;set;}
    map<String,set<String>> country;
    map<String,set<String>> state;
    public List<selectOption> countryList{get;set;}
    public List<selectOption> statelist{get;set;}
    public List<selectOption> citylist{get;set;}
    public countryStateCtlr(){
        country = new map<String,set<String>>(); 
        state =  new map<String,set<String>>();    
        
        //citylist = new List<selectOption>();
        countryList = new List<selectOption>();
        for(world__c w : [SELECT lightingprefix__Country__c, lightingprefix__State__c, lightingprefix__city__c FROM lightingprefix__World__c]){
            set<String> tempset = country.get(w.lightingprefix__Country__c);
            if(tempset == null){
                tempset  = new set<String>();                
            }
            tempset.add(w.lightingprefix__State__c);
            country.put(w.lightingprefix__Country__c,tempset);
            
            //---fill state and city map-
            set<String> citylist = state.get(w.lightingprefix__State__c);
            if(citylist == null){
                citylist = new set<String>();
            }
            citylist.add(w.lightingprefix__city__c);
            state.put(w.lightingprefix__State__c,citylist); 
        }
        system.debug('@@@@@@@@@@'+state);
        countryList.add(new selectOption('--None--','--None--'));
        for(String str : country.keyset()){
            countryList.add(new selectOption(str,str));
        }
    }
    
    public void state(){    
         if(seelctedCountry != null && seelctedCountry !='--None--'){   
            statelist = new List<selectOption>();
            statelist.add(new selectOption('--None--','--None--'));
            system.debug('########'+country.get(seelctedCountry));            
                for(String str : country.get(seelctedCountry)){
                     statelist.add(new selectOption(str,str));
                } 
             }  
    }
    public void city(){
        if(seelctedstate!=null && seelctedstate!='--None--'){
            citylist = new List<selectOption>();
            citylist.add(new selectOption('--None--','--None--'));
            for(String str : state.get(seelctedstate)){
                 citylist.add(new selectOption(str,str));
            }
         }   
    }
}