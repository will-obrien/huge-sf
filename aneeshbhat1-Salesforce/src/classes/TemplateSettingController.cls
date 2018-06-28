public with sharing class TemplateSettingController {


public Id SettingID{get;set;}
public string PageHeader{get;set;}
public TemplateSetting__c ObjTemp{get;set;}
public Look_Up__c ObjLookUp{get;set;}
public List<Look_Up__c> LstLookUp{get;set;}
public List<EmailTemplate> LstEmailTemplate{get;set;}
public List<TemplateSetting__c > LstTemplateSetting{get;set;}

    public TemplateSettingController(ApexPages.StandardController controller) {
            SettingID=system.currentPagereference().getParameters().get('id');
            LstTemplateSetting=[SELECT Id, Billing_Country__c,Name, TemplateId__c ,Template_Name__c, Program__c, Extra_Brochure_To_Send__c, Master_Rule__c, Is_Enabled__c, Requested_Brochures__c, Based_On__c, Based_On1__c FROM TemplateSetting__c where id=:SettingID];
            if(LstTemplateSetting==null || LstTemplateSetting.size()==0)
            {
                ObjTemp= new TemplateSetting__c();
                PageHeader='Create New Template Settings';
            }
            else
            {
                ObjTemp=LstTemplateSetting[0];
                System.debug('************************************************************** EmailTemplate ID Is  '+  ObjTemp.TemplateId__c );
               
                PageHeader='Edit Template Settings';
            }
            
    }
       

        public TemplateSettingController ()
            {
                ObjTemp= new TemplateSetting__c();
            }
            
        public PageReference save() 
        {
            ObjTemp.TemplateId__c=ObjTemp.Template_Name__c;
             System.debug(' ObjEmailTemplate '+ ObjTemp.Template_Name__c);
           ObjTemp.Template_Name__c=SaveLookup();
          
          ApexPages.StandardController controllersetting = new ApexPages.StandardController(ObjTemp);
          try {
          
                controllersetting .save();
              }
          catch(Exception e) {
                    return null;
                              }
          return controllersetting .view();
       }
       
       public string SaveLookup()
       {
     
       
      
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,ObjTemp.Template_Name__c));
              System.debug(' ObjEmailTemplate '+ ObjTemp.Template_Name__c);
           LstEmailTemplate=[SELECT Id, TemplateStyle, Name, TemplateType, Encoding FROM EmailTemplate where Id= :ObjTemp.Template_Name__c];
           if(LstEmailTemplate==null || LstEmailTemplate.size()==0)
           {
               LstLookUp=[select Id,name from Look_Up__c  where id=:ObjTemp.Template_Name__c];
                System.debug('ObjEmailTemplate is NULL');
               if(LstLookUp!= null && LstLookUp.size() >0)
               {
                   LstEmailTemplate=[SELECT Id, TemplateStyle, Name, TemplateType, Encoding FROM EmailTemplate where Name= :LstLookUp[0].name];
               }
               
              
           }
            ObjTemp.TemplateId__c=LstEmailTemplate[0].Id;
           System.debug(' ObjEmailTemplate is Not Null'+LstEmailTemplate[0].Name);
           LstLookUp=[select Id,name from Look_Up__c  where name=:LstEmailTemplate[0].Name];
           System.debug('List LookUp Size is'+ LstLookUp.size());
           if(LstLookUp==null || LstLookUp.size()==0)
           {
               System.debug(' New LookUp **************************************************************'+ LstEmailTemplate[0].Name);
               ObjLookUp=new Look_Up__c();
               ObjLookUp.Name=LstEmailTemplate[0].Name;
                insert ObjLookUp;

               
            }
           ObjLookUp=[select Id,name from Look_Up__c  where name=:LstEmailTemplate[0].Name];
           return ObjLookUp.Id;
           
       }
            
            
}