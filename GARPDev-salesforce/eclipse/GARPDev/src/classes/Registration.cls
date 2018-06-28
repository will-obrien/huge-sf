public with sharing class Registration
{
    
    public static id GetMember(String strEmail,String strFirstName,String strLastName) {
        Integer iCount = [select count() from contact where Primary_Email__C =: strEmail];
        if(iCount > 0)
        {
            return null;
        }
        else
        {
            return UpdateLead(strEmail,strFirstName,strLastName);
         
        }
        
    }
    
    
    public static Id UpdateLead(String strEmail,String strFirstName,String strLastName) {
         return checkLead(strEmail,strFirstName,strLastName);
         
        
    }
    
    public static Id checkLead(String strEmail,String strFirstName,String strLastName)
    {
        Lead ld = [select id,Name,Email from Lead where Email =: strEmail LIMIT 1];
        if(ld != null)
        {
            ld.FirstName = strFirstName;
            ld.LastName = strLastName;
            update ld;
            return ld.id;
        }
        else
        {
            Lead newLead = new Lead();
            newLead.Email = strEmail;
            insert newLead;
            return newLead.id;
        }
    
    }
    
    public static boolean convertLead(Lead leadRecord)
    {
        Database.LeadConvert convertLead = new Database.LeadConvert();
        convertLead.setLeadId(leadRecord.id);

        LeadStatus ls = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        convertLead.setConvertedStatus(ls.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(convertLead);
        return lcr.isSuccess();
        
    }
    
    
    
}