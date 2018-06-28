/**
 *
 * @author  Fernando Rodriguez (frodriguez@adooxen.com)
 * @date    01/11/2012
 *
 */
global class OpenOpportunitiesScheduler implements Schedulable {
	
	public OpenOpportunitiesScheduler() {}
	
	global void execute(SchedulableContext sc) {
	
	   Database.executeBatch(new OpenOpportunitiesBatch(), 1);	
	}

}