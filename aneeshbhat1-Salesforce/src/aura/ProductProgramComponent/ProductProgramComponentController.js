({
	getSelectedValues : function( component, event) {
        debugger;
     let SelectedItems=event.getParam("SelectedItems");
        let PassingComponent=event.getParam("PassingComponent");
         let outName = component.find("SelectedProduct");
        if(PassingComponent=="Program")
        {
             outName = component.find("SelectedProgram");
            outName.set("v.value", SelectedItems);
            
        }
        else if(PassingComponent=="Product")
        {
           outName = component.find("SelectedProduct");
      		outName.set("v.value", SelectedItems);
            component.find("SelectedProgram").set("v.value", "");
        }
	}
})