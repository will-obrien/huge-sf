({
	createExpense : function(component, expense) {
		var theExpenses = component.get("v.expenses");
        
        //copy the expense to a new object
        //This is a disgusting, temporary hack
         var newExpense = JSON.parse(JSON.stringify(expense));
        
        
         console.log("Expenses before 'create': " + JSON.stringify(theExpenses));
         theExpenses.push(newExpense);
         component.set("v.expenses", theExpenses);
         console.log("Expenses after 'create': " + JSON.stringify(theExpenses));
	}
})