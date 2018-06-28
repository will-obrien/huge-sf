({
	handleComponentEvent : function(component, event) {
		component.set("v.messageFromEvent",event.getParam("message"));
        component.set("v.numEvents",parseInt(component.get("v.numEvents")) + 1);
	}
})