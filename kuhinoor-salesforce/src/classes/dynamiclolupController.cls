Public Class dynamiclolupController{
    Public String selectedobj{get;set;}    
    Public Contact con{get;set;}
    Public String Dynamicsobj{get;set;}
    Public String keyPrefix{get;set;}
     Public String url{get;set;}
   
   // Public List<sObjectWrapper> sObjList{get;set;}
    
    //------cons --------------------
    Public dynamiclolupController(){
    }
    
    Public List<SelectOption> getNames(){
        List<Schema.sObjectType> gd = Schema.getGlobalDescribe().values();
        List<SelectOption> options = new List<SelectOption>();
        for(schema.sObjectType t : gd){
            system.debug('0000'+t.getDescribe().getkeyPrefix());
            if(t.getDescribe().getkeyPrefix()!=null){
            options.add(new selectOption(t.getDescribe().getkeyPrefix(),t.getDescribe().getName()));
           }
        }
        system.debug('0000'+options);
        return options;
    }
  public void demo(){
      url='https://ap1.salesforce.com/_ui/common/data/LookupPage?lkfm=page%3Afrm&lknm=page%3Afrm%3Ablock%3Awhatid&lktp='+selectedobj+'&lksrch=';
  }
}