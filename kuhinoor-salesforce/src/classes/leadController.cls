Public class leadController{

    public Lead leaddata {get;set;}
    public leadController(){
        leaddata = new lead();
        
    }
    Public pageReference save(){
        insert leaddata;
        return new pagereference('/'+leaddata.id);
    } 
    Public pageReference convert(){
        insert leaddata;
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leaddata.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        return null;
    } 
   
}