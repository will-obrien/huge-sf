/** 
 * eightCloud (2014)
 * Round Robin Lead Assignment class, called from etcd8_LeadTrigger
 */
public without sharing class etcd8_RRLeadAssignment {
  
/******************************************************************************************
 * BEFORE UPDATE
 ******************************************************************************************/
    public void OnBeforeUpdate(List<Lead> originalLeads, List<Lead> updatedLeads, Map<Id, Lead> oldMap, Map<Id, Lead> newMap){
      List<QueueSobject> lstUnassignedQueue;
      if(lstUnassignedQueue == NULL || lstUnassignedQueue.isEmpty()) {
         lstUnassignedQueue = [SELECT QueueId From QueueSobject WHERE Queue.Name = 'Unassigned'];
      }	
      if(lstUnassignedQueue.isEmpty()) {
        return;
      }
      List<Lead> lsRRtLeads = new List<Lead>(); 
      for(Lead lead : updatedLeads) {
        if(lead.OwnerId != lstUnassignedQueue[0].QueueId) {
          continue;
        }
        lsRRtLeads.add(lead);
      }
      if(lsRRtLeads.isEmpty()) {
        return;
      }
      assignRRLeads(lsRRtLeads,lstUnassignedQueue[0]);
    }//end OnBeforeUpdate


/******************************************************************************************
 * Method to assign RR leads
 ******************************************************************************************/
	public void assignRRLeads(List<Lead> lsRRtLeads,QueueSobject queueUnassigned) {
	  list<etcd8_LeadRecipient__c> listRecipients = [  SELECT Id, Name, user__c, available__c, nextUp__c 
                           FROM etcd8_LeadRecipient__c 
                           WHERE available__c = TRUE 
                           AND user__r.isActive = TRUE 
                           ORDER BY user__r.lastName ASC];
	  
	  
      for(Lead lead : lsRRtLeads) {
      	
      	Boolean beginAgain = false;
        for(etcd8_LeadRecipient__c leadRecipient : listRecipients) {
	      if(leadRecipient.nextUp__c && lead.OwnerId == queueUnassigned.QueueId) {
	        lead.OwnerId = leadRecipient.User__c;
	        lead.Lead_Recipient__c = leadRecipient.Id; 
	        leadRecipient.nextUp__c = false;
	        beginAgain = true;
	      }
	      else if(lead.OwnerId != queueUnassigned.QueueId && !leadRecipient.nextUp__c) {
	        leadRecipient.nextUp__c = true;
	        beginAgain = false;
	        break;  
	      }
	    }
	    if(beginAgain && !listRecipients.isEmpty()) {
	      listRecipients[0].nextUp__c = true;
	    }
	    
      }
      
      if(!listRecipients.isEmpty()) {
        update listRecipients;
      }
	}//end assignRRLeads

	
}//end etcd8_RRLeadAssignment.cls