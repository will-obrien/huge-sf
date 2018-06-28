public with sharing class KVApexBatchExecute 
{
    public static Boolean mockCallout(Goal_Achiever__c goalAchiever)
    {
        return true;
    }
    
    /*
    // A real callout might look something like the following (trimmed down for this example)
    public static Boolean realCallout(GoalQualifier__c gq)
    {
        Boolean retVal = false;
        HTTPResponse res = callout('POST', BASE_URL + '/api/goals/' + gq.Id, getJSONBody('/api/goals/' + gq.Id, gq));
        try
        {
            JSONBody responseBody = (JSONBody) JSON.deserialize(res.getBody(), JSONBody.class);
            // Process JSON response
            retVal = true;
        }
        catch(Exception e){}
        
        return retVal;
    }

    public class JSONBody
    {
        public String AUTH_APIKEY {get; set;}
        public String AUTH_SIGNATURE {get; set;}
        public String AUTH_DATE {get; set;}
        public GoalQualifier__c gq {get; set;}
    }

    private static final String BASE_URL = 'http://ec2-XX-XXX-XX-XX.compute-1.amazonaws.com';
    private static final String API_KEY = '00000000000000000000000000000';
    private static final String API_SECRET = '000000000000000000000000000000000000';

    private static String epochTime;
    private static void setEpochTime(){ epochTime = String.valueOf(DateTime.now().getTime()/1000); }

    private static String getSignature(String secret, String path)
    {
        Blob sig = Crypto.generateMac('HmacSHA256', Blob.valueOf(path + epochTime), Blob.valueOf(secret));
        return EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8');
    }

    private static String getJSONBody(String path, GoalQualifier__c gq)
    {
        setEpochTime();
        JSONBody jb = new JSONBody();
        jb.AUTH_APIKEY = API_KEY;
        jb.AUTH_SIGNATURE = getSignature(API_SECRET, path);
        jb.AUTH_DATE = epochTime;
        jb.gq = gq;

        return JSON.serializePretty(jb);
    }

    private static HTTPResponse callout(String method, String endpoint, String body)
    {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HTTPResponse res;
        req.setTimeout(40000);
        req.setMethod(method);
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type','application/json');
        body = body.replace('%3D', '=');
        body = body.replace('%2B', '+');
        body = body.replace('%2F', '/');
        req.setBody(body);
        if(system.Test.isRunningTest() == false)
            res = h.send(req);
        //else
            // Mock a JSON response 

        return res;
    }
    */
}