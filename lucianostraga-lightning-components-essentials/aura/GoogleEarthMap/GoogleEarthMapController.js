({
	doinit : function(component, event, helper) { 
        
        var req = component.get("c.getSalesforceBaseURL");

        req.setCallback(this, function(action) {
            if (action.getState() === "SUCCESS") {
                component.set("v.frameSrc",
                              req.getReturnValue()+'/apex/GoogleEarthIframe?id='+component.get("v.recordId"));
            }else if (state === "ERROR") {
            	
            }
        });
		$A.enqueueAction(req);
    }
})