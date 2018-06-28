trigger createNameAndValidateRuleInfo on UnfollowRule__c (before insert, before update) {

    //This simple trigger creates a name automatically so that customers don't have to type it themselves
    //Also, this converts field names to lowercase as Apex Set() considers "email" and "Email" to be 2 different entries
    Integer describeCounter=0;
    for (UnfollowRule__c u:trigger.new){
        if(u.ObjectName__c==null ||u.ObjectName__c==''){
            u.ObjectName__c.addError('Error: Invalid object name entered: '+u.ObjectName__c+'.  Please enter a valid object name.');//kinda redundant but helpful just in case
        }else{
            describeCounter++;
            if(describeCounter>10){
                u.addError('You may only update 10 records at a time to ensure that the rule definition can be verified in a trigger. Please try again with 10 or fewer records.');
            } else{
                DescribeSObjectResult objDef;
                try{
                    SObjectType objToken = Schema.getGlobalDescribe().get(u.ObjectName__c); 
                    objDef = objToken.getDescribe();
                }catch (exception e){
                    system.debug('Object name is likely invalid.  Object Name: '+u.ObjectName__c+'.  Error: '+e);
                    u.addError('Error: Invalid object name entered: '+u.ObjectName__c+'.  Please enter a valid object name.  Note object name is different from object label.');
                    break;
                }//try
                Map<String, SObjectField> fieldMap = objDef.fields.getMap();
                
                if(u.FieldName__c!=null){//if 1
                    try{
                        u.ObjectLabel__c=objDef.getLabel();
                        u.FieldLabel__c=FieldMap.get(u.FieldName__c).getDescribe().getLabel();
                        u.FieldType__c=String.valueOf(FieldMap.get(u.FieldName__c).getDescribe().getType());
                    }catch (Exception e){
                        system.debug('Field name is likely invalid for this object.  Field Name: '+u.FieldName__c+'.  Error: '+e);
                        u.adderror('Error: Invalid field name entered: '+u.FieldName__c+'.  Please enter a valid field name.  Note field name is different from field label.');
                    }    
                    String name=u.objectLabel__c+' '+u.FieldLabel__c+' '+u.Operator__c+' '+u.Value__c;
                    if(name.length()>80){
                        name=(u.objectLabel__c+' '+u.FieldLabel__c+' '+u.Operator__c+' '+u.Value__c).substring(0,79);
                    }
                    u.name=name;
                    if(u.DaysDelay__c!=null){
                        if(u.DaysDelay__c>0){
                            u.name+=', Delay '+u.DaysDelay__c+' Days';
                        }//if 4
                    }//if 3
                    u.FieldName__c=u.FieldName__c.toLowerCase();
                    if(u.Value__c!=null){
                        if(u.FieldType__c=='CURRENCY'|| u.FieldType__c=='DOUBLE'|| u.FieldType__c=='INTEGER'  || u.FieldType__c=='PERCENT'){
                            Double testValue=0;
                            try{
                                testValue=double.valueOf(u.Value__c);
                            } catch(Exception e){
                                system.debug('Value is like a text value for this number field. Value: '+u.Value__c+'.  Field Type: '+u.FieldType__c+'  Error: '+e);
                                u.adderror('Error: Invalid number entered as criteria: '+u.Value__c+'.  Please enter a number in Value.');
                            }//try
                        }//if 5
                    }//if 4
                }//if 3
            }//if 2
        }//if 1    
    }//for
    
}//trigger