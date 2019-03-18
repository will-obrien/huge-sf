public with sharing class InitWidgetList {
  public List<ApexComponent> lComps {get;set;}
  public List<Custom_Widgets__c> lcws {get;set;}
  public Map<String, Custom_Widgets__c> mapWidgets {get;set;}
  public String templateId {get;set;}
  public String centerRecordType, sideRecordType;
  public InitWidgetList(ApexPages.StandardController controller) {
    lComps = [Select Name, MasterLabel from ApexComponent where Name Like 'Community%'];
    templateId = ApexPages.currentPage().getParameters().get('tmid');
    mapWidgets = new Map<String, Custom_Widgets__c>();
    
    for(RecordType rt : [Select Id, Name from RecordType where SObjectType='Custom_Widgets__c']){
      if(rt.Name.containsIgnoreCase('Center')){
        centerRecordType = rt.Id;
      } else{
        sideRecordType = rt.Id;
      }
    }
    

  }

  public void insertCustomWidgets(){
        try{
            if(templateId != null){
              lcws = [Select Id, Name, isDisplayed__c from Custom_Widgets__c where Template_Map__c=:templateId];
              if(lcws.size() <= 0){                
                lcws = new List<Custom_Widgets__c>();
                for(ApexComponent ac : lComps){
                  if(ac.Name.containsIgnoreCase('center')){
                    lcws.add(new Custom_Widgets__c(name=ac.MasterLabel, Template_Map__c=templateId, RecordTypeId=centerRecordType));
                  } else{
                    lcws.add(new Custom_Widgets__c(name=ac.MasterLabel, Template_Map__c=templateId, RecordTypeId=sideRecordType));
                  }
                }  
              } else if(lcws.size() < lComps.size()){
                  for(ApexComponent ac : lcomps){
                      if(!listContains(lcws, ac.MasterLabel)){
                          if(ac.Name.containsIgnoreCase('center')){
                              lcws.add(new Custom_Widgets__c(name=ac.MasterLabel, Template_Map__c=templateId, RecordTypeId=centerRecordType));
                          } else{
                              lcws.add(new Custom_Widgets__c(name=ac.MasterLabel, Template_Map__c=templateId, RecordTypeId=sideRecordType));
                          }
                      } 
                  }                  
              }
            }
            upsert lcws;
            System.Debug(lcws);
            for(Custom_Widgets__c cw : lcws){
                mapWidgets.put(cw.id,cw);
            }
        } catch (Exception e){
            System.debug('Failed to upsert: ' + e.getMessage());        
        }
  }

    
  //simple check wether list contains the id or not
	private boolean listContains(List<Custom_Widgets__c> listOfIds, String lookForId)
	{
		for(Integer i = 0; i< listOfIds.size();i++)
			if(listOfIds[i].Name == lookForId)
				return true;
		return false;
	}
    
  public void saveWidgetConfig(){
        try{
          upsert mapWidgets.values();
        } catch( Exception e){
            System.debug('Failed to upsert: ' + e.getMessage());
        }
  }
}