public class worldDemoController
{
     
    public list<world__c> worlds{get;set;}
    public map<String,set<String>>country{get;set;}
    public map<String,set<String>>states{get;set;}
    public String selectcountry{get;set;}
    public String state{get;set;}
    public list<SelectOption> countries{get;set;}
     public list<SelectOption> stateoption{get;set;}
          public  worldDemoController()
          {
              stateoption=new list<selectoption>();
              countries=new list<selectoption>();
              worlds = new list<world__c>();
              country = new map<String,set<String>>();
              states = new  map<String,set<String>>();
              worlds=[select country__c,state__c,city__c from world__c];
              for(World__c w : worlds)
              {
                  set<String> countrylist=country.get(w.country__c);
                  if(countrylist==null)
                  {
                      countrylist=new set<String>();
                  }
                  countrylist.add(w.state__c);
                 
                  System.debug('countrylist:'+countrylist);
                  country.put(w.country__c,countrylist);
                  for(String count : country.keyset())
                  {
                      countries.add(new selectoption(count ,count ));
                  }
                   set<String> statelist=states.get(w.state__c);
                  if(statelist==null)
                  {
                      statelist=new set<String>();
                  }
                  statelist.add(w.state__c);
                  statelist.clear();
                  states.put(w.state__c,statelist);
                   
              }
          }
             public void gostate()
             {    
                 stateoption.clear();
                  set<String> state=country.get(selectcountry);
                  
                 for(String s : state)
                 {
                   stateoption.add(new selectoption(s,s));
                   
                 }
              
             
              
                
             }     
          
    }