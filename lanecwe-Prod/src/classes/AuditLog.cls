public class AuditLog {
    
  private Logs__c logObj                            = null;
  private Boolean error                             = false;
  private static final string UNDERSCORE_STR        = '_';
  
  // Constructor for log object
  public AuditLog(String classOrTriggerName, String methodName) {
    logObj                  = new Logs__c();
    logObj.class_name__c    = classOrTriggerName;
    logObj.method_name__c   = methodName;
    this.startLogTimes(); 
  }
  

  // Tracks start time/ms
  public void startLogTimes() {
    logObj.start_dtm__c = System.now();
    logObj.start_ms__c  = System.currentTimeMillis();
  }
  
  
  // Capture SourceSystem.
  public void logSourceSystem(String sourceSystem){
    logObj.Z_Source__c = sourceSystem;  
  }

  // Capture Object RecordId.
  public void logRecordId(String recordId){
    logObj.Record_Id__c = recordId;  
  }  
  
  // capture request info for log
  public void logRequestInfo(String requestInfo) {
    system.debug('RequestInfo : ' + requestInfo);
    if (logObj.request__c == null) 
        logObj.request__c = UNDERSCORE_STR;
    
    logObj.request__c += requestInfo + '\n';

    if((logObj.request__c).length()>1 && (logObj.request__c).indexof(UNDERSCORE_STR)==0){
        logobj.request__c = (logobj.request__c).substring(1);
    }
    
    system.debug('logobj.request__c : ' + logobj.request__c);
    
  }
  
  // capture response info for log
  public void logResponseInfo(String responseInfo) {
    system.debug('ResponseInfo : ' + responseInfo);
    if (logObj.response__c == null) 
        logObj.response__c = UNDERSCORE_STR;
    
    logObj.response__c += responseInfo + '\n';
    
    if((logObj.response__c).length()>1 && (logObj.response__c).indexof(UNDERSCORE_STR)==0){
        logobj.response__c = (logobj.response__c).substring(1);
    }
    
    system.debug('logobj.response__c : ' + logobj.response__c);
  }

  //Capture success/failure status  
  public void logStatusInfo(String statusMessage) {
    logObj.status__c = statusMessage;
  }
  
  
  //Capture Message if not for request/response
  public void logMessage(String msg) {
    if (logObj.message__c == null) logObj.message__c = UNDERSCORE_STR;
    //logObj.message__c += (System.now() + ': ' + msg + '\n\n');
    logObj.message__c += msg + '\n\n';
    if((logObj.message__c).length()>1 && (logObj.Message__c).indexof(UNDERSCORE_STR)==0){
        logobj.message__c = (logobj.message__c).substring(1);
    }
  }
  
  // Sets ENDPoint url for outbound calls
  public void setUrl (String endpointUrl) {
    logObj.EndPoint_Url__c = endpointUrl;
  }

  // Captures Custom Error Message for logs
  public void logErrorMessage(String errMsg) {
    this.error = true;
    if (logObj.error_message__c == null) logObj.error_message__c = UNDERSCORE_STR;
    logObj.error_message__c +=  errMsg + '\n\n';
    if((logObj.error_message__c).length()>1 && (logObj.error_Message__c).indexof(UNDERSCORE_STR)==0){
        logobj.error_message__c = (logobj.error_message__c).substring(1);
    }
  }
  
  // Captures Exception/Custom Error
  public void logException(String errMsg, Exception ex) {
      this.logErrorMessage(errMsg);
      this.logException(ex);
  }
    
  public void logException(Exception ex) {
    try {
      this.error = true;
      logObj.exception_cause__c = '' + ex.getCause();
      logObj.exception_message__c = ex.getMessage();
      logObj.exception_type__c = ex.getTypeName();
    } catch (Exception ex2) {
      System.debug('\n\n>>> AuditLog is swallowing exception on logException(): ' + ex2);
     
    }
  }
  
  //Captures End time for logs 
  public void stopLogging() {
    logObj.stop_dtm__c = System.now();
    logObj.stop_ms__c  = System.currentTimeMillis();
  }
 
 // Inserts log
  public Logs__c saveLog() {
    if (logObj.stop_ms__c == null) {
      this.stopLogging();
    }
    
    // Setting Default Source System
    if(logObj.Z_Source__c == null)
        logObj.Z_Source__c = label.Default_Z_Source;
      
      try {
      
        if ((Limits.getLimitDMLStatements() - Limits.getDMLStatements()) > 0 &&
            (Limits.getLimitDMLRows() - Limits.GetDMLRows()) > 0) {
      
          Database.DMLOptions dml = new Database.DMLOptions();
          dml.allowFieldTruncation = true;
          System.debug(' logObj : ' + logObj);
          Database.insert(logObj,dml);
        }
      
      } catch (Exception ex) {
        System.debug('\n\n>>> AuditLog is swallowing exception on saveLog(): ' + ex);
        System.debug('\n logObj = ' + logObj);
        
      }
    system.debug(' Before Returning logObj: ' + logObj);  
    return logObj;
  }
}