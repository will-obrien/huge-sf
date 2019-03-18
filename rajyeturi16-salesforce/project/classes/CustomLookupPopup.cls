public with sharing class CustomLookupPopup
{

    public string accname{get;set;}
    public string acc1{get;set;}
    
    public string tempstring{get;set;}
    public boolean searchbox{get;set;}
    public boolean showacclist{get;set;}
    public string actname{get;set;}
    public account acc{get;set;}
    public boolean message{get;set;}
    public list<account> acclist{get;set;}
    // To set the error message
    public Boolean blErr{get; set;}
    
    public CustomLookupPopup()
    {
       tempstring = ApexPages.currentPage().getParameters().get('str');
       system.debug(tempstring +'Shwetha');
        acc = new account();
        searchbox = true;
        showacclist = false;
        blErr = False;
        acclist = new list<account>();
        system.debug('accnameaccnameaccnameaccnameaccname'+accname);
        
        
    }
    
    public void autodisplay()
    {
        accname = tempstring;
        showaccounts();    
    }
    
    
    public pagereference showaccounts()
    {
            system.debug(accname + 'Varma'+acc1);
           
            //tempstring = ApexPages.currentPage().getParameters().get('str');
            tempstring = accname;
            system.debug(tempstring + '####');
            searchbox = true;
            showacclist = true;
            acclist = [SELECT ID,Name from Account where Name LIKE : accname+'%' ];
            system.debug('************fdtd*****'+acclist.size());
            if(acclist.size()<=0)
            { 
                 system.debug('*****************'+acclist.size());
                 apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,'No Records Found,Please Create New Account'));
                 blErr = true;
            } 
            blErr = False;
            system.debug(acclist + '*****') ;
          pagereference pageref = new pagereference('/apex/LookupExamplePopup?str='+ tempstring); 
           
           
           //return pageref ;
           return null;
    }
    
    public pagereference saveacc()
    {
        acc.Name = actname;
        insert acc;
        return null;
    }


}