/**
* This is a Apex Trigger in Booking social
* The program implements an application that
* Sync service request
*
*
*
* @author        : Deva
* @ModifiedBy    : Deva  
* @ModifiedDate  : 30/03/2015
* @application   : Booking Social
* @see           : ''
*/
trigger BKSL_syncServiceRequest on Event (after insert, after update) {
    BKSL_SyncEvent handlerClass = new BKSL_SyncEvent();
    
    if(Trigger.isInsert)
    {
        for(Event objEvent : Trigger.new )
        {
            handlerClass.afterInsertEventHandler(objEvent);
        }
    }
    if(Trigger.isUpdate)
    {
        for(Event objEvent : Trigger.new )
        {
            handlerClass.afterUpdateEventHandler(objEvent);
        }
    }
}