/*********************************************************************************************************
Name              : UpdateActionReportingAttrSchedulable
Created By        : Justin LaMont
Created Date      : July 2017
Description       : Makes UpdateActionReportingAttr schedulable
Last Updated      : 
*********************************************************************************************************/
global class UpdateActionReportingAttrSchedulable implements Schedulable {

	global void execute(SchedulableContext sc) {
		UpdateActionReportingAttr uara = new UpdateActionReportingAttr();
		Database.executeBatch(new UpdateActionReportingAttr());
	}
}