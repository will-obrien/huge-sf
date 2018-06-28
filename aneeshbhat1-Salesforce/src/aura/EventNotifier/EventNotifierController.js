({
	fireComponentEvent : function(component, event) {
		var cmp=component.getEvent("cmpEvent");
        cmp.setParams({
            message : "It's fired!!" 
        });
        cmp.fire();
	}
})