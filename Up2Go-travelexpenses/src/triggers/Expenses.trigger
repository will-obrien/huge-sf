trigger Expenses on Expense__c (before insert, before update, before delete, after insert, after update, after delete) {
    new ExpensesTriggerHandler().delegate();
}