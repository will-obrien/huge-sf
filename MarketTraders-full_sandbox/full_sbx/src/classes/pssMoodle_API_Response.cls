public with sharing class pssMoodle_API_Response{          
    
    public string message {get; set{message = value; }}    
    public RestError error {get; set{ error = value; }}   
    
    public pssMoodle_API_Response()
    {        
        message = '';
        error = null;
    }
    
    public class RestError{
        public string errorCode {get; set{errorCode = value; }}
        public string debuginfo {get; set{debuginfo = value; }}        
        public string mexception {get; set{mexception = value; }}           
        public boolean isError {get; set;}
        
        public RestError(string exceptionMsg){
            mexception = exceptionMsg;
        }
    }
}