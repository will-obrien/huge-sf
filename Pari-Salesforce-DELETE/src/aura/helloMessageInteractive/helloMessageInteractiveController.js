({
	handleClick : function(component, event, helper) {
		var whichButton = event.getSource().get("v.label");
        console.log(whichButton);
        component.set("v.message", whichButton);
	}
})