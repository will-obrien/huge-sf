({
	nameThatButton : function(component, event, helper) {
		var whichOne = event.getSource().get("v.name");
        console.log(whichOne);
        component.set("v.whichButton", whichOne );
	}
})