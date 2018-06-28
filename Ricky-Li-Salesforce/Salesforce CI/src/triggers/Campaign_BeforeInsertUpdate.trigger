trigger Campaign_BeforeInsertUpdate on Campaign (before insert, before update) {
  //check if campaign's phone number is used by existing Campaign (campaign valid date + wind down days)   
  Set<String> tfnIds = new Set<String>();
  List<Campaign> camList = new List<Campaign>(); 
  for(Campaign c : trigger.new)
  {
    if(c.Toll_Free_Number__c != null){
        String tempId = c.Toll_Free_Number__c;
        tfnIds.add(tempId.substring(0,15));//add toll free number id (length format 15 vs.18)
        
        if(c.Wind_down_Days__c == null)
            c.Wind_down_Days__c = 0;//set to numeric for calculation purpose
    }else{
        c.TFN_Id__c = null;
    }   
  } 
  
  List<Campaign> campaigns = new List<Campaign>(
    [select id, name, TFN_Id__c, IsActive, Toll_Free_Number__c, Campaign_Id__c, Wind_down_Days__c, EndDate, StartDate from Campaign where TFN_Id__c in: tfnIds and IsActive = true]);
  
  //this won't trigger too many script statements because we only have 3 lines inside the nested loops 3*200*200 < 200001 lines
  //cannot replace with Map because there could be different campaigns using same TFN_Id, in that case TFN_Id can not be a key in the Map
  for(Campaign c : trigger.new){
    for(Campaign cam: campaigns){
        if(c.TFN_Id__c == cam.TFN_Id__c && c.Id != cam.Id){
            if(!(c.StartDate > cam.EndDate.addDays(cam.Wind_down_Days__c.intValue()) || c.EndDate.addDays(c.Wind_down_Days__c.intValue()) < cam.StartDate)){
                c.addError('This phone number campaign cannot be used during the time period that you\'ve selected.  Please select a different phone number or choose a different time period.');
            }
        }
    }
    
  }
  
}