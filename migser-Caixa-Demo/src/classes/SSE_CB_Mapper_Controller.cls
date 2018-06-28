public with sharing class SSE_CB_Mapper_Controller {
  public Map<String,String> map_profile {get;set;}
  public Map<String,List<String>> map_community_profile {get;set;}
  public Map<String,String> map_community {get;set;}
  public Map<String,String> map_template {get;set;}
  public Map<string,String> map_widget_template {get;set;}

  public Map<String, Template_Map__c> ultimateMap {get;set;}

  public List<Template_Map__c> lTemplateMap {get;set;}
  
  public List<SelectOption> soTemplate {get;set;}
  public List<SelectOption> soWidgetTemplate {get;set;}

  public String defaultTemplate {get;set;}
  public String defaultWidgetTemplate {get;set;}
  
  public String sTemplate {get;set;}
  public String sWidget {get;set;}

  public SSE_CB_Mapper_Controller() {
    map_profile = new Map<String,String>();
    map_community = new Map<String,String>();
    map_community_profile = new Map<String,List<String>>();
    map_template = new Map<String,String>();
    map_widget_template = new Map<String,String>();
  
    lTemplateMap = new List<Template_Map__c>();

    ultimateMap = new Map<String, Template_Map__c>();

    soTemplate = new List<SelectOption>();
    soWidgetTemplate = new List<SelectOption>();

    //creating a map of community id and name to retrieve data on the front end and minimize the number of SOQL statements
    //initializing maps for network Id --> Profile ID --> Template 
    initializeNetworkMaps();

    //creating a map of Profiles to create a list on the front-end
    for(Profile p : [Select Id, Name from Profile]){
      map_profile.put(p.Id, p.Name);
    }

    //check if there are any template maps already
    for(Template_Map__c tm : [Select Id, Profile__c, Community__c, Demo_Template__c, Widget_CSS__c from Template_Map__c]){
      ultimateMap.put(tm.Community__c+'_'+tm.Profile__c, tm);
    }
    
    //creating a map of profiles with associated communities
    mapCommunityProfiles();

    //once the profile-communities map has been populated lets remove all those profiles with no communities associated to them
    filterMaps();

    for(Org_Template__c dt : [Select Id, Name from Org_Template__c]){
      map_template.put(dt.Id, dt.Name);
      soTemplate.add(new SelectOption(dt.Id, dt.Name));
      if(dt.Name == 'Cirrus - Customer'){
        defaultTemplate = dt.Id;  
      }
      
    }

    for(Widget_Template__c wt : [Select Id, Name from Widget_Template__c]){
      map_widget_template.put(wt.Id, wt.Name);
      soWidgetTemplate.add(new SelectOption(wt.Id, wt.Name));
      if(wt.Name == 'Cirrus - Customer'){
        defaultWidgetTemplate = wt.Id;
      }
    }

    //the following loop seems like you are overwritting the ultimateMap but it actually does not.
    lTemplateMap = new List<Template_Map__c>();
    Template_Map__c tmp;
    Map<String, Template_Map__c> ph_ct;
    for(String nId : map_community_profile.keySet()){
      for(String s : map_community_profile.get(nId)){
        if(!ultimateMap.containsKey(nId+'_'+s)){
          //if template is not present we initialize it
          tmp = new Template_Map__c(Profile__c=s, Community__c=nId, Demo_Template__c=defaultTemplate, Widget_CSS__c=defaultWidgetTemplate);
          System.debug('Template ' + tmp);
          lTemplateMap.add(tmp);
          //ultimateMap.put(nId+'_'+s, tmp);
        }
      }
    }
    System.debug(lTemplateMap.size());

    //after all the templates are created this happens twice to avoid exceptions
    for(Template_Map__c tm : lTemplateMap){
      ultimateMap.put(tm.Community__c+'_'+tm.Profile__c, tm);
    }
  }

  public void filterMaps(){
    List<String> phList = new List<String>();
    for(String nId : map_community.keySet()){
      if(map_community_profile.containsKey(nId)){
        phList = map_community_profile.get(nId);
        if(phList.size() == 0){
          map_community_profile.remove(nId);
          map_community.remove(nId);
        }  
      }
    }
  }

  public void initializeNetworkMaps(){
    for(Network n : [Select Id, Name from Network order by Name asc]){
      map_community.put(n.Id, n.Name);
      map_community_profile.put(n.Id, new List<String>());    
    }
  }

  public void mapCommunityProfiles(){
    List<String> phList = new List<String>();
    for(NetworkMemberGroup nm : [Select Id, ParentId, NetworkId from NetworkMemberGroup]){
      if(!String.valueOf(nm.ParentId).startsWith('0PS')){
          phList = map_community_profile.get(nm.NetworkId);
          phList.add(nm.ParentId);
          map_community_profile.put(nm.NetworkId, phList);
      }
    }
  }

  public void insertTemplates(){
    if(lTemplateMap.size()>0){
      upsert lTemplateMap;
    }
    //after all the templates are created
    for(Template_Map__c tm : lTemplateMap){
      ultimateMap.put(tm.Community__c+'_'+tm.Profile__c, tm);
    }
  }

  public void saveAll(){
    try{
      upsert ultimateMap.values();
    } catch (Exception e){
      System.debug('Error Upserting :' + e.getMessage());
    }
    
  }

  public PageReference updateLink(){
    return null;
  }
}