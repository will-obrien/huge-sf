public with sharing class SesameQuery {

    private static final String keySettingName = 'Sesame Address Verification Key';
<<<<<<< HEAD
	private String rawResults = '';
=======
	private String rawResults{get; set;}
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
	private Integer matchScore{get; set;}
	private String userKey;
    private Integer remainingTransactions;
    private LoqateLicense__c licenseInfo{get;set;}
	private VerifiedAddressDto jsonResults{get; set;}
	
	public SesameQuery(){
		licenseInfo = LoqateLicense__c.getValues(keySettingName);
    	if(licenseInfo == null){
    		throw new QueryException('Can\'t load Sesame Address Verification Key');
    	}
	}
		
	public VerifiedAddressDto query(String queryString){
<<<<<<< HEAD
		jsonResults = null;
=======
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
		String queryPrefix;
		//add license key
		queryPrefix = 'https://saas.loqate.com/json/?lqtkey=' + licenseInfo.License_Key__c;
		queryPrefix += '&p=v';
		queryPrefix += '&addr=';
		System.debug('****Calling with  ' + queryPrefix + queryString);
		
		//set up calling HTTP classes
		Http h = new Http();
		HttpRequest request = new HttpRequest();
		String endPointQuery = queryPrefix + EncodingUtil.urlEncode(queryString, 'UTF-8');
<<<<<<< HEAD
		System.debug('***** Endpoint query :' + endPointQuery);
		request.setEndpoint(endPointQuery);
		request.setMethod('GET');
		HttpResponse response = h.send(request);
		setRawResults( response.getBody() );
		System.debug('***** Raw json: ' + getRawResults());
=======
		request.setEndpoint(endPointQuery);
		request.setMethod('GET');
		HttpResponse response = h.send(request);
		//System.debug('*****JSON*****' + EncodingUtil.urlDecode(response.getBody(), 'UTF-8'));
		rawResults = response.getBody();
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
		jsonResults = (VerifiedAddressDto)JSON.deserialize(rawResults, VerifiedAddressDto.class);
		debugCall(jsonResults);
		return jsonResults;
	}
	
	public String[] matchResults(){
		VerifiedAddressDto.SesameVerificationResults results = jsonResults.results[0];
		String matchString = results.avc;
		return matchString.split('-');
	}
	private void debugCall(VerifiedAddressDto jsonResponse){
		System.debug('**** DEBUG:: Status ' + jsonResponse.status);
		for(VerifiedAddressDto.SesameVerificationResults result : jsonResponse.results){
			System.debug('***** DEBUG:: ' + result + ' ' + result);
		}
	}
	
<<<<<<< HEAD
	public String getRawResults(){
		return rawResults;
	}
	
	public void setRawResults(String rawResults){
		this.rawResults = rawResults;
	}
=======
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
	public class QueryException extends Exception{}
}