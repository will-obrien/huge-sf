public class ButtonTestController2
{

    public String output{get; set;}
    public String name{get; set;}

    Schema.SObjectType convertType;
    Sobject genericObject;
    
    public ButtonTestController2()
    {
       
        
        String param=ApexPages.currentPage().getParameters().get('id');  
          output=findObjectNameFromRecordIdPrefix(param);
       
       
        System.debug('*******'+param+'*****'+output);
        
        convertType = Schema.getGlobalDescribe().get(output);      
        
        
      
        
    }
    
    public void addName()
    {
        genericObject = convertType.newSObject();
        genericObject.put('Name__c' , name) ;
        insert genericObject;
        
    }
    
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
           
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
           
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                System.debug('Prefix is ' + prefix);
                 
               
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }

}