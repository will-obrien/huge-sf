/*
Update the comment for git demo.
Only so much can be tested with unit tests.
In an anonymous apex 
ArcGISaArcGIS= new GIS();
aGis.address('990 spring garden');
or 
ArcGISaArcGIS= new GIS();
aGis.address('1220-1240 market', new GIS.XyPair(-75.1609005520884,39.9520313272683));
*/

public with sharing class ArcGIS{
    public class Address {
        public Link[] links;
        public string matchType;
        public string rawAddress;
        public string standardizedAddress;
        public double similarity;
        public string streetNumber;
        public string streetCode;
        public string streetFullName;
        public string streetPrefix;
        public string streetName;
        public string streetyType;
        public double streetCode2;
        public double segmentId;
        public double segementId2;
        public double xCoord;
        public double yCoord;
        public string addressKey; // populated by the /topic callout inside address()
        public string liAddress; // populated by the /topic callout inside address()
        public string taxAddress; // ex. 1607-09 WALNUT ST instead of 1607 WALNUT ST
    }
    
    // AddressResponse aResponse = (GIS.AddressResponse) Json.Deserialze(aString, GIS.AddressResponse.class);
    public class AddressResponse {
        public list<Address> addresses;
    }
    
    public class Key {
        public string topicName;
        public string topicId;
        public Link[] links;
    }
    
    public class Link {
        public string rel;
        public string href;
        public string method;
    }
    
    public class ProjectResponse {
        public list<XyPair> geometries;
    }
    
    public class ServiceArea {
        public string value;
        public string serviceAreaId;
        public string displayName;
    }
    
    public class ServiceAreaResponse {
        public list<ServiceArea> serviceAreaValues;
    }
    
    public class Topic {
        public string topicName;
        public string agencyId;
        public string agencyName;
        public string addressRef;
        public Key[] keys;
    }
    
    public class TopicResponse {
        public string standardizedAddress;
        public Topic[] topics;
    }
    
    public class XyPair {
        public XyPair(decimal anX, decimal aY) {
            this(Double.ValueOf(anX), Double.ValueOf(aY));
        }
        
        public XyPair(double anX, double aY) {
            x = anX;
            y = aY;
        }
        public double x;
        public double y;
    }
    
    static ArcGIS__c aArcGIS = ArcGIS__C.GetOrgDefaults();
    
    public string address(string anAddress) { return address(anAddress, null, '4326'); }
    
    public string address(string anAddress, XyPair aPair) {
        return address(anAddress, aPair, '4326');       
    }

    public string address(string anAddressString, XyPair aPair, string aSpacialReferenceId)
    {
        
        anAddressString = uptoPattern(anAddressString, '(?i)[\\s,]+philadelphia[\\s,]+(pa|pennsylvania)[\\s,]+\\d+');
        
        HttpResponse res = ulrsAddress(anAddressString, aSpacialReferenceId);
        
        if (res.getStatusCode() != 200)
            System.debug('HTTP response status Code returned for fetching address location: ' + res.getStatusCode());
        
        AddressResponse anAddressResponse = (AddressResponse) Json.deserialize(
            String.ValueOf(res.getBody()), 
            AddressResponse.class
        );
        
        system.debug(anAddressResponse);
        
        system.debug('should try reverse geocoding');
        if (anAddressResponse.addresses.size() > 1 && aPair != null) {
            res = ulrsLocations(aPair);
            anAddressResponse = (AddressResponse) Json.deserialize(
                String.ValueOf(res.getBody()), 
                AddressResponse.class
            );
        }
            
        Address anAddress = anAddressResponse.addresses[0];
        
        ulrsTopics(anAddress);
        
        return Json.serialize(anAddressResponse);
    }
    
    public string addressCandidates(string anAddress) { return addressCandidates(anAddress, '4326'); }
    
    public string addressCandidates(string anAddressString, string aSpacialReferenceId)
    {
       anAddressString = uptoPattern(anAddressString, '(?i)[\\s,]+philadelphia[\\s,]+(pa|pennsylvania)[\\s,]+\\d+');
        
        HttpResponse res = ulrsAddress(anAddressString, aSpacialReferenceId);
        
        if (res.getStatusCode() != 200)
            System.debug('HTTP response status Code returned for fetching address candidates: ' + res.getStatusCode());
        
        return res.getBody();
    }
    
    public static string GetGISRestEndpoint() { return aArcGIS.GISRestEndpoint__c; }
    public static string GetGeometryServer() { return aArcGIS.GeometryServer__c; }
    
/*
try:
    
list<list<string>> xyList = new list<list<string>>();
xyList.add(new string[] { '-75.154187', '39.961132' });
xyList.add(new string[] { '-75.1600172183275', '39.9532193814569 ' });
ArcGISaArcGIS= new GIS();
system.debug(aGis.project(xyList, '4326', '2272'));
*/
    public ProjectResponse project(double x, double y, string fromSrid, string toSrid) {
        list<list<string>> aListList = new list<list<string>>();
        aListList.add(new string[] { String.ValueOf(x), String.ValueOf(y)});
        return project(aListList, fromSrid, toSrid);
    }
    
    public ProjectResponse project(list<list<string>> xyList, string fromSrid, string toSrid)
    {       
        list<string>xyPairs = new list<string>();
        for (list<string> each : xyList)
            xyPairs.add(String.Join(each, ','));
        
        string xyListString = String.Join(xyPairs, ','); 
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        String returnFields = EncodingUtil.UrlEncode('city,state,zip,predir,streetName', 'utf-8');      
        
        request.setMethod('GET');
        request.setTimeout(60000);      
        
        request.setEndpoint(
            ArcGIS.GetGeometryServer()+ '/project?inSR=' + fromSrid + '&outSR=' + toSrid + '&geometries=' + 
            EncodingUtil.UrlEncode(xyListString, 'utf-8') + '&f=json');
        
        Httpresponse response = http.send(request);
        if (response.getStatusCode() != 200)
            System.debug('HTTP response status Code returned for fetching project Details: ' + response.getStatusCode());
        
        string jsonString = response.getBody();
        system.debug(jsonString);  
        
        return (ProjectResponse) Json.deserialize(jsonString, ProjectResponse.class);
    }
    
    // serviceAreas() should be called with an already-normalized address, 
    // which should come from a call to address() above.  This will work
    // for some non-normalized addresses, but just to be safe... call address() first.
    
    /*
    below is an example of what's returned by service-areas
    
    PWD_MAINT_DIST: "3E"
    PWD_PRES_DIST: "EPG"
    PWD_WTPSA: "EAST PARK"
    SA_PHILLYRISING: null
    SA_PLANNING_2000CensusBlock: "3004"
    SA_PLANNING_2000CensusBlockGroup: "3"
    SA_PLANNING_2000CensusTract: "012700"
    SA_PLANNING_2000Councilmanic: "1"
    SA_PLANNING_2016Councilmanic: "1"
    SA_PLANNING_Planning_Districts: "Central"
    SA_PLANNING_Ward: "5"
    SA_PLANNING_Ward_Divisions: "0525"
    SA_POLICE_District: "6"
    SA_POLICE_Division: "CPD"
    SA_POLICE_FireDistricts: "20"
    SA_POLICE_PSA: "061"
    SA_POLICE_Sector: "6N"
    SA_PWD_CenterCityDistrict: "In"
    SA_RECREATION_Recreation_District: "5"
    SA_SCHOOLS_Elementary_School_Catchment: "Kearny"
    SA_SCHOOLS_High_School_Catchment: "Franklin HS"
    SA_SCHOOLS_Middle_School_Catchment: "Kearny"
    SA_STREETS_HISTORIC: null
    SA_STREETS_Highway_District: "3"
    SA_STREETS_Highway_Section: "3 J"
    SA_STREETS_Highway_Subsection: "3J12"
    SA_STREETS_Recycling: "MON"
    SA_STREETS_Recycling_Diversion_Rate: "2"
    SA_STREETS_Rubbish: "MON"
    SA_STREETS_Rubbish_Recyc: "MON"
    SA_STREETS_Sanitation_Area: "3"
    SA_STREETS_Sanitation_Districts: "3F"
    SA_STREETS_Snow_Categories: null
    SA_STREETS_Street_Lights_Routes: "20"
    SA_STREETS_ZipCode: "19123"
    SA_Streets_Traffic_District: "1"
    SA_Streets_Traffic_PM_District: "1208"
    SA_WATER_Water_Plate_Index: "33C"
    */
    public map<string, string> serviceAreas(string aStandardizedAddress)
    {
        HttpResponse res = ulrsServiceAreas(aStandardizedAddress);
        system.debug(res.getBody());
                
        ServiceAreaResponse aServiceAreaResponse = (ArcGIS.ServiceAreaResponse) Json.Deserialize(res.getBody(), ArcGIS.ServiceAreaResponse.class);
        
        map<string, string> areaMap = new map<string, string>();
        for (ServiceArea eachArea : aServiceAreaResponse.serviceAreaValues)
            areaMap.put(eachArea.serviceAreaId, eachArea.value);
        
        system.debug(areaMap);

        return areaMap;
    }
    
    HTTPResponse ulrsAddress(string aStandardizedAddress, string aSpacialReferenceId)
    {
        HttpResponse res;
        
        for (string eachType : new string[] { 'SnapNearCenterline', 'CenterlineOnly' }) {           
           
           //Code changes - Start

            string endpoint = 
               ArcGIS.GetGISRestEndpoint() + '/addresses/' + aStandardizedAddress.replace(' ', '%20').replace('.', '') + 
               '?srid=' + aSpacialReferenceId + '&geocodetype=' + eachType + '&format=json'; 
               
            //Code changes - End
           
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(endpoint);
            req.setTimeout(30000);
            
            Http http = new Http();
            res = http.send(req);
            
            if (res != null)
                system.debug(res.getBody());
            else
                system.debug('res is null!');
            
            if (res.getStatusCode() == 200)
                break;
        }
        
        return res;
    }
    
    // assumes input srid is 4326
    HTTPResponse ulrsLocations(XyPair anXy)
    {
        ProjectResponse aProjection = project(anXy.x, anXy.y, '4326', '2272');
        if (aProjection.geometries.isEmpty())
            return null;
            
        HttpResponse res;
        
        string endpoint = ArcGIS.GetGISRestEndpoint() + '/locations/' + (integer) aProjection.geometries[0].x+ ',' + 
            (integer) aProjection.geometries[0].y + '/addresses?srid=2272&format=json';

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setTimeout(30000);
        
        Http http = new Http();
        res = http.send(req);
        
        system.debug(res.getBody());
        
        return res;
    }
    
    public HttpResponse ulrsServiceAreas(string aStandardizedAddress)
    {
        HttpResponse res;
        
        string endpoint = ArcGIS.GetGISRestEndpoint() + '/addresses/' + aStandardizedAddress.replace(' ', '%20') 
            + '/service-areas?format=json';

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setTimeout(30000);
        
        Http http = new Http();
        res = http.send(req);
        
        if (res.getStatusCode() != 200)
             System.debug('HTTP response status Code returned for fetching ulrsServiceAreas Details: ' + res.getStatusCode());
        
        system.debug(res.getBody());
        
        return res;
    }
    
    void ulrsTopics(Address anAddress)
    {
        if (anAddress == null || anAddress.links == null)
            return;
            
        for (Link each : anAddress.links) {
            if (each.rel.equalsIgnoreCase('topics')) {
                HttpRequest req = new HttpRequest();
                req.setMethod(each.method);
                req.setEndpoint(each.href.replace('#', '%23') + '?format=json');
                req.setTimeout(30000);
                
                Http http = new Http();
                HttpResponse res = http.send(req);

                if (res.getStatusCode() >= 300)
                    break; // no topic for address?
                
                TopicResponse aTopicResponse = (TopicResponse) Json.deserialize(res.getBody(), TopicResponse.class);
                system.debug(aTopicResponse);
                
                for (Topic eachTopic : aTopicResponse.topics) {
                    if (eachTopic == null)
                        continue;
                    
                    if (String.IsBlank(eachTopic.topicName))
                        continue;
                        
                    if (eachTopic.topicName.equalsIgnoreCase('AddressKeys')) {
                        string anAddressKey = eachTopic.keys[0].topicId;
                        system.debug('addressKey = ' + anAddressKey);
                        anAddress.addressKey = anAddressKey;
                    
                        if (String.IsNotBlank(eachTopic.addressRef))
                            anAddress.liAddress = eachTopic.addressRef.trim();
                    }
                    
                    if (eachTopic.topicName.equalsIgnoreCase('TaxAccounts')) {
                        if (String.IsNotBlank(eachTopic.addressRef))
                            anAddress.taxAddress = eachTopic.addressRef.trim();
                    }
                }
                
                if (res.getStatusCode() == 200)
                    break;
            }
        }
    }
    
    public string uptoPattern(string anAddress, string aPattern) {
        if (String.IsBlank(anAddress))
            return '';
        
        Pattern p = Pattern.Compile(aPattern);
        matcher m = p.matcher(anAddress);
        
        while (m.find())
            return(anAddress.left(m.start()));
        
        return anAddress;
    }
}