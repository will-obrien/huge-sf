public class fetchRecordSFID
{
    //public List<String> obj = new List<String>();
    //public List<String> fld = new List<String>();
    
    public string sfIdValue = ApexPages.currentPage().getParameters().get('Id');
    public string completeURL = ApexPages.currentPage().getUrl();
    public string fieldValue;
    //public List<Sobject> Ids = new Sobject[]{};
    public PageReference newPage;
    public string url;
    //public string qryString;

    public fetchRecordSFID(){}

    public PageReference getRedirectURL()
    {
        Integer i,notnullindex;
        try
        {
             if(completeURL==null)
             {
                 return newPage;
             }
             else
             {
               if(sfIdValue<>null)
               {
                     url = '/' + sfIdValue;
                    newPage = new PageReference(url);
                    newPage.setRedirect(true);
                 } 

              }
        }
        catch(exception e)
        {
          
           
        }
    return newPage;    
    }
}