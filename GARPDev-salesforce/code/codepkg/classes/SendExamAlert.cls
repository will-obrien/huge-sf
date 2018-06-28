public class SendExamAlert {
	public String msg {get;set;}
    
    public SendExamAlert() {
    	msg = 'Sending Alert...';

			String alertId = ApexPages.currentPage().getParameters().get('id');
            List<String> sites = new List<String>();
        	List<String> apns = new List<String>();
        	List<String> gcms = new List<String>();
        	Exam_Alert__c ea = [select Id, Name, Text__c, Sound__c from Exam_Alert__c where Id = :alertId];
            if(ea != null) {
				List<Exam_Alert_Site__c> lstEAs = [select Id, Name, Exam_Site__c from Exam_Alert_Site__c where Exam_Alert__c = :ea.Id];
                
                System.debug('lstEAs:' + lstEAs);
                
                if(lstEAs != null && lstEAs.size() > 0) {
                    for(Exam_Alert_Site__c eas :lstEAs) {
                        System.debug('eas:' + eas.Exam_Site__c);
                        sites.add(String.valueOf(eas.Exam_Site__c));
                    }
                }
                
                List<FRM_App_Setting__c> lstFAS = [select Id, Name, Contact__c, apnId__c, gcmId__c, examId__c from FRM_App_Setting__c where (apnId__c != null or gcmId__c != null) and examId__c in :sites];
				
                System.debug('lstFAS:' + lstFAS);
                
                if(lstFAS != null && lstFAS.size() > 0) {
                    for(FRM_App_Setting__c fas :lstFAS) {
                        System.debug('fas:' + fas.apnId__c + ':' + fas.gcmId__c);
                        if(fas.apnId__c != null)
                            apns.add(String.valueOf(fas.apnId__c));
                        
                        if(fas.gcmId__c != null)
                            gcms.add(String.valueOf(fas.gcmId__c));

                    }
                }
                
            }
        
        	System.debug('sites:' + sites);
        
			HttpRequest req = new HttpRequest();
            req.setEndpoint('http://ec2-54-186-51-192.us-west-2.compute.amazonaws.com/frmApp/alerts');
            req.setMethod('POST');
            
            Map<String,object> mapEmp = new Map<String,object>();
            mapEmp.put('title',ea.name);
            mapEmp.put('msg',ea.Text__c);
            mapEmp.put('sound',ea.Sound__c);        
            //mapEmp.put('sites',sites);
            mapEmp.put('apns',apns);
        	mapEmp.put('gcms',gcms);
        
            String JSONString = JSON.serialize(mapEmp);    
        
        	System.debug('JSONString:' + JSONString);
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSONString);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            System.debug(res.getBody());
        
        msg = res.getBody();
        
    }
}