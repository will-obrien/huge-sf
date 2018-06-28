@RestResource(urlMapping='/InputOutputRetrievalService')
global with sharing class DaikinToolsOpptyInOutService
{
    @HttpPost
    global static void doPost()
    {
        OpportunityInOutRequest theRequest = (OpportunityInOutRequest)JSON.deserializeStrict(RestContext.request.requestBody.toString(), OpportunityInOutRequest.class);
        system.debug(logginglevel.error, theRequest);

        OpportunityInOutResponse theResponse = new OpportunityInOutResponse();
        List<Input_and_Output_Values__c> inOutSettings = Input_and_Output_Values__c.getAll().values();
        Map<String, List<Input_and_Output_Values__c>> appkeyToSettings = new Map<String, List<Input_and_Output_Values__c>>();
        for( Input_and_Output_Values__c aSetting : inOutSettings )
        {
            if( !appkeyToSettings.containsKey( aSetting.AppKey__c) )
            {
                appkeyToSettings.put( aSetting.AppKey__c, new List<Input_and_Output_Values__c>() );
            }
            appkeyToSettings.get( aSetting.AppKey__c ).add( aSetting );
        }

        for( Request_OpportunityItem aRequestItem : theRequest.OpportunityItems )
        {
            Response_OpportunityItem newResponseOpptyItem = new Response_OpportunityItem( aRequestItem.ItemGuid );
            List<Input_and_Output_Values__c> settingsForAppkey = appkeyToSettings.get( aRequestItem.AppKey );
            if( settingsForAppkey != NULL )
            {
                for( Input_and_Output_Values__c aSetting : settingsForAppkey )
                {
                    newResponseOpptyItem.addItem( aSetting.Input_Output_Value_Name__c, 0 );
                }
            }
            theResponse.OpportunityItems.add( newResponseOpptyItem );
        }

        RestContext.response.responseBody = Blob.valueOf( JSON.serialize(theResponse) );
        RestContext.response.addHeader( 'Content-Type', 'application/json' );
    }

    /* Request schemas */
    public class OpportunityInOutRequest
    {
        public List<Request_OpportunityItem> OpportunityItems;
    }

    public class Request_OpportunityItem
    {
        public String SFDCID;
        public String ItemGuid;
        public String AppKey;
        public String FormatNumber;
        public String ModelNumber;
    }

    /* Response schemas */
    global class OpportunityInOutResponse
    {
        public List<Response_OpportunityItem> OpportunityItems;
        public List<Response_Error> Errors;

        public OpportunityInOutResponse()
        {
            this.OpportunityItems = new List<Response_OpportunityItem>();
            this.Errors = new List<Response_Error>();
        }

        public void addError( String errorCode, String errorMessage )
        {
            Response_Error newError = new Response_Error();
            newError.ErrorMessage = errorMessage;
            newError.ErrorCode = errorCode;
            this.Errors.add( newError );
        }
    }

    public class Response_OpportunityItem
    {
        public String ItemGuid;
        public List<Response_Error> Errors;
        public List<Response_InputOutputItem> InputsAndOutputs;

        public Response_OpportunityItem( String itemGUID )
        {
            this.ItemGuid = itemGUID;
            this.Errors = new List<Response_Error>();
            this.InputsAndOutputs = new List<Response_InputOutputItem>();
        }

        public void addError( String errorCode, String errorMessage )
        {
            Response_Error newError = new Response_Error();
            newError.ErrorMessage = errorMessage;
            newError.ErrorCode = errorCode;
            this.Errors.add( newError );
        }

        public void addItem( String name, Integer componentType )
        {
            Response_InputOutputItem newItem = new Response_InputOutputItem();
            newItem.Name = name;
            newItem.ComponentType = componentType;
            this.InputsAndOutputs.add( newItem );
        }
    }

    public class Response_Error
    {
        public String ErrorMessage;
        public String ErrorCode;
    }

    public class Response_InputOutputItem
    {
        public String Name;
        public Integer ComponentType;
    }
}