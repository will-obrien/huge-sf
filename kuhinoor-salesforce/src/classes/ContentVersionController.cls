Public Class ContentVersionController{
    Public List<contentversion> contentList{get;set;}
    Public String setelectedcontent{get;set;}
    public String selectedradio{get;set;}
    Public List<lightingprefix__Content__c> proList{get;set;}   
    Public List<lightingprefix__contentOpportunity__c> opplist{get;set;}
    Public Integer index{get;set;}
    Public ContentVersionController(){      
       prolist = new  List<lightingprefix__Content__c>();  
       opplist = new   List<lightingprefix__contentOpportunity__c>();  
       contentList = [select id,title from contentVersion];
    }
   Public List<selectOption> getItem(){
        List<selectOption> options = new List<selectOption>();
        for(contentVersion s : contentList){
            options.add(new SelectOption(s.id,s.title));
        }
        return options;
    }
    
    Public pageReference next(){
        return new pagereference('/apex/contentversionpage2');
    }
    
    
    Public pageReference lookupfetchmethod(){
        prolist.clear();
        opplist.clear();
    
        System.debug('*****************'+selectedradio);
        
        
        if(selectedradio.equals('product')){
              prolist = new list<lightingprefix__Content__c>(); 
              prolist.add(new lightingprefix__Content__c());
              
        }
      if(selectedradio.equals('Opportunity')){
          opplist = new List<lightingprefix__contentOpportunity__c>();
          opplist.add(new lightingprefix__contentOpportunity__c());
      }
      return new PageReference('/apex/contentversionpage3');
    }
    Public void addrow(){
        if(selectedradio.equals('product')){
           prolist.add(new lightingprefix__Content__c());
        }
        if(selectedradio.equals('Opportunity')){
           opplist.add(new lightingprefix__contentOpportunity__c()); 
        }
    }
    public PageReference save(){
        if(prolist.size()>0){
            for(lightingprefix__Content__c c : proList){
               c.lightingprefix__contentId__c=setelectedcontent;              
            }
            insert prolist;
          
        }
        if(opplist.size()>0){
            for(lightingprefix__contentOpportunity__c cop : opplist){
                cop.lightingprefix__contentopportunityId__c = setelectedcontent;
            }
            insert oppList;
            
        }
      return new pageReference('/apex/ContentVersionControllerpag');
    }
    public PageReference redirectmethod(){
        if(prolist==null || oppList== null){
            return new pageReference('/apex/ContentVersionControllerpag');
        }
        if(setelectedcontent==null){
            return new pageReference('/apex/ContentVersionControllerpag');
        }
        return null;
    }
  public void del(){
      System.debug('########################'+index);
      if(index!=null){
          if(prolist.size()>0){
               prolist.remove(index);
          }
          if(oppList.size()>0){
              oppList.remove(index);
          }
      }
  }
  Public pageReference back(){
      return new pageReference('/apex/contentversionpage2');
  }
  Public pageReference BackToFirstPage(){
      return new pageReference('/apex/ContentVersionControllerpag');
  }
  
}