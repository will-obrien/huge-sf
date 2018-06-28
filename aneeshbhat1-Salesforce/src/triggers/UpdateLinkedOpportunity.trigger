trigger UpdateLinkedOpportunity on TemplateSetting__c (before update) {
    
     if (Trigger.isUpdate) 
         {
          for(TemplateSetting__c objsetting:trigger.new)
                {
                    List<TemplateSetting__c> settings=[SELECT Id, Name, TemplateId__c ,Template_Name__c, Program__c, Extra_Brochure_To_Send__c, Master_Rule__c, Is_Enabled__c, Requested_Brochures__c, Based_On__c, Based_On1__c FROM TemplateSetting__c where id=:objsetting.Id];
            		system.debug(' Updated Setting is  '+objsetting.name);
                    system.debug(' Email Template Id IS  '+objsetting.TemplateId__c);
                    if(settings!=null && settings.size()>0)
                        {
                            List<Opportunity> Opps=[SELECT Id, Name, Letter_Template__c FROM Opportunity where Letter_Template__c=:settings[0].Id];
                             if(Opps!=null && Opps.size()>0)
                                {
                                    system.debug(' We have '+Opps.size()+ ' Records to Update');
                                    for(Opportunity opportunity:Opps)
        									{
                                                opportunity.Name=opportunity.Name+' Arjun';
                                                opportunity.Template_ID__c=settings[0].TemplateId__c;
                                                update  opportunity;
                                                system.debug(' Opportunity Name '+opportunity.Name+ ' Email Template Id '+settings[0].TemplateId__c);
        									}
                                }
                        }
                } 
         }

}