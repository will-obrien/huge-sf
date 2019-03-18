/*
    Name : FillMapFromSOQL
    Date : 17-March-2016
    Author : Kuhinoor Alam 
    Description : This class is for filling list form Map    
*/

public class FillMapFromSOQLCtlr{
  public list<Account> Acclist{get;set;}
  public Set<Id> AccSet {get;set;}
  public Map<Id,Account> AccMap{get;set;} 
  public Map<id,lightingprefix__Job__c> mapJobs{get;set;}
  public String name {get;set;}
  public ID ids{get;set;}
  
  public list<lightingprefix__Element__c> templist{get;set;}
   // Contatractor Method   
    public FillMapFromSOQLCtlr(){
        AccSet  = New set <Id>();
        Acclist = new List<Account>();
        AccMap = new Map<Id,Account>([Select id,name,AccountNumber from Account limit 100]);
        
        // Getting list of Account using map.values method
        Acclist = AccMap.values();
        
        // getting key values using map.keyset method
        AccSet = AccMap.keySet();
     }   
     
     public void test(){
         AccMap.clear();
         mapJobs = new Map<id,lightingprefix__Job__c>([SELECT Id, Name,(Select id ,Name from elements__r) FROM lightingprefix__Job__c limit 20]);
         for(id i : mapJobs.keySet()){
             templist =  mapJobs.get(i).elements__r;
             name = mapJobs.get(i).elements__r[0].Name;
             ids =  mapJobs.get(i).elements__r[0].id;
         }
         
     }
  }