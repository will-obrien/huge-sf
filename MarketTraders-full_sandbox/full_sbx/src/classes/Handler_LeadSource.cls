public with sharing class Handler_LeadSource extends Handler{
    
    public static Boolean BYPASS = false;
    
    private list<Lead_Sources__c> newList;
    private map<Id,Lead_Sources__c> newMap;
    private list<Lead_Sources__c> oldList;
    private map<Id,Lead_Sources__c> oldMap;

    public Handler_LeadSource(){
        
    }
    
    public Handler_LeadSource(String typeOfHandler) {
        handlerType = typeOfHandler;
    }
    
    public override void mainEntry(String triggerObject,
            Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
            Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
            map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap)
        {
            this.newList = (list<Lead_Sources__c>)newList;
            this.newMap = (map<Id,Lead_Sources__c>)newMap;
            this.oldList = (list<Lead_Sources__c>)oldList;
            this.oldMap = (map<Id,Lead_Sources__c>)oldMap;
            
         //added aac 1.9.16 to track merged leads and reassign leadsource to existing lead   
        Map<id,id> previousToExistingLead = new Map<id,id>();
        List<id> leadsourcesforinsert = new list<id>();  
        List<lead_sources__c> leadsourcesMissingLeads = new list<lead_sources__c>();         
        List<String> leadsourceemails = new list<String>(); 
            
            if(isBefore && isInsert){
                 System.debug('@asha: @debug: Handler_LeadSource : Creating map of deleted to existing leads');

                for(Lead_Sources__c ls: this.newList){
                    leadsourcesforinsert.add(ls.id);
                    System.debug('@asha: @debug: Handler_LeadSource : Adding new Lead Source Id '+ ls.id);
                }
                
                Map<id, Lead> leadexisting = new Map<id,Lead>([Select id, isdeleted from Lead where id in :leadsourcesforinsert]);    
                System.debug('@asha: @debug: Handler_LeadSource : lead records found :'+ leadexisting.size() );
          
                if(!leadexisting.isEmpty()){
                    for(Lead_Sources__c ls: this.newList){
                        if(!leadexisting.containskey(ls.lead__c)){
                            if(ls.Email_at_last_edit__c != null){
                                leadsourceemails.add(ls.Email_at_last_edit__c);
                                leadsourcesMissingLeads.add(ls);
                                System.debug('@asha: @debug: Handler_LeadSource : Lead not found - Adding email address to list of emails '+ls.Email_at_last_edit__c);
                            }
                        }else{
                            Boolean isdel = leadexisting.get(ls.lead__c).isDeleted;
                            if(isdel){
                                 if(ls.Email_at_last_edit__c != null){
                                    System.debug('@asha: @debug: Handler_LeadSource : lead was deleted - '+ ls.lead__c);
                                    leadsourceemails.add(ls.Email_at_last_edit__c);
                                    leadsourcesMissingLeads.add(ls);
                                }
                            }
                        }
                    }
                }else{
                    for(Lead_Sources__c ls: this.newList){
                        if(ls.Email_at_last_edit__c != null){
                            System.debug('@asha: @debug: Handler_LeadSource : Lead not found - Adding email address to list of emails '+ls.Email_at_last_edit__c);
                            leadsourceemails.add(ls.Email_at_last_edit__c);
                            leadsourcesMissingLeads.add(ls);
                        }
                    }
                }
                    
                    if(leadsourceemails.size() > 0){
                        //pull the leads with matching email addresses to find the earliest
                        Map<String,list<lead>> emailtoleadsmap = new Map<String,list<lead>>();
                        List<lead> allleadsbyemail = [select id, CreatedDate, Email, Alternate_Email__c, FirstName, LastName
                                                    FROM Lead 
                                                    WHERE (Email IN :leadsourceemails OR Alternate_Email__c IN :leadsourceemails) 
                                                    AND isConverted = false 
                                                    AND isDeleted = false 
                                                    ORDER BY CreatedDate ASC];
                       
                       
                       // loop through all the leads returned and add to map of email to list of leads - sorted asc
                       for(lead ld : allleadsbyemail ){

                           if(ld.email != null){
                              List<lead> temp = (emailtoleadsmap.containskey(ld.email))? emailtoleadsmap.get(ld.email) : new list<lead>();
                               temp.add(ld);
                               emailtoleadsmap.put(ld.email,temp);
                           }
                           
                           if(ld.Alternate_Email__c != null){
                               List<lead> tempalt = (emailtoleadsmap.containskey(ld.Alternate_Email__c))? emailtoleadsmap.get(ld.Alternate_Email__c) : new list<lead>();
                               tempalt.add(ld);
                               emailtoleadsmap.put(ld.Alternate_Email__c ,tempalt);
                           }
                       }   
                        
                        //create leadsource id to earliest lead map based on email to lead map created 
                        for(Lead_Sources__c lsm : leadsourcesMissingLeads){
                                List<lead> leadbyemail = (emailtoleadsmap.containskey(lsm.Email_at_last_edit__c))? emailtoleadsmap.get(lsm.Email_at_last_edit__c) : new List<lead>();
                                if(leadbyemail.size() > 0 ){
                                    previousToExistingLead.put(lsm.id, leadbyemail[0].id);
                                   System.debug('@asha: @debug: Handler_LeadSource : Adding lead source and matching earliest created lead to map leadsource '+lsm.id+' lead '+leadbyemail[0].id);
                                }                                 
                       }  
                                                                    
                     }
                
            }
            
            if(isBefore && (isInsert || isUpdate || isUndelete)){
                for(Lead_Sources__c leadsource : this.newList){ 
                    
                    //added aac 1.9.16 to track merged leads and reassign leadsource to existing lead   
                    if(isInsert){
                        if(previousToExistingLead.containskey(leadsource.id)){
                            if(previousToExistingLead.get(leadsource.id) != null){
                             System.debug('@asha: @debug: Handler_LeadSource : merge history record was found - reassigning lead source from '+leadsource.Lead__c +' to '+previousToExistingLead.get(leadsource.Lead__c));
                                leadsource.Lead__c =  previousToExistingLead.get(leadsource.id);
                            }
                        }
                    }
                    
                    if (leadsource.Override_Lead_Source_Rules__c && (this.oldMap == null || this.oldMap != null && this.oldMap.get(leadsource.Id).Override_Lead_Source_Rules__c != true)){
                        leadsource.Override_Date__c = DateTime.now();
                        leadsource.Override_User__c = UserInfo.getUserId();
                    }
                    else if (leadsource.Override_Lead_Source_Rules__c != true) {
                        leadsource.Override_Date__c = null;
                        leadsource.Override_User__c = null;
                    }
                }
            }

            if (isAfter && (isInsert || isUpdate)) {
                LeadSourceStamper stamper = new LeadSourceStamper();
                stamper.stampLeadSources(this.newList, true);
            }
            else if(isAfter && isDelete) {
                // we DO NOT want this to happen when the accounts are being deleted, thus deleting the lead sources (no orphan lead sources)
                LeadSourceStamper stamper = new LeadSourceStamper();
                stamper.BYPASS = true; 
                stamper.stampLeadSources(this.oldList, true);
            }
            
            TriggerDispatcher.activeHandler = null;
    }
    
    public override void inProgressEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap){
            system.debug('In Progress Entry: ' + triggerObject);
    }

}