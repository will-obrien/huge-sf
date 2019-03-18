({
	doinit : function(component, event, helper) { 
        var req = component.get("c.getTasks");

        req.setCallback(this, function(action) {
            if (action.getState() === "SUCCESS") {
                component.set('v.tasks', action.getReturnValue());
            }else if (state === "ERROR") {}
        });
		$A.enqueueAction(req);
    }
})