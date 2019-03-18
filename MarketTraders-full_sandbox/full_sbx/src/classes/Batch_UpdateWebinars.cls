/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       ???
*   Author:             ???
*   Last Modified:      6/9/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
/********************************
*
* @description: used to callout to Citrix to add the webinars to the org, works with the credential obj
*  and the webinartype_credential custom setting.
* 
**/
global class Batch_UpdateWebinars implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    /**************************************
    * @method updateMasterAccount
    *
    * @description
    * method added to prevent any of the black listed fields from being copied from the dup
    *  
    * @since 4.9.15
    * 
    * @params oldmaster the copy of the master account
    * @params newmasterID the id of the resulting master account after the merge
    *
    **/
    global final String Query;
    //custom settings map
    public Map<String, WebinarType_Credential__c> webinarToCredential = new Map<String, WebinarType_Credential__c>();
    
    /**************************************
    *
    * @description:
    * constructor
    *  
    * @params: 
    * query - batch query string for webinar credentials object records
    *
    **/
    global Batch_UpdateWebinars(){
        Query = 'SELECT Token__c,Org_ID__c,Provider__c,Credentials_ID__c,Mnemonic__c FROM Webinar_Credentials__c';
    }
 
    /**************************************
    * @method start
    *
    * @description
    * required method for batch processes; uses query locator
    *  
    * @since 4.9.15
    * 
    * @params BC - batchable context 
    * 
    *
    **/ 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }


    /**************************************
    * @method execute
    *
    * @description
    * iterates over the webinar credetials return from the query, for each credential it
    * calls the method that does the callout to citrix, takes the returned webinars
    * and then upserts webinars to the database
    *  
    * 
    * @params credentials - the webinar credentials list returned from the query done in the start method
    *
    **/
    global void execute(Database.BatchableContext BC, List<Webinar_Credentials__c> credentials){
        Logger logger = new Logger();
        for(Webinar_Credentials__c credential : credentials){
            list<Webinar__c> webinars = new list<Webinar__c>();
            if(credential.Provider__c == 'Citrix'){
                list<CitrixWebinar> citrixWebinars;
                citrixWebinars = this.parseUpcomingCitrixWebinars(credential.Org_ID__c,credential.Token__c);
                webinars.addAll(this.getWebinarsToUpsert(credential.Credentials_ID__c,credential.Mnemonic__c,citrixWebinars));
            }
            if(!webinars.isEmpty()){
                list<Database.UpsertResult> results = Database.upsert(webinars,Webinar__c.Webinar_ID__c,false);
                for(Database.UpsertResult result : results){
                    if(!result.isCreated() || !result.isSuccess()){
                        for(Database.Error error : result.getErrors()){
                            logger.log(error.getMessage());
                        }
                    }
                }
            }
        }
        logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
    }

    /**************************************
    * @method finish
    *
    * @description
    * required method for batch processes - schedules the next occurring run for the batch callout
    *  
    * 
    * @params Database.BatchableContext - batchinable context for batch processes
    *
    **/
    global void finish(Database.BatchableContext BC){
        Batch_UpdateWebinars updateWebinars = new Batch_UpdateWebinars();
        if(!test.isRunningTest())
            System.scheduleBatch(updateWebinars,'Update Webinars' + String.valueOf(DateTime.now()),60, 1);
    }

    /**************************************
    * @method getWebinarsToUpsert
    *
    * @description
    * queries the webinar credential object and gets the data from the custom setting (webinartype_credential)
    * iterates through the returned citrixwebinars and updates the data
    * 
    * @params credentialsId - used to query the credential ; value is unique for each record
    * @params mnemonic - unique value for the credentials records
    * @params citrixWebinars - passes in the webinars from the callout uses the class CitrixWebinar as record templates
    * @params webinars - returns the updated webinars
    *
    **/  
    public list<Webinar__c> getWebinarsToUpsert(String credentialsId,String mnemonic,list<CitrixWebinar> citrixWebinars){
        Webinar_Credentials__c credentials = [SELECT id,Name,Mnemonic__c FROM Webinar_Credentials__c WHERE Credentials_ID__c = :credentialsId];
        Map<String, WebinarType_Credential__c> webinarToCredential = WebinarType_Credential__c.getAll();
        list<Webinar__c> webinars = new list<Webinar__c>();
        for(CitrixWebinar citrixwebinar : citrixWebinars){
            Webinar__c webinar = new Webinar__c();
            if(citrixwebinar.subject.length() > 80){     
                webinar.Name = citrixwebinar.subject.substring(0,80);
            }else{
                webinar.Name = citrixwebinar.subject;
            }    
            webinar.Webinar_Credentials__c = credentials.id;
            webinar.Description__c = citrixwebinar.description;
            webinar.Webinar_ID__c = citrixwebinar.webinarKey;
            webinar.Platform__c = 'Citrix';
            /*if(credentials.Name == 'Options'){
                webinar.Webinar_Type__c = 'Ultimate Options Course';
            }else if(credentials.Name == 'Client'){
                webinar.Webinar_Type__c = 'Continued Education';
            } aac 3 20 2015 changed to custom setting */
            if(webinarToCredential.containskey(credentials.Mnemonic__c)){
                webinar.Webinar_Type__c = webinarToCredential.get(credentials.Mnemonic__c).Webinar_Type__c;
            }
                        
            if(citrixwebinar.times != null && citrixwebinar.times[0].startTime != null){
                DateTime dateTimeFromCitrix = DateTime.valueOfGmt(citrixwebinar.times[0].startTime.replace('T',' '));
                webinar.Event_Date_Time__c = dateTimeFromCitrix;
                webinars.add(webinar);
            }   
        }
        return webinars;
    }
    

    /**************************************
    * @method parseUpcomingCitrixWebinars
    *
    * @description
    * does callout to citrix, uses class CitrixWebinarJSONHandler to deserialize the data into records for the webinar object
    *  
    * 
    * @params orgId the username for the citrix account where the webinar was setup
    * @params authToken the token needed to connect to citrix stored in the webinar credentials obj
    * @params webinarHandler.webinars - returns the list of webinars using the class webinarHandler
    *
    **/    
    public list<CitrixWebinar> parseUpcomingCitrixWebinars(String orgId,String authToken){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.citrixonline.com/G2W/rest/organizers/'+ orgId +'/upcomingWebinars');
        req.setMethod('GET');
        req.setHeader('Accept','application/json');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization','OAuth oauth_token=' + authToken);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        CitrixWebinarJSONHandler webinarHandler = (CitrixWebinarJSONHandler)JSON.deserialize('{"webinars":' + res.getBody() + '}',CitrixWebinarJSONHandler.class);
        return webinarHandler.webinars;
    }

}