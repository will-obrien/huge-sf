global class batchCventIntegration implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        Cvent_Registration_Codes__c cvent = Cvent_Registration_Codes__c.getall().values(); 
        String taskStatus = 'Not Started';
        String sub = cvent.Convention_Name__c+'%';
        string query = 'select Id, Status, Subject,Description,whoId from task where status =\'' + taskStatus + '\' and subject like \'' + sub + '\'';
       // String taskId = '00T4000004OVlB6';
       // string query = 'select Id, Status, Subject,Description,whoId from task where ID =\'' + taskId + '\'';
       // string query1 = 'select Id, Status, Subject,Description,whoId from task';
       // system.debug('Query is : '+query);
       // if(!Test.isRunningTest())
        return Database.getQueryLocator(query);
        
    }
    
    
    global void execute(Database.BatchableContext bc, List<task> lsttask){
        
        List<String> fields;
        string email;
        List<ID> lstLeadIds = new List<ID>();
        Set<Id> LeadsToConvert =new Set<ID>();
        List<string> lstemail = new List<string>();
        Map<string, String> mapEmailToAmtowed = new Map<string, String>();
        Map<string, String> mapEmailToBalance = new Map<string, String>();
        Map<string,List<string>> mapIdtoBodyFields = new Map<string,List<string>>();
        Map<string,List<string>> mapEmailtoBodyFields = new Map<string,List<string>>();
        Map<ID,ID> mapLeadtoTask = new map<ID,ID>();
        List<ID> tasklist = new List<ID>();
        
        
        Cvent_Registration_Codes__c cvent = Cvent_Registration_Codes__c.getall().values();
        List<Task> lsttasktoupdate = new List<Task>();
         for(Task tk:lsttask)
         {
                    if(tk.Subject.indexOf(cvent.Subject_Line_No_Match__c) > -1) 
                    {
                                    if (tk.WhoId != null)
                                    {
                                        LeadsToConvert.add(tk.whoId);
                                        tasklist.add(tk.ID);
                                        string description = tk.Description;
                                        system.debug('The description is'+description);
                                        List<String> descFields = description.split(':');         
                                        if(descFields.size() > 1) 
                                        {
                                            mapIdtoBodyFields.put(tk.whoId,descFields);                                                                                 
                                        }                                
                                     }
                     
                     /* No Match - Email Id in the subject of the task is not present in our system */   
                    
                        fields = tk.Subject.split(':');
                                if(fields.size() > 1) 
                                {
                                email = fields[1].toLowerCase();
                                mapEmailToAmtowed.put(email,fields[2]);
                                mapEmailToBalance.put(email,fields[3]);
                                system.debug('Value of field[0] the trigger: '+ fields[0]);
                                system.debug('Value of field[1] the trigger: '+ fields[1]);
                                system.debug('Value of field[2] the trigger: '+ fields[2]);
                                system.debug('Value of field[3] the trigger: '+ fields[3]);
                                system.debug('List of Email Ids'+lstemail);
                                }
                                                            
                    } // end of no match
             
                 /* Single Match - Email Id in the subject of the task is already present in our system */
                else if(tk.Subject.indexOf(cvent.Subject_Line_Match__c) > -1) 
                {
                         
                         tasklist.add(tk.Id);
                          fields = tk.Subject.split(':');
                          if(fields.size() > 1) 
                          {
                            email = fields[1].toLowerCase();
                            lstemail.add(email);
                            mapEmailToAmtowed.put(email,fields[2]);
                            mapEmailToBalance.put(email,fields[3]);
                                                        
                            system.debug('Value of field[0] the single match trigger: '+ fields[0]);
                            system.debug('Value of field[1] the single match trigger: '+ fields[1]);
                            system.debug('Value of field[2] the single match trigger: '+ fields[2]);
                            system.debug('Value of field[3] the single match trigger: '+ fields[3]);
                            system.debug('List of Email Ids'+lstemail);
                            system.debug('Map Email to Amount Owed:'+mapEmailToAmtowed.get(email));
                          }
                                                    
                          string description = tk.Description;
                          system.debug('The description is'+description);
                          List<String> descFields = description.split(':');         
                          if(descFields.size() > 1) 
                          {
                                email = fields[1].toLowerCase();
                                mapEmailtoBodyFields.put(email,descFields);
                                system.debug('The new body fields are: '+mapEmailtoBodyFields.Keyset()+mapEmailtoBodyFields.values());                                                 
                           }
              } // end of single match else if
             
             
      } // for loop
             
              List<Contact> lstCheckCon = [select ID, Email, Name, AccountID,CVent_Member_Type__C, KPI_Member__c from Contact where Email in :lstemail];
             
              /***********************  CASE 1  *************************/
              // If contact does not exists in the database, convert lead to Account, Contact and Opportunity. As well create Opportunity Line Items.
              if(!LeadsToConvert.isEmpty())
              {
                    taskUtil.noMatch(LeadsToConvert,mapEmailToAmtowed,mapEmailToBalance,mapIdtoBodyFields,tasklist);
              }
              /***********************  CASE 2  *************************/
              //Else If contact already exists create opportunity and opportunity line item.
              if(!lstCheckCon.isEmpty())
              {
                      taskUtil.singleMatch(lstCheckCon,mapEmailToAmtowed,mapEmailToBalance,mapEmailtoBodyFields,tasklist);
              }
              
        
    } // end of execute

    global void finish(Database.BatchableContext bc)
    {
           
    }

}