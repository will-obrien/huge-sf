global class SampleController extends XedeController {
 
    @RemoteAction global static ESRILocator.Address AddressGeocode(string street)
    {       double  lat;        
            if (String.IsBlank(street))
                return null;
            
            ESRILocator locator = ESRILocator.NewInstance();
            ESRILocator.FindAddressResponse response = locator.findAddressCandidates('3857', street);
            if (response.isEmpty())
                return null;
                
            ESRILocator.Address address = response.candidates[0];
            lat = address.location.y;
            return address;
    }

    public SampleController(ApexPages.StandardController controller) {
        esriConfig = ESRI_Config__c.GetInstance('Default');        
        this.controller = controller;       
        this.lat = 0.0;
    }
   
    ApexPages.StandardController controller {get; set;}
    public ESRI_Config__c esriConfig { get; private set; }
    public double lat { get; private set; }
}