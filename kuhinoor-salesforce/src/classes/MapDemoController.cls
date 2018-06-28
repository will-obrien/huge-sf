public class MapDemoController
{
    public map<String,String> states{get;set;}
    public map<String,list<String>> statevalue{get;set;}
    public list<integer> user{get;set;}
    public MapDemoController()
    {
        statevalue = new map<String,list<String>>();
        user = new list<integer>();
        states = new map<String,String>();
        
        states.put('rajasthan','india');
        states.put('delhi','india');
        states.put('new york','USA');
        System.debug('size='+states.size());
        System.debug('size='+states.values());
        System.debug('state keyset='+states.keyset());
        for(String obj : states.keyset())
        {
            System.debug('obj::'+obj);
            List<String> statelist=statevalue.get(states.get(obj));
            if(statelist==null)
            {
                statelist=new list<String>();
            }
            statelist.add(obj);
            System.debug('statelist:'+statelist);
            statevalue.put(states.get(obj),statelist);
        }
        System.debug('statevalue:'+statevalue);
    }
}