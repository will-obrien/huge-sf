global virtual class ESRILocator {
    global class Location {
        public double x;
        public double y;    
        
        Location(decimal anX, decimal aY) { x = anX; y = aY; }  
    }
    
    global class Address {
        public string address;
        public Location location;
        public double score;
        
        Address(string street, decimal x, decimal y)
        {
            location = new Location(x, y);
            address = street;
            score = 0.0;
        }
    }
    
    
    global class FindAddressResponse {
        public map<string, string> spatialReference;
        public list<Address> candidates;
        public boolean isEmpty() { return candidates == null ? true : candidates.isEmpty(); }
        public integer size() { return candidates == null ? 0 : candidates.size(); }
    }
    
    /* Only caller of this method is commented out
    public static Address AddressFor(string street, decimal x, decimal y)
    {
        Address response = new Address(street, x, y);
        system.debug('response = ' + response);
        return response;
    }
    */
    
    protected ESRILocator(string baseURI)
    {
        system.debug(baseURI);
        if (baseURI.indexOf('/') >= 0)
            serverURI = baseURI;
        else {
            ESRI_Config__c config = ESRI_Config__c.GetInstance(baseURI);
            system.assertNotEquals(null, config, 'Unable to find locator for config named "' + baseURI + '"');
            serverURI = config.locator__c;
        }
    }
    
    @RemoteAction global static ESRILocator.FindAddressResponse FindAddress(string anAddress)
    {
        ESRILocator aLocator = ESRILocator.NewInstance();
        return aLocator.findAddressCandidates(anAddress);
    }   
    
    public FindAddressResponse findAddressCandidates(string address)
    {
        return findAddressCandidates('3857', address);
    }
    
    public virtual FindAddressResponse findAddressCandidates(string spatialReference, string address)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        String field = 'SingleKey';
        string encodedAddress = EncodingUtil.UrlEncode(address, 'utf-8');
        
        request.setMethod('GET');
         if(encodedAddress.contains('and') || encodedAddress.contains('@')) {
             serverURI= 'http://webgis.hampton.gov/arcgis/rest/services/streets7/GeocodeServer';
             field = 'Street';
         }
        
        System.debug(serverURI + encodedAddress);
        request.setEndpoint(String.format('{0}/findAddressCandidates?f=pjson&outSR={1}&{2}={3}', new string[] { serverURI, spatialReference, field, encodedAddress} ));
        Httpresponse response = http.send(request);
        string jsonString = response.getBody();
        system.debug(jsonString);
        
        FindAddressResponse aResponse = (FindAddressResponse) Json.Deserialize(jsonString, FindAddressResponse.class);
        return aResponse;
    }
    

    public FindAddressResponse findAddressCandidates(string street, string city, string state, string postal, string country)
    {
        
        return findAddressCandidates(String.Format(
            '{0}, {1}, {2} {3} {4}', 
            new string[] {
                street, 
                city,
                state,
                postal,
                country
            }
        ));
    }
    
    public static ESRILocator NewInstance(string anAddress){
        return  new ESRILocator(anAddress);
    }
    
    public static ESRILocator NewInstance(){
        return NewInstance('Default');
    }
    
    public string services()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setMethod('POST');
        request.setEndpoint(serverURI + '/arcgis/rest/services?f=json');
        Httpresponse response = http.send(request);
        return response.getBody();      
    }

    string serverURI;
}