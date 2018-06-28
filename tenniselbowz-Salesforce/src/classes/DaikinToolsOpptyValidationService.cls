@RestResource(urlMapping='/OpportunityValidationService')
global with sharing class DaikinToolsOpptyValidationService
{
    public static final Set<String> ORDERABLE_STAGES = new Set<String>{ 'Closed Won', 'Order-Won-Crdt Release, Submittal signed' };
    public static final Set<String> LATIN_AM_RECORD_TYPE = new Set<String>{ 'Latin_America', 'Latin_America_Apttus' };

    public static Map<String, Set<String>> userDepartments {
        get{

            if(userDepartments == null){
                userDepartments = new Map<String, Set<String>>();
                for ( User_Departments__c department : [Select Rep_Number__c, Region__c from User_Departments__c] ){
                    if(! (String.isBlank(department.rep_number__c)|| String.isBlank(department.Region__c)) ){
                        if(userDepartments.containsKey(department.Region__c)){
                            userDepartments.get(department.Region__c).add(department.rep_number__c );
                        } else {
                            userDepartments.put(department.Region__c, new Set<String>{department.rep_number__c });
                        }
                    }
                }
            }
            return userDepartments;
        } set;
    }

    @HttpPost
    global static void doPost()
    {
        OpportunityValidationRequest theRequest = (OpportunityValidationRequest)JSON.deserializeStrict(RestContext.request.requestBody.toString(), OpportunityValidationRequest.class);
        system.debug(logginglevel.error, theRequest);

        OpportunityValidationResponse theResponse = new OpportunityValidationResponse();

        List<Opportunity> theOpportunity = [ SELECT Id, Name, Owner.Name, Is_Valid__c, Latin_America_Opportunity_Number__c,
                                                    DST_ID__c, RecordType.DeveloperName, StageName, Opportunity_Owner_Department__c
                                                FROM Opportunity WHERE Latin_America_Opportunity_Number__c = :theRequest.OpportunityNumber ];
        if( theOpportunity.isEmpty() )
        {
            theResponse.addError( 'OPPORTUNITY_NOT_FOUND', 'Opportunity Number not found in Salesforce.' );
        }
        else
        {

            Set<String> repOfficeSetting = (userDepartments.containsKey(theOpportunity[0].Opportunity_Owner_Department__c)) ? userDepartments.get(theOpportunity[0].Opportunity_Owner_Department__c) : null ;

            if( repOfficeSetting == NULL || (!repOfficeSetting.contains( theRequest.RepOfficeNumber )))
            {
                theResponse.addError( 'INVALID_REP_OFFICE', 'The specified Rep Office is not valid for this Opportunity' );
            }
            if( theOpportunity[0].DST_ID__c != NULL && theOpportunity[0].DST_ID__c != theRequest.JobGuid )
            {
                theResponse.addError( 'INVALID_OPPORTUNITY_GUID', 'The Daikin Tools GUID does not match.' );
            }
            if( ! LATIN_AM_RECORD_TYPE.contains(theOpportunity[0].RecordType.DeveloperName) )
            {
                theResponse.addError( 'INVALID_RECORD_TYPE', 'The Opportunity is not a Latin America Opportunity.' );
            }

            if( theResponse.Errors.isEmpty() )
            {
                theResponse.IsOrderable = ORDERABLE_STAGES.contains( theOpportunity[0].StageName );
                theResponse.IsValid = true;
                theResponse.OpportunityName = theOpportunity[0].Name;
                theResponse.OpportunityOwner = theOpportunity[0].Owner.Name;
                theResponse.SFDCID = theOpportunity[0].Id;

                theOpportunity[0].Is_Valid__c = true;

                List<Response_Error> errors = updateOpportunity(theOpportunity[0]);
                theResponse.Errors.addAll(errors);
            }
        }

        RestContext.response.responseBody = Blob.valueOf( JSON.serialize(theResponse) );
        RestContext.response.addHeader( 'Content-Type', 'application/json' );
    }

    public static List<Response_Error> updateOpportunity(Opportunity theOpportunity){
        List<Response_Error> responseErrors = new List<Response_Error>();
        try{
            update theOpportunity;
        } catch (dmlexception ex){
            for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ ){
                Response_Error err = new Response_Error();
                err.ErrorCode ='INVALID_OPPORTUNITY';
                err.ErrorMessage ='Opportunity Update Error ['+ex.getDmlMessage(errorIndex)+']';
                responseErrors.add(err);
            }
        }
        return responseErrors;
    }

    /* Request schemas */
    public class OpportunityValidationRequest
    {
        public String JobName;
        public String JobGuid;
        public String OpportunityNumber;
        public String RepOfficeName;
        public String RepOfficeNumber;
        public String SFDCID;
        public String UserId;
        public String UserFirstName;
        public String UserLastName;
        public String UserMiddleInitial;
    }

    /* Response schemas */
    global class OpportunityValidationResponse
    {
        public Boolean IsOrderable;
        public Boolean IsValid;
        public List<Response_Error> Errors;
        public String OpportunityName;
        public String OpportunityOwner;
        public String SFDCID;

        public OpportunityValidationResponse()
        {
            this.Errors = new List<Response_Error>();
            this.IsValid = false;
        }

        public void addError( String errorCode, String errorMessage )
        {
            Response_Error newError = new Response_Error();
            newError.ErrorCode = errorCode;
            newError.ErrorMessage = errorMessage;
            this.Errors.add( newError );
        }
    }

    public class Response_Error
    {
        public String ErrorMessage;
        public String ErrorCode;
    }
}