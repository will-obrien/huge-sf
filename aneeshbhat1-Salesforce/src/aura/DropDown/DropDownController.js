({
    
    onInit : function(component, event, helper) {
        debugger;
        
        if(!component.get("v.IsDependentDropDown"))
        {
             var arr = component.get("v.DropDownData");
        var action=component.get("c.getDropDownValues");
         action.setParams({
        	"SelectedDropDownSource" : component.get("v.DropDownData"),
             "SelectedDropDownType" : component.get("v.DropDownType")
    	});
        action.setCallback(this,function(a){
    		component.set("v.DataSource",JSON.parse(a.getReturnValue()));
		});
        $A.enqueueAction(action);
        }
       
         
        helper.HideDiv(component);
        helper.getUniqueComponentId(component,event,helper);
        
	},

    OnDropClick:function(component, event,helper) {
        
       debugger;
        helper.HideDiv(component);
        //var selectCmp1 = component.find("MultiSelectDiv");
        //$A.util.removeClass(selectCmp1, 'slds-hidden');
        //$A.util.addClass(selectCmp1, 'slds-dropdown slds-dropdown--left slds-dropdown--length-5');
	 },
 	OnCheckBoxChecked:function(cmp,event,helper) {
      debugger;
      	let el = event.srcElement;
   		let id = event.currentTarget.id;
        let spnid=id.substring(id.length-3,id.length)
        id=(spnid==cmp.get("v.LIConstant"))?id.substring(0, id.length-3):id;
        //var articles = cmp.find("MultiSelectDiv");
        if(spnid==cmp.get("v.LIConstant"))
        {
            document.getElementById(id).checked=(document.getElementById(id).checked)?false:true;
        }
        
     //var todoItemField = $A.getComponent(id);
     let ddllist=cmp.get("v.DataSource");
     let selectedItem='';
     let value="";
        let CmpID=  cmp.get("v.ComponentID");
         var text="";
         var Multitext="";
         var count=0;
        document.getElementById(CmpID).value=Multitext;
     //component.find("button1").get("v.label");
     	if(document.getElementById(id).checked && cmp.get("v.DropDownType")=="Single Select")
        {
           
            //debugger;
            
            for (var i = 0; i < ddllist.length; i++) 
            {
                value=cmp.get("v.ComponentID")+ddllist[i];
                //debugger;
                
                if(value!=id)
                {
                    document.getElementById(value).checked=false;
                   //cmp.find(ddllist[i]).set("v.checked", false); 
                   //debugger;
                }
                else
                {
                    //debugger;
                    selectedItem=ddllist[i];
                }
                
			}
           
			document.getElementById(CmpID).value=selectedItem;
            helper.HideDiv(cmp);
        }
     else if(document.getElementById(id).checked &&   cmp.get("v.DropDownType")!="Single Select")
     {
       
         
         for (var i = 0; i < ddllist.length; i++) 
            {
                value=cmp.get("v.ComponentID")+ddllist[i];
                text=ddllist[i];
                if(document.getElementById(value).checked)
                {
                    count++;
                    if(i==0)
                    {
                        Multitext=text;
                    }
                    else 
                    {
                        Multitext=Multitext+","+text;
                    }
                   // debugger;
                }
			}
         
         if(count==ddllist.length)
         {
             document.getElementById(CmpID).value="ALL";
         }
         else
         {
             
             if(Multitext.indexOf(",")==0)
            {
                document.getElementById(CmpID).value=Multitext.substring(1, Multitext.length);;
            }
             else
             {
                 document.getElementById(CmpID).value=Multitext;
             }
             
         }
     }
         else if(!document.getElementById(id).checked &&   cmp.get("v.DropDownType")!="Single Select")
        {
             for (var i = 0; i < ddllist.length; i++) 
            {
                value=cmp.get("v.ComponentID")+ddllist[i];
                text=ddllist[i];
                if(document.getElementById(value).checked)
                {
                    
                    if(i==0)
                    {
                        Multitext=text;
                    }
                    else 
                    {
                        Multitext=Multitext+","+text;
                    }
                   // debugger;
                }
			}
           // debugger;
            if(Multitext.indexOf(",")==0)
            {
                document.getElementById(CmpID).value=Multitext.substring(1, Multitext.length);;
            }
            else
            {
                document.getElementById(CmpID).value=Multitext;
            }
             
        }
        let SelectedValues=(cmp.get("v.DropDownType")=="Single Select")?selectedItem:Multitext;        var evt=$A.get("e.c:DropDownEvent");
        		evt.setParams({"SelectedItems":SelectedValues});
        		evt.setParams({"ComponentID":CmpID});
        		evt.setParams({"PassingComponent":cmp.get("v.DropDownData")});
         if(!cmp.get("v.IsDependentDropDown"))
        {
        		evt.setParams({"ControllingField":cmp.get("v.DropDownData")});
        }
        evt.fire();
        
	 },
    getControllingFieldValue:function(component, event,helper)
    {
        debugger;
         
        if(component.get("v.IsDependentDropDown") && event.currentTarget==null)
        {
            debugger;
            let ControllingField=event.getParam("ControllingField");
            let SelectedItems=event.getParam("SelectedItems");
            if(ControllingField!=null)
            {
                helper.LoadDependentDropDown(component,event,ControllingField,SelectedItems);
            	helper.HideDiv(component);
            }
        }
        else if(!component.get("v.IsDependentDropDown") && event.currentTarget==null)
        {
            helper.HideDiv(component);
        }
        else
        {
            var selectCmp1 = component.find("MultiSelectDiv");
        	$A.util.removeClass(selectCmp1, 'slds-hidden');
        	$A.util.addClass(selectCmp1, 'slds-dropdown slds-dropdown--left slds-dropdown--length-5');
        }
         helper.SetDivWidth();
        //alert(event.getParam("SearchString"));
    }
})