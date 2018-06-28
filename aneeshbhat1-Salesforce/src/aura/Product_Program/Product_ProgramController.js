({
    onInit : function(component, event, helper) {
       var selectCmp = component.find("MultiSelectDiv");
        
        $A.util.removeClass(selectCmp, 'slds-dropdown slds-dropdown--left slds-dropdown--length-5');
        $A.util.addClass(selectCmp, 'slds-hidden');
	},

    OnDropClick:function(cmp) {
        var selectCmp1 = cmp.find("MultiSelectDiv");
        $A.util.removeClass(selectCmp1, 'slds-hidden');
        $A.util.addClass(selectCmp1, 'slds-dropdown slds-dropdown--left slds-dropdown--length-5');
	 },
 OnFocusOut:function(cmp) {
       alert('focus out');
	 },
   
    onMultiSelectChange: function(cmp) {
         var selectCmp = cmp.find("InputSelectMultiple");
         var resultCmp = cmp.find("multiResult");
         resultCmp.set("v.value", selectCmp.get("v.value"));
	 }
})