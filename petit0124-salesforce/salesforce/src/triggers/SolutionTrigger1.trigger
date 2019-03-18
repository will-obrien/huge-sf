trigger SolutionTrigger1 on Solution (before insert, before update) {

	/* Use after triggers for the simple (but flawed) example
	 trigger SolutionTrigger1 on Solution (after insert, after update) { 
	
	GoingAsync.GoingAsync1(trigger.new, trigger.newmap, trigger.oldmap, trigger.isInsert);
	*/
	
	// GoingAsync.GoingAsync2(trigger.new, trigger.oldmap, trigger.isInsert);

	GoingAsync.GoingAsync3(trigger.new, trigger.oldmap, trigger.isInsert);

	
}