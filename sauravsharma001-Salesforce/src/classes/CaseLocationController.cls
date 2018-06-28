public class CaseLocationController {

    public List<Case> relatedCases {get; set;}
    public Case currentCase {get; set;}
    
    public CaseLocationController(ApexPages.StandardController controller)    {
        ID caseID = ApexPages.currentPage().getParameters().get('id');
        List<Case> ca = [Select id, CaseNumber, Subject, Service_request_Type__c, Location__Latitude__s, Location__Longitude__s, City__c, Street__c, State__c, Country__c, Zipcode__c from Case WHERE ID =: caseID];
        if(ca != null && ca.size() ==1)
             currentCase = ca[0];
    }
    
    public String getCurrentCaseJson(){
        return JSON.serialize(currentCase);
    }
    
    public String getRelatedCasesJson(){
        getrelatedCases();
        System.debug('Related Case:' + JSON.serialize(relatedCases));
        return JSON.serialize(relatedCases);
    }
    
    public void getrelatedCases(){
        
        if(currentCase != null && currentCase.Location__Latitude__s != null)    {
            Decimal latitude = currentCase.Location__Latitude__s;
            Decimal longitude = currentCase.Location__Longitude__s; 
            relatedCases  = [Select id, CaseNumber, Subject, Status, Service_Request_Type__c, Location__Latitude__s, Location__Longitude__s, City__c, Street__c, State__c, Country__c, Zipcode__c from Case WHERE 
                        DISTANCE(Location__c, GEOLOCATION(:latitude, :longitude), 'km') < 5.0 AND ID != : currentCase.Id LIMIT 10];
        } 
    }
    
    public void LocateAddress()    {
        String addressString = currentCase.Street__c + ',' + currentCase.City__c + ',' + currentCase.State__c + ',' + currentCase.Country__c; 
        LocateAddress.GResponse gr = LocateAddress.validateAddress(addressString ,'gis');
        LocateAddress.GResponse gr1 = LocateAddress.validateAddress(addressString ,'arc');
        System.debug(' GMAP: ' + gr.results[0].formatted_address + ', ' + gr.results[0].geometry.location.lat + ', ' + gr.results[0].geometry.location.lng); 
        System.debug(' ARC: ' + gr1.locations[0].name + ', ' + gr1.locations[0].feature.geometry.x + ', ' + gr1.locations[0].feature.geometry.y );
        System.debug('Call Done');
    }
    
    @RemoteAction 
    public static string RelateCaseAndClose(string parentCaseId, string childCaseId) {
        list<string> idList = new list<string>(new string[] { parentCaseId, childCaseId });
        
        map<id, Case> caseMap = new map<id, Case>([select id, caseNumber, parentId, status, reason from Case where id in :idList ]);
        if (caseMap.size() != 2)
            return 'Both old and new cases were not found.';
        
        Case child = caseMap.get(childCaseId);
        Case parent = caseMap.get(parentCaseId);
        
        child.parentId = parentCaseId;
        try {
            update child;           
        }
        catch (system.dmlexception ex)
        {
            return ex.getMessage();
        }
        
        return 'Made ' + parent.caseNumber + ' parent for ' + child.caseNumber + 'and updated the status of '+ parent.caseNumber + ' to ' + child.caseNumber + '.';
    }
}