public class MapingDemoController{
    public Map<String,String> country{get;set;}   
    public Map<String,List<String>>states{get;set;}
    public List<String>statelist{get;set;}
    public MapingDemoController(){
        statelist = new List<String>();
        states = new Map<String,List<String>>();
        country = new Map<String,String>();
       
        country.put('Rajasthan','india');
        country.put('delhi','india');
        country.put('california','USA');
        for(String obj : country.keyset()){
            List<String> statesvalues=states.get(country.get(obj));
            if(statesvalues == null){
                statesvalues= new List<String>();
            }
            statesvalues.add(obj);
        
         states.put(country.get(obj),statesvalues); 
       System.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!'+statelist);
        
    }
    }
}