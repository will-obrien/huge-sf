/***************************************
* AutomaticAuthorizeCtrl.cls
* Redirect user to Automatic OAuth page
***************************************/
public with sharing class AutomaticAuthorizeCtrl {
	private static final String AUTOMATIC_CLIENT_ID=AutomaticAPI__c.getInstance().client_id__c;

	public AutomaticAuthorizeCtrl() {
	}

	// THis method, called from a bound command button on the page, will redirect the user to Automatic's OAuth page, prompting
	// a login to Automatic if necessary
	public PageReference doRedirect() {
		// This is the state url parameter, which is passed to Automatic, then passed back in the temporary token request body,
		// to guard against attacks
		Blob blobState = crypto.generateAesKey(128);
		String state = EncodingUtil.convertToHex(blobState);
		AutomaticAPI__c a=AutomaticAPI__c.getInstance(UserInfo.getUserId());
		a.state__c=state;
		a.token__c=null;
		a.automatic_id__c=null;
		a.refresh__c=null;
		a.client_id__c=null;
		a.client_secret__c=null;
		upsert a;

		return new PageReference('https://www.automatic.com/oauth/authorize/?client_id='+AUTOMATIC_CLIENT_ID+'&response_type=code&scope=scope:ignition:on%20scope:mil:on%20scope:trip:summary%20scope:notification:hard_accel%20scope:notification:speeding%20scope:mil:off%20scope:ignition:off%20scope:parking:changed%20scope:region:changed%20scope:location%20scope:vehicle%20scope:notification:hard_brake&state='+state);
	}
}