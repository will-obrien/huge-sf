({
	doinit : function(component, event, helper) { 
        var req = component.get("c.getIdeas");

        req.setCallback(this, function(action) {
            if (action.getState() === "SUCCESS") {
                component.set('v.ideas', action.getReturnValue());
            }else if (state === "ERROR") {}
        });
		$A.enqueueAction(req);
    }
})