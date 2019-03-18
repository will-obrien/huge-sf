public class assignmentSevenController{
    public map<String,schema.sObjectType> sobjectmap{get;set;}
    public List<SelectOption> soblist{get;set;}
    public list<selectOption> fieldnames{get;set;}
    public list<String> reqlist{get;set;}
    public list<sobject> newlist{get;set;}
    String addvalues{get;set;}
    public String data{get;set;}
    public String selectobj{get;set;}
    public sObject sObjectToBind {get;set;}
    public list<String>adddata{get;set;}
    
 public assignmentSevenController(){
       newlist = new list<sObject>();
      soblist = new List<SelectOption>();
      fieldnames = new List<SelectOption>();
      reqlist = new list<String>();
      sobjectmap = schema.getGlobalDescribe();
      system.debug('sobject********'+sobjectmap);
      list<String> entites = new list<String>(sobjectmap.keyset());
      entites.sort();
      system.debug('sobject********'+entites);
      for(String objname : entites){
          soblist.add(new selectOption(objname,objname));
      }
       
    }  
    public void name(){
       /* schema.sObjectType obj = sobjectmap.get(selectobj);
        system.debug('obj---------------->>'+obj);
         sObjectToBind = obj.newSObject();  
        system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'+sObjectToBind);
       Map<String,Schema.SObjectField> fieldMap = obj.getDescribe().fields.getMap();
      
       system.debug('filemap---------------->>'+fieldMap );
        reqlist.clear();
       for(Schema.SObjectField fieldname : fieldMap.values()){
           //fieldnames.add(new selectOption(fieldname,fieldname));
           
        Schema.DescribeFieldResult fieldResult = fieldname.getDescribe();  
        Schema.DisplayType fielddataType = fieldMap.get(fieldname).getDescribe().getType();
       system.debug('-------------+++++++++---fielddataType >>'+fielddataType);
      if(fieldResult.isAccessible() && fieldResult.isUpdateable() && fieldResult.isCreateable())  
              {      
                        reqlist.add(fieldResult.getName());
                        
               }

       }*/
       
       
       //---------------------------------field show all--------------------------------------------------
       
        schema.sObjectType obj = sobjectmap.get(selectobj);
        system.debug('obj---------------->>'+obj);
        
       Map<String,Schema.SObjectField> fieldMap = obj.getDescribe().fields.getMap();
      
       system.debug('filemap---------------->>'+fieldMap );
       reqlist.clear();
       for(String fieldname : fieldMap.keyset()){
         //fieldnames.add(new selectOption(fieldname,fieldname));
           
       // Schema.DescribeFieldResult fieldResult = fieldname.getDescribe();  
        Schema.DisplayType fielddataType =fieldMap.get(fieldname).getDescribe().getType();
       system.debug('-------------+++++++++---fielddataType >>'+fielddataType);
                        //newlist.add(fielddataType);
                        reqlist.add(fieldname);
             

       }
       
       
       
       
                
    }
       
     
    /* public void save(){
        System.debug('########################adddvalues'+adddata);
      newlist.add(data);
       System.debug('########################newlist====='+newlist);
         
     } */ 
       
  
  
   
}