public with sharing class UnfollowController {
    
    public Boolean picklistRendered { get; set;}
    public Boolean inputBoxRendered{ get; set; }
    public Boolean inputCheckBoxRendered{ get; set;}
    public Boolean showAllObjects { get; set;}
        
    private UnfollowRule__c u;

    private ApexPages.StandardController uController;
    
    public UnfollowController (ApexPages.StandardController controller) {
        uController = controller;
        u= (UnfollowRule__c)controller.getRecord();
        String label=u.ObjectLabel__c;
        checkShowAllObjects(label);    
        valueRender();   
    }
  
    public PageReference saveNew()
    {
        PageReference pr;
        try{
            //uController.save(); //Note save breaks for some reason but upsert works
            upsert u;
            Schema.DescribeSObjectResult describeResult = uController.getRecord().getSObjectType().getDescribe();
            pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e');
            pr.setRedirect(true);
            return pr;    
        }catch(Exception e){
//            system.debug('Save & New failed, likely due to validation rule errors or trigger fail due to bad data or null field, value or operator. Error: '+e);
//            ApexPages.addmessages(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            ApexPages.addmessages(e);            
            return null;
        }//try

    }//saveNew
        
    public void ShowAllObjectsTrue(){
        showAllObjects = TRUE;
    }
    
    public void checkShowAllObjects(String label){
        Set<String> secondTeirObjects=listSecondTierObjects();
        if (secondTeirObjects.contains(label)){
            showAllObjects=True;
        }else{
            showAllObjects=False;
        }//if
    }

    public List<selectOption> getObjectNames(){
        List<selectOption> options=new List<selectOption>();
        List<String> objectLabels=new List<String>();//included to create a sorted field name list
        Map<String,String> objectLabelNameMap=new Map<String,String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 

        for (String objectName:gd.keyset()){
            if(gd.get(objectName).getDescribe().isAccessible()==True && gd.get(objectName).getDescribe().isUpdateable()==True){
                objectLabels.add(gd.get(objectName).getDescribe().getLabel());
                objectLabelNameMap.put(gd.get(objectName).getDescribe().getLabel(),objectName);
            }//if 
        }//for

        objectLabels.sort();

        Set <String> secondTierObjects=listSecondTierObjects();
        Set <String> neverShowObjects= listNeverShowObjects();
                    
        for (String oLabel:objectLabels){
            if(neverShowObjects.contains(oLabel)==False){
                if(secondTierObjects.contains(oLabel)==True){
                    if(ShowAllObjects==True){
                        options.add( new selectOption(objectLabelNameMap.get(oLabel),oLabel));
                    }//if 3
                }else{
                    options.add( new selectOption(objectLabelNameMap.get(oLabel),oLabel));
                }//if i2
            }//if 
        }//for
        return options;
    }//getObjectNames
    
    public List<selectOption> getFieldNames(){
        List<selectOption> options=new List<selectOption>();
        List<String> fieldLabels=new List<String>();//included to create a sorted field name list
        Map<String,String> fieldLabelNameMap=new Map<String,String>();
        Boolean evaluateFields=False;
        
        if(u.ObjectName__c!=null){
            evaluateFields=True;
        }
 
        if (evaluateFields){//if 1    
            SObjectType objToken = Schema.getGlobalDescribe().get(u.ObjectName__c); 
            DescribeSObjectResult objDef = objToken.getDescribe();
            Map<String, SObjectField> fieldMap = objDef.fields.getMap();

            options.add(new selectOption('',''));
            
            for (String fName:fieldMap.keySet()){//for 1
                //Disallow unsupported field types
//this is the exclusion list including date types, which are currently removed from the production "if" below
                //This disallows the unsupported types: text area, anytype, encrypted string, multiselect picklists, lookup fields, base64, reference fields, and URL's
                if(fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.Time && fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.anytype&&fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.base64&&fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.EncryptedString&&fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.Id&&fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.MultiPicklist&&fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.Reference&&fieldMap.get(fName).getDescribe().getType()!=Schema.DisplayType.TextArea){
                    fieldLabels.add(fieldMap.get(fName).getDescribe().getLabel());                  
                    fieldLabelNameMap.put(fieldMap.get(fName).getDescribe().getLabel(), fName);
                }//if 2
            }//for 1
            fieldLabels.sort();
            for (String fLabel:fieldLabels){//for 1
                options.add(new selectOption(fieldLabelNameMap.get(fLabel),fLabel));
            }//for 1    
        }//if 1

        return options;
    }//getFieldNames

    public List<selectOption> getOperator(){
        List<selectOption> options=new List<selectOption>();
        //these get the field token for the selected field so that below we can figure out what type of field it is
       
        if(u.FieldName__c!=null&&u.ObjectName__c!=null){
            SObjectType objToken = Schema.getGlobalDescribe().get(u.ObjectName__c); 
            DescribeSObjectResult objDef = objToken.getDescribe();
            Map<String, SObjectField> fieldMap = objDef.fields.getMap();
            SObjectField fieldToken = fieldMap.get(u.FieldName__c);
     
            DisplayType fieldType;
            Boolean typeSelected=False;
        
            try{
                fieldType=fieldToken.getDescribe().getType();
                typeSelected=true;
            }catch (Exception e){}//exception happens when changing type as the other picklist hasn't had a chance to refresh yet   
                
            //only add an operator if a valid field type is chosen.  Otherwise, leave it blank.
            if (typeSelected){//if 2
                if (fieldType!=Schema.DisplayType.Time && fieldType!=Schema.DisplayType.anyType && fieldType!=Schema.DisplayType.base64 && fieldType!=Schema.DisplayType.Date && fieldType!=Schema.DisplayType.DateTime && fieldType!=Schema.DisplayType.EncryptedString && fieldType!=Schema.DisplayType.Id && fieldType!=Schema.DisplayType.MultiPicklist&&fieldType!=Schema.DisplayType.Reference&&fieldType!=Schema.DisplayType.TextArea && fieldType!=Schema.DisplayType.Time){//if 2
                    //the above types are unsupported at this time 
                    options.add(new selectOption('equals','equals')); 
                    options.add(new selectOption('not equal to','not equal to')); 
                    if (fieldType!=Schema.DisplayType.Boolean&&fieldType!=Schema.DisplayType.Picklist){//if 4
                        //boolean can't use the below, but the others can
                        options.add(new selectOption('greater than','greater than')); 
                        options.add(new selectOption('less than','less than')); 
                        options.add(new selectOption('greater or equal','greater or equal')); 
                        options.add(new selectOption('less or equal','less or equal')); 
                        if (fieldType==Schema.DisplayType.STRING || fieldType==Schema.DisplayType.ComboBox ||fieldType==Schema.DisplayType.Picklist ||fieldType==Schema.DisplayType.email||fieldType==Schema.DisplayType.Phone||fieldType==Schema.DisplayType.url){
                        //if 5
                           //these options are for string type fields
                           options.add(new selectOption('contains','contains')); 
                           options.add(new selectOption('does not contain','does not contain')); 
                           options.add(new selectOption('starts with','starts with')); 
                        }//if 5
                   }//if 4
               }else if(fieldType==Schema.DisplayType.Date || fieldType==Schema.DisplayType.DateTime){
                    //Note that TIME is not supported as a valid field type
                  options.add(new selectOption('equals TODAY','equals TODAY')); 
               }//if 3
            }//if 2
        }//if 1    
        return options;
    }//getOperator
    
    public List<SelectOption> getValuePicklistOptions(){
        List<SelectOption> valuePicklistOptions = new List<SelectOption>();
     
        SObjectType objToken = Schema.getGlobalDescribe().get(u.ObjectName__c); 
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fieldMap = objDef.fields.getMap();

        if (u.FieldName__c!=null){
            String fName=u.FieldName__c;
//            system.debug('Field Name: '+fName);
            try{//this will error when changing types as the field name is different than the type as the FieldNames picklsit hasn't been regenerated yet
                Schema.DisplayType fType=fieldMap.get(fName).getDescribe().getType();
                if(fType==Schema.DisplayType.Picklist){
                    for (Schema.PickListEntry pickVal: fieldMap.get(fName).getDescribe().getPicklistValues()){
                        // create a selectoption for each pickval
                        valuePicklistOptions.add(new SelectOption(pickVal.getValue(),pickVal.getLabel()));
                    }//for 1
                }//if 2
            }catch(Exception e){
//                system.debug('getValuePicklistOptions had an error, likely due to switching between Lead & Campaign Member rules. Error:'+e);
            }
        }//if 1    
        return valuePicklistOptions ;
    } //getValuePicklistOptions
    
    public void valueRender(){
        picklistRendered=False;
        inputCheckBoxRendered=False;
        inputboxRendered=False;
        
        if (u.FieldName__c!=null &&u.ObjectName__c!=null){//if 1
            SObjectType objToken = Schema.getGlobalDescribe().get(u.ObjectName__c); 
            DescribeSObjectResult objDef = objToken.getDescribe();
            Map<String, SObjectField> fieldMap = objDef.fields.getMap();

            String fname=u.FieldName__c;
            try{//this catches exceptions thrown when changing objects and FieldName is populated with a value not valid for the new object
                if(fieldMap.get(fName).getDescribe().getType()==Schema.DisplayType.Picklist){//if 2
                    picklistRendered=True;
                }else if(fieldMap.get(fName).getDescribe().getType()==Schema.DisplayType.Boolean){
                    inputCheckBoxRendered=True;
                }else if(fieldMap.get(fName).getDescribe().getType()==Schema.DisplayType.Date || fieldMap.get(fName).getDescribe().getType()==Schema.DisplayType.DateTime){
                      inputboxRendered=FALSE;//hide all input fields for Values if it's a date field so customers won't get confused
                    u.Value__c='TODAY';
                }else{
                    inputboxRendered=!(picklistRendered || inputCheckBoxRendered);
                }//if 2
            }catch (Exception e){
//                system.debug('Likely you selected one object, a field for that object, then changed the object resulting in an invalid FieldName for the new object.  You can safely ignore this exception: '+e);
            }
        }//if 1
       
    }//picklsitRendered    

    public Set<String> listSecondTierObjects(){
        Set <String> secondTierObjects=new Set<String>();

        secondTierObjects.add('Additional Directory Number');
        secondTierObjects.add('Approval');        
        secondTierObjects.add('Asset');        
        secondTierObjects.add('Attachment');        
        secondTierObjects.add('Business Hours');        
        secondTierObjects.add('Business Process');        
        secondTierObjects.add('CSS User');        
        secondTierObjects.add('Campaign Member');        
        secondTierObjects.add('Campaign Member Status');        
        secondTierObjects.add('Document');        
        secondTierObjects.add('Email Template');        
        secondTierObjects.add('Event');        
        secondTierObjects.add('Folder');        
        secondTierObjects.add('Idea');        
        secondTierObjects.add('Note');        
        secondTierObjects.add('Opportunity Product');        
        secondTierObjects.add('Opportunity: Competitor');        
        secondTierObjects.add('Price Book');        
        secondTierObjects.add('Price Book Entry');        
        secondTierObjects.add('Profile');        
        secondTierObjects.add('Record Type');        
        secondTierObjects.add('Solution');        
        secondTierObjects.add('Task');        
        secondTierObjects.add('User');        
        secondTierObjects.add('Entitlement');        
        secondTierObjects.add('Entitlement Template');        
        secondTierObjects.add('Milestone');        
        secondTierObjects.add('Question');        
        secondTierObjects.add('Service Contract');        
        secondTierObjects.add('Tag Definition');        
        secondTierObjects.add('');    

        return secondTierObjects;
    }//listSecondTierObjects
    
    //These are primarily system objects that should never be selectable and are not supported with this application
    public Set<String> listNeverShowObjects(){
        Set<String> neverShowObjects= New Set<String>();

        //Exclude this app's custom objects to prevent recursion in queries.
        neverShowObjects.add('Chatter Unfollow Rules');
        neverShowObjects.add('Chatter Unfollow Batch Job Queued');
        neverShowObjects.add('Chatter Unfollow Delayed RecordId');
        neverShowObjects.add('Chatter Unfollow Rule Job Batch');

        neverShowObjects.add('Case Team Member');
        neverShowObjects.add('Apex Class');
        neverShowObjects.add('Apex Trigger');
        neverShowObjects.add('Approval Request');
        neverShowObjects.add('Case Comment');
        neverShowObjects.add('Case Milestone');    
        neverShowObjects.add('Case Team Member');
        neverShowObjects.add('Case Team Member Role');
        neverShowObjects.add('Category Data');
        neverShowObjects.add('Category Node');
        neverShowObjects.add('Chatter Group');
        neverShowObjects.add('Contact Role');
        neverShowObjects.add('Contract Line Item');    
        neverShowObjects.add('Custom Button or Link');
        neverShowObjects.add('Custom S-Control');
        neverShowObjects.add('Document Entity Map');
        neverShowObjects.add('Email Service');
        neverShowObjects.add('Email Services Address');                
        neverShowObjects.add('Email Template');                
        neverShowObjects.add('Group');                
        neverShowObjects.add('Holiday');                
        neverShowObjects.add('Idea Comment');                
        neverShowObjects.add('Letterhead');                
        neverShowObjects.add('Mail Merge Template');                
        neverShowObjects.add('Organization');                
        neverShowObjects.add('Find & Replacer');                
        neverShowObjects.add('Organization-wide From Email Address');                
        neverShowObjects.add('Predefined Case Team');                
        neverShowObjects.add('Predefined Case Team Member');                
        neverShowObjects.add('Role');    
        neverShowObjects.add('Static Resource');    
        neverShowObjects.add('Visualforce Component');    
        neverShowObjects.add('Visualforce Page');    
        neverShowObjects.add('Reply');    
        neverShowObjects.add('Service Contract Share');    
        neverShowObjects.add('');

        return neverShowObjects;
    }//listNeverShowObjects
    
    
}//UnfollowController