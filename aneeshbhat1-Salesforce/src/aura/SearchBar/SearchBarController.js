({
	searchHomePage : function(component, event, helper) {
        debugger
		var searchtxt=component.find("SearchText").get("v.value");
        var evt=$A.get("e.c:SearchBarEvent");
        evt.setParams({"SearchString":searchtxt});
        //alert(searchtxt);
        evt.fire();
	}
})