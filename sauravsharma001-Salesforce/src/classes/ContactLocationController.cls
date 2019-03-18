public class ContactLocationController {

    // Global Variables Declaration
    public String searchContactLocation {get; set;}
    public String latitude {get; set;}
    public String longitude {get; set;}
    public String arcLatitude {get; set;}
    public String arcLongitude {get; set;}
    public List<Contact> contacts {get; private set;}
    public List<GmapResponse> gmapRes {get; set;}
    public Integer gmapReslength {get; set;}
    
    public class GmapResponse {
        
        public Boolean selected {get; set;}
        public String formattedAddress {get; set;}
        public Decimal latitude {get; set;}
        public Decimal longitude {get; set;}
        
        GmapResponse(String formattedAddress, Decimal latitude, Decimal longitude)    {
            this.formattedAddress = formattedAddress;
            this.latitude = latitude;
            this.longitude = longitude;
        }
    }
    
    public static final String GEOCODING_URI_BASE = 'https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyB4OXvx8iE-R0fC2gMdUfLCzERvV4wbImk&sensor=false&address=';
    public static final String ARCGISGEOCODING_URI_BASE = 'http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?f=pjson&outSR=102100&text=';
    
    public ContactLocationController(ApexPages.StandardController controller)    {
        ID contactID = ApexPages.currentPage().getParameters().get('id');
        List<Contact> con = new List<Contact>();
        gmapReslength = 0;
        contacts = new List<Contact>();
        if(contactID != null)    {
            con = [Select id, Name, MailingStreet, MailingState, MailingCountry, MailingAddress, MailingLocation__Latitude__s, MailingLocation__Longitude__s,
                    ArcGIS_Location_Latitude__c, ArcGIS_Location_Longitude__c from Contact where id =: contactID LIMIT 1];
            
            if(con != null && con.size() == 1)    {
            
                searchContactLocation = con[0].MailingStreet;
                if(con[0].MailingState != null)
                    searchContactLocation = searchContactLocation + ', ' + con[0].MailingState;
                if(con[0].MailingCountry!= null)
                    searchContactLocation = searchContactLocation + ', ' + con[0].MailingCountry;
                latitude = String.valueOf(con[0].MailingLocation__Latitude__s);
                longitude = String.valueOf(con[0].MailingLocation__Longitude__s);
                contacts.add(con[0]);
            }    
        }
    }
    
    public String getContactsJson(){
        return JSON.serialize(contacts);
    }
    
    public void gMapGeocode(){
        List<Contact> contactsToUpdate = new List<Contact>();
        Http h = new Http();  
        HttpRequest req = new HttpRequest();
        req.setMethod('GET'); 
        req.setTimeout(10000);
        gmapRes = new List<GmapResponse>();
        
        for(Contact c : contacts){
            if((c.MailingLocation__Latitude__s == null || c.MailingLocation__Longitude__s == null)){
                String address = c.MailingStreet;
                if(address != ''){
                
                    if(c.MailingState != null)
                        address = address + ', ' + c.MailingState;
                    if(c.MailingCountry != null)
                        address = address + ', ' + c.MailingCountry;    
                        
                    req.setEndpoint(GEOCODING_URI_BASE + EncodingUtil.urlEncode(address, 'UTF-8'));
                    try{
                        HttpResponse res = h.send(req);
                        System.Debug('--------------GIS Response--------------');
                        System.Debug(res.getBody());
                        GResponse gr = (GResponse) JSON.deserialize(res.getBody(), ContactLocationController.GResponse.class);
                        if(gr.status == 'OK'){                       
                            
                            if(gr.results.size() == 1)    { 
                                LatLng ll = gr.results[0].geometry.location;                               
                                c.MailingLocation__Latitude__s = ll.lat;
                                c.MailingLocation__Longitude__s = ll.lng;
                                contactsToUpdate.add(c);
                            }
                            else    {
                                for(GComponents gComp : gr.results)    {
                                    LatLng ll = gComp.geometry.location;
                                    gmapRes.add(new GmapResponse(gComp.formatted_address, ll.lat, ll.lng));
                                }    
                                gmapReslength = gmapRes.size();
                            }    
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Geocoding of "' + address + '" failed:' + gr.status));
                        }
                    }catch(Exception e){
                        ApexPages.addMessages(e);
                    }
                }
            }
        }
        if(!contactsToUpdate.isEmpty()) {
            Database.update(contactsToUpdate, false);
            latitude = String.valueOf(contactsToUpdate[0].MailingLocation__Latitude__s);
            longitude = String.valueOf(contactsToUpdate[0].MailingLocation__Longitude__s);
        }
    }
    
    public void updateGeocode(){
        try{
            for(GmapResponse gm : gmapRes)    {
                if(gm.selected && contacts != null && contacts.size() > 0)    {
                    contacts[0].MailingLocation__Latitude__s = gm.latitude;
                    contacts[0].MailingLocation__Longitude__s = gm.longitude;
                    Database.update(contacts[0]);
                    gmapRes = null;
                    gmapReslength = 0;
                    latitude = String.valueOf(contacts[0].MailingLocation__Latitude__s);
                    longitude = String.valueOf(contacts[0].MailingLocation__Longitude__s);
                }
            }  
        }
        catch(Exception ex)    {
            System.Debug('Error Occurred while Updating Contact' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Occurred while upadting Contact: '+ ex.getMessage()));
        }          
    }
    
    
    public void arcGISGeocode()    {
        List<Contact> contactsToUpdate = new List<Contact>();
        Http h = new Http();  
        HttpRequest req = new HttpRequest();
        req.setMethod('GET'); 
        req.setTimeout(10000);
        gmapRes = new List<GmapResponse>();
        for(Contact c : contacts){
            if((c.ArcGIS_Location_Latitude__c == null || c.ArcGIS_Location_Longitude__c == null)){
                String address = c.MailingStreet;
                if(address != ''){
                
                    if(c.MailingState != null)
                        address = address + ', ' + c.MailingState;
                    if(c.MailingCountry != null)
                        address = address + ', ' + c.MailingCountry;    
                        
                    req.setEndpoint(ARCGISGEOCODING_URI_BASE + EncodingUtil.urlEncode(address, 'UTF-8'));
                    try{
                        HttpResponse res = h.send(req);
                        System.Debug('--------------ArcGIS Response--------------');
                        System.Debug(res.getBody());
                        ArcResponse ar = (ArcResponse) JSON.deserialize(res.getBody(), ContactLocationController.ArcResponse.class);
                        if(res.getStatusCode() == 200){                       
                            
                            if(ar.locations.size() == 1)    { 
                                ArcGeometry ll = ar.locations[0].feature.geometry; 
                                System.debug('Address Location: ' + ll.x + ', ' + ll.y); 
                                System.Debug('--------------ArcGIS Response--------------');
                                System.Debug(res.getBody());                           
                                c.ArcGIS_Location_Latitude__c = ll.x;
                                c.ArcGIS_Location_Longitude__c = ll.y;
                                contactsToUpdate.add(c);
                                System.Debug(contactsToUpdate);
                            }
                            else    {
                                for(ArcLocation gComp : ar.locations)    {
                                    ArcGeometry ll = gComp.feature.geometry;
                                    gmapRes.add(new GmapResponse(gComp.name, ll.x, ll.y));
                                }    
                                gmapReslength = gmapRes.size();
                            }    
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Geocoding of "' + address + '" failed:' + res.getStatusCode()));
                        }
                    }catch(Exception e){
                        ApexPages.addMessages(e);
                    }
                }
            }
        }
        if(!contactsToUpdate.isEmpty()) {
            Database.update(contactsToUpdate, false);
            arcLatitude = String.valueOf(contactsToUpdate[0].ArcGIS_Location_Latitude__c);
            arcLongitude = String.valueOf(contactsToUpdate[0].ArcGIS_Location_Longitude__c);
        }
    }
    
    // Helper class - template into which results of lookup will be parsed. Some fields are skipped! --- For GMap
    // Visit https://developers.google.com/maps/documentation/geocoding/#Results if you need to create full mapping.
    public class GResponse{
        public String status;
        public GComponents[] results;
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
    public class ArcResponse{
        public ArcSpatResponse[] spatialRefrence;
        public ArcLocation[] locations;
    }
    
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