global class CountOfRelatedObjectBatchClassAPAC  implements Database.Batchable<sObject>
{  // global datetime criteria=datetime.now()-90 ;
     //criteria=system.now();
     
    global String query='SELECT id,name,Count_of_Recent_Tasks__c,Count_of_Recent_Events__c,Count_of_Recent_Attachments__c,Count_of_Recent_Contacts__c,Count_of_Recent_Leads__c,Count_of_Recent_Notes__c,Count_of_Recent_Opportunities__c,Count_of_Related_Company__c FROM Account     where Account_Owner_Region_New__c=\'APAC\'  ' ;
    global List<Account> TargetAccounts= new List<Account>();  
    global Database.QueryLocator start(Database.BatchableContext bc)
    {   return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {   
       set<Id> AccIDSet =new set<Id>();
        List<Contact> RelatedContacts =new List<Contact>();
        List<Opportunity> RelatedOpportunity =new List<Opportunity>(); 
        List<Task> RelatedTasks =new List<Task>(); 
        List<Event> RelatedEvent =new List<Event>(); 
        List<Note> RelatedNote =new List<Note>(); 
        List<Attachment> RelatedAttachment =new List<Attachment>(); 
        List<Lead> RelatedLead =new   List<Lead>();
        
        map<id, Account> AccountMap = new map<id,Account>();
        map<id, List<Contact>> ContactMap = new map<id, List<Contact>>();
        map<id, List<Opportunity>> OpportunityMap = new map<id, List<Opportunity>>();
        map<id, List<Task>> TaskMap = new map<id, List<Task>>();
        map<id, List<Event>> EventMap = new map<id, List<Event>>();
        map<id, List<Note>> NoteMap = new map<id, List<Note>>();
        map<id, List<Attachment>> AttachmentMap = new map<id, List<Attachment>>();
        map<id, List<Lead>> LeadMap = new map<id, List<Lead>>();
        List<Account> AccountUpdateList= new List<Account>();
           
         for(Account a : scope)
            {    TargetAccounts.add(a);
            }
            
            // system.debug('##-TargetAccounts -'+TargetAccounts); 
        
        //*** Add account ids in a set************
         if(TargetAccounts.size()>0)
           { for(Account acc:TargetAccounts)
             {        AccIDSet.add(acc.id);  }       
           }
           
    RelatedContacts =[Select id,AccountId  from contact where AccountId IN:AccIDSet and Last_modified_Date_by_non_admin__c >=:system.today()-90];
    //system.debug('##-RelatedContacts Count-'+RelatedContacts.size());    
    RelatedOpportunity =[Select id,AccountId from Opportunity where AccountId IN: AccIDSet and Last_modified_Date_by_non_admin__c >=:system.today()-90];   
    //system.debug('##-RelatedOpportunity -'+RelatedOpportunity.size()); 
    RelatedTasks =[SELECT id,AccountId FROM Task where AccountId IN: AccIDSet and Last_modified_Date_by_non_admin__c >=:system.today()-90];
    //system.debug('##-RelatedTasks Count-'+RelatedTasks.size());
    RelatedEvent =[SELECT id,AccountId FROM Event where AccountId IN: AccIDSet and Last_modified_Date_by_non_admin__c >=:system.today()-90];
   // system.debug('##-RelatedEvent Count-'+RelatedEvent.size());
    RelatedNote =[SELECT Id,ParentId FROM Note where ParentId IN: AccIDSet and LastModifiedDate >=:system.today()-90];
    //system.debug('##-RelatedNote Count-'+RelatedNote.size());
    RelatedAttachment =[SELECT Id,ParentId FROM Attachment where parentID IN: AccIDSet and LastModifiedDate >=:system.today()-90];
    //system.debug('##-RelatedAttachment Count-'+RelatedAttachment.size());
    RelatedLead =[SELECT Id,Account__c FROM Lead where Account__c IN: AccIDSet and Last_modified_Date_by_non_admin__c >=:system.today()-90];
   // system.debug('##-RelatedLead Count-'+RelatedLead.size());
    
      //******** Create a map For Related Contacts ********************* 
   AccIDSet=new Set<id>(); 
if(RelatedContacts.size()>0 )
{
    for(Contact cc: RelatedContacts )
    {   //system.debug('Acc '+cc.AccountId); 
        //system.debug('AccIdSet '+AccIdSet);
        List<Contact> allContacts = new List<Contact>();
        if(!AccIDSet.contains(cc.accountId)){
            allContacts.add(cc);
            ContactMap.put(cc.accountId,allContacts);
            AccIDSet.add(cc.AccountId);
           // system.debug('ContactMap inside if '+ContactMap);
        }
        else{
            //Fetch value against cc.AccountId key and add all of them to allContacts
            allContacts = ContactMap.get(cc.AccountId);
            //add current cc record to allContacts 
            allContacts.add(cc);
            ContactMap.remove(cc.accountId);
            ContactMap.put(cc.accountId,allContacts);
          //  system.debug('ContactMap inside else '+ContactMap);
        }
    }
}    
  // system.debug('##$$---ContactMap Final -'+ContactMap); 
    
  //******** Create a map For For Related Opportunities *********************   

AccIDSet=new Set<id>();   
    if(RelatedOpportunity.size()>0 )
{
     for(Opportunity cc: RelatedOpportunity )
    {  // system.debug('Acc Related OPp '+cc.AccountId); 
       // system.debug('AccIdSet Related opp '+AccIdSet);
        List<Opportunity> allOpportunity = new List<Opportunity>();
        if(!AccIDSet.contains(cc.accountId)){
        // system.debug('Inside Opp IF');
            allOpportunity.add(cc);
            OpportunityMap.put(cc.accountId,allOpportunity);
            AccIDSet.add(cc.AccountId);
          //  system.debug('OpportunityMap inside if '+OpportunityMap);
        }
        else{ //  system.debug('Inside Opp ELSE');
            //Fetch value against cc.AccountId key and add all of them to allContacts
            allOpportunity = OpportunityMap.get(cc.AccountId);
            //add current cc record to allOpportunity 
            allOpportunity.add(cc);
            OpportunityMap.remove(cc.accountId);
            OpportunityMap.put(cc.accountId,allOpportunity);
           // system.debug('OpportunityMap inside else '+OpportunityMap);
        }
    } 
  }  
  //  system.debug('$$$OpportunityMap Final '+OpportunityMap);
  //  system.debug('##$$---RelatedOpportunity -'+RelatedOpportunity ); 
    
    
    //******** Create a map For For Related Leads *********************     
AccIDSet=new Set<id>(); 
    if(RelatedLead.size()>0 )
{  
    for(Lead cc: RelatedLead )
    {  // system.debug('Acc '+cc.Account__c); 
        
        List<Lead> allLeads = new List<Lead>();
        if(!AccIDSet.contains(cc.Account__c)){
            allLeads.add(cc);
            LeadMap.put(cc.Account__c,allLeads);
            AccIDSet.add(cc.Account__c);
           // system.debug('ContactMap inside if '+ContactMap);
        }
        else{
            //Fetch value against cc.AccountId key and add all of them to allContacts
            allLeads = LeadMap.get(cc.Account__c);
            //add current cc record to allContacts 
            allLeads.add(cc);
            LeadMap.remove(cc.Account__c);
            LeadMap.put(cc.Account__c,allLeads);
           // system.debug('LeadMap inside else '+LeadMap);
        }
    }
 }
 //  system.debug('##$$---LeadMap Final -'+LeadMap); 
 
   
    //********Create a map For Related Note *********************     
  AccIDSet=new Set<id>();
    if(RelatedNote.size()>0 )
{
    for(Note cc: RelatedNote )
    { //  system.debug('Acc '+cc.ParentId); 
        
        List<Note> allNotes = new List<Note>();
        if(!AccIDSet.contains(cc.ParentId)){
            allNotes.add(cc);
            NoteMap.put(cc.ParentId,allNotes);
            AccIDSet.add(cc.ParentId);
         //   system.debug('ContactMap inside if '+ContactMap);
        }
        else{
            //Fetch value against cc.AccountId key and add all of them to allContacts
            allNotes = NoteMap.get(cc.ParentId);
            //add current cc record to allContacts 
            allNotes.add(cc);
            NoteMap.remove(cc.ParentId);
            NoteMap.put(cc.ParentId,allNotes);
          //  system.debug('NoteMap inside else '+NoteMap);
        }
    }
 } // system.debug('##$$---NoteMap Final -'+NoteMap); 

     
    //********Create a map For Related Attachment *********************  
    AccIDSet=new Set<id>();   
    if(RelatedAttachment.size()>0 )
{
    for(Attachment cc: RelatedAttachment )
    {  // system.debug('Acc '+cc.ParentId); 
        
        List<Attachment> allAttachment = new List<Attachment>();
        if(!AccIDSet.contains(cc.ParentId)){
            allAttachment.add(cc);
            AttachmentMap.put(cc.ParentId,allAttachment);
            AccIDSet.add(cc.ParentId);
           // system.debug('ContactMap inside if '+ContactMap);
        }
        else{
            //Fetch value against cc.AccountId key and add all of them to allContacts
            allAttachment = AttachmentMap.get(cc.ParentId);
            //add current cc record to allContacts 
            allAttachment.add(cc);
            AttachmentMap.remove(cc.ParentId);
            AttachmentMap.put(cc.ParentId,allAttachment);
           // system.debug('AttachmentMap inside else '+AttachmentMap);
        }
    }
 } // system.debug('##$$---AttachmentMap Final -'+AttachmentMap);  

    
          //********Create a map For Related Task *********************     
AccIDSet=new Set<id>();
      if(RelatedTasks.size()>0 )
{  for(Task cc: RelatedTasks )
    {   //system.debug('Acc '+cc.AccountId); 
        
        List<Task> allTask = new List<Task>();
        if(!AccIDSet.contains(cc.AccountId)){
            allTask.add(cc);
            TaskMap.put(cc.AccountId,allTask);
            AccIDSet.add(cc.AccountId);
           // system.debug('allTask inside if '+allTask);
        }
        else{
            //Fetch value against cc.AccountId key and add all of them to allContacts
           allTask = TaskMap.get(cc.AccountId);
            //add current cc record to allContacts 
            allTask.add(cc);
            TaskMap.remove(cc.AccountId);
            TaskMap.put(cc.AccountId,allTask);
          //  system.debug('TaskMap inside else '+TaskMap);
        }
    }
 }  //system.debug('##$$---TaskMap Final -'+TaskMap);
   

             //********Create a map For Related Event *********************     
AccIDSet=new Set<id>(); 
      if(RelatedEvent.size()>0 )
{  for(Event cc: RelatedEvent )
    {  // system.debug('Acc '+cc.AccountId); 
       
        List<Event> allEvent = new List<Event>();
        if(!AccIDSet.contains(cc.AccountId)){
            allEvent.add(cc);
            EventMap.put(cc.AccountId,allEvent);
            AccIDSet.add(cc.AccountId);
         //   system.debug('allEvent inside if '+allEvent);
        }
        else{
            //Fetch value against cc.AccountId key and add all of them to allContacts
            allEvent = EventMap.get(cc.AccountId);
            //add current cc record to allContacts 
            allEvent.add(cc);
            EventMap.remove(cc.AccountId);
            EventMap.put(cc.AccountId,allEvent);
           // system.debug('EventMap inside else '+EventMap);
        }
    }
 }  //system.debug('##$$---EventMap Final -'+EventMap); 

   

    if(TargetAccounts.size()>0)
    {
      for(Account AA: TargetAccounts){
        // system.debug('##$$---inside update method -');         
        
            List<Contact> ContactCount =new List<Contact>();
            List<Opportunity> OpportunityCount =new List<Opportunity>(); 
            List<Task> TaskCount =new List<Task>();  
            List<Event> EventCount =new List<Event>();  
            List<Note> NoteCount =new List<Note>();  
            List<Attachment> AttachmentCount =new List<Attachment>();  
            List<Lead> LeadCount =new List<Lead>();
            
            ContactCount =ContactMap.get(AA.id);
            OpportunityCount =OpportunityMap.get(AA.id);
            TaskCount =TaskMap.get(AA.id);
            EventCount =EventMap.get(AA.id);
            NoteCount =NoteMap.get(AA.id);
            AttachmentCount =AttachmentMap.get(AA.id);
            LeadCount =LeadMap.get(AA.id);
           
            
            if(ContactCount==null) 
            {    AA.Count_of_Recent_Contacts__c=0; } 
            else
            {    AA.Count_of_Recent_Contacts__c= ContactMap.get(AA.id).size();
            }
            
             if(OpportunityCount==null) 
            {    AA.Count_of_Recent_Opportunities__c= 0; } 
            else
            {    AA.Count_of_Recent_Opportunities__c= OpportunityMap.get(AA.id).size();
            }
            
             if(TaskCount==null) 
            {    AA.Count_of_Recent_Tasks__c= 0; } 
            else
            {    AA.Count_of_Recent_Tasks__c= TaskMap.get(AA.id).size();
            }
            
             if(EventCount==null) 
            {    AA.Count_of_Recent_Events__c=0; } 
            else
            {    AA.Count_of_Recent_Events__c= EventMap.get(AA.id).size();
            }
            
             if(NoteCount==null) 
            {     AA.Count_of_Recent_Notes__c= 0; } 
            else
            {     AA.Count_of_Recent_Notes__c= NoteMap.get(AA.id).size();
            }
            
             if(AttachmentCount==null) 
            {    AA.Count_of_Recent_Attachments__c= 0; } 
            else
            {    AA.Count_of_Recent_Attachments__c= AttachmentMap.get(AA.id).size();
            }
            
             if(LeadCount==null) 
            {   AA.Count_of_Recent_Leads__c= 0; } 
            else
            {    AA.Count_of_Recent_Leads__c= LeadMap.get(AA.id).size();
            }        

         // update AA;
         AccountUpdateList.add(AA);
     }
  }  
  
  //************** Update account List ******************
    if(AccountUpdateList.size()>0)
    {   Update AccountUpdateList;
    }
    

    
           
           
      
    }
        
    global void finish(Database.BatchableContext BC)
    {  }
}