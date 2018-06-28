/** 
 * eightCloud (2014)
 * Best Practice Lead Trigger "Master", passes control to appropriate Class.
 *
 * In theory, ALL trigger actions performed on Lead should be initiated via classes inside this single master Trigger.
 * This approach allows for a degree of control over **execution order** for orgs with several triggers on Lead.
 *
 */
trigger etcd8_LeadTrigger on Lead ( before update) {

   etcd8_RRLeadAssignment rrAssign = new etcd8_RRLeadAssignment();

    /* Before Update */
    if(Trigger.isUpdate && Trigger.isBefore){
        rrAssign.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
   
}