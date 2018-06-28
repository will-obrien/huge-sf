({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAccounts");
        action.setCallback(this, function(response){
        	var state = response.getState();  
            $A.log(response);
        	if(state === "SUCCESS"){
            component.set("v.accounts", response.getReturnValue());   
        }                 
       });
       $A.enqueueAction(action);
	}
})