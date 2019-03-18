global class GBL_MultiSelectLookup_CTRL {

    public GBL_MultiSelectLookup_CTRL()
    {
        
        
    }
    
    @RemoteAction
    global static  List<List_Of_Names__c> getItemsList(String fieldName)
    {
      List<List_Of_Names__c> listItems;
        
     listItems= [Select Id, Name from List_Of_Names__c where  MultiSelectIdentifier__c=:fieldName  ORDER BY Name ASC ];

        return listItems;
        
   }
    
     public GBL_MultiSelectLookup_CTRL (ApexPages.StandardController controller) 
     {

 
    }
   
}