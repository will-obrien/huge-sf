public with sharing class PGIErrorUtilities  
{
	public enum LoggingLevel {INFO, DEBUG, WARN, FATAL} 
	public static PGIError__c logPgiError(String errorCode, String errorMessage, LoggingLevel logLevel)
	{
		PGIError__c thisError = new PGIError__c();
		if(errorCode != null)
		{
			thisError.Error_Code__c =  errorCode;
		}
		//Set standard error code
		else
		{
			thisError.Error_Code__c = 'UNHANDLED';
		}
		
		//set fields
		thisError.Error_Message__c = errorMessage;
		thisError.Error_Type__c = logLevel != null ? logLevel.name() : null;
		//log Error
		boolean insertError = false;
		try {
                                    
                                    if(logLevel == LoggingLevel.INFO || logLevel == LoggingLevel.DEBUG || logLevel == LoggingLevel.WARN || logLevel == LoggingLevel.FATAL) {
						                 insertError = true;
						               }
                                    if(insertError)
                                                insert thisError;
                        } catch (DMLException dml){
                        } catch (Nullpointerexception ne){}
                        
		
		return thisError;	
	}
}