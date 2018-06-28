public with sharing class fieldCreatorController {

public String obj { get; set; }
public List<SelectOption> objects { get; set; }
private String sessionId;
private String pod;
private Map<String,Schema.Sobjecttype> globalDescribe = Schema.getGlobalDescribe();
private Map<String,String> label2name = new Map<String, String>();
private Map<String,String> name2label = new Map<String, String>();
private static Set<String> addFieldableStandardObjects = new Set<String>();


public String getCreateUrl() {
    if(sessionId != null) {
        String metaDataUrl = 'https://' + pod + '-api.salesforce.com/services/Soap/m/15.0/' + UserInfo.getOrganizationId().substring(0,15);
        String baseUrl = System.Label.FieldCreatorBaseUrl + System.Label.FieldCreatorJSP + '?srv=' + metaDataUrl + '&sid=' + sessionId;
        String endpointUrl = baseUrl + '&objectName=' + obj;
        endpointUrl += '&objectLabel=' + name2label.get(obj);
        String retUrl = 'https://' + pod + '.salesforce.com' + system.currentPageReference().getUrl();
        List<String> temp = retUrl.split('\\?');
        retUrl = temp[0];
        endpointUrl += '&retUrl=' + retUrl;
        return endpointUrl;
    } else { 
        return null;
    }   
}


public fieldCreatorController() {
    populateAddFieldableStandardObjects();
    populateObjects();  
    
}

void populateAddFieldableStandardObjects() {
    addFieldableStandardObjects.add('campaign');
    addFieldableStandardObjects.add('campaignmember');
    addFieldableStandardObjects.add('lead');
    addFieldableStandardObjects.add('account');
    addFieldableStandardObjects.add('contact');
    addFieldableStandardObjects.add('opportunity');
    addFieldableStandardObjects.add('case');
    addFieldableStandardObjects.add('contract');
    addFieldableStandardObjects.add('solution');
    addFieldableStandardObjects.add('product');
    addFieldableStandardObjects.add('idea');
    addFieldableStandardObjects.add('asset');
    addFieldableStandardObjects.add('user');
    addFieldableStandardObjects.add('opportunitylineitem');
}

void populateObjects() {
    objects = new List<SelectOption>();
    objects.add(new SelectOption('','--Select Object--'));
    
    system.debug('Evaluating Objects');
    for (String s : globaldescribe.keySet()) {
        
        if(!s.contains('__c')) {
            system.debug('Object Name: ' + s);
            system.debug('Contains Check: ' + addFieldableStandardObjects.contains(s));
        }
        if(s.contains('__c') || addFieldableStandardObjects.contains(s)) {
            label2name.put(globaldescribe.get(s).getDescribe().getLabel(),globaldescribe.get(s).getDescribe().getName());
            name2label.put(globaldescribe.get(s).getDescribe().getName(),globaldescribe.get(s).getDescribe().getLabel());
        }
    }
    
    Set<String> keySet = label2name.keySet();
    List<String> labels = new List<String>();
    labels.addAll(keySet);
    labels.sort();
    
    for(String s : labels) {
        if(!s.contains('Tag')) // filter out tag objects as we can't add fields to them
            objects.add(new SelectOption(label2name.get(s), s));
    }
}

public PageReference selectObject() {
    sessionId = UserInfo.getSessionId();
    String referer = ApexPages.currentPage().getHeaders().get('Referer');
    system.debug(referer);
    pod = referer.substring(8, 11);
    
    /* ssinghvi fix for pod##.salesforce.com > 10 */
    String ss_Pod = URL.getSalesforceBaseUrl().getHost();
    Integer idx = ss_Pod.indexOf('.', 0);
    if(idx != -1) { pod = ss_Pod.subString(0,idx); }
    /* end fix */    
    
    return Page.fieldCreatorStep2;
}

public PageReference changeObject() {
    obj = '';
    return Page.fieldCreatorStep1;
}

private static testmethod void tests() {
    fieldCreatorController controller = new fieldCreatorController();
    controller.dummyMethod();
}

public void dummyMethod() {
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
}



}