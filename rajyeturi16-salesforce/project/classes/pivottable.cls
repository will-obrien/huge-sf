public class pivottable{
     public Contact con{get;set;}
     public Map<String,List<Contact>> mapcontact{get;set;}
     public Map<String,Decimal> mapcontactCityRevenue{get;set;}
     public Map<String,Decimal> mapcontactRevenue{get;set;} 
     public Map<String, Map<String, List<Contact>>> mapcontacts{get;set;}
     public Map<String, decimal> mapcityRevenue {get;set;}
     public Map<String, decimal> mapStateRevenue {get;set;}
         public pivottable()
          {
          con = new contact(); 
          } 
          public pagereference Selctedvalue() 
           {   
           mapcontacts = new Map<String, Map<String, List<Contact>>>();  
           mapcityRevenue = new Map<String, decimal>();
           mapStateRevenue = new Map<String, decimal>();
           mapcontactCityRevenue=new Map<String,Decimal> ();
           mapcontact=new Map<String,List<Contact>>();   
          for(Contact conn:[select id,name,state__c,Revenue__c,city__c from Contact where state__c=:con.state__c order by city__c limit 1000])
        {                                                
            String state = conn.state__c;
            if(mapcontacts.get(state) != null){
                if(mapcontacts.get(state).get(conn.city__c) != null){   
                    mapcontacts.get(state).get(conn.city__c ).add(conn);
                  }
                else
                  mapcontacts.get(state).put(conn.city__c , new List<contact>{conn});      
            }
            else{
               mapcontacts.put(state, new Map<String, List<contact>>{conn.city__c=> new List<contact>{conn}});
            }
        }  
        for(Contact conn:[select id,name,state__c,Revenue__c,city__c from Contact where state__c=:con.state__c order by city__c  ]){
            if(mapcityRevenue.containsKey(conn.city__c)){
              decimal revenue = 0;
                if(mapcityRevenue.get(conn.city__c) != null){
                   revenue = mapcityRevenue.get(conn.city__c);
                   system.debug('The revenue is ' + revenue);
                   revenue = revenue + conn.Revenue__c;
                   mapcityRevenue.put(conn.city__c,revenue);
                }
            }
            else{
                if(conn.city__c != null && conn.Revenue__c != null){
                   mapcityRevenue.put(conn.city__c,conn.Revenue__c);
                }
            }
            if(mapStateRevenue.containsKey(conn.state__c)){
                decimal revenue = 0;
                if(mapStateRevenue.get(conn.state__c) != null){
                        revenue = mapStateRevenue.get(conn.state__c);
                        system.debug('The revenue is ' + revenue);
                        revenue = revenue + conn.Revenue__c;
                        mapStateRevenue.put(conn.state__c,revenue);
                }
            }
            else{
                if(conn.state__c != null && conn.Revenue__c != null){
                 mapStateRevenue.put(conn.state__c,conn.Revenue__c);
                }
            } 
         }
    return null;
     } 
}