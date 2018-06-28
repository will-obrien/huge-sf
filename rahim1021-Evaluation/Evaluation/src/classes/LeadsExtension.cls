/* This class is the extension class for ConvertedLeads VisualForce Page.
 *
 * Functionality: this class will converts lead records into Account, Contact And Oppurtunity,
 *   lead records are received from ConvertedLeads VisualForce Page
 *   Editted from Jenkins
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     21/03/2016   Basic Functionality Acheived 
 *
 */
public class LeadsExtension {
    private ApexPages.StandardSetController standardObjectController;
    public List<Lead> convertedSelectedLeads{get;set;}
    public LeadsExtension(ApexPages.StandardSetController standardController) {
        this.standardObjectController = standardController;
    }
    public pagereference convertLeads()
    {       
        // Get the selected records (do your own SOQL)
        Map<String,Account> mapCompanyName=new Map<String,Account>();
        Map<String,Contact> mapContact=new Map<String,Contact>();
        List<Lead> listSelectedLeads = (List<Lead>) standardObjectController.getSelected();
        List<Lead> listSelectedLeadRecords =[Select Id,Company,firstName,lastName FROM Lead Where id in :listSelectedLeads];
        List<String> listStringCompanyName=new List<string>{};
        List<String> listStringContactName=new List<string>{};
            for(Lead strName:listSelectedLeadRecords){
                listStringCompanyName.add(strName.Company);
                listStringContactName.add(strName.firstName + ' ' + strName.lastName);
            }
        List<Account> listAccount = [ SELECT id,Name FROM Account WHERE name IN :listStringCompanyName];
        List<Contact> listContact = [ SELECT id,Name,FirstName,LastName FROM Contact WHERE name IN :listStringContactName];
        for(Lead objLead:listSelectedLeadRecords){
            system.debug(objLead);
            for(Account objAccount:listAccount){
                
                if(objLead.Company==objAccount.name)
                {
                    mapCompanyName.put(objLead.Id, objAccount);
                }
            }
            for(Contact objContact:listContact){
                if(objLead.firstName==objContact.firstName && objLead.lastName==objContact.LastName)
                {
                    mapContact.put(objLead.Id, objContact);
                }
            }
        }
        List<Database.LeadConvert> listLeadConversions = new List<Database.LeadConvert>(); 
        Database.LeadConvert objLeadConvert;
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        // Set Conversion records       
        for(Lead objSelectedLead : listSelectedLeadRecords)
        {
            objLeadConvert = new Database.LeadConvert();
            objLeadConvert.setLeadId(objSelectedLead.id);
            objLeadConvert.setOverwriteLeadSource(true);
            if(mapCompanyName.containsKey(objSelectedLead.Id))
            {
                objLeadConvert.setAccountId(mapCompanyName.get(objSelectedLead.id).Id);
            }
            if(mapCompanyName.containsKey(objSelectedLead.Id))
            {
                objLeadConvert.setContactId(mapContact.get(objSelectedLead.id).Id);
            }
            objLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
            listLeadConversions.add(objLeadConvert);
        }     
        // Convert Records
        List<Database.LeadConvertResult> leadConversionResults = Database.convertLead( listLeadConversions ); 
        // Set the Converted Result
        convertedSelectedLeads = [SELECT convertedContact.lastName,
                                         convertedContactId, 
                                         convertedAccount.name, 
                                         convertedAccountId,
                                         name, id, 
                                         firstName, 
                                         lastName
                                  FROM Lead 
                                  WHERE id IN :listSelectedLeads 
                                  ] ; 
        return null;
    }
}
