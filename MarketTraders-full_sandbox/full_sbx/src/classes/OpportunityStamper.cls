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
*   Date Created:       4.27.15
*   Author:             Asha Calderon
*   Last Modified:      3.12.2016
*   Last Modified By:   Asha Calderon
*
*   aac updated USC to USOP 10.5.15
*   aac updated field from Sale_TOTAL_Down_Payment__c  to Same_Day_Cash__c from OPP 11.12.16
*   aac added field for roll up sum pulling the Total_Amount_Paid__c field from the Opp to the web attendance 11.12.16
*   aac 3.12.16 expanded to client/backend   
*   
**********************************************************************************************************************/
/**********************************
@description:
Used to stamp webinar attendance record info to the closed won Opps with matching products
Run when update/insert/del for webinar attendance record
For UOC/UTP/LMFS/USOP webinar attendance records as of 10.5.15
Stamp Type field on webinar to match to Opportunity Product field
Find the following based on the product:
First Webinar Attended (LOOKUP field to the WebAttd record)
Latest Webinar Attended (LOOKUP field to the WebAttd record) to the closed date of the opp
Latest Webinar Attended That is greater that 25 min duration (LOOKUP field to the WebAttd record) to the closed date of the opp
***********************************/
public with sharing class OpportunityStamper {
  
    public class StamperException extends Exception {}
  
    private static Map<id,Opportunity> OppMapFromWebAttnd {get; private set;} 
    private static Map<Id, Opportunity> OppMap {get; private set;}
    private static Map<String, List<Opportunity>> OppMapbyProduct {get; private set;}  
    private static List<Webinar_Attendance__c> webinarAttendanceList {get; private set;}
    private static Set<Webinar_Attendance__c> webinarAttendanceUpdateList {get; set;}
    public static Map<id, Webinar_Attendance__c> webinarAttendanceUpdateMap {get; set;}
    private static set<Id> acctIds;
    private static Map<String, Map<String,List<Webinar_Attendance__c>>> WebinarAttendanceMapbyProduct {get; private set;}
    public static List<String> utpwebattndFieldList {get; set;}
    public static List<String> lmfswebattndFieldList {get; set;}
    public static List<String> uocwebattndFieldList {get; set;}
    public static List<String> uscwebattndFieldList {get; set;}
    public static List<String> bewebattndFieldList {get; set;}
    //added 3.12.16 to map opps by rec type instead of product
    static Map<String,ID> opprectypeToProdMap = new Map<String,ID>();
 
    /**
     *  constructor
     */
    public OpportunityStamper(){ }
  
    /**********************
     @method: stampOpportunitiesAsynchronous - asynchronous method
     @description: 
      - query opps with fields to update based on opportunitysetIds param passed into the method
      - iterate through the opportunites from the query and map by Product to list of Opps
      - calls method prepareStamping
     
     @params: 
     opportunitysetIds = list of opp ids passed in from method
      that takes in the webinar attendance records and finds the associated opps (getRelatedOpportunities)
        
    **********/
    @future
    public static void stampOpportunitiesAsynchronous(list<id> opportunitysetIds) {
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([Select id, Amount,Total_Amount_Paid__c ,Same_Day_Cash__c, Sale_TOTAL_Down_Payment__c, AccountId, StageName, Product__c, CloseDate,RecordTypeId, 
                                                                            web_UTP_LastAttd__c, web_UTP_FirstAttd__c, web_UTP_LastAttd25__c,
                                                                            web_LMFS_LastAttd__c, web_LMFS_FirstAttd__c, web_LMFS_LastAttd25__c,
                                                                            web_UOC_LastAttd__c, web_UOC_FirstAttd__c, web_UOC_LastAttd25__c,
                                                                            web_USC_LastAttd__c, web_USC_FirstAttd__c, POS_Cash_Amount__c,
                                                            /* added aac 3.12.16 expanded to client/backend and USOP */
                                                            web_BE_FirstAttd__c,web_BE_LastAttd__c,web_BE_LastAttd50__c,web_USC_LastAttd50__c,
                                                            ClosedWon_Presenter_BE__c,ClosedWon_Presenter_FE__c 
                                                            FROM Opportunity 
                                                            WHERE id in :opportunitysetIds]); 
        acctIds = new Set<ID>();
        OppMapbyProduct = new Map<String, List<Opportunity>>();
        //mapped by record type instead of product name aac 3.12.16 
        List<Opportunity> listofOpps = new List<opportunity>();
        //@info: get the accounts for each opp
        for (Opportunity opp : opportunityMap.values()) {
            if (opp.StageName.equals('Closed Won')) {
               // listofOpps = (OppMapbyProduct.containskey(opp.Product__c)) ? OppMapbyProduct.get(opp.Product__c) : new List<opportunity>();
               listofOpps = (OppMapbyProduct.containskey(opp.RecordTypeId)) ? OppMapbyProduct.get(opp.RecordTypeId) : new List<opportunity>();
               listofOpps.add(opp);
                OppMapbyProduct.put(opp.RecordTypeId, listofOpps);    // OppMapbyProduct.put(opp.Product__c, listofOpps);    
                System.debug('@asha: @debug : OpportunityStamper: Opp Account ID '+ opp.AccountId);
                acctIds.add(opp.AccountId);              
            } 
        }
        //@info: added to skip batch/future calls from the trigger handler while in the future call
        Handler_Account.BYPASS = true;
        prepareStamping();
        Handler_Account.BYPASS = false;
    } 
  

    
  
  
    /**********************
    @method: stampOpportunitiesSynchronous - synchronous method
    @description: 
     - iterate through the opportunites from the map passed as parameter and map by Product to list of Opps
     - adds account id to set acctIds
     - calls method prepareStamping
    
    @params: 
    opportunityMap = passes map of opp ids to Opps passed in from method that takes in 
    webinar attendance records and finds the associated opps (getRelatedOpportunities)
       
    **********/ 
    public static void stampOpportunitiesSynchronous(Map<Id, Opportunity> opportunityMap) {
        acctIds = new Set<ID>();
        OppMapbyProduct = new Map<String, List<Opportunity>>();
        List<Opportunity> listofOpps = new List<opportunity>();
        //@info: get the accounts for each opp
        for (Opportunity opp : opportunityMap.values()) {          
            if (opp.StageName.equals('Closed Won')) {
               // if (!String.isblank(opp.Product__c)) {   changed to record type aac 3.12.16
                if (!String.isblank( opp.RecordTypeId)) {
                    System.debug('@asha : @debug: OpportunityStamper: opp stage is closed won '+ opp.StageName);
                    //changed to record type aac 3.12.16
                    //listofOpps = (OppMapbyProduct.containskey(opp.Product__c)) ? OppMapbyProduct.get(opp.Product__c) : new List<opportunity>();
                    listofOpps.add(opp);
                    OppMapbyProduct.put(opp.RecordTypeId ,listofOpps);   // OppMapbyProduct.put(opp.Product__c ,listofOpps);    
                    System.debug('@asha: @debug : OpportunityStamper: Opp Account ID '+ opp.AccountId);
                    acctIds.add(opp.AccountId);
                }    
            } 
        }
        prepareStamping(); 
    } 
  
    /**********************
     @method: stampOpportunities
     @description: 
     - iterates through the list of updated opps gets the associated account ids and then queries the webinar attendance records
       for those accounts, then updates those webinar attendance records and nullifies the closed won opps on every webinar attendance record
     @param:
      - UpdateOppList pass in the list of opp that have been updated from the opportunity handler trigger function
     @param:
      - OldOppMap pass in the list of old opp to compare stage field, allows a check to see if an opp that was previously closed won was changed
        to not closed won and thus setting any closed won opp fields on the webinar attendances to null
     @return:
      - returns the updated list of webinar attendance records for later update in the opp handler. update done separately to trigger the webinar attendance
        handler after opportunity updates    
    **********/ 
    public static List<Webinar_Attendance__c> stampOpportunities(list<Opportunity> UpdateOppList, Map<id,Opportunity> OldOppMap) { 
        acctIds = new Set<ID>();
        //@info: get the accounts for each opp
        for (Opportunity opp : UpdateOppList) {
            if (opp.StageName.equals('Closed Won')) {
                System.debug('@asha: @debug : OpportunityStamper: Opp Account ID '+ opp.AccountId);
                acctIds.add(opp.AccountId);           
            }
            else {
                if (OldOppMap.get(opp.id).StageName.equals('Closed Won')) {
                    acctIds.add(opp.AccountId); 
                }              
            } 
        }
        getFullWebinarAttendanceList(acctIds);
        for (Webinar_Attendance__c wa : webinarAttendanceList) {
            wa.Closed_Won_Opp__c = null;
        }       
         
        return webinarAttendanceList;        
    } 
  
  
    /**********************
     @method: prepareStamping
     @description: 
     - (utpwebattndFieldList /lmfswebattndFieldList /uocwebattndFieldList )creates a list of the field names needed to update for each product (uoc/lmfs/utp)
     - (WebinarAttendanceMapbyProduct) map Webinar Attendance records by product and then by Account id <(stamp type/product),<(accountid,list webinar attnd)>>
        the webinar attnd records are in order oldest to newest
     - For each UOC/LMFS/UTP product - aac 3.12.16 added BE/USOP
      send each map of accountid to list of webinar attnds to stampByProductType method 
      send list of corresponding opportunities to stampByProductType
      send list of field names depending on product to stampByProductType
     - stampByProductType returns a list of Opps that have been updated and adds it to updatingOpps set
     - all Opps are updated 
        
    **********/ 
    private static void prepareStamping() {
        Set<Opportunity> updatingOpps = new Set<Opportunity>();  
        utpwebattndFieldList = new List<String>();
        utpwebattndFieldList.add('web_UTP_FirstAttd__c'); //first attended
        utpwebattndFieldList.add('web_UTP_LastAttd__c'); //last attended
        utpwebattndFieldList.add('web_UTP_LastAttd25__c'); //last attended with more than 25 min duration 
        lmfswebattndFieldList = new List<String>();
        lmfswebattndFieldList.add('web_LMFS_FirstAttd__c'); //first attended
        lmfswebattndFieldList.add('web_LMFS_LastAttd__c'); //last attended
        lmfswebattndFieldList.add('web_LMFS_LastAttd25__c'); //last attended with more than 25 min duration    
        uocwebattndFieldList = new List<String>();
        uocwebattndFieldList.add('web_UOC_FirstAttd__c'); //first attended
        uocwebattndFieldList.add('web_UOC_LastAttd__c'); //last attended
        uocwebattndFieldList.add('web_UOC_LastAttd25__c'); //last attended with more than 25 min duration
        uscwebattndFieldList = new List<String>(); 
        uscwebattndFieldList.add('web_USC_FirstAttd__c'); //first attended
        uscwebattndFieldList.add('web_USC_LastAttd__c'); //last attended
        uscwebattndFieldList.add('web_USC_LastAttd50__c'); //last attended 50+   added aac 3.12.16 expanded to USOP  
        bewebattndFieldList = new List<String>(); 
        bewebattndFieldList.add('web_BE_FirstAttd__c'); //first attended added aac 3.12.16 expanded to client/backend   
        bewebattndFieldList.add('web_BE_LastAttd__c'); //last attended added aac 3.12.16 expanded to client/backend   
        bewebattndFieldList.add('web_BE_LastAttd50__c'); //last attended 50+   added aac 3.12.16 expanded to client/backend      
        
                //@info: opp record type schema map
            Schema.DescribeSObjectResult describeopp = Schema.SObjectType.Opportunity;
            List<Schema.RecordTypeInfo> rtInfos = describeopp.getRecordTypeInfos();
    
            for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
                opprectypeToProdMap.put(rtInfo.getName(),rtInfo.getRecordTypeId());
            }  
        
        if (acctIds.size() > 0) {
            System.debug('@asha : @debug: OpportunityStamper: account id list size is greater than 0 ');
            //@info:get the webinar attendance for all the associated accounts that are attached to the opps
          
            WebinarAttendanceMapbyProduct = new Map<String, Map<String,List<Webinar_Attendance__c>>>();
            webinarAttendanceList = new List<Webinar_Attendance__c>();
            webinarAttendanceUpdateMap = new Map<id, Webinar_Attendance__c>();
            getFullWebinarAttendanceList(acctIds);
 
            if (webinarAttendanceList.size() > 0) {
                //@info: map Webinar Attendance records by product and then by Account id
                //pull custom setting mapping
                Map<String,OpportunityStamperMapping__c> webinarStampToOppProductMap = OpportunityStamperMapping__c.getall();
                System.debug('@asha : @debug: OpportunityStamper: web attendance greater than 0');
                List<Webinar_Attendance__c> listofwebattnd = new List<Webinar_Attendance__c>();
                for (Webinar_Attendance__c wa : webinarAttendanceList) {
                    listofwebattnd = new List<Webinar_Attendance__c>();
                    String stampToProduct = (webinarStampToOppProductMap.containskey(wa.Webinar__r.StampType__c)) ? webinarStampToOppProductMap.get(wa.Webinar__r.StampType__c).Opportunity_Product__c : wa.Webinar__r.StampType__c;
                    System.debug('@asha : @debug: OpportunityStamper: Webinar Product: ' + wa.Webinar__r.StampType__c +' Stamp product'+stampToProduct);
                    System.debug('@asha : @debug: OpportunityStamper: Account id: ' + wa.Account__r.id);
                    System.debug('@asha : @debug: OpportunityStamper: Adding Webinar Attendance to Maps ');
                           
                    //@info:map accountid to webinar attendance records           
                    Map<String,List<Webinar_Attendance__c>> acctToWebAttd = new Map<String,List<Webinar_Attendance__c>>();
                    if (WebinarAttendanceMapbyProduct.containskey(stampToProduct)) {
                        acctToWebAttd = WebinarAttendanceMapbyProduct.get(stampToProduct);
                        //@info:get list of webinars by account id                         
                        listofwebattnd = (acctToWebAttd.containskey(wa.Account__r.id))? acctToWebAttd.get(wa.Account__r.id) : new List<Webinar_Attendance__c>();
                    }  
                    listofwebattnd.add(wa);
                    acctToWebAttd.put(wa.Account__r.id,listofwebattnd); 
                    System.debug('@asha: @debug : OpportunityStamper: Added account id from Webinar Attendance '+ wa.Account__r.id); 
                    //@info:map product to map account id to list of webinar attendance records              
                    WebinarAttendanceMapbyProduct.put(stampToProduct,acctToWebAttd);
                }
                  
                if (!WebinarAttendanceMapbyProduct.isempty()) {
                    webinarAttendanceUpdateList = new Set<Webinar_Attendance__c>(); //initialize list of webinar attendances to update
                    //@info:stamp the LMFS Opps / micro
                   //aac 3.12.16 changed to rec types- if (OppMapbyProduct.containskey('Live Market Forex Session')){    
                   ID microrectypeid = opprectypeToProdMap.get('Micro');
                   if(OppMapbyProduct.containskey(microrectypeid)){
                       // updatingOpps.addAll(stampByProductType(lmfswebattndFieldList,OppMapbyProduct.get('Live Market Forex Session'), WebinarAttendanceMapbyProduct.get('Live Market Forex Session'))); 
                       updatingOpps.addAll(stampByProductType(lmfswebattndFieldList,OppMapbyProduct.get(microrectypeid), WebinarAttendanceMapbyProduct.get('Live Market Forex Session'))); 
                    }
                    //@info:stamp the UTP Opps
                    //aac 3.12.16 changed to rec types-if (OppMapbyProduct.containskey('UTP OnDemand')) {
                    ID utprectypeid = opprectypeToProdMap.get('Education');
                    if(OppMapbyProduct.containskey(utprectypeid)){  
                       // updatingOpps.addAll(stampByProductType(utpwebattndFieldList,OppMapbyProduct.get('UTP OnDemand'), WebinarAttendanceMapbyProduct.get('UTP OnDemand'))); 
                       updatingOpps.addAll(stampByProductType(utpwebattndFieldList,OppMapbyProduct.get(utprectypeid), WebinarAttendanceMapbyProduct.get('UTP OnDemand')));
                    }                 
                    //@info:stamp the UOC Opps
                    //aac 3.12.16 changed to rec types-if (OppMapbyProduct.containskey('Ultimate Options Course')) { 
                    ID uocrectypeid = opprectypeToProdMap.get('Options');
                    if(OppMapbyProduct.containskey(uocrectypeid)){
                       // updatingOpps.addAll(stampByProductType(uocwebattndFieldList,OppMapbyProduct.get('Ultimate Options Course'), WebinarAttendanceMapbyProduct.get('Ultimate Options Course'))); 
                       updatingOpps.addAll(stampByProductType(uocwebattndFieldList,OppMapbyProduct.get(uocrectypeid),
                       WebinarAttendanceMapbyProduct.get('Ultimate Options Course'))); 
                    }
                    /* aac updated 10.5.15
                    //@info:stamp the USC Opps
                    if (OppMapbyProduct.containskey('Ultimate Stock Course')) { //MSM  
                        updatingOpps.addAll(stampByProductType(uscwebattndFieldList,OppMapbyProduct.get('Ultimate Stock Course'), WebinarAttendanceMapbyProduct.get('Ultimate Stock Course')));     //MSM
                    }   //MSM
                    */
                    //@info:stamp the USOP Opps
                    //aac 3.12.16 changed to rec types-if (OppMapbyProduct.containskey('Ultimate Stock and Options Package')) { //aac added 10.5.15
                    ID usoprectypeid = opprectypeToProdMap.get('Stock');                    
                    if(OppMapbyProduct.containskey(usoprectypeid)){
                       // updatingOpps.addAll(stampByProductType(uscwebattndFieldList,OppMapbyProduct.get('Ultimate Stock and Options Package'), WebinarAttendanceMapbyProduct.get('Ultimate Stock and Options Package')));    
                       updatingOpps.addAll(stampByProductType(uscwebattndFieldList,OppMapbyProduct.get(usoprectypeid), 
                       WebinarAttendanceMapbyProduct.get('Ultimate Stock and Options Package')));
                    }  
                    
                    //@info:stamp the Backend/Client Opps - only if within 2 wks added 3.12.16
                    ID berectypeid = opprectypeToProdMap.get('Continuing Education');
                    if(OppMapbyProduct.containskey(berectypeid)){
                        updatingOpps.addAll(stampByProductType(bewebattndFieldList,OppMapbyProduct.get(berectypeid), 
                        WebinarAttendanceMapbyProduct.get('Backend')));    
                    }  
                }              
            }          
        }
      
        //@info:update the opps with the stamp data
        //List<Opportunity> oppsupdate = new list<Opportunity>();
        Map<id,Opportunity> oppBYIDMap = new Map<id,Opportunity>();
        for(Opportunity o: updatingOpps){
            oppBYIDMap.put(o.id,o);
        }
        //recieving duplicate id errors, updating to map instead to eliminate dups
        //oppsupdate.addall(oppBYIDMap.values());
        update oppBYIDMap.values(); // oppsupdate;
        
        if (webinarAttendanceUpdateList.size() > 0) {
            System.debug('@asha: OpportunityStamper : Updating webinar Attendance records size: '+webinarAttendanceUpdateList.size());
            List<Webinar_Attendance__c> webattndToUpdate = new List<Webinar_Attendance__c>();
            webattndToUpdate.addAll(webinarAttendanceUpdateList);
            //@info: update fires the webinar attnd handler but goes to in progress method instead of main method
            // update webattndToUpdate;            
            update webinarAttendanceUpdateMap.values();
        }
    }
  
    private static void getFullWebinarAttendanceList(Set<Id> accountIds) {
        webinarAttendanceList = [SELECT Id, Name, Account__c ,Account__r.id, Adjusted_Duration__c, Attended__c, Credit_Name__c, Credit_User__c,
                                        Duration__c, Lead__c,Leave_Time__c, OnDemand_Attendance_Date__c, OnDemand_Views__c, Status__c,
                                        Raised_Hands__c, Registration_Date__c, Source_Other__c, Webinar__r.StampType__c, Webinar__c, Webinar__r.PrimaryPresenter__c,
                                        Webinar__r.Product_Presented__c, WEBINAR_Event_Date__c, Join_Time__c, IER_et4ae5_SendDefinition__c,
                                        IER_et4ae5_Send_Number__c, ACCOUNT_Id__c, Closed_Won_Opp__c, isClosedWon__c,
                                        Sale_TOTAL_Down_Payment__c,Total_Amount_Paid__c,Presenter__c  
                                    FROM Webinar_Attendance__c 
                                    WHERE Account__c != null AND Account__r.id IN :acctIds AND Attended__c= true
                                    ORDER BY Join_Time__c ASC
                                    LIMIT 50000];
    }
  
    private static Map<id,Opportunity> getOppMapping(List<Id> webAttdAcctIds) {
        OppMapFromWebAttnd = new Map<id,Opportunity>([SELECT Id, Amount, AccountId, StageName, Product__c, CloseDate, Sale_TOTAL_Down_Payment__c, POS_Cash_Amount__c,RecordTypeId, 
                                                           Same_Day_Cash__c,Total_Amount_Paid__c,
                                                            web_UTP_LastAttd__c, web_UTP_FirstAttd__c, web_UTP_LastAttd25__c,
                                                            web_LMFS_LastAttd__c, web_LMFS_FirstAttd__c, web_LMFS_LastAttd25__c,
                                                            web_UOC_LastAttd__c, web_UOC_FirstAttd__c, web_UOC_LastAttd25__c,
                                                            web_USC_LastAttd__c, web_USC_FirstAttd__c,
                                                            /* added aac 3.12.16 expanded to client/backend and USOP */
                                                            web_BE_FirstAttd__c,web_BE_LastAttd__c,web_BE_LastAttd50__c,web_USC_LastAttd50__c,
                                                            ClosedWon_Presenter_BE__c,ClosedWon_Presenter_FE__c 
                                                        FROM Opportunity
                                                        WHERE StageName = 'Closed Won' AND AccountId != null AND AccountId in: webAttdAcctIds 
                                                        LIMIT 50000]);  
        return OppMapFromWebAttnd;
    }
   
    /**********************
     @method: stampByProductType
     @description: 
     clear the existing webinar attnd lookups
     if the webinar attendances are not empty then stamp all the opps in the oppstoStamp list with the corresponding web attndance record
     list is in order of created date and record in list 0 - first web attnd record, size of webinar attnds list from productMap - 1 - latest attnd
     pass to method findgreaterthan25mins to find the web attnd with a duration over 25 mins or for BE/USOP findgreaterthan50mins for durations over 50 mins
     
     @params:
     webAttndToOppFields - list of fieldnames to update on the opp
     oppsToStamp - list of opportunities
     productMap  - Map of products to list of webinar attendances
        
    **********/ 
    private static List<Opportunity> stampByProductType(List<String> webAttndToOppFields,List<Opportunity> oppsToStamp, Map<String, List<Webinar_Attendance__c>> productMap ) {

        List<Webinar_Attendance__c> webattnds = new List<Webinar_Attendance__c>();                   
              
        for (Opportunity opp : oppsToStamp) {  
            //@info:empty all fields 
            opp.put(webAttndToOppFields[0],null); 
            opp.put(webAttndToOppFields[1],null);
            if (webAttndToOppFields.size() > 2) {                       
                opp.put(webAttndToOppFields[2],null);
            }
            opp.ClosedWon_Presenter_BE__c = webAttndToOppFields[0].contains('web_BE_')? 'N/A' : null;
            opp.ClosedWon_Presenter_FE__c = null;
                     
            //@info:check to see if there are any webinar attendance records that match to the product
            if ((productMap != null) && (!productMap.isEmpty())) {                                
                //@info:get the list of opps that match to this opportunities account id
                System.debug('@asha: @debug : OpportunityStamper: Account Id from Opportunity '+ opp.AccountId); 
                webattnds = (productMap.containskey(opp.AccountId))? productMap.get(opp.AccountId) : new List<Webinar_Attendance__c>() ;
                //@info:web attendance should be in order first to latest
                if (webattnds.size() > 0) {
                    //@info:get the first web attendance record and add it to the field passed in               
                       if (webattnds[0].WEBINAR_Event_Date__c <= opp.CloseDate) {
                            if(!(webAttndToOppFields[0].contains('web_BE_')) || (webAttndToOppFields[0].contains('web_BE_') && (webattnds[0].WEBINAR_Event_Date__c >= opp.CloseDate.adddays(-14)))){
                          		 opp.put(webAttndToOppFields[0],  webattnds[0].id);
                            }
                       }
                    System.debug('@asha:@debug: OpportunityStamper: opp.web_UOC_FirstAttd__c: ' + opp.web_UOC_FirstAttd__c);
                    System.debug('@asha:@debug: OpportunityStamper: opp.web_USC_FirstAttd__c: ' + opp.web_USC_FirstAttd__c);
                    System.debug('@asha:@debug: OpportunityStamper: opp.web_UTP_FirstAttd__c: ' + opp.web_UTP_FirstAttd__c);
                    System.debug('@asha:@debug: OpportunityStamper: opp.web_LMFS_FirstAttd__c: ' + opp.web_LMFS_FirstAttd__c);
                    System.debug('@asha:@debug: OpportunityStamper: opp.web_BE_FirstAttd__c: ' + opp.web_BE_FirstAttd__c);                  
                    //@info:get the last web attendance record and add it to the field passed in               
                    //aac updated 6.19.15 with info for the closed won date -  before the closed won date  
                    //should be marked
                    Webinar_Attendance__c lastattnd = null;   
                    for (Integer i = webattnds.size()- 1; i >= 0; i--) {
                        System.debug('@asha: opportunitystamper: webinar event date:'+webattnds[i].WEBINAR_Event_Date__c+' opp close date'+ opp.CloseDate);
                        if (webattnds[i].WEBINAR_Event_Date__c <= opp.CloseDate) {
                            //backend web need to be within 2 wks of the closed date otherwise not stamped - date already less than closed date 
                            if(webAttndToOppFields[0].contains('web_BE_') && (webattnds[i].WEBINAR_Event_Date__c >= opp.CloseDate.adddays(-14))){
                                lastattnd = webattnds[i];
                                break;
                            }else{
                                //not a backend then stamp the field since met before close date condition
                                if(!webAttndToOppFields[0].contains('web_BE_')){
                                    lastattnd = webattnds[i];
                                    break;
                                }
                                
                            }
                        }
                    } 
                                
                    if (lastattnd != null) {        
                        opp.put(webAttndToOppFields[1],  lastattnd.id);  
                        
                        //update the opportunity frontend or backend presenter field; USC/USOP/UOC/UTP - frontend ; backend - cont ed;
                        //determine which field to update ClosedWon_Presenter_BE__c  or ClosedWon_Presenter_FE__c
                        String presenterfield = (webAttndToOppFields[1].contains('web_BE_'))? 'ClosedWon_Presenter_BE__c': null;
                        presenterfield = (webAttndToOppFields[1].contains('web_UTP_') ||
                        webAttndToOppFields[1].contains('web_USC_') ||
                        webAttndToOppFields[1].contains('web_UOC_'))? 'ClosedWon_Presenter_FE__c': presenterfield;
                        
                        //update the presenter field
                        if(lastattnd.Webinar__r.PrimaryPresenter__c != null && presenterfield != null){
                            opp.put(presenterfield, lastattnd.Webinar__r.PrimaryPresenter__c);
                        }
                    }else{
                       opp.ClosedWon_Presenter_BE__c = (webAttndToOppFields[1].contains('web_BE_'))? 'N/A' : opp.ClosedWon_Presenter_BE__c;                        
                    } 
   
                    //@info:get the last web attendance record  > 25 min duration and add it to the field passed in               
                    Webinar_Attendance__c lastmorethan25 = findgreaterthan25mins(webattnds,opp.CloseDate);
                    //@info:get the last web attendance record  > 50 min duration
                    Webinar_Attendance__c lastmorethan50 = findgreaterthan50mins(webAttndToOppFields[0].contains('web_BE_'),webattnds,opp.CloseDate);
                    if (((lastmorethan25 != null && !webAttndToOppFields[0].contains('web_BE_'))|| 
                    lastmorethan50 != null) && 
                    (webAttndToOppFields.size() > 2)){
                        //update to > 50 if the field is for lastattd50 duration - added aac 3.12.16 expanded to client/backend and USOP 
                        lastmorethan25 = (webAttndToOppFields[2].contains('LastAttd50') && (lastmorethan50 != null))? lastmorethan50 : lastmorethan25;
                        system.debug('@asha: opportunitystamper: updating webinar attnd field: '+webAttndToOppFields[2]+' 25+='+lastmorethan25.id); 
                        if(lastmorethan50 != null){
                        	system.debug('@asha: opportunitystamper: updating webinar attnd field: 50+ id: '+lastmorethan50.id); 
                        }
                        //update latest 25+/50+ webinar attendance with Opp
                        opp.put(webAttndToOppFields[2], lastmorethan25.id);
                        System.debug('@asha: opportunitystamper: updating webinar attnd: '+lastmorethan25.id+' with opp id: '+opp.id); 
                        lastmorethan25.Closed_Won_Opp__c = opp.id; 
                        lastmorethan25.isClosedWon__c = true;
                        lastmorethan25.Opp_Clsd_Won_Amnt__c = opp.Amount;
                        //aac updated field 
                        lastmorethan25.Sale_Total_Down_Payment__c = opp.Same_Day_Cash__c; //old field Sale_TOTAL_Down_Payment__c;  
                        //added field for roll up sum pulling the Total_Amount_Paid__c field from the Opp aac 1.12.16
                        lastmorethan25.Total_Amount_Paid__c = opp.Total_Amount_Paid__c;
                        webinarAttendanceUpdateList.add(lastmorethan25);
                        webinarAttendanceUpdateMap.put(lastmorethan25.id,lastmorethan25);
                    }                     
                }
            } 
        } 
        
        return oppsToStamp;
    }

    /**********************
     @method: getRelatedOpportunities
     @description: 
     iterate through webinar attendance records, if attended then add webinar attnd account to the list of account ids (webattnacctids)
     get all the corresponding opportunites by the account ids found
     send ids or map of ids to opps to method stampOpportunitiesSynchronous or stampOpportunitiesAsynchronous depending on if being run from batch/future call or 
     being run from standard trigger
    
     @params:
     webAttendanceMap - map of webinar attendance ids to webinar attendance records passed in from trigger ( WebinarAttendanceTrigger > Handler_WebinarAttendance > OpportunityStamper)
     
         
    **********/ 
    public static void getRelatedOpportunities(Map<Id,Webinar_Attendance__c> webAttendanceMap) {
        webinarAttendanceList = webAttendanceMap.values();
        Set<Opportunity> oppset = new Set<Opportunity>();
        OppMapFromWebAttnd = new Map<ID,Opportunity>();
        List<Id> webAttdAcctIds = new List<id>();
        for (Webinar_Attendance__c wa : webAttendanceMap.values()) {
            if (wa.Attended__c) {
                webAttdAcctIds.add(wa.Account__c);
            }
        }
    
        if (webAttdAcctIds.size() > 0) {
    
            OppMapFromWebAttnd = getOppMapping(webAttdAcctIds);        
            if (OppMapFromWebAttnd.size() > 0) {
                List<id> oppids = new list<id>();
                oppids.addAll(OppMapFromWebAttnd.keyset());
                //@info: allows skipping at future call if batch process is running
                //all batch processors have Handler_Account.BYPASS = true for when upsert/update/insert leads,accts,opps
                System.debug('@asha: IsFuture:'+System.isFuture() + ' isBatch:'+System.isBatch());
                if (!Handler_Account.BYPASS && (!System.isBatch() && !System.isFuture())) {          
                    stampOpportunitiesAsynchronous(oppids);
                }
                else {
                    stampOpportunitiesSynchronous(OppMapFromWebAttnd);
                }
            }  
        }
    }



    /**********************
     @method: findgreaterthan25mins
     @description: 
        finds webinar attendance record with a duration of longer than 25 mins
        changed 6.19.15 to only look at attendances before the closed won date
        if none found returns null;
        if none found returns null;
        returns webinar attendance record found
     @params:
     listwebattendance - list of webinar attendance records
         
    **********/ 
    private static Webinar_Attendance__c findgreaterthan25mins(list<Webinar_Attendance__c> listwebattendance, Date clsddt) {
        Webinar_Attendance__c wafound = null;
        for (Integer i = listwebattendance.size() - 1; i >= 0; i--) {
            Webinar_Attendance__c w = listwebattendance[i];
            if (w.WEBINAR_Event_Date__c <= clsddt) {
                System.debug('Adjusted Duration ' + w.Adjusted_duration__c);
                wafound = (w.Adjusted_Duration__c > 25) ?  w : wafound;
                System.debug('wafound ' + wafound);
                if (wafound != null) {
                    break;
                }
            }
        }
        
        return wafound;
    }  
    
    /**********************
     @method: findgreaterthan50mins
     @description: 
        finds webinar attendance record with a duration of longer than 50 mins
        added 3.12.16
        if none found returns null;
        if none found returns null;
        returns webinar attendance record found
     @params:
     listwebattendance - list of webinar attendance records
         
    **********/ 
    private static Webinar_Attendance__c findgreaterthan50mins(Boolean isBE,list<Webinar_Attendance__c> listwebattendance, Date clsddt) {
        Webinar_Attendance__c wafound = null;
        for (Integer i = listwebattendance.size() - 1; i >= 0; i--) {
            Webinar_Attendance__c w = listwebattendance[i];
            //if its a Backend then check for if its within 2 wks of the close date first
            if (w.WEBINAR_Event_Date__c <= clsddt && (!isBE || (isBE && w.WEBINAR_Event_Date__c >= clsddt.adddays(-14)))) { 
                System.debug('Adjusted Duration ' + w.Adjusted_duration__c);
                wafound = (w.Adjusted_Duration__c > 50) ?  w : wafound;
                System.debug('wafound ' + wafound);
                if (wafound != null) {
                    break;
                }
            }
        }
        
        return wafound;
    }  
    
}