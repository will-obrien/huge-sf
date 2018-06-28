global class QuickOrderController{
    public static List<Merchandise__c> merchandise;
    public static Line_Item__c quickOrder;
    
    public QuickOrderController(ApexPages.StandardController controller){  
    }
    
    @RemoteAction
    global static List<Merchandise__c> findWarehouses(String accId, String merchName, String warehouseDist){
         merchandise = new List<Merchandise__c>();
         String queryString = '';
         
         Account acc = [Select Location__Longitude__s, Location__Latitude__s, Name, Id from Account where Id =: accId];
         
         //Finds warehouses nearby if you have location specified on the Account
         if(acc.Location__Latitude__s != null && acc.Location__Longitude__s != null){
             queryString = 'SELECT Id, (SELECT Id, Name, Quantity__c, Warehouse__r.Name, Warehouse__r.Id, Warehouse__r.Street_Address__c, Warehouse__r.City__c '
                             +'FROM Merchandise__r WHERE Name like \'%'+merchName+'%\') '
                             +'FROM Warehouse__c WHERE '
                             +'DISTANCE(Location__c, GEOLOCATION('+acc.Location__Latitude__s+','+acc.Location__Longitude__s+'), \'mi\')';
             if(warehouseDist != null){                    
                 queryString += ' <'+ warehouseDist;
             }
             
         }
         //If no location defined on the Account, this will run query against the merchandise name only
         else {
             queryString = 'SELECT Id, Name, Location__Longitude__s, Location__Latitude__s, '
                          +'(SELECT Id, Name, Warehouse__r.Name, Quantity__c FROM Merchandise__r WHERE Name like \'%'+merchName+'%\') '
                          +'FROM Warehouse__c limit 25';
             
         }
         
		//This creates a list of merchandise to display in the search results
         Warehouse__c[] warehouses = Database.Query(queryString);
         for(Warehouse__c warehouse : warehouses){
             Merchandise__c[] merch = warehouse.getSObjects('Merchandise__r');
                 if (merch != null) {
                    for (Merchandise__c m : merch){ 
                        merchandise.add(m);
                    }
                 }    
         }
         return merchandise;
         
    }
    
    //This remote action creates the invoice for the quick order
    @RemoteAction
    global static Line_Item__c createQuickOrder(String accId, String merchandiseId){        
        Invoice__c newInvoice = new Invoice__c();
        newInvoice.Account__c = accId;
        insert newInvoice;
        
        quickOrder = new Line_Item__c();
        Merchandise__c m = [Select Id, Name from Merchandise__c where Id=: merchandiseId limit 1];
        quickOrder.Merchandise__c = m.Id;
        quickOrder.Invoice__c = newInvoice.Id;
        
        return quickOrder;   
    }
    
    //This remote action creates the line item related to the invoice for the quick order
    @RemoteAction
    global static Boolean insertQuickOrder(String o, String q, String aId){
        try {
            Integer quantity = integer.valueof(q);
            
            Line_Item__c order = new Line_Item__c();
            /* The order variable being passed in as a param is being passed in the form
            of a JSON object. You need to use the JSON deserialize method in Apex
            to convert it into a SObject */
            order = (Line_Item__c)JSON.deserialize(o, Line_Item__c.class);
            
            order.Quantity__c = quantity;
            insert order;
            
            //Need to requery for the name for the post to Chatter since it wasn't explicitly specified
            Line_Item__c li = [Select Name, Merchandise__r.Name, Id, Quantity__c, Invoice__c from Line_Item__c where Id =: order.Id];
            
            
            FeedItem post = new FeedItem();
            post.ParentId = aId;
            post.Body = UserInfo.getName() + ' just created a quick order';
            post.type = 'LinkPost'; 
            post.LinkUrl = '/' + li.Invoice__c;
            post.Title = li.Merchandise__r.Name + ': ' + li.quantity__c;
            insert post; 
        } catch(System.Exception ex) {
            system.debug(ex.getMessage());
        }
        
        return true;
    }
    
    //This remote action handles deleting the invoice if the user doesn't want to insert the line item
    @RemoteAction
    global static Boolean goBack(String invoiceId){
        // Delete created invoice and return to original search screen
        Invoice__c cancelledInvoice = [select Id from Invoice__c where Id=: invoiceId];
        delete cancelledInvoice;
        
        return true;
    }
    
}