trigger AccountTrigger on Account (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	try{
        
	    TriggerDispatcher.callHandler('Account', 
	        trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, 
	        trigger.isDelete, trigger.isUndelete, trigger.isExecuting, trigger.new, 
	        trigger.newMap, trigger.old, trigger.oldMap);
        
	}catch(Exception ex){
		Logger logger = new Logger('Account Trigger');
		logger.log(ex.getMessage());
		logger.log(ex.getStackTraceString());
		logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
		system.debug(ex);
	}
}