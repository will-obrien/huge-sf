({
	calculate : function(component, event, helper) {
		var x=component.get("v.Amount");
        var y=component.get("v.Tenure");
        var z=0;
        //alert(y);
        if(y<12){
            z=x+1000;
        }
        if(y>12){
            z=x-1000;
        }
        component.set("v.Maturity",z);
        helper.showMessage1();
        $A.util.addClass(component,'changeMe');
	},
    
    getContactName:function(component,event,helper){
    	var action=component.get("c.getContactName1");
    	action.setParams({id:component.get("v.Conid")});
		action.setCallback(this,function(a){
    		component.set("v.ContactName",a.getReturnValue());
            alert(a.getReturnValue());
		});
        $A.enqueueAction(action);
	}
})