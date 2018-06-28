({
    reactInit : function(component, event, helper) {
        console.log("REACT INIT");
        /*var dataService = {
            findAll : $A.getCallback(function(callback) {
                var action = component.get("c.findAll");
                action.setCallback(this, function(a) {
                    var contacts = a.getReturnValue();
                    callback(contacts);
                });
                $A.enqueueAction(action, false);
            }),
            findByName : $A.getCallback(function(name, callback) {
                var action = component.get("c.findByName");
                action.setParams({name: name});
                action.setCallback(this, function(a) {
                    var contacts = a.getReturnValue();
                    callback(contacts);
                });
                $A.enqueueAction(action, false);
            })
        }*/
         
        var container = component.find("app").getElement();
 
        console.log("STARTING");
        console.log(container);
        //console.log(codescanNg);
        //console.log(reactSearch);
        console.log(ReactSearch);
        codescanNg.init(container);
        
        console.log("HELLO");
         
    }
})