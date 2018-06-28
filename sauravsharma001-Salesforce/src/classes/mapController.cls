public with sharing class mapController {

public String searchText {get;set;}
public List<Case> cases{get; private set;}

public static final String GEOCODING_URI_BASE = 'https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=';

// For purposes of this demo I'll geocode only couple of addresses server-side. Real code can use the commented out value.
public static final Integer MAX_CALLOUTS_FROM_APEX = 3; // Limits.getLimitCallouts()

public mapController(){
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
    if(searchText != null && searchText.length() > 1){
        List<List<SObject>> results = [FIND :('*' + searchText + '*') IN ALL FIELDS RETURNING 
            Case (Id,  Address_X__c, Address_Y__c)
            ];
        cases = (List<Case>)results[0];
        if(cases.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No matches for "' + searchText + '"'));
        } else {
            serverSideGeocode();
        }
    } else {
        if(cases != null) {
            cases.clear();
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please provide at least 2 characters for the search.'));
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
            String address = '';
            if(address != ''){
                req.setEndpoint(GEOCODING_URI_BASE + EncodingUtil.urlEncode(address, 'UTF-8'));
                try{
                    HttpResponse res = h.send(req);
                    GResponse gr = (GResponse) JSON.deserialize(res.getBody(), mapController.GResponse.class);
                    if(gr.status == 'OK'){
                        LatLng ll = gr.results[0].geometry.location;
                        c.Address_X__c = ll.lat;
                        c.Address_Y__c = ll.lng;
                        casesToUpdate.add(c);
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Geocoding of "' + address + '" failed:' + gr.status));
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
// Helper class - template into which results of lookup will be parsed. Some fields are skipped!
// Visit https://developers.google.com/maps/documentation/geocoding/#Results if you need to create full mapping.
public class GResponse{
    public String status;
    public GComponents[] results;
}
public class GComponents{
   public String formatted_address;
   public GGeometry geometry;
}
public class GGeometry {
    public LatLng location;
}
public class LatLng{
    public Double lat, lng;
}
}