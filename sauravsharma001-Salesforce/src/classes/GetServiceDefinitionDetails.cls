/* 
 * Get Service Definition Details is used to storing the required field for a particular service code,
 * to hardcode all the datatype description,
 * to encrypt and decrypt a field name ,
 *  to generate key value for Picklist datatype fields
 */

global with sharing class GetServiceDefinitionDetails  {
        
    // Method for Storing the required field name for particular Service Code- Start    
    global list<String> fieldList(String serviceCode)  {
    
        List<Open311Field__c> fieldList = Open311Field__c.getall().values();
        list<String> fields = new list<String>();
        list<String> fields2 = new list<String>();
        String allCustField = '';
        if(fieldList != null && fieldList.size() > 0)    {
            for(Open311Field__c op311 : fieldList )    {
                if(op311.Name.equalsIgnoreCase(serviceCode))    {
                    allCustField = op311.Custom_Fields_1__c;            
                    fields = allCustField.split(';');
                    if(op311.Custom_Fields_2__c != null)    {
                        allCustField = op311.Custom_Fields_2__c;            
                        if(op311.Custom_Fields_3__c != null && op311.Custom_Fields_3__c != '')
                            allCustField += op311.Custom_Fields_3__c;
                        fields2 = allCustField.split(';');
                    }
                }
            }
            if(fields2 != null && fields2.size() >0)    {
                for(String s1: fields2)
                    fields.add(s1);
            }
            System.debug('GetServiceDefinitionDetails.fieldList: ' + fields.size() + '  ' + fields);
            return fields;
        }
        else {
            System.debug('GetServiceDefinitionDetails.fieldList: null');
            return null;       
        }    
    }           
    // Method for Storing the required field name for particular Service Code- End
    
    // Method for getting all field Code which are not required for a SR
    global String fieldListNotReqd(String serviceCode, String fieldName)  {
        List<Open311Field__c> fieldList = Open311Field__c.getall().values();
        list<String> fields = new list<String>();
        String notReqdField= '';
        if(fieldList != null && fieldList.size() > 0)    {
            for(Open311Field__c op311 : fieldList )    {
                if(op311.Name.equalsIgnoreCase(serviceCode))    {
                    if(op311.Not_Required_Fields__c != null)
                        notReqdField = op311.Not_Required_Fields__c;            
                    fields = notReqdField.split(';');
                }
            }
            if(fields!= null && fields.size() > 0)    {
                for(String f : fields)    {
                    if(f.equalsIgnoreCase(fieldName))
                        return 'false';
                }
            }    
        }
        return 'true';
    }
    
    // For getting all corresponding field Code of fields Name for a SR
    global Map<String,String> fieldListCode(String serviceCode)  {
        List<Open311Field__c> fieldList = Open311Field__c.getall().values();
        Map<String,String> fields = new Map<String,String>();
        Map<String,String> fields2 = new Map<String,String>();
        List<String> temp = new List<String>();
        List<String> temp2 = new List<String>();
        String encryptCode = '';
        String allCustField = ''; 
        integer i = 0;
        if(fieldList != null && fieldList.size() > 0)    {
            for(Open311Field__c op311 : fieldList )    {
                if(op311.Name.equalsIgnoreCase(serviceCode))    {
                    encryptCode = op311.Encrypted_Code_Name_1__c;      
                    allCustField = op311.Custom_Fields_1__c;     
                    temp = encryptCode.split(';');  
                    temp2 = allCustField.split(';');
                    System.debug('temp : ' + temp);
                    System.debug('temp2 : ' + temp2);
                    System.debug('temp Length: ' + temp.size());
                    System.debug('temp2 Length: ' + temp2.size());
                    for(i=0; i< temp.size() ; i++ )    {
                        fields.put(temp2.get(i),temp.get(i));
                    }                    
                    if(op311.Encrypted_Code_Name_2__c!= null)    {
                        allCustField = op311.Custom_Fields_2__c;  
                        encryptCode = op311.Encrypted_Code_Name_2__c;    
                        if(op311.Custom_Fields_3__c != null && op311.Custom_Fields_3__c != '')    {
                            allCustField += op311.Custom_Fields_3__c;        
                            encryptCode += op311.Encrypted_Code_Name_3__c;    
                        }    
                        temp = encryptCode.split(';');
                        temp2 = allCustField.split(';');
                        for(i = 0; i< temp.size() ; i++ )    {
                            fields.put(temp2.get(i),temp.get(i));
                        } 
                    }
                }
            }
            System.debug('GetServiceDefinitionDetails.fieldListCode: ' + fields.size() + '  ' + fields);
            return fields;
        }
        else {
            System.debug('GetServiceDefinitionDetails.fieldListCode: null');
            return null;
        }    
    }
    
    // For getting Field API Name from the given code
    global String decryptFieldListCode(String serviceCode, String code)  {
        List<Open311Field__c> fieldList = Open311Field__c.getall().values();
        List<String> fieldCode = new List<String>();
        List<String> fieldNames = new List<String>();
        String encryptCode  = '', allCustField = '';
        
        if(fieldList != null && fieldList.size() > 0)    {
            for(Open311Field__c op311 : fieldList )    {
                if(op311.Name.equalsIgnoreCase(serviceCode))    {
                    encryptCode = op311.Encrypted_Code_Name_1__c;      
                    allCustField = op311.Custom_Fields_1__c;  
                    if(encryptCode.indexOf(code) != -1)    {
                        fieldCode = encryptCode.split(';');
                        fieldNames = allCustField.split(';');
                        for(integer i = 0; i< fieldCode.size() ; i++ )    {
                            if(code.equalsIgnoreCase(fieldCode.get(i)))
                                return fieldNames.get(i);
                        }
                    }
                    else if(op311.Encrypted_Code_Name_2__c != null){
                        encryptCode = op311.Encrypted_Code_Name_2__c;      
                        allCustField = op311.Custom_Fields_2__c;  
                        if(op311.Custom_Fields_3__c != null && op311.Custom_Fields_3__c != '')    {
                            allCustField += op311.Custom_Fields_3__c;        
                            encryptCode += op311.Encrypted_Code_Name_3__c;    
                        } 
                        if(encryptCode.indexOf(code) != -1)    {
                            fieldCode = encryptCode.split(';');
                            fieldNames = allCustField.split(';');
                            for(integer i = 0; i< fieldCode.size() ; i++ )    {
                                if(code.equalsIgnoreCase(fieldCode.get(i)))    {
                                    System.debug('GetServiceDefinitionDetails.decryptFieldListCode: '+ fieldNames.get(i));
                                    return fieldNames.get(i);
                                }    
                            }
                        }    
                    }
                }
            }
        }
        System.debug('GetServiceDefinitionDetails.decryptFieldListCode: invalid');
        return 'invalid';    
    }
    
    // Method for Storing the datatype description - Start    
     global string getDatatypeDescription(String fieldType) {
        String dataDescription='';
        if(fieldType=='DataCategoryGroupReference')
            dataDescription='Creates a relationship that links this object to another object. The relationship field allows users to click on a lookup icon to select a value from a popup list. The other object is the source of the values in the list.';
        else if(fieldType=='Currency')
            dataDescription='Allows users to enter a dollar or other currency amount and automatically formats the field as a currency amount. This can be useful if you export data to Excel or another spreadsheet.';
        else if(fieldType=='Boolean')
            dataDescription='Boolean (true or false) values.';
        else if(fieldType=='Date')
            dataDescription='Allows users to enter a date or pick a date from a popup calendar.';
        else if(fieldType=='Date/Time')
            dataDescription='Allows users to enter a date and time, or pick a date from a popup calendar. When users click a date in the popup, that date and the current time are entered into the Date/Time field.';
        else if(fieldType=='Email')
            dataDescription='Allows users to enter an email address, which is validated to ensure proper format. If this field is specified for a contact or lead, users can choose the address when clicking Send an Email. Note that custom email addresses cannot be used for mass emails.';
        else if(fieldType=='Geolocation')
            dataDescription='Allows users to define locations.';
        else if(fieldType=='Integer')
            dataDescription='Allows users to enter any number. Leading zeros are removed.';
        else if(fieldType=='Percent')
            dataDescription='Allows users to enter a percentage number, for example, 10 and automatically adds the percent sign to the number.';
        else if(fieldType=='Phone')
            dataDescription='Allows users to enter any phone number. Automatically formats it as a phone number.';
        else if(fieldType=='Picklist')
            dataDescription='Allows users to select a value from a list you define.';
        else if(fieldType=='MultiPicklist')
            dataDescription='Allows users to select multiple values from a list you define.';
        else if(fieldType=='String')
            dataDescription='Allows users to enter any combination of letters and numbers.';
        else if(fieldType=='TextArea')
            dataDescription='Allows users to enter up to 255 characters on separate lines.';
        else if(fieldType=='EncryptedString')
            dataDescription='Allows users to enter any combination of letters and numbers and store them in encrypted form.';
        else if(fieldType=='URL')
            dataDescription='Allows users to enter any valid website address. When users click on the field, the URL will open in a separate browser window.';
                 
        return dataDescription;
    }       // Method for Storing the datatype description - End
      
}        // End of Class GetServiceDefinitionDetails