global class iMeetTrialCreate_Remoting {
    
    public class iMeetTrialRequest {
    	public String  billTo_firstName;
    	public String  billTo_lastName;
    	public String  billTo_email;
    	public String  password;
    }
    
    public class Result {
    	public iMeetTrialResponse result;
    }
    
    public class iMeetTrialResponse {
    	//public iMeetTrialResponse result;
    	public String success;
    	public String room_url;
    }
    
    @RemoteAction
    global static String createiMeetTrial(Id id) {
        Lead lead = [SELECT Id, FirstName, LastName, Company, email FROM Lead WHERE id = :id LIMIT 1];
        System.debug('lead: ' + lead);
        
        iMeetTrialCreate_Remoting.iMeetTrialRequest reqBody = new iMeetTrialCreate_Remoting.iMeetTrialRequest();
        
        Double random = math.random();
        reqBody.billTo_firstName = lead.FirstName;
        reqBody.billTo_lastName = lead.LastName;
        reqBody.billTo_email = lead.Email;
        reqBody.password = 'Testing12345';
        
        String serializedRequestList = JSON.serialize(reqBody);
        System.debug('serializedRequestList: ' + serializedRequestList);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //iMeet trial beta endpoint
        //req.setEndpoint('http://54.200.79.135/imeet/sftrial_account.php');
        req.setEndpoint('http://54.200.79.135/imeet/sftrial_account_prod.php');
        req.setMethod('POST');
        req.setBody(serializedRequestList);
        req.setTimeout(120000);
        HttpResponse res = h.send(req);
        System.debug('res.getBody(): ' + res.getBody());
        
        Result itr = (Result)JSON.deserialize(res.getBody(), Result.class);
        System.debug('iMeetTrialResponse: ' + itr.result);
        
        if (itr.result.success == 'true') {
        
        	lead.IM_ROOM_URL__c = itr.result.room_url;
        	lead.IM_SIGN_UP_DATE__c = date.today();
        	System.debug('IM_ROOM_URL__c: ' + itr.result.room_url);
        	update lead;
        	return itr.result.success;
        }
        else {
            return itr.result.success;
        }
    }
}