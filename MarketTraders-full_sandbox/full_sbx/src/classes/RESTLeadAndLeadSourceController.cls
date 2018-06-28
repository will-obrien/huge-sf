/***************************
* RESTLeadAndLeadSourceController
* @description: API endpoint for creating lead and lead source object records
* 
*   Author:             Asha Calderon
*   Date Created:       1/10/2015
*   Last Modified:      1/10/2015
*   Last Modified By:   Asha Calderon
*
**********************************/
@RestResource(urlMapping='/CreateLeadAndLeadSourceRecords/*')
global with sharing class RESTLeadAndLeadSourceController{

//EndPoint: https://na4.salesforce.com/services/apexrest/CreateLeadAndLeadSourceRecords
//responses

//get lead sources attached to a particular lead JSON array of lead sources
// ?ldid=[leadid]
@HttpGet
    global static ResponseHandler getLeadSourcesByLead(){
    
        String lead_id = RestContext.request.params.get('ldid');
        List<sObject> thesObjectList = new List<sObject>();
        List<Lead_Sources__c> returnedLeadSources = [ Select id, Name, Lead__c, Lead__r.FirstName, Lead__r.LastName, Email_at_last_edit__c, 
        Lead_Source__c, Lead_Source_Date__c, Lead_Source_Detail__c, URL__c, IP_Address__c, Product__c, Cake_Conversion_Date__c,
        Offer__c, Offer_Type__c, Created_By_API__c from Lead_Sources__c Where Lead__c =: lead_id ];
        ResponseHandler res = new ResponseHandler();
        thesObjectList.addAll((List<sObject>) returnedLeadSources);
        res.Data = thesObjectList;
        res.Status = 'Success';
        res.Message = null;
        return res;
    }   
    
//send data as {"lead_FirstName":"Trader","lead_LastName":"Trader","lead_email":leadsource_name}    
//returns a ResponseHandler - see ResponseHandler class for details 
@HttpPost
    global static ResponseHandler createLeadAndLeadSource(String FirstName, String LastName, String email, String lead_source, String url , String lead_source_detail, String lead_source_content,String product,String clickid, String subid, String ip_address,String offertype, String offer, String createdbyapi, String recordtype, String phone, String cityaddress, String countryaddress  ){
         
         Map<string, ID> leadrectypemap = recTypeID();
         ResponseHandler res = new ResponseHandler();
         List<sObject> thesObjectList = new List<sObject>();
         Lead newlead = new Lead();
         Lead_Sources__c newleadsource = new Lead_Sources__c();
         
         //must have a last name and a phone number or email address
         if(!String.isblank(LastName) && (!String.isblank(email) || !String.isblank(phone))){
             //lead fields
             
             newlead.RecordTypeID = (!String.isblank(recordtype) && leadrectypemap.containskey(recordtype))? leadrectypemap.get(recordtype)  : leadrectypemap.get('Education');
             newlead.LastName = LastName;
             newlead.status = 'New Lead';
             newlead.CountryList__c = (!String.isblank(countryaddress))? countryaddress : 'United States of America';
             newlead.FirstName = FirstName; 
            newlead.Email = email; 
            newlead.Phone = phone; 
            //newlead.LeadSource = lead_source; 
            newlead.IP_Address__c = ip_address; 
            if(!string.isblank(createdbyapi)){
                newlead.Created_By_API__c = true; 
             } 
          // newlead.Address = StreetAddress; 
            newlead.City = cityaddress; 
             
             
             //lead source field

             //newleadsource.FirstName = FirstName; 
             //newleadsource.LastName = LastName; 
             newleadsource.Email_at_last_edit__c = email; 
             newleadsource.Lead_Source__c = lead_source; 
             newleadsource.Lead_Source_Detail__c = lead_source_detail; 
            //TODO - add in FULL newleadsource.Lead_Source_Content__c = lead_source_content;
             newleadsource.Product__c = (!string.isblank(product))? product : 'UTP';
             newleadsource.ClickID__c = clickid; 
             newleadsource.Sub_ID__c = subid; 
             newleadsource.IP_Address__c = ip_address;
             newleadsource.Offer_Type__c = offertype; 
             newleadsource.Offer__c = offer; 
             newleadsource.Created_By_API__c = createdbyapi; 
             newleadsource.URL__c = url;
            
         }else{
            res.Status = 'ERROR DATA - Required Fields Missing';
            res.Message= 'Lastname isBlank: '+String.isblank(LastName)  +';Email isBlank: '+ String.isblank(email) +';Phone isBlank: '+String.isblank(phone);
            return res;
         }
        try{
            if(newlead != null){
                String errmsg = '';
                Database.SaveResult savedldResult = Database.insert(newlead, false);
                if (savedldResult.isSuccess()) {                                   
                    newleadsource.Lead__c = savedldResult.getId();                  
                    thesObjectList.add((sObject)newlead);
                  if(newleadsource.Lead_Source__c != null){     
                        Database.SaveResult savedldsrcResult = Database.insert(newleadsource, false);
                         if (savedldsrcResult.isSuccess()) {                                
                            thesObjectList.add((sObject)newleadsource);
                            res.Data = thesObjectList;
                            res.Status = 'Success';
                            res.Message = null;
                         }else{  
                            res = createErrorResponse(res, savedldsrcResult.getErrors(), thesObjectList, false,true);                     
                         }
                   }else{
                        res.Data = thesObjectList;
                        res.Status = 'ERROR ON INSERT - Lead Success: Lead Source Failed';
                        res.Message = 'Lead Source missing from Lead Source object'; 
                    }
                }else{
                    res = createErrorResponse(res, savedldResult.getErrors(), thesObjectList, true,false);             
                }
            }else{
                res.Data = thesObjectList;
                res.Status = 'ERROR BEFORE INSERT - Lead Null';
                res.Message = 'Lead was null';
            }
        }catch(DmlException e){
            res.Status = 'ERROR ON INSERT - DMLException';
            res.Message= e.getMessage();
        }
        
        return res;
    }

 public static Map<String, ID> recTypeID(){
        
        Map<String, ID> newmap = new Map<String, ID>();
        Schema.DescribeSObjectResult describeld = Schema.SObjectType.Lead;
        List<Schema.RecordTypeInfo> rtInfos = describeld.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
            newmap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
        }
        
        return newmap;
    }
    

    public static ResponseHandler createErrorResponse(ResponseHandler r, List<Database.Error> errlist, List<sObject> errthesObjectList, Boolean leaderr,Boolean ldsrcerr ){
        string errmessage = '';
        for(Database.Error err : errlist) {
            System.debug('@asha: @debug: RESTLeadAndLeadSourceController : Lead Error: '+leaderr+'Lead Source Error: '+ldsrcerr+' code:'+ err.getStatusCode() + ': ' + err.getMessage());                   
            System.debug('Fields that affected this error: ' + err.getFields());
            errmessage += 'RESTLeadAndLeadSourceController: Lead Error: '+leaderr+'Lead Source Error: '+ldsrcerr+' code:'+ err.getStatusCode() + ': ' + err.getMessage()+ ' Field errors: ' + err.getFields();
        }
        r.Data = errthesObjectList;
        r.Status = 'ERROR ON INSERT - Lead Failed: '+leaderr+' Lead Source Failed: '+ldsrcerr;
        r.Message = errmessage; 
        return r;
    }
    
}