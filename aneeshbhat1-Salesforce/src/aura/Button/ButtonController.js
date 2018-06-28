({
    onInit : function(component, event, helper) {
    }
	,getSelectedValues : function( component, event) {
        debugger;
     	let SelectedItems=event.getParam("SelectedItems");
        let PassingComponent=event.getParam("PassingComponent");
         //let outName = component.find("SelectedProduct");
        //component.set("v.IsDependentDropDown")
        if(PassingComponent=="Program")
        {
            component.set("v.SelectedProgram", SelectedItems);
        }
        else if(PassingComponent=="Product")
        {
           component.set("v.SelectedProduct", SelectedItems);
        }
	}
    ,
    ButtonClicked:function(component, event)
    {
        debugger;
        let prd=component.get("v.SelectedProduct");
        let prg=component.get("v.SelectedProgram");
        alert('Selected Product:'+prd+"/n"+"Selected Program:"+prg);
    }
})