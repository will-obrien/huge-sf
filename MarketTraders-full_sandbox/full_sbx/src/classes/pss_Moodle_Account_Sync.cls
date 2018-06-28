public with sharing class pss_Moodle_Account_Sync {  
    public class MoodleUserId
    {
        public string userid {get; set{userid = value; }}           
    }
    
    public class MoodleResponse
    {
        public string done {get; set;}
        public string useremail {get;  set{useremail = value; }}      
        //public string code {get; set{code = value; }}
        public string message {get; set{message = value; }}
        //public string debuginfo {get; set{debuginfo = value; }}        
        //public string mexception {get; set{mexception = value; }} 
        public string sfid {get; set{sfid = value; }}           
        public boolean isError {get; set;}
        public string idcourses {get; set{idcourses = value; }} 
        //public MoodleUserId data {get; set{data = value; }}   
        
        public MoodleResponse()
        {
            done = '';
            useremail = '';
            //code = '';
            //status = '';
            message = '';
            isError = false;
            sfid = '';
            idcourses ='';
            //mexception='';
        }
        
    }
    
    public class User_Info_Collection{
        public List<MoodleResponse> data;
        public boolean success {get; set;}        
        public string error {get; set;}         
        public User_Info_Collection(){
            data = new List<MoodleResponse>();
        }
    }
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Moodle integration endpoint URL configured in custom settings 
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    public static Map<String, String> countriesMap;

    //static String  moodleUrl = 'http://market.paradisosolutions.com//auth/saml/webservice/index.php?method=user_enrolment&format=json';
    //static String  moodleUrl = 'http://moodledev.markettraders.com//auth/saml/webservice/index.php?method=user_enrolment&format=json';
    static String  moodleUrl = 'http://education.markettraders.com//auth/saml/webservice/index.php?method=user_enrolment&format=json';
    
    //static String wstoken = 'b1dbSFkwMRguQfLsAa3zIK0Vksd8oVxr';           // market.paradisosolutions.com
    //static String wstoken = '7ad7c3ce-c699-4cad-8489-a0ac201c1877';       // moodledev.markettraders.com
    static String wstoken = '7ad7c3ce-c699-4cad-8489-a0ac201c1877';             // education.markettraders.com
    
    private final string TEXT_DATA = 'data';
    private final string TEXT_STATUS = 'status';
    public pss_Moodle_Account_Sync ()
    {
        //System.debug(Logginglevel.DEBUG, String.format('url of the moodle environment: {0}', new String[] {pss_Moodle_Account_Sync.moodleUrl}));
        //System.debug(Logginglevel.DEBUG, String.format('request body format: {0}',  new List<String>{pss_Moodle_Account_Sync.requestBodyFormat}));
    }

    public User_Info_Collection createUserInMoodle(List<Account> newUsers)
    {       
        System.debug(Logginglevel.DEBUG,'creating Contact in Moodle started for Contact with id:  '+newUsers);
        System.debug(Logginglevel.DEBUG, '@@@@ creating Contact in Moodle started for Contact with id: ' + newUsers);
        System.debug(Logginglevel.DEBUG, '@@@@ creating Contact in Moodle started for Contact with size: ' + newUsers.size());
        System.debug(Logginglevel.DEBUG, '@@@@ creating Contact in Moodle started for Contact with 0: ' + newUsers[0]);
        System.debug(Logginglevel.DEBUG, '@@@@ creating Contact in Moodle started for Contact with 1: ' + newUsers[1]);
        System.debug(Logginglevel.DEBUG, '@@@@ creating Contact in Moodle started for Contact with 2: ' + newUsers[2]);
        System.debug(Logginglevel.DEBUG, '@@@@ creating Contact in Moodle started for Contact with 3: ' + newUsers[3]);
        System.debug(Logginglevel.DEBUG, '@@@@ creating Contact in Moodle started for Contact with 4: ' + newUsers[4]);
        
                
        User_Info_Collection mResponse = sendRequestToMoodle(getParameters(newUsers));
        
        
        //if ((mResponse.mexception != null && mResponse.mexception != '')||(mResponse.debuginfo != null && mResponse.debuginfo != '')||(mResponse.code != null && mResponse.code != '')|| (mResponse.message != null && mResponse.message != '') )
        /*
        if (mResponse.code!='1')
        {
            mResponse.isError=true;
        }  
        else
        {
            mResponse.isError=false;
            //mResponse.id = mResponse.data.userid;
        } 
        */          
        return mResponse;           
    }
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Method sends a service request to moodle
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    private User_Info_Collection sendRequestToMoodle(List<pssKeyValuePair> parameterList)
    {       
        try
            {
                Http http = new Http();
                 if (Test.isRunningTest())
                {
                    Account acc = [Select Id From Account Where PersonEmail='test@abc.com' Limit 1];
                    String body='[{"done":true,"sfid":"'+ acc.id +'","idcourses":"PB_Client_Target_Trading_Course__c","useremail":"test@abc.com","message":"user update"}]';
                    User_Info_Collection mResponse = new User_Info_Collection();
                    mResponse= parseMoodleOutput(body);                   
                    return mResponse;
                }
                else
                {
                    pssMoodle_API_Response apiResponse;
                    User_Info_Collection mResponse = new User_Info_Collection();
                    apiResponse = pssapi_Moodle_Proxy.call(moodleUrl , parameterList); 
                     if(apiResponse.error == null){
                        //mResponse = (pss_Moodle_Account_Sync.MoodleResponse)JSON.deserialize(apiResponse.message.replace('[','').replace(']',''), pss_Moodle_Account_Sync.MoodleResponse.class);
                        mResponse= parseMoodleOutput(apiResponse.message);
                    }
                    else{
                        mResponse.error= apiResponse.error.mexception;
                    }
//                    HTTPResponse response = http.send(request);
                    System.debug(Logginglevel.Debug,mResponse);
                    System.debug('response.getBody:'+apiResponse.message);
                    /*
                    if(response.getStatusCode()==200)
                    {
                        return (pss_Moodle_Account_Sync.MoodleResponse)JSON.deserialize(response.getBody().replace('[','').replace(']',''), pss_Moodle_Account_Sync.MoodleResponse.class);
                    }
                    else
                    {
                        MoodleResponse mResponse = new MoodleResponse();
                        mResponse.message = response.getBody();
                        return mResponse;
                    }
                    */
                    return mResponse;
                }
            }
        catch(System.CalloutException calloutException)
            {
                System.debug(Logginglevel.Debug, calloutException.getMessage());
                User_Info_Collection mResponse = new User_Info_Collection();
                mResponse.error= calloutException.getMessage();
                return mResponse;
            }
        catch(System.Exception ex)
            {
                System.debug(Logginglevel.Debug, ex.getMessage());
                User_Info_Collection mResponse = new User_Info_Collection();
                mResponse.error= ex.getMessage();
                return mResponse;
            }
    }
    
    private List<pssKeyValuePair> getParameters(List<Account> newUser)
    {
        List<pssKeyValuePair> params = new List<pssKeyValuePair>();
        //String users='{users : [';
        string data='';
        integer i=0;
        Map<String, PB_Course__c> mcs = PB_Course__c.getAll();
        params.add(new pssKeyValuePair('ptoken',wstoken));        
        for (Account a:newUser)       
        {
            String city='';
            String firstName=''; 
            String lastName=''; 
            String email='';  
            String password='password1';  
            String idcourses=''; 
            
            if(!String.isBlank(a.FirstName))                 
                firstName= a.FirstName;
                
            if(!String.isBlank(a.LastName))
                lastName= a.LastName;
                
            if(!String.isBlank(a.PersonEmail))
                email= a.PersonEmail;                
            
            if(!String.isBlank(a.LMS_Password__c))
                password= a.LMS_Password__c;
            
            
            for(PB_Course__c pbCourse : mcs.values()){
                String strCourseName = pbCourse.Course_API_Name__c.trim();
                System.debug('strCourseName'+ strCourseName);
                System.debug('strCourseName:::::'+ a.get(strCourseName));                
                if(strCourseName != 'PB_ScalpingClass_Summary_CLIENT__c' && strCourseName != 'PB_UTP_Summary_Client__c' 
                   && a.get(strCourseName) == True ){
                   //System.debug('strCourseName'+ strCourseName);
                   idcourses+=strCourseName + ',';                   
                }else if ((strCourseName == 'PB_ScalpingClass_Summary_CLIENT__c' || strCourseName == 'PB_UTP_Summary_Client__c') 
                   && a.get(strCourseName) == 'Purchased'){
                  idcourses+=strCourseName + ',';
                }                
            }
            if(idcourses.length() > 0) {
                idcourses= idcourses.substring(0, (idcourses.length() - 1));
            }
            params.add(new pssKeyValuePair('users['+ i +'][firstname]',firstName));        
            params.add(new pssKeyValuePair('users['+i+'][lastname]',lastName));
            //params.add(new pssKeyValuePair('ptoken','users['+i+'][username]',email));
            params.add(new pssKeyValuePair('users['+i+'][city]',''));
            params.add(new pssKeyValuePair('users['+i+'][email]',email));
            params.add(new pssKeyValuePair('users['+i+'][password]',password));
            params.add(new pssKeyValuePair('users['+i+'][sfid]',a.id));
            params.add(new pssKeyValuePair('users['+i+'][idcourses]',idcourses));
            
            i++;
            
        }
        /*
        if(data.length() > 0) {
            data = data.substring(0, (data.length() - 1));
        }
        users += data;
        */
        
        
        return params;
        
    }
    private User_Info_Collection parseMoodleOutput(string moodleJSON){
        // Parse entire JSON response.
        JSONParser parser = JSON.createParser(moodleJSON);
        User_Info_Collection moodleCourses = new User_Info_Collection();
        while (parser.nextToken() != null) {                               
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                
                // Read entire object                            
                MoodleResponse courseInfo = (MoodleResponse)parser.readValueAs(MoodleResponse.class);
                system.debug(' Course Text: ' + courseInfo);
                moodleCourses.data.add(courseInfo);
                // Skip the child start array and start object markers.
                parser.skipChildren();                                                                        
            }                                
            else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == TEXT_STATUS ){
                parser.nextToken();                                    
                moodleCourses.success = (parser.getIntegerValue() == 200 ? true : false);  
                System.Debug(' Status:' + moodleCourses.success);                     
            }                        
        }
            
        return moodleCourses;
    }
}