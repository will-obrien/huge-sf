global class PROEmailRemindarClearDataBatch implements Database.Batchable<DContract__c>, Database.Stateful {
    Map<string,integer> FrequencyMap=null;
    List<DContract__c> failedReocrds = new List<DContract__c>();
    String failedDML = '';
    public PROEmailRemindarClearDataBatch(){
        FrequencyMap=new Map<string,integer>();
        List<PRO_Frequency_Settings__C> proSettings=PRO_Frequency_Settings__C.getAll().values();
        for(PRO_Frequency_Settings__C proSet : proSettings){
             FrequencyMap.put(proSet.Name,Integer.valueOf(proSet.Frequency_In_Week__C));
        }
    }
    
    global List<DContract__c> start(Database.BatchableContext context) {
       return GetContract();
    }
    global void execute(Database.BatchableContext context, List<DContract__c> contracts) {
         
         Date currentDate=Date.today();
         
         List<DContract__c> updateList=new List<DContract__c>();
         
         integer currentYear=currentDate.year();
         integer currentMonth=currentDate.month();
         
         List<Date> thursDayList= PROHelper.GetAllThursDayOfMonth(currentYear,currentMonth);
         
         //If Thursday then clear Data.
         if(PROHelper.IsThursDay(currentDate)){
         
            for(DContract__c contract : contracts){
                integer noOfDays=FrequencyMap.get(contract.Last_Report_Out_Status__c);
                if(noOfDays==null || noOfDays==0){
                    noOfDays=2;
                }
                
                if(noOfDays==1 || 
                    (noOfDays==2 && (thursDayList[1]==currentDate || thursDayList[3]==currentDate ))
                   || (noOfDays==3 && thursDayList[2]==currentDate)
                   || (noOfDays==4 && thursDayList[3]==currentDate)
                 ){
                
                    contract.Is_Snooze__c=false;
                    contract.Snooze_Date__c=null;
                    contract.Snooze_Days__c=null;
                    contract.Is_First_Nag_Sent__c=false;
                    contract.First_Nag_Sent_Date__c=null;
                    contract.Second_Nag_Sent_Date__c=null;
                    contract.Third_Nag_Sent_Date__c=null;
                    contract.Fourth_Nag_Sent_Date__c=null;
                    updateList.add(contract);
                }
             }
              
            //update updateList;
            List<Database.SaveResult> updateResults = Database.update(updateList, false);
            
            for(Integer i=0;i<updateResults.size();i++){
                if (updateResults.get(i).isSuccess()){
                    updateResults.get(i).getId();
                }
                else if (!updateResults.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = updateResults.get(i).getErrors().get(0);
                    failedDML = error.getMessage();
                    system.debug('Failed ID'+updateList.get(i).Id);
                    failedReocrds.add(updateList.get(i));
                }

            }
        }

    }
    global void finish(Database.BatchableContext context) {
        List<String> toAddresses = new List<String>();
        List<PRO_Email_Remindar_Settings__c> settingList=PRO_Email_Remindar_Settings__c.getALL().values();
        PRO_Email_Remindar_Settings__c settings = settingList[0];
        if(settings.Error_Email__c != null && settings.Error_Email__c.contains(',')){
            for(String email : settings.Error_Email__c.split(',')) {
                toAddresses.add(email);
            }
        }else if(settings.Error_Email__c != null ){
            toAddresses.add(settings.Error_Email__c);
        }
     
        if(failedReocrds.size() > 0 && toAddresses.size() > 0){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);            
            mail.setSenderDisplayName('');
            mail.setSubject('');
            String htmlBody = 'Second reminder was failed to sent on the following records.<br/>';
            htmlBody += '<b>Error:</b> '+failedDML+'<br/><br/>';
            htmlBody += '<b>Records:</b> <br/>';
            for(DContract__c contract : failedReocrds) {
                htmlBody +=  '<b>Name:</b> '+contract.Name +' - <b>Id:</b> '+ contract.Id +'<br/>';
            }

            mail.setUseSignature(false);
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    private List<DContract__c> GetContract(){
       List<DContract__c> contractList=[select id,Name,Last_Report_Out_Date__c,Last_Report_Out_Status__c,Is_Snooze__c,Is_First_Nag_Sent__c,
                                       Snooze_Days__c,Snooze_Date__c,First_Nag_Sent_Date__c
                                     ,OwnerId,Owner.Name,Owner.Email 
                                     ,Backstop__c,Backstop__r.FirstName,Backstop__r.LastName,Backstop__r.Email 
                                     ,Project_Manager__c,Project_Manager__r.FirstName, Project_Manager__r.LastName,Project_Manager__r.Email
                                     ,Prime_Contracting_Business_Unit__c,Last_Report_Out_Created_Date__c 
                                     from DContract__c
                                     where Last_Report_Out_Date__c!=null and Requires_Report_Out__c='Yes' and
                                      Workflow_Escalation_Enabled__C=true];
       return contractList;
    }
}