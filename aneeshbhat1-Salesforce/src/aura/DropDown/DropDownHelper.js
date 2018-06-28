({
	HideDiv:function(component)
    {
        var selectCmp = component.find("MultiSelectDiv");
       $A.util.removeClass(selectCmp, 'slds-dropdown slds-dropdown--left slds-dropdown--length-5');
        $A.util.addClass(selectCmp, 'slds-hidden');
        
    },
    getUniqueComponentId : function(component, event, helper) 
    {
        var action=component.get("c.getUniqueComponentId");
        
         
        action.setCallback(this,function(a){
            //alert(a.getReturnValue());
    		component.set("v.ComponentID",a.getReturnValue());
		});
        $A.enqueueAction(action);
	},
    LoadDependentDropDown:function(component,event,ControllingField,ControllingFieldValues)
    {
        debugger;
        
        var arr = component.get("v.DropDownData");
        var action=component.get("c.LoadDependentDropDownValues");
        action.setParams({
        	"SelectedDropDownSource" : component.get("v.DropDownData"),
             "ControllingField" : ControllingField,
              "ControllingFieldValues" : ControllingFieldValues
    	});
         
        action.setCallback(this,function(a){
    		component.set("v.DataSource",JSON.parse(a.getReturnValue()));
		});
        $A.enqueueAction(action);
         document.getElementById(component.get("v.ComponentID")).value="";
    },
    
    SetDivWidth:function()
    {
           debugger;
        document.getElementById("divToHide").Width=document.getElementById("InputDiv").Width;
    }
})