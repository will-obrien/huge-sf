({
	onInit : function(component, event, helper) {
        var action=component.get("c.GetHomepageData");
        action.setCallback(this,function(a){
    		component.set("v.TimelineItems",JSON.parse(a.getReturnValue()));
		});
        $A.enqueueAction(action);
	}
    ,
    getSearchString:function(component, event)
    {
        
        alert(event.getParam("SearchString"));
    }
})