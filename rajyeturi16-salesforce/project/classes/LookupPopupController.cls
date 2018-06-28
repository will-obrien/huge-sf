public with sharing class LookupPopupController 
{

    public string accname{get;set;}
    public string acc1{get;set;}
    public string fieldname{get;set;}
    public string tempstring{get;set;}
    public boolean searchbox{get;set;}
    public boolean showacclist{get;set;}
    public string actname{get;set;}
    public sObject objct {get;set;}
    public boolean message{get;set;}
    // To set the error message
    public Boolean blErr{get; set;}
    // To hold the accounts
    public List<sObject> acclist {get; set;}
    // To hold the object API name
    public string objName;
    // To hold the query
    public  String query1;
    public Wrapper test1 { get; set; }
    public List<Wrapper> testList { get; set; }
    
    public LookupPopupController()
    {
    
      try{
     /*  tempstring = ApexPages.currentPage().getParameters().get('str');
       objName = ApexPages.currentPage().getParameters().get('obj');
       if(objName != '')
       {
           objct = Schema.getGlobalDescribe().get(objName).newSObject() ;
       }
       */
       system.debug(tempstring +'Shwetha');
        searchbox = true;
        showacclist = false;
        blErr = False;
        acclist = new List<sObject>();
        autodisplay();
       
       }
       catch(Exception ex)
       {}
        
    }
    
    public void autodisplay()
    {
       tempstring = ApexPages.currentPage().getParameters().get('str');
       objName = ApexPages.currentPage().getParameters().get('obj');
       
       system.debug('********************'+objName);
       system.debug('#####'+ fieldname );
       if(objName != '')
       {
           objct = Schema.getGlobalDescribe().get(objName).newSObject() ;
       }
         accname = tempstring;
        showaccounts();    
    }
    
    
    public pagereference showaccounts()
    {
            system.debug(accname + 'Varma'+acc1);
           
           try{
            //tempstring = ApexPages.currentPage().getParameters().get('str');
            tempstring = accname;
            system.debug(tempstring + '####');
            searchbox = true;
            showacclist = true;
           // string tempInput = '%' + accname + '%';
          
           string tempInput  ='\'' + accname + '%\'';
            String allobj='Account';
           // system.debug('Shwetha'+tempInput +allobj );
           // String query1= 'Select Id , Name from '+allobj+' where name like  : '+tempInput;
          
         //  String query1= 'Select Id , Name from '+allobj+' where name  LIKE ' + accname + '%';
           if(objName != '')
           query1= 'Select Id , Name from '+ objName +' where name Like '+tempInput; 
            system.debug('shwetha***********'+query1);
            
        
            acclist = database.query(query1);
            System.debug('------------'+acclist);
            //acclist = [SELECT ID,Name from Account where Name LIKE : accname+'%' ];
            system.debug('************fdtd*****'+acclist.size());
            
            
             testList = new List<Wrapper>();
             if(acclist.size()>0)
             {
                for(sObject so : acclist)
                {
                 test1 = new Wrapper();
                 test1.obj = so;
                 testList.add(test1);
                }
            }
            if(testList.size()<=0)
            { 
                 system.debug('*****************'+acclist.size());
                 apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,'No Records Found,Please create a new Record'));
                 blErr = true;
            }
            else{ 
                blErr = False;
            }
            system.debug(acclist + '*****') ;
          }
          catch(Exception ex)
          {}
          pagereference pageref = new pagereference('/apex/LookupExamplePopup?str='+ tempstring); 
           
           
           //return pageref ;
           return null;
    }
    
    public pagereference saveacc()
    {
        objName = ApexPages.currentPage().getParameters().get('obj');
        objct = Schema.getGlobalDescribe().get(objName).newSObject() ;
        //objct.Name = actname;
        insert objct;
        //objct = new objct();
        return null;
    }

    ///wrapper
    public class wrapper
    {
         public SObject obj { get; set; }
    }

}