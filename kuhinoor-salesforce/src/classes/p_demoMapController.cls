public class p_demoMapController
{
    public map<String,String>states{get;set;}
    public map<String,list<String>>statevalue{get;set;}

    public p_demoMapController()
    {
        states = new map<String,String>();
        statevalue=new map<String,list<String>>();
        states.put('r','Rajasthan');
        states.put('a','assam');
        states.put('d','delhi');
        System.debug(states.get('r'));
        for(String obj : states.keyset())
        {
            System.debug('obj=='+obj);
            list<String> statelist=statevalue.get(states.get(obj));
            if(statelist==null)
            {
                statelist=new list<String>();
                
            }
            statelist.add(obj);
            statevalue.put(states.get(obj),statelist);
            System.debug('Statevalues=='+statevalue);
        }
    }
}