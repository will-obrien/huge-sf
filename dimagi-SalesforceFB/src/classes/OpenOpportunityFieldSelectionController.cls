/**
 *
 * @author  Fernando Rodriguez (frodriguez@adooxen.com)
 * @date    01/16/2012
 *
 */
public with sharing class OpenOpportunityFieldSelectionController {

    public Selectoption[] availableFields {get; set;}
    public String selectedValue {get; set;}     
    public Integer orderCount {get; set;} 

    public OpenOpportunityFieldSelectionController() {

        init();
    }

    public void addColumn() { 
        
        if (selectedValue != null && selectedValue != '') {        
	        insertNewColumn();
	        removeSelectedValue();
        }
        else {
        	Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.FATAL, 'Please select a field'));
        }
    }

    public void clearCurrentSelection() {
        
        Map<String, Open_Opportunity_Fields__c> result = Open_Opportunity_Fields__c.getAll();
        delete result.values();
        
        init();     
    }

    public Open_Opportunity_Fields__c[] getCurrentSelection() {
        
        Open_Opportunity_Fields__c[] result = new Open_Opportunity_Fields__c[] {};
        
        result = [SELECT 
                       Id,
                       Name,
                       Label__c,
                       Order__c
                   FROM Open_Opportunity_Fields__c
                   Order By Order__c];
                        
        return result;
    }

    private void init() {
    	
        availableFields = new Selectoption[] {};        
        orderCount = 0;
        Set<String> alreadySelectedColumns = getCurrentSelectionNames();        
        Map<String, Schema.Describefieldresult> fieldList = getOpportunitySchemaFields();        
        
        String[] fieldIterator = new String[] {};
        fieldIterator.addAll(fieldList.keySet());
        fieldIterator.add('Opportunity Owner');
        fieldIterator.sort();
        
        for (String fieldName :fieldIterator) {
                        
            if (!alreadySelectedColumns.contains(fieldName)) {
                
                if (fieldName.equals('Opportunity Owner')) {
                	availableFields.add(new Selectoption('Owner.Name', 'Opportunity Owner'));
                }
                else {                
	                Schema.Describefieldresult fieldResult = fieldList.get(fieldName);              
	                availableFields.add(new Selectoption(fieldResult.getName(), fieldResult.getLabel()));
                }
            }
        }       
    }
    
    private void insertNewColumn() {
        
        Open_Opportunity_Fields__c newColumn = new Open_Opportunity_Fields__c();
        
        if (selectedValue.equals('Owner.Name')) {        	         
	        newColumn.Name = 'Owner.Name';
	        newColumn.Label__c = 'Opportunity Owner';
	        newColumn.Type__c = 'String';         	
        }
        else {
	        Map<String, Schema.Describefieldresult> opportunitySchemaFields = getOpportunitySchemaFields();
	        Schema.Describefieldresult fieldDescribe = opportunitySchemaFields.get(selectedValue);
	                
	        newColumn.Name = fieldDescribe.getName();
	        newColumn.Label__c = fieldDescribe.getLabel();
	        newColumn.Type__c = fieldDescribe.getType().name(); 
        }        
        orderCount ++;
        newColumn.Order__c = orderCount;
        
        try {
            insert newColumn;
        }
        catch(Exception e) {}       
    }
    
    private void removeSelectedValue() {
    	
    	for (Integer i = 0; i < availableFields.size(); i++) {
    		
    		if (availableFields[i].getValue().equals(selectedValue)) {
    			
    			availableFields.remove(i);
    			break;
    		}
    	}
    }

    private Set<String> getCurrentSelectionNames() {
        
        Map<String, Open_Opportunity_Fields__c> result = Open_Opportunity_Fields__c.getAll();      
        orderCount =  result.size();
        return result != null ? result.keySet() : new Set<String> ();
    }
    
    private Map<String, Schema.Describefieldresult> getOpportunitySchemaFields() {
    	
    	Map<String, Schema.SObjectField> fieldsSchema = Schema.SObjectType.Opportunity.fields.getMap();
    	Map<String, Schema.Describefieldresult> result = new Map<String, Schema.Describefieldresult>();
    	
    	for (String fieldName :fieldsSchema.keySet()) {
    	
            Schema.SObjectField fieldSchema = fieldsSchema.get(fieldName);
            Schema.Describefieldresult fieldDescribe = fieldSchema.getDescribe();
            
            if (fieldDescribe.getName() != 'Name') {            
                result.put(fieldDescribe.getName(), fieldDescribe);
            }
    	}
    	
    	return result;
    }

}