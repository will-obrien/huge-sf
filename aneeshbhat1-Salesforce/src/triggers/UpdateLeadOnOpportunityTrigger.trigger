trigger UpdateLeadOnOpportunityTrigger on Opportunity (before insert,before update)
{
        List<Opportunity> AutoAssignTemplates=new List<Opportunity>();
             if (Trigger.isInsert) 
         {
             for(Opportunity opportunity:trigger.new)
                {
                    //List<Opportunity> Opps=[SELECT Id, Name, Billing_Country__c,Letter_Template__c FROM Opportunity where Id=:opportunity.Id ];
            
                    //if(Opps!=null&&Opps.size()>0)
                        //{
                                
                                //Opportunity autotempOpportunity=[Select Id,Lead__c,Letter_Template__c,Billing_Country__c FROM Opportunity where Id=:opportunity.Id];
                                List<TemplateSetting__c> LstTemplt=[SELECT Id, Name,TemplateId__c FROM TemplateSetting__c where Billing_Country__c=:opportunity.Billing_Country__c];
                                if(LstTemplt!=null && LstTemplt.size()>0)
                                {
                                   
                                    opportunity.Letter_Template__c=LstTemplt[0].Id;
                                    opportunity.Template_ID__c=LstTemplt[0].TemplateId__c;
                                    //AutoAssignTemplates.add(autotempOpportunity);
                                }
                                else
                                {
                                    opportunity.Letter_Template__c=null;
                                    opportunity.Template_ID__c='';
                                }
                
                       // }
                }
                    //for(Opportunity opportunity:AutoAssignTemplates)
                            //{
                                //update opportunity;
                            //}

          }
      if (Trigger.isUpdate) 
         {
          for(Opportunity opportunity:trigger.new)
                {
                    List<Opportunity> Opps=[SELECT Id, Name, Letter_Template__c,Billing_Country__c FROM Opportunity where Id=:opportunity.Id ];
            
                    if(Opps!=null&&Opps.size()>0)
                        {
                            
                            List<TemplateSetting__c> LstTemplts=[SELECT Id, Name,TemplateId__c FROM TemplateSetting__c where Billing_Country__c=:opportunity.Billing_Country__c];
                            if(LstTemplts!=null && LstTemplts.size()>0)
                                {
                                    opportunity.Letter_Template__c=LstTemplts[0].Id;
                                    opportunity.Template_ID__c=LstTemplts[0].TemplateId__c;
                                }
                            else
                            {
                                opportunity.Letter_Template__c=null;
                                opportunity.Template_ID__c='';
                            }
                            
                        }
                     
                } 
         }
    
    
       // for(Opportunity opportunity:trigger.new)
       // {
           // List<Lead> leads=[SELECT Id,Name FROM Lead WHERE ConvertedOpportunityId=:opportunity.Id];
            //Opportunity tempOpportunity=[Select Id,Lead__c FROM Opportunity where Id=:opportunity.Id];
           // if(leads!=null&&leads.size()>0)
            //{
               // tempOpportunity.Lead__c=(leads[0]).Id;
                //opportunitiesToBeUpdated.Add(tempOpportunity);
            //}
       // }
    
        //for(Opportunity opportunity:opportunitiesToBeUpdated)
        //{
            //update opportunity;
        //}
}