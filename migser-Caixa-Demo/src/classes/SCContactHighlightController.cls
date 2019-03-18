public class SCContactHighlightController {
    public String cID {get;set;}
    public String aID {set;get;}
    public Contact c {get;set;}
    public Account a {get;set;}
    public Boolean cleans {get;set;}
    public Integer total {get;set;}
    public Integer psize {get;set;}
    public List <Event> elist {get;set;}
    public List <Case> clist {get;set;}
    public List <Task> tlist {get;set;}
    public List <P_lizas__c> plist {get;set;}
    
    public SCContactHighlightController (){
        ApexPages.currentPage().getParameters().get('id');
        ID currRecordId = ID.valueOf(ApexPages.currentPage().getParameters().get('Id'));
        String primaryTabObjectType = String.valueOf(currRecordId.getSObjectType());
        
        // Determine whether this is an account or a contact object...
        if (primaryTabObjectType == 'Contact') {
            // Populate the contact details
            // Grab the account details from the contat record
            cID = currRecordId;
            c = [SELECT Name, LeadSource, Activity_Indicator__c, Total_of_Activities__c, Days_Since_Last_Activity__c, Phone, Email,
                Title, AccountId, Account.Name, Account.Industry, Account.Type, Account.Closed_Won_Value__c, Account.Rating_Indicator__c FROM Contact WHERE id =:cID];
            aID = c.AccountId;
        } else if (primaryTabObjectType == 'Account') { 
            aID = currRecordId;
        } else {
            System.debug('Ummmmm.... I cannot handle a ' + primaryTabObjectType + ' object.');
        }
                                     
        
        a = [Select Name, Id, Site, Phone, CleanStatus, NumberOfEmployees, AccountSource, Website, Industry, Type, Closed_Won_Value__c, Rating_Indicator__c, Region__c, Days_Since_Activity__c, Segmento__c, Fecha_Renovacion_Proxima__c, cci__c, Num_Siniestros__c, I7_Revenue_YTD__c, I8_Margin_YTD__c From Account Where id =:aID];        
        elist = [Select Id, AccountId From Event Where AccountId = :a.Id];
        
        tlist = [Select Id, AccountId From Task Where AccountId =:a.Id];
        
        clist = [Select Id, AccountId FROM Case Where AccountId =:a.Id];
        
        plist = [Select Id from P_lizas__c Where account__c =: a.Id];
        IF(a.CleanStatus == 'In Sync'){ 
            cleans= true;
        }    
        
       // total = elist.size() + tlist.size();
        total = clist.size();
        psize = plist.size();
        
    }

}