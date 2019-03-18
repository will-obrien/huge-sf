/**
*    PGI_Utility class contains generic methods that can be reused across appliction
*
*    Modification Log
*
*    Deepthi        PGI    11/04/2014      contains generic methods that can be reused across appliction
**/
public class PGI_Utility{

    /*
    *   Logic to lookup Lead LicenseSet records with Opportunity
    */
    public static list<LicenseSet__c> createOpporLicenseSet(map<id, id> ldOpporIdMap){
        list<Licenseset__c> licSetLst = new list<Licenseset__c>();
        //Retrieve Leads and LicenseSets associated with Leads
        for(Lead ld: [select id, Z_Source__c, (Select id, name, Opportunity__c, Enterprise_Name__c, Number_of_Licensed_Named_Users__c,Start_Date__c,End_Date__c, Z_Source__c from licensesets__r) 
                            from 
                                lead 
                            where 
                                id in :ldOpporIdMap.keyset()]){
            system.debug(' ld.licensesets__r: ' + ld.licensesets__r);
            for(Licenseset__c licSet : ld.licensesets__r){
                if(licSet.Opportunity__c == null){
                    //Mapping LicenseSet with Opportunity
                    licSet.Opportunity__c = ldOpporIdMap.get(ld.id);
                }
                licSetLst.add(licSet);
            }
        }
        system.debug(' licSetLst: ' + licSetLst);

        //Returning LicenseSet list for update
        return licSetLst;
    }

    /*
    *   Logic to create Opportunity Assets
    */
    public static list<Asset> createOpporAsset(list<LicenseSet__c> licSetLst){
        list<Asset> licLst     = new list<Asset>();
        //set<string> offeringIdSet   = new set<String>();
        set<string> opporIdSet      = new set<String>();

        //Collecting OpportnityIds from LicenseSet list
        for(LicenseSet__c licSet: licSetLst){
            //offeringIdSet.add(licSet.Enterprise_Name__c);
            opporIdSet.add(licSet.Opportunity__c);
        }
        //map<Id, Offerings__c > offeringsMap = new map<id, Offerings__c>([select id, name from offerings__c where id in :offeringIdSet]);

        // Querying for Opportunity Values and Storing in Map
        map<Id, Opportunity >   opporMap    = new map<id, Opportunity>([select id, name, AccountId, Z_Source__c,ECommerce_Account_Number__c from Opportunity where id in :opporIdSet]);
        system.debug('licSetLst : ' + licSetLst);
        
        // Creating Assets for LicenseSets
        for(Licenseset__c licSet:licSetLst){
            for(Integer i=0;i<licSet.Number_of_Licensed_Named_Users__c;i++){
                // Initializing assets
                Asset lic = new Asset(Name = licSet.name,
                                    Enterprise_Name__c = licSet.Enterprise_Name__c, 
                                    Client_ID__c = Label.Default_Asset_ClientId,
                                    accountid = opporMap.get(licSet.Opportunity__c).accountid,
                                    ECommerce_Account_Number__c = opporMap.get(licSet.Opportunity__c).ECommerce_Account_Number__c,
                                    Opportunity__c = licSet.Opportunity__c, 
                                    License_Name__c = licSet.id,
                                    Z_Source__c = licSet.Z_Source__c
                                );

                //Adding Assets to list
                licLst.add(lic);    
             }
        }
        system.debug('licLst : ' + licLst);
        //Returning Assets list for Update
        return licLst;
    }   

    /*
    *   Logic to create Contracts
    */
     public static list<Contracts__c> createAccountContracts(list<Opportunity> opporLst){
        list<Contracts__c> contractLst = new list<Contracts__c>();
        // Querying for Opportunity, LicenseSet records
        for(Opportunity oppor: [select id, accountid, Z_Source__c, (select id, Start_Date__c, Z_Source__c, End_Date__c from licensesets__r) from opportunity where id in:opporLst]){
            if(oppor.licensesets__r.size()>0){
                Date leastdate   = null;
                Date highestdate = null;
                // Getting leastDate from Licenseset.StartDate, highestDate from LicenseSet.EndDate from opportunity LicenseSet
                for(Licenseset__c licset: oppor.licensesets__r){
                    if((licSet.Start_Date__c < leastdate) || leastdate == null)
                       leastdate = licSet.Start_Date__c;
                    
                    if((licSet.End_Date__c > highestdate) ||highestdate == null)
                       highestdate = licSet.End_Date__c;
                }
                // Initializing contract adding to Contract List
                contractLst.add(new Contracts__c(
                        Start_Date__c        = leastdate,
                        End_Date__c          = highestdate,
                        Status__c            = Label.Default_Contract_Status,
                        Account__c           = oppor.accountid,
                        Signed_Date__c       = System.Today(),
                        Z_Source__C          = oppor.Z_Source__c
                    )
                );
            }
        }
        // Returning Contract List for insert
        return contractLst;
     }
 }