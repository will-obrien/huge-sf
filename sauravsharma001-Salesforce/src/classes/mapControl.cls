public with sharing class mapControl {

    public mapControl(ApexPages.StandardController controller) {

    }


public String searchText {get;set;}
public String id1 {get;set;}public String add {get;set;}
public List<Case> cases{get; private set;}

public static final String GEOCODING_URI_BASE = 'https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=';
public static final String GEOCODING_URI_BASE2 = 'http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?f=pjson&text=';
// For purposes of this demo I'll geocode only couple of addresses server-side. Real code can use the commented out value.
public static final Integer MAX_CALLOUTS_FROM_APEX = 3; // Limits.getLimitCallouts()

public mapControl(){
    searchText = ApexPages.currentPage().getParameters().get('q');
}

public void clearGeocodedData(){
    for(Case c : cases){
        c.Address_X__c = c.Address_Y__c = null;
    }
    Database.update(cases, false);
    cases.clear();
}

public String getCasesJson(){
    return JSON.serialize(cases);
}
public String getDebugCasesJson(){
    return JSON.serializePretty(cases);
}

public void find() {

    id1 = ApexPages.currentPage().getParameters().get('id');
    Case c1 = [Select street__c from Case where id =: id1];
    if(c1.street__c != null){
        List<List<SObject>> locations = [FIND :('*' + c1.street__c + '*') IN ALL FIELDS RETURNING 
            Case (Id, Address_X__c, Address_Y__c, Street__c, City__c, State__c, Country__c)
            ];
        cases = (List<Case>)locations[0];
        if(cases.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No matches for "' + c1.street__c + '"'));
        } else {
            serverSideGeocode();
        }
    } else {
        if(cases != null) {
            cases.clear();
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please provide at least 2 characters for the search.'+ add));
    }
}



private void serverSideGeocode(){
    List<Case> casesToUpdate = new List<Case>();
    Http h = new Http();  
    HttpRequest req = new HttpRequest();
    req.setMethod('GET'); 
    req.setTimeout(10000);

    for(Case c : cases){
        if((c.Address_X__c == null || c.Address_Y__c == null)){
            String address = c.street__c+',' + c.City__c + ', ' + c.State__c+', ' + c.Country__c;
            if(address != ''){
                req.setEndpoint(GEOCODING_URI_BASE2 + EncodingUtil.urlEncode(address , 'UTF-8'));
                try{
                    HttpResponse res = h.send(req);
                    System.debug('Response: ' + res.getBody());
                    GResponse gr = (GResponse) JSON.deserialize(res.getBody(), mapControl.GResponse.class);
                    
                    if(res.getStatusCode() == 200){
                        GGeometry ll = gr.locations[0].feature.geometry;
                        c.Address_X__c = ll.x;
                        c.Location__Latitude__s = ll.x;
                        c.Address_Y__c = ll.y;
                        c.Location__Longitude__s = ll.y;
                        casesToUpdate.add(c);
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Geocoding of "' + address + '" failed:' + res.getStatusCode()));
                    }
                }catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            // Bail out if we've reached limit of callouts (not all contacts might have been processed).
            if(Limits.getCallouts() == MAX_CALLOUTS_FROM_APEX) {
                break;
            }
        }
    }
    if(!casesToUpdate.isEmpty()) {
        Database.update(casesToUpdate, false); // some data in Developer editions is invalid (on purpose I think).
        // If update fails because "j.davis@expressl&amp;t.net" is not a valid Email, I want the rest to succeed
    }
}
// Helper class - template into which locations of lookup will be parsed. Some fields are skipped!
// Visit https://developers.google.com/maps/documentation/geocoding/#locations if you need to create full mapping.
public class GResponse{
    public GComponents[] locations;
}
public class GComponents{
   public GGeometry1 feature;
}
public class GGeometry1 {
    public GGeometry geometry;
}
public class GGeometry {
    public Double x, y;
}
}