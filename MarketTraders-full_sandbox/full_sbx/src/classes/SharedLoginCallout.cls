/**********************************************************************************************************************
*  Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*  [2015] Market Traders Institute
*  All Rights Reserved
*
*  NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*  suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*  Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*  protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*  is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*  Date Created:   4/6/2015
*  Author:        Asha Calderon
*  Last Modified:    7/15/2015
*  Last Modified By:  Asha Calderon
*
*   
*   
**********************************************************************************************************************/

global class SharedLoginCallout implements Database.Batchable<sObject>,Database.AllowsCallouts {
  
  global String Query;
  global Logger logger;
  global Boolean err; 
  global Set<Account> updateuser;
    
/****************************
    @method: 
    SharedLoginCallout
    
    @description:
    Constructor
    
    @param:
    query - batch query string for Account object records
    
**/   

  global SharedLoginCallout(){
     updateuser = new set<Account>();
      logger = new Logger();
      err = false;
    Query = 'SELECT id, PersonEmail,FirstName, LastName, Country_List__c,Phone, Sub_End_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc,'; 
    Query += 'ForexTips_Username__c,Moodle_Start_Date__c, Moodle_Username_College__c,'; 
    Query += 'UCS_User_Password__c, UCS_Username__c, PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c FROM Account';
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
    * iterates over the accounts returned from the query, for each account it
    * calls the method that does the callout to the UCS endpoint which is set in the sharedlogininfo custom setting field,
    * it sends the endpoint url from the custom settting, the UCS type - the callout is setup to handle more than UCS callout,
    * and the account record 
    * 
    * @params BC - batchable context 
    * @params loginlist - a list of accounts    
    *
    **/  
  global void execute(Database.BatchableContext BC, List<Account> loginlist){
      HTTPResponse response = new HTTPResponse();
         Map<String, SharedLoginInfo__c> endpointsmap = new Map<String, SharedLoginInfo__c>();
         endpointsmap = SharedLoginInfo__c.getAll();

      for(Account acct : loginlist){
        //ucs callout endpoint 
            if(!test.isRunningTest()){
                 //todo: change url back to https and on the remote site detail too
                 //UCS   
                try { 
                    String urlenpt = (String.isblank(endpointsmap.get('UCS').url__c))?'http://dev.api.markettraders.com/app_dev.php/v1/ucsapp/users':endpointsmap.get('UCS').url__c;                             
                    response = sharedLoginEndpoint(urlenpt ,'UCS', acct);
                    System.debug('@asha:@debug: SharedLoginCallout:'+ response.getStatusCode() );
                    System.debug('@asha: @debug: SharedLoginCallout :: '+ response);
                } catch(System.CalloutException e) {
                    System.debug('@asha: @debug: SharedLoginCallout : Callout error: '+ e);
                    System.debug(response.toString());
                    logger.log('ERROR: Shared Login Callout: Account:'+ account.id );
                    logger.log(response.getBody());
                    err = true;
                }              
            }
            
                    
        //determine if response was ok  
        Integer resheader = response.getStatusCode();      
        if(resheader != 200){ //check if res ok if not then send error msg and create log
            system.debug(resheader);
            logger.log('ERROR: Shared Login Callout: Account:'+ acct.id );
            logger.log(response.getBody());
            err= true;
        }
        /*   HTTPResponse response = new HTTPResponse();
         if(!test.isRunningTest()){
                 //todo: change url back to https and on the remote site detail too
                 //MOODLE
               try {              
                    response = sharedLoginEndpoint('http://api.markettraders.com/shared-login/','MOODLE', acct);   
                    System.debug('@asha:@debug: SharedLoginCallout:'+ response.getStatusCode() );
                    System.debug('@asha: @debug: SharedLoginCallout :: '+ response);
                } catch(System.CalloutException e) {
                    System.debug('@asha: @debug: SharedLoginCallout : Callout error: '+ e);
                    System.debug(response.toString());
                    logger.log('ERROR: Shared Login Callout: Account:'+ account.id );
                    logger.log(response.getBody());
                    err = true;
                }    
        
                //AOD
                //response = sharedLoginEndpoint('http://api.markettraders.com/shared-login/','AOD', acct);
            }*/
            //adds to list of accounts to update at the end of the batch process
            updateuser.add(acct);
        }
      //send error log
    if(err){ 
     logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});        
    }
  }
  
     /**************************************
    * @method finish
    *
    * @description
    * required method for batch processes - updates the accounts with the username and password if successfully sent to callout endpoint
    *  
    * 
    * @params Database.BatchableContext - batchinable context for batch processes
    *
    **/ 
  global void finish(Database.BatchableContext BC){
      List<Account> listofaccts = new List<Account>();
      listofaccts.addAll(updateuser);
      update listofaccts;
  }
  
     /**************************************
    * @method sharedLoginEndpoint
    *
    * @description
    * does callout to endpoint
    *  
    * 
    * @params urlstr - the endpoint url
    * @params type - supports only UCS as this time but could be expanded
    * @params account - account record to gather date from, sent to endpoint
    *
    **/     
  public HTTPResponse sharedLoginEndpoint(String urlstr, String type, Account account ){
      if(!String.isblank(account.PersonEmail)){
        

        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        //custom settings map
          Map<String, SharedLoginInfo__c> custsettingendpoints = new Map<String, SharedLoginInfo__c>();
          custsettingendpoints = SharedLoginInfo__c.getAll();
          
                    //aac 7.15.15 added country code to send code instead of full country name to ucs backoffice
                  //uses UCSCountryCodes custom setting         
         Map<String, UCSCountryCodes__c> countrycodemap = new Map<String, UCSCountryCodes__c>();
         countrycodemap = UCSCountryCodes__c.getAll();
        //req.setTimeout(60000);
          //default for ucs
          String endptBody = '';
          /*if(type.equals('AOD')){  
            endptBody = '?handle=';
          }else{*/
              if(type.equals('UCS')){
                      String versionstr =  '1.1.2.0';
                      String typestr = '0';
                  endptBody += '?login='+ account.PersonEmail +'&username='+ account.PersonEmail +'&password=password1&sfid='+ account.id+'&forcedpasswordchange=1';
                  if(custsettingendpoints.get('UCS') != null){
                      versionstr = (String.isblank(custsettingendpoints.get('UCS').version__c))? '1.1.2.0':custsettingendpoints.get('UCS').version__c;
                      typestr = (String.isblank(custsettingendpoints.get('UCS').type__c))? '0':custsettingendpoints.get('UCS').type__c;
                  }
                  //time conversion to Unix time
                  Time midnighthour = Time.newInstance(11, 59, 59, 0);
                  Datetime createdt = datetime.now().adddays(-1); 
                  Datetime forexdt = (account.PB_SubEnd_UCSForex__c != null)? datetime.newInstance(account.PB_SubEnd_UCSForex__c,midnighthour) : null; 
                  Datetime stocksdt = (account.PB_SubEnd_UCSStocks__c != null)? datetime.newInstance(account.PB_SubEnd_UCSStocks__c,midnighthour) : null;          
                  Datetime webforexdt = (account.Sub_End_Ultimate_Charting_Pro_Forex__pc != null)? datetime.newInstance(account.Sub_End_Ultimate_Charting_Pro_Forex__pc,midnighthour) : null; 
                  Datetime webstocksdt = (account.Sub_End_Ultimate_Charting_Pro_Stocks__pc != null)? datetime.newInstance(account.Sub_End_Ultimate_Charting_Pro_Stocks__pc,midnighthour) : null;           
                 // Datetime alldt = (account.PB_SubEnd_UCSALL__c != null)? datetime.newInstance(account.PB_SubEnd_UCSALL__c,midnighthour) : null; 
                  Datetime enddt = null;
                  if(forexdt != null && stocksdt != null){
                     enddt = (forexdt > stocksdt) ? forexdt : stocksdt; 
                  }else{
                     enddt = (stocksdt != null) ? stocksdt : forexdt;           
                  }
                  //enddt = (> enddt)? stocksdt : enddt;
                  
                            
                  String unixForexTime =(forexdt != null)? ''+forexdt.getTime()/*/1000 */: null;
                  String unixStocksTime = (stocksdt != null)? ''+stocksdt.getTime()/*/1000*/ : null;
                  String unixWebForexTime =(webforexdt != null)? ''+webforexdt.getTime()/*/1000 */: null;
                  String unixWebStocksTime = (webstocksdt != null)? ''+webstocksdt.getTime()/*/1000*/ : null;
                  //String unixAllTime =(alldt != null)? ''+alldt.getTime()/1000 : null;
                  String unixenddate = (enddt != null)? ''+enddt.getTime()/* /1000*/ : null;
                  String unixcreatedt = ''+createdt.getTime()/*/1000*/;
                  String unixstartdt = ''+datetime.now().getTime();
                  //add the datetime fields
                 // endptBody +='&enddateall='+unixAllTime+'&enddatestock='+unixStocksTime+'&enddateforex='+unixForexTime;
                   endptBody +='&enddatestock='+unixStocksTime+'&enddateforex='+unixForexTime;
                   endptBody +='&enddatewebstock='+unixWebStocksTime+'&enddatewebforex='+unixWebForexTime;
                  //aac 7.15.15 added country code to send code instead of full country name to ucs backoffice
                  //uses UCSCountryCodes custom setting 
                  String accountCountry = (!string.isblank(account.Country_List__c))? account.Country_List__c : null;
                  accountCountry = (accountCountry == 'Northern Mariana Islands (US Territory)' || accountCountry == 'Northern Mariana Islands (US Territory)')? accountCountry.left(24) : accountCountry;
                  UCSCountryCodes__c countrycode = (countrycodemap.containskey(accountCountry))? countrycodemap.get(accountCountry) : null;
	              String countryinfo = ((countrycode != null) && (countrycode.CountryCode__c != null)) ? countrycode.CountryCode__c : 'US';
                 //String countryinfo = (!String.isblank(account.Country_List__c))? EncodingUtil.urlEncode(account.Country_List__c, 'UTF-8') : null;
                  String phoneinfo = (!String.isblank(account.Phone)) ? EncodingUtil.urlEncode(account.Phone, 'UTF-8') : null;
                  // additional fields
                  endptBody += '&createddate='+ unixcreatedt ;
                  endptBody += '&enddate=' +unixenddate ;
                  endptBody += '&startdate=' + unixstartdt;
                  endptBody += '&firstname='+account.FirstName;
                  endptBody += '&lastname='+account.LastName;
                  endptBody += '&country='+ countryinfo;
                  endptBody += '&email='+account.PersonEmail;
                  endptBody += '&phone='+ phoneinfo;
                  endptBody += '&version='+ versionstr;
                  endptBody += '&type='+ typestr;
    
              }else{
                  if(type.equals('MOODLE')){
                     endptBody = '';
                  }              
              }         
          //}
          
        System.debug(LoggingLevel.ERROR, '@@@@ shared login callout url string: ' + urlstr);
        System.debug(LoggingLevel.ERROR, '@@@@ shared login callout endpoint body: ' + endptBody);
        
        req.setEndpoint(urlstr);
        req.setBody(endptBody);    
        req.setMethod('POST');      
        //req.setCompressed(true); // otherwise we hit a limit of 32000          
        
        res = http.send(req);    
        return  res; 
    } 
    return null;  
 }
 
 
    /**************************************
    * @method sharedLoginPullBack
    *
    * @description
    * does callout to endpoint to get information from endpoint - not currently used
    *  
    * 
    * @params urlstr - the endpoint url
    * @params authToken - token if needed
    * @params account - account record to gather date from, sent to endpoint
    *
    **/   
   public String sharedLoginPullBack(String urlstr, String authToken ,Account account ){
   if(!String.isblank(account.PersonEmail)){
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    HTTPResponse res = new HTTPResponse();
   
    req.setEndpoint(urlstr); 
    req.setHeader('Accept','application/json');
    req.setHeader('Content-Type','application/json');
    req.setHeader('Authorization','OAuth oauth_token=' + authToken);    
    req.setMethod('GET');      
    req.setCompressed(true); // otherwise we hit a limit of 32000
       
    try {
       res = http.send(req);
        System.debug('@asha:@debug: SharedLoginCallout:'+ res.getStatusCode() );
    } catch(System.CalloutException e) {
        System.debug('@asha: @debug: SharedLoginCallout : Callout error: '+ e);
        System.debug(res.toString());
        logger.log('ERROR: Shared Login Callout: Account:'+ account.id );
        logger.log(res.getBody());
        err = true;
    }    
    

    

    return  res.getBody();  
    }else{
        logger.log('ERROR: Shared Login Callout: No email address found for Account:'+ account.id );
        err = true; 
    }
          
    return null; 
 }

}