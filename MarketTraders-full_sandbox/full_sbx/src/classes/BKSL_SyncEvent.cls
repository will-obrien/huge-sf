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

public class BKSL_SyncEvent
{
    public void afterInsertEventHandler(Event objEvent){
        if(objEvent.Service_Request_Id__c != null && (BKSL_SyncServiceRequest.isServiceRequestLocked == NULL || BKSL_SyncServiceRequest.isServiceRequestLocked == false))
        {
            list<BKSL2__Service_Request__c> lstServiceReq = [Select BKSL2__Start_Date__c, BKSL2__End_Date__c from BKSL2__Service_Request__c where Id = :objEvent.Service_Request_Id__c];
            for(BKSL2__Service_Request__c objServiceReq: lstServiceReq){
                objServiceReq.Related_Event__c = objEvent.Id;
            }
            BKSL_SyncServiceRequest.isServiceRequestLocked = true;
            update lstServiceReq;
            system.debug('EventSynchronization'+lstServiceReq);
        }
        else{
        /*
            BKSL2__Service_Request__c objServiceReq = new BKSL2__Service_Request__c();
            objServiceReq.BKSL2__Start_Date__c = objEvent.StartDateTime;
            objServiceReq.BKSL2__End_Date__c = objEvent.EndDateTime;
            objServiceReq.Name = objEvent.Subject;
            objServiceReq.Related_Event__c = objEvent.Id;
            insert objServiceReq;
        */
        }
    }
    
    public void afterUpdateEventHandler(Event objEvent){
        if(objEvent.Service_Request_Id__c != null && (BKSL_SyncServiceRequest.isServiceRequestLocked == NULL || BKSL_SyncServiceRequest.isServiceRequestLocked == false))
        {
            list<BKSL2__Service_Request__c> lstServiceReq = [Select BKSL2__Start_Date__c, BKSL2__End_Date__c from BKSL2__Service_Request__c where Id = :objEvent.Service_Request_Id__c];
            for(BKSL2__Service_Request__c objServiceReq: lstServiceReq){
                objServiceReq.BKSL2__Start_Date__c = objEvent.StartDateTime;
                objServiceReq.BKSL2__End_Date__c = objEvent.EndDateTime;
                objServiceReq.Name = objEvent.Subject;
                objServiceReq.Related_Event__c = objEvent.Id;
            }
            BKSL_SyncServiceRequest.isServiceRequestLocked = true;
            update lstServiceReq;
            system.debug('EventSynchronization'+lstServiceReq);
        }
    }
}