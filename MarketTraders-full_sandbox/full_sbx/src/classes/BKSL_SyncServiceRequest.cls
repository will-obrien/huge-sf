/**
* This is a Apex Trigger in Booking social
* The program implements an application that
* Sync service request
*
*
*
* @author        : Vinu Velan
* @ModifiedBy    : Vinu Velan   
* @ModifiedDate  : 30/03/2015
* @application   : Booking Social
* @see           : ''
*/
public class BKSL_SyncServiceRequest{
    public static Boolean isServiceRequestLocked{get; set;}
    
    public BKSL_SyncServiceRequest(){
        isServiceRequestLocked = false;
    }
    
    public void afterInsertServiceRequestHandler(BKSL2__Service_Request__c objServiceRequest){
        //BKSL2__Service_Request__c objSerReq = [SELECT Opportunity__c,Contact_FirstName__c,Contact_LastName__c,Contact_Phone__c,Contact_Email__c,Appointment_Owner__c,BKSL2__Expert__r.BKSL2__Salesforce_User__c FROM BKSL2__Service_Request__c where Id=: objServiceRequest.Id];
        //system.debug('objService==========+'+objSerReq.BKSL2__Expert__r.BKSL2__Salesforce_User__c);
        //system.debug('objService==========+'+objSerReq.Appointment_Owner__c);
        system.debug('BKSL_SyncobjService==========+'+objServiceRequest);
        system.debug('BKSL_SyncobjService==========+'+BKSL_SyncServiceRequest.isServiceRequestLocked);
        
        if(objServiceRequest.BKSL2__Service__c != null && (BKSL_SyncServiceRequest.isServiceRequestLocked == NULL || BKSL_SyncServiceRequest.isServiceRequestLocked == false)){
            system.debug('BKSL_SyncobjServiceRequest: ' + objServiceRequest);
            Event objEvent = new Event ();
            objEvent.Activity_Type__c = 'Booking Social';
            objEvent.Description = 'Contact Details: '+objServiceRequest.Contact_FirstName__c +', '+ objServiceRequest.Contact_LastName__c +', '+ objServiceRequest.Contact_Phone__c +', '+ objServiceRequest.Contact_Email__c+'.';
            objEvent.Activity_Type_Detail__c = 'Booking Social';
            objEvent.Service_Request_Id__c = objServiceRequest.Id;
            objEvent.StartDateTime = objServiceRequest.BKSL2__Start_Date__c;
            objEvent.EndDateTime = objServiceRequest.BKSL2__End_Date__c;
            objEvent.ActivityDateTime = objEvent.StartDateTime;
            objEvent.Subject = objServiceRequest.Name;
            objEvent.WhoId = objServiceRequest.BKSL2__Contact__c;
            /*//if(objSerReq.BKSL2__Expert__r.BKSL2__Salesforce_User__c != NULL)
                //objEvent.OwnerId = objSerReq.BKSL2__Expert__r.BKSL2__Salesforce_User__c;*/
            if(objServiceRequest.Appointment_Owner__c != NULL)
                objEvent.OwnerId = objServiceRequest.Appointment_Owner__c;
            if(objServiceRequest.Opportunity__c != NULL)
                objEvent.WhatId = objServiceRequest.Opportunity__c;
            insert objEvent;
			
			BKSL_SyncServiceRequest.sendEmail(objServiceRequest.Contact_Email__c, objServiceRequest.Contact_LastName__c, objServiceRequest.BKSL2__Start_Date__c.format(), objServiceRequest.Id, objServiceRequest.BKSL2__Service__c);
        }
    }
    
    public void afterUpdateServiceRequestHandler(BKSL2__Service_Request__c objServiceRequest){
        BKSL2__Service_Request__c objSerReq = [SELECT Appointment_Owner__c,Opportunity__c,Opportunity__r.Name,BKSL2__Expert__r.BKSL2__Salesforce_User__c FROM BKSL2__Service_Request__c where Id=: objServiceRequest.Id];
        system.debug('objSerReq==========+'+objSerReq.BKSL2__Expert__r.BKSL2__Salesforce_User__c);
        system.debug('objSerReq==========+'+objSerReq.Appointment_Owner__c );
        
        if(objServiceRequest.BKSL2__Service__c != null && (BKSL_SyncServiceRequest.isServiceRequestLocked == NULL || BKSL_SyncServiceRequest.isServiceRequestLocked == false)){
            datetime createdDate = Datetime.newInstance(2015, 9, 1);
            list<Event> lstEvent = [Select Id, Event_Name__c, WhoId, StartDateTime, EndDateTime, Subject from Event where Service_Request_Id__c = :objServiceRequest.Id and Activity_Type__c = 'Booking Social' and Activity_Type_Detail__c = 'Booking Social' and createdDate > :createdDate];
            for(Event objEvent: lstEvent){
                objEvent.Service_Request_Id__c = objServiceRequest.Id;
                objEvent.Event_Name__c = objSerReq.Opportunity__r.Name;
                objEvent.StartDateTime = objServiceRequest.BKSL2__Start_Date__c;
                objEvent.EndDateTime = objServiceRequest.BKSL2__End_Date__c;
                objEvent.ActivityDateTime = objEvent.StartDateTime;
                objEvent.Subject = objServiceRequest.Name;
                objEvent.WhoId = objServiceRequest.BKSL2__Contact__c;
                /*if(objSerReq.BKSL2__Expert__r.BKSL2__Salesforce_User__c != NULL)
                    objEvent.OwnerId = objSerReq.BKSL2__Expert__r.BKSL2__Salesforce_User__c;*/
                if(objSerReq.Appointment_Owner__c != NULL)
                    objEvent.OwnerId = objSerReq.Appointment_Owner__c;
                if(objSerReq.Opportunity__c != NULL)
                objEvent.WhatId = objSerReq.Opportunity__c;
            }
            BKSL_SyncServiceRequest.isServiceRequestLocked = true;
            update lstEvent;
        }
    }
	
	@future (callout=true)
	public static void sendEmail(String email, String lastName, String appointmentTime, String appointmentId, String serviceId){
		BKSL_Mandrill_Email cls = new BKSL_Mandrill_Email();
		
		BKSL_Mandrill_Email.properties prop = new BKSL_Mandrill_Email.properties();
		prop.toAddress = email;
		prop.toName = lastName;
		prop.replyTo = 'rsharpe@markettraders.com';
		prop.appointmentTime = appointmentTime;
		prop.appointmentId = appointmentId;
		prop.serviceid = serviceId;
		
		cls.prop = prop;
		cls.sendEmail();
	}
}