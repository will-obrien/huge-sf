/**
*    LicensesetEventHandler helper Class for licenseSet trigger
*
*    Modification Log
*
*    Deepthi        PGI    10/27/2014      created helper class for licenseSet trigger events, method/logic for creating OpportunityAssets 
**/
public class LicensesetEventHandler{

     public static boolean skipAfterEvent      = false; // Skip recursive after event trigger logic execution
     public static boolean skipBeforeEvent     = false; // Skip recursive before event trigger logic execution

    /*
    * Method to Create OpportunityLicenses/Assets on Licenseset updates with hubId and CompanyId
    */
    public static void createOpporLicense(map<id,licenseset__c> newLicensesetMap, 
                            map<id,licenseset__c> oldLicensesetMap){
        list<LicenseSet__c> updatedCompanyHubIdlicsetLst = new list<Licenseset__c>();
        
        /* START retrieving list of all LicenseSets with hubid/companyid updated */
        for(Licenseset__c licset: newLicensesetMap.values()){
            licenseset__c oldlicset = oldLicensesetMap.get(licset.id);
            if((oldlicset.companyid__c == null && licset.companyid__c <> oldlicset.companyid__c) &&
               (oldlicset.hubid__c == null && licset.hubid__c <> oldlicset.hubid__c)){
                updatedCompanyHubIdlicsetLst.add(licset);
            }
        }
        /* END retrieving list of all LicenseSets with hubid/companyid updated */
        /* Calling PGI Utility method to create  assets if licenseset contains updates with hubid/companyid */
        if(updatedCompanyHubIdlicsetLst.size() > 0){
            list<Asset> newAssetLst = PGI_Utility.createOpporAsset(updatedCompanyHubIdlicsetLst);
            if(newAssetLst <> null && newAssetLst.size() > 0){
                // Inserting Assets
                insert newAssetLst;
            }
        }
    }
    
    /* Logic to Validate LicenseSet updates */
    public static void validateLicenseSetUpdates(Map<id, licenseset__c> licensesetmap){
        Set<id> OpportunityIdSet = new set<id>();

        // collecting licenseset opportunityids
        for(Licenseset__c licset: licensesetMap.values()){
            OpportunityIdSet.add(licset.opportunity__c);
        }
        // Retreiving closed opportunities for updated licensesets
        Map<id, Opportunity> closedOpportunityMap = new map<id, Opportunity>([select id, opp_Stage__c 
                                                            from opportunity 
                                                            where opp_Stage__c in ('Closed Won', 'Closed Lost') 
                                                                    and id in :OpportunityIdSet]);
        
        // Checking for licenseset with closed opportunity and throwing error message
        for(Licenseset__c licset: licensesetMap.values()){
            if(closedOpportunityMap.containskey(licset.opportunity__c)){
                licset.addError(label.Closed_Opportunity_Licenseset_Update_Error_Message);
            }
        }
    }
}