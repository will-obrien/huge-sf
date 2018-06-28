public class MetadataService {
      
     public class RemoteSiteSetting extends Metadata {
        public String type = 'RemoteSiteSetting';
        public String fullName;
        public String description;
        public Boolean disableProtocolSecurity;
        public Boolean isActive;
        public String url;
        public String[] type_att_info = new String[]{'xsi:type'};
        public String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] description_type_info = new String[]{'description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] disableProtocolSecurity_type_info = new String[]{'disableProtocolSecurity','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        public String[] isActive_type_info = new String[]{'isActive','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        public String[] url_type_info = new String[]{'url','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'fullName','description','disableProtocolSecurity','isActive','url'};
    }
     
    public class CreateResponse_Element {
        public MetadataService.AsyncResult[] result;
        public String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'result'};
        
        public CreateResponse_Element() {}
    }
           
    public class MetadataPort {
        public String endpoint_x;
        {
            // Workaround to platform bug (?) where the following method returns a none HTTPS URL in a Batch Apex context
            URL baseUrl = URL.getSalesforceBaseUrl();
            
            if(baseUrl.getProtocol() == 'http')
                baseUrl = new URL('https', baseUrl.getHost(), baseUrl.getPort(), baseUrl.getFile()); // Switch to https protocol
            endpoint_x = baseUrl.toExternalForm() + '/services/Soap/m/27.0';          
        }
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public MetadataService.SessionHeader_Element SessionHeader;
        public MetadataService.DebuggingInfo_Element DebuggingInfo;
        public MetadataService.CallOptions_Element CallOptions;
        public MetadataService.DebuggingHeader_Element DebuggingHeader;
        public String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        public String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        public String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        public String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        public String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata', 'MetadataService'};
        
        public MetadataService.AsyncResult[] create(MetadataService.Metadata[] metadata) {
            MetadataService.Create_Element request_x = new MetadataService.Create_Element();
            MetadataService.CreateResponse_Element response_x;
            request_x.metadata = metadata;
            Map<String, MetadataService.CreateResponse_Element> response_map_x = new Map<String, MetadataService.CreateResponse_Element>();
            response_map_x.put('response_x', response_x);
            
            if(!Test.isRunningTest()) {
            	WebServiceCallout.invoke(
	              this,
	              request_x,
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'http://soap.sforce.com/2006/04/metadata',
	              'create',
	              'http://soap.sforce.com/2006/04/metadata',
	              'createResponse',
	              'MetadataService.CreateResponse_Element'}
	            );
	            
	            response_x = response_map_x.get('response_x');
            	
            	return response_x.result;
            } else {	
            	return null;
            }
        }
       
        public MetadataService.AsyncResult[] checkStatus(String[] asyncProcessId) {
            MetadataService.CheckStatus_Element request_x = new MetadataService.CheckStatus_Element();
            MetadataService.CheckStatusResponse_Element response_x;
            request_x.asyncProcessId = asyncProcessId;
            Map<String, MetadataService.CheckStatusResponse_Element> response_map_x = new Map<String, MetadataService.CheckStatusResponse_Element>();
            response_map_x.put('response_x', response_x);
            
            if(!Test.isRunningTest()) {
            	
            	WebServiceCallout.invoke(
	              this,
	              request_x, 
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'http://soap.sforce.com/2006/04/metadata', 
	              'checkStatus',
	              'http://soap.sforce.com/2006/04/metadata',
	              'checkStatusResponse',
	              'MetadataService.CheckStatusResponse_Element'}
	            );
	            
	            response_x = response_map_x.get('response_x');
            	
            	return response_x.result;
            } else {	
            	return null;
            }   
        }
    }    
    
    public class AsyncResult {
        public Boolean checkOnly;
        public Boolean done;
        public String id;
        public String message;
        public Integer numberComponentErrors;
        public Integer numberComponentsDeployed;
        public Integer numberComponentsTotal;
        public Integer numberTestErrors;
        public Integer numberTestsCompleted;
        public Integer numberTestsTotal;
        public String state;
        public String stateDetail;
        public DateTime stateDetailLastModifiedDate;
        public String statusCode;
        public String[] checkOnly_type_info = new String[]{'checkOnly','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        public String[] done_type_info = new String[]{'done','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        public String[] id_type_info = new String[]{'id','http://soap.sforce.com/2006/04/metadata','ID','1','1','false'};
        public String[] message_type_info = new String[]{'message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] numberComponentErrors_type_info = new String[]{'numberComponentErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberComponentsDeployed_type_info = new String[]{'numberComponentsDeployed','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberComponentsTotal_type_info = new String[]{'numberComponentsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberTestErrors_type_info = new String[]{'numberTestErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberTestsCompleted_type_info = new String[]{'numberTestsCompleted','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberTestsTotal_type_info = new String[]{'numberTestsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] state_type_info = new String[]{'state','http://soap.sforce.com/2006/04/metadata','AsyncRequestState','1','1','false'};
        public String[] stateDetail_type_info = new String[]{'stateDetail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] stateDetailLastModifiedDate_type_info = new String[]{'stateDetailLastModifiedDate','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        public String[] statusCode_type_info = new String[]{'statusCode','http://soap.sforce.com/2006/04/metadata','StatusCode','0','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'checkOnly','done','id','message','numberComponentErrors','numberComponentsDeployed','numberComponentsTotal','numberTestErrors','numberTestsCompleted','numberTestsTotal','state','stateDetail','stateDetailLastModifiedDate','statusCode'};
    
    	public AsyncResult() {}
    }    
    
    public class CheckStatus_Element {
        public String[] asyncProcessId;
        public String[] asyncProcessId_type_info = new String[]{'asyncProcessId','http://soap.sforce.com/2006/04/metadata','ID','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'asyncProcessId'};
        
        public CheckStatus_Element() {}
    }
    
    public class CheckStatusResponse_Element {
        public MetadataService.AsyncResult[] result;
        public String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'result'};
        
        public CheckStatusResponse_Element() {}
    }
    
    public class PackageTypeMembers {
        public String[] members;
        public String name;
        public String[] members_type_info = new String[]{'members','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        public String[] name_type_info = new String[]{'name','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'members','name'};
        
        public PackageTypeMembers() {}
    }
    
    public class DebuggingHeader_Element {
        public MetadataService.LogInfo[] categories;
        public String debugLevel;
        public String[] categories_type_info = new String[]{'categories','http://soap.sforce.com/2006/04/metadata','LogInfo','0','-1','false'};
        public String[] debugLevel_type_info = new String[]{'debugLevel','http://soap.sforce.com/2006/04/metadata','LogType','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'categories','debugLevel'};
        
        public DebuggingHeader_Element() {}
    }
    
    public class LogInfo {
        public String category;
        public String level;
        public String[] category_type_info = new String[]{'category','http://soap.sforce.com/2006/04/metadata','LogCategory','1','1','false'};
        public String[] level_type_info = new String[]{'level','http://soap.sforce.com/2006/04/metadata','LogCategoryLevel','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'category','level'};
        
        public LogInfo() {}
    }
    
    public virtual class Metadata {
        public String fullName;
        public String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'fullName'};
    	
    	public Metadata() {}
    }
    
    public class SessionHeader_Element {
        public String sessionId;
        public String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'sessionId'};
        
        public SessionHeader_Element() {}
    }
   
    public class RetrieveResponse_Element {
        public MetadataService.AsyncResult result;
        public String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'result'};
        
        public RetrieveResponse_Element() {}
    }
 
    public class DebuggingInfo_Element {
        public String debugLog;
        public String[] debugLog_type_info = new String[]{'debugLog','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'debugLog'};
        
        public DebuggingInfo_Element() {}
    }
    
    public class CallOptions_Element {
        public String client;
        public String[] client_type_info = new String[]{'client','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'client'};
        
        public CallOptions_Element() {}
    }
    
    public class CheckDeployStatus_Element {
        public String asyncProcessId;
        public String[] asyncProcessId_type_info = new String[]{'asyncProcessId','http://soap.sforce.com/2006/04/metadata','ID','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'asyncProcessId'};
        
        public CheckDeployStatus_Element() {}
    }
    
     public class Create_Element {
        public MetadataService.Metadata[] metadata;
        public String[] metadata_type_info = new String[]{'metadata','http://soap.sforce.com/2006/04/metadata','Metadata','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'metadata'};
        
        public Create_Element() {}
    }   
}