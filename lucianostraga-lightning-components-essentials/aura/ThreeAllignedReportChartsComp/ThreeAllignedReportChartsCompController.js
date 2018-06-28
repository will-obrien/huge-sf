({
	doinit : function(component, event, helper) { 
        
        var req = component.get("c.getSalesforceBaseURL");

        req.setCallback(this, function(action) {
            if (action.getState() === "SUCCESS") {
                var sUrl = req.getReturnValue();
                component.set("v.sourceFrame1",sUrl+'/apex/reportChartIframe?id='+component.get("v.reportID1"));
                component.set("v.sourceFrame2",sUrl+'/apex/reportChartIframe?id='+component.get("v.reportID2"));
                component.set("v.sourceFrame3",sUrl+'/apex/reportChartIframe?id='+component.get("v.reportID3"));
            }else if (state === "ERROR") {}
        });
		$A.enqueueAction(req);
    }
})