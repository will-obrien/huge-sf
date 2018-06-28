trigger OnOpportunity3 on Opportunity (after delete, after insert, after update, 
before delete, before insert, before update) {
	DiagnosticsMain.MainEntry('Opportunity', trigger.IsBefore, trigger.IsDelete, trigger.IsAfter, 
	trigger.IsInsert, trigger.IsUpdate, trigger.IsExecuting, trigger.new, trigger.newmap, trigger.old, trigger.oldmap);
}