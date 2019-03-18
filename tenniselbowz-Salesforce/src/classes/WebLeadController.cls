public without sharing class WebLeadController {
    Private final Lead newLead;
    public boolean showSuccessMessage{get;set;}
    public boolean showErrorMessage{get;set;}
    public CampaignMember newCampaignMember;
   
     //Constructor
    public WebLeadController(ApexPages.StandardController controller) {
        showSuccessMessage=false;
        showErrorMessage=false;
        this.newLead = (Lead)Controller.getRecord();
        newCampaignMember = new CampaignMember();
    }
    
     //Save method
    public System.PageReference save()
    {    
    
 if(string.isempty(newLead.firstname) || string.isempty(newLead.lastname) || string.isempty(newLead.company) || string.isempty(newLead.CountryCode) || string.isempty(newLead.Email) || string.isempty(newLead.phone) || string.isempty(newLead.Description) 
             || ((newLead.CountryCode == 'US' || newLead.CountryCode == 'AG' || newLead.CountryCode =='AR'|| newLead.CountryCode =='AU'
             || newLead.CountryCode =='BB'|| newLead.CountryCode =='BO'|| newLead.CountryCode =='BQ'|| newLead.CountryCode =='BR'|| newLead.CountryCode =='BS'|| newLead.CountryCode =='BZ'|| newLead.CountryCode =='CA'|| newLead.CountryCode =='CL'
             || newLead.CountryCode =='CN'|| newLead.CountryCode =='CO'|| newLead.CountryCode =='CR'|| newLead.CountryCode =='DM'|| newLead.CountryCode =='DO'|| newLead.CountryCode =='EC'|| newLead.CountryCode =='GD'|| newLead.CountryCode =='GT'
             || newLead.CountryCode =='GY'|| newLead.CountryCode =='HN'|| newLead.CountryCode =='HT'|| newLead.CountryCode =='IE'
             || newLead.CountryCode =='IN'|| newLead.CountryCode =='IT'|| newLead.CountryCode =='JM'|| newLead.CountryCode =='KN'|| newLead.CountryCode =='LC'|| newLead.CountryCode =='MX'|| newLead.CountryCode =='NI'|| newLead.CountryCode =='PA'
             || newLead.CountryCode =='PE'|| newLead.CountryCode =='PY'|| newLead.CountryCode =='SR'|| newLead.CountryCode =='SV'
             || newLead.CountryCode =='TT'|| newLead.CountryCode =='US'|| newLead.CountryCode =='UY'|| newLead.CountryCode =='VC'|| newLead.CountryCode =='VE') && string.isempty(newLead.StateCode)))
     {
     showErrorMessage=true;
            return null;
     }
     
     //Code to trigger Assignment Rules
     Database.DMLOptions dmo = new Database.DMLOptions();
     dmo.emailHeader.triggerUserEmail = true;               //Triggering Email alert mentioned on Assignment Rule
     dmo.assignmentRuleHeader.useDefaultRule= true;         //Triggering Assignment Rule
     newLead.setOptions(dmo);                               //Setting Assignment rule options on Leads
     newLead.LeadSource='Contact Us Web Page';              //Hard Coding Lead Source Value
     insert(newLead);                                       //Inserting Leads
     
     newCampaignMember.CampaignId='701C0000000Wg1U';        // Hard Coding CampiagnId in CampaignMmebers
     newCampaignMember.LeadId=newLead.ID;                   // Assigning Lead Id to Campaign Member
     insert(newCampaignMember);                             //Inserting Campaign Members
     return clearLead();
    }
    
     public PageReference clearLead()
     {
    showSuccessMessage = true;
    return null;
     }
       public pageReference cancel()
    {
        PageReference p = Page.LatamWebtoLead;
        p.setRedirect(true);
        
        return p;
    }
    

}