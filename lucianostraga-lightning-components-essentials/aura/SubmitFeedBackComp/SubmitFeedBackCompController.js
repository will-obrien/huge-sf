({   
  navigateToRecord:function(component){
  
          var recordID  = component.get("v.chatterGroupId");
        
          var sObectEvent = $A.get("e.force:navigateToSObject");
                                sObectEvent .setParams({
                                "recordId": recordID  ,
                                "slideDevName": "detail"
                              });
          sObectEvent.fire(); 
	}
 })