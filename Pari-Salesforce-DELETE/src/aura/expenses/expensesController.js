({
	clickCreate : function(component, event, helper) {
        var validExpense = component.find('expenseform').reduce(function(validSoFar, inputCmp){
          //Displays error messages for invalid fields   
          	inputCmp.showHelpMessageIfInvalid();
          	return validSoFar && inputCmp.get('v.validaity').valid;
                                                                
        }, true);
    
        if(validExpense){
    		var newExpense = Component.get("v.newExpense");
    		console.log("Create expense :" + JSON.stringify(newExpense));
            helper.createExpense(component, newExpense);
        }
    
	    
	    	
	}
})