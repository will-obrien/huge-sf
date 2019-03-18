global class CaseGeocodeController extends XedeController {
 
    @RemoteAction global static ESRILocator.Address AddressGeocode(string anId, string spatialReference)
    {
        try {
            Case c = [ select id, street__c, address_x__c, address_y__c from case where id = :anId ];
            
                           
            if (String.IsBlank(c.street__c))
                return null;
            
            if ((c.address_x__c == null || c.address_y__c == null))
                return null;
                    
            ESRILocator locator = ESRILocator.NewInstance();
            ESRILocator.FindAddressResponse response = locator.findAddressCandidates('3857', c.street__c);
            if (response.isEmpty())
                return null;
                
            ESRILocator.Address address = response.candidates[0];
            return address;
        } catch (system.Dmlexception e) {
            system.debug(e.getMessage());
        }
        
        return null;
    }

    public CaseGeocodeController(ApexPages.StandardController controller) {
        esriConfig = ESRI_Config__c.GetInstance('Default');
        
        this.controller = controller;
        this.aCase = (Case) controller.getRecord();        
    }
    
    // fired when the search button is clicked
    public PageReference geocode() {
        ESRILocator aLocator = ESRILocator.NewInstance();
        ESRILocator.FindAddressResponse response = aLocator.findAddressCandidates(aCase.Street__c);
        
        if (response.candidates.isEmpty())
            return null;
        
        ESRILocator.Address anAddress = response.candidates[0];
        
        aCase.Address_X__c = anAddress.location.x;
        aCase.Address_Y__c = anAddress.location.y;
        return null;
    }
    
    @RemoteAction global static list<Case> GetRecentCases(integer rowLimit, string anId)    
    {
        system.debug(String.Format('GetRecentCases({0}, {1})', new string[] { '' + rowLimit, anId }));
        
        list<Case> aList = new list<Case>();
        
        Case aCase = [ select id, recordTypeId, CreatedDate from case where id = :anId];     
        
        try {
            aList = [
                select  id,
                        caseNumber,
                        street__c,
                        subject,
                        status,
                        createdDate,
                        createdBy.name,
                        description,
                        address_x__c,
                        address_y__c,
                        Priority,
                        ParentId
                  from  Case
                  where  id != :anId
                  and  recordTypeId = :aCase.recordTypeId
                  and status != 'Closed'
                  order by CreatedDate desc
            ];              
        } catch (system.Dmlexception e) {
            system.debug(e.getMessage());
        }
                
        system.debug(aList);
        return aList;
    }

    @RemoteAction global static string RelateCaseAndClose(string parentCaseId, string childCaseId) {
        list<string> idList = new list<string>(new string[] { parentCaseId, childCaseId });
        
        map<id, Case> caseMap = new map<id, Case>([select id, caseNumber, parentId, status, reason from Case where id in :idList ]);
        if (caseMap.size() != 2)
            return 'Both old and new cases were not found.';
        
        Case child = caseMap.get(childCaseId);
        Case parent = caseMap.get(parentCaseId);
        
        child.status = parent.status;
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
    
    ApexPages.StandardController controller {get; set;}
    public Case aCase { get; private set; }
    public ESRI_Config__c esriConfig { get; private set; }
}