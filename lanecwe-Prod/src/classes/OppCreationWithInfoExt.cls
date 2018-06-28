public with sharing class OppCreationWithInfoExt {
	private ApexPages.StandardController controller = null;
	public OppCreationWithInfoExt(ApexPages.StandardController controller) {
		this.controller = controller;
    }

  	public PageReference SetFields(){
		String newUrl = '/'+Opportunity.SObjectType.getDescribe().getKeyPrefix()+'/e?'+ getParameters();
		newUrl += '&opp11=Identify Target'; //Set StageName
		return new PageReference(newUrl);
	}
	
	private String getParameters(){
		string param = '';
		Map<String, String> strMap = ApexPages.currentPage().getParameters();
		Set<String> excludeKeys = new Set<String>{'save_new', 'sfdc.override'};
		for(String key : strMap.keySet()){
			if(!excludeKeys.contains(key))
			param += key + '=' +  strMap.get(key) + '&';
		}       
        param += 'nooverride=1';
        return param;
    }
}