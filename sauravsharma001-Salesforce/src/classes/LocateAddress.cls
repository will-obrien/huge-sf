public class LocateAddress {

    public static final String GEOCODING_URI_BASE_GMAP = 'https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=';
    public static final String GEOCODING_URI_BASE_ARCGIS = 'http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?f=pjson&text=';
    
    public static List<Case> cases{get; private set;}
    public static List<Contact> contacts{get; private set;}
    
    static boolean HasFutureFired = false;
    static boolean HasAfterUpdateFired = false;
    
    public static void LocateAddressNow(List<ID> recordList, String mapServer, String Obj)    {
        
        String addressString = null;
        List<SObject> recordToUpdate = new List<SObject>();
        if (HasFutureFired)
            return;    
        HasFutureFired = true;
        List<AddComponent> addCom = new List<AddComponent>();
        try{
            if(Obj.equals('Cases'))    {
                if(recordList != null && recordList.size() > 0 )    {
                    cases = [Select id, CaseNumber, Subject, Service_request_Type__c, Location__Latitude__s, Location__Longitude__s,
                             Street__c, City__c, State__c, Country__c, ZipCode__c from Case WHERE ID IN: recordList];
                    for(Case currentcase : cases)    {
                        addressString = currentCase.Street__c + ',' + currentCase.City__c + ',' + currentCase.State__c + ',' + currentCase.Country__c; 
                        LocateAddress.GResponse gRes = LocateAddress.validateAddress(addressString , mapServer);
                        if(mapServer.toLowerCase().equals('arc'))    {
                            currentCase.Location__Longitude__s = gRes.locations[0].feature.geometry.x;
                            currentCase.Location__Latitude__s = gRes.locations[0].feature.geometry.y;
                            recordToUpdate.add(currentcase);
                        }
                        else {
                            currentCase.Location__Longitude__s = gRes.results[0].geometry.location.lng;
                            currentCase.Location__Latitude__s = gRes.results[0].geometry.location.lat;
                            addCom = gRes.results[0].address_components;
                            for(AddComponent a : addCom)    {
                                if(a.types[0] == 'postal_code')                                
                                    currentCase.ZipCode__c = Decimal.valueOf(a.short_name);
                                else if(a.types[0] == 'country')    
                                    currentCase.Country__c = a.short_name;
                                else if(a.types[0] == 'administrative_area_level_1')    
                                    currentCase.State__c = a.long_name;
                                else if(a.types[0] == 'locality')     
                                    currentCase.City__c = a.short_name;
                            }    
                            recordToUpdate.add(currentcase);
                        }                        
                        System.Debug('Case To Update: ' + currentcase);
                    }
                }             
            }
            else if(Obj.equals('Contacts'))    {
                if(recordList != null && recordList.size() > 0 )    {
                    contacts = [Select id, Name, MailingStreet, MailingCity, MailingState, MailingCountry, 
                                MailingLocation__Latitude__s, MailingLocation__Longitude__s from Contact WHERE ID IN: recordList];
                    for(Contact currentcontact : contacts)    {
                        addressString = currentContact.MailingStreet + ',' + currentContact.MailingCity + ',' + currentContact.MailingState + ',' + currentContact.MailingCountry; 
                        LocateAddress.GResponse gRes = LocateAddress.validateAddress(addressString , mapServer);
                        if(mapServer.toLowerCase().equals('arc'))    {
                            currentcontact.MailingLocation__Longitude__s = gRes.locations[0].feature.geometry.x;
                            currentcontact.MailingLocation__Latitude__s = gRes.locations[0].feature.geometry.y;
                            recordToUpdate.add(currentcontact);
                        }
                        else {
                            currentcontact.MailingLocation__Longitude__s = gRes.results[0].geometry.location.lng;
                            currentcontact.MailingLocation__Latitude__s = gRes.results[0].geometry.location.lat;
                            recordToUpdate.add(currentcontact);
                        }                        
                    }             
                }                
            }
            if(recordToUpdate != null && recordToUpdate.size() > 0)
                Database.update(recordToUpdate);
        }
       catch(Exception ex)    {
           System.Debug('Exception was thrown: ' + ex.getMessage());
       }    
    }
    
    @future (callout=true)
    public static void LocateAddressFuture(List<ID> recordList, String mapServer, String Obj) {
        LocateAddressNow(recordList, mapServer, Obj);
    }
    
    public static GResponse validateAddress(String addressString, String mapServer)    {
    
        Http h = new Http();  
        HttpRequest req = new HttpRequest();
        req.setMethod('GET'); 
        req.setTimeout(10000);
        if(mapServer.toLowerCase().equals('arc'))    {
            req.setEndpoint(GEOCODING_URI_BASE_ARCGIS + EncodingUtil.urlEncode(addressString, 'UTF-8'));
        }    
        else    {
            req.setEndpoint(GEOCODING_URI_BASE_GMAP + EncodingUtil.urlEncode(addressString, 'UTF-8'));
        }
        HttpResponse res = h.send(req);
        System.Debug('--------------Address Locator Response--------------');
        System.Debug(res.getBody());
        if(res.getStatusCode() == 200)  {
            GResponse gr = (GResponse) JSON.deserialize(res.getBody(), LocateAddress.GResponse.class);        
            return gr;                
        }
        else {
            System.debug('Server responded with Status Code: ' + res.getStatusCode());
            return null;
        } 
    }

    // Visit https://developers.google.com/maps/documentation/geocoding/#Results if you need to create full mapping.
    public class GResponse{
        public String status;
        public GComponents[] results;
        public ArcSpatResponse[] spatialRefrence;
        public ArcLocation[] locations;
    }
    
    public class GComponents{
       public AddComponent[] address_components;
       public String formatted_address;
       public GGeometry geometry;
       public String place_id;
    }    

    public class AddComponent    {
       public String long_name;
       public String short_name; 
       public String[] types;
    }
       
    public class GGeometry {
        public LatLng location;
        public String location_type;
    }
    
    public class LatLng{
        public Double lat, lng;
    }
    
    // Helper class - template into which results of lookup will be parsed. Some fields are skipped! --- For GMap
    
    public class ArcSpatResponse {
        public String wkid;
        public String latestWkid;
    }
    
    public class ArcLocation{
        public String name;
        public ArcFeature feature;
    }
    
    public class ArcFeature{
        public ArcGeometry geometry;
    }
    
    public class ArcGeometry{
        public Double x;
        public Double y; 
    }
}