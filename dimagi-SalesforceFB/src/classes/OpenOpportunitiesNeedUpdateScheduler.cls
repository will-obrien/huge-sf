/**
 *
 * @author  Fernando Rodriguez (frodriguez@adooxen.com)
 * @date    01/22/2012
 *
 */
global class OpenOpportunitiesNeedUpdateScheduler implements Schedulable {
	
    public OpenOpportunitiesNeedUpdateScheduler() {}
    
    global void execute(SchedulableContext sc) {
    
       Database.executeBatch(new OpenOpportunityNeedUpdateBatch(), 1);
    }

}