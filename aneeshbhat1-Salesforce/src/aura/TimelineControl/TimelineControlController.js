({
	onInit : function(component, event, helper) {
        var action=component.get("c.GetTimelineData");
        action.setCallback(this,function(a){
    		component.set("v.TimelineItems",JSON.parse(a.getReturnValue()));
		});
        $A.enqueueAction(action);
	},
    
    OnItemClick : function(component,event,helper){
        var action=component.get("c.GetSelectedActivity");
    	action.setParams({SelectedId:event.target.id});
        action.setCallback(this,function(a){
        	debugger;
    		component.set("v.SelectedTimelineActivity",JSON.parse(a.getReturnValue()));
		});
        $A.enqueueAction(action);
	}
})