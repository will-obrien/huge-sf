/**
*  Description : Controller Class to show How to utilize existing List View in Apex with Pagination Support
*
*  Author : Jitendra Zaa
*/
public with sharing class ListViewDemo {

  private String baseQuery = 'Select ID, Name FROM Account ORDER BY NAME ASC';
  public String AccFilterId {get; set;}
  private Integer pageSize = 10;

  public ListViewDemo(){}

  public ApexPages.StandardSetController AccSetController {
        get{
            if(AccSetController == null){
                AccSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                AccSetController.setPageSize(pageSize);

                // We have to set FilterId after Pagesize, else it will not work
                if(AccFilterId != null)
                {
                  AccSetController.setFilterId(AccFilterId);
                }
            }
            return AccSetController;
        }set;
    }

  public ListViewDemo(ApexPages.StandardSetController c) {   }

    //Navigate to first Page
    public void firstPage()
    {
      AccSetController.first();
    }

    //Navigate to last Page
    public void lastPage()
    {
      AccSetController.last();
    }

    //Navigate to Next page
    public void next()
    {
      if(AccSetController.getHasNext())
      {
        AccSetController.next();
      }
    }

    //Navigate to Prev Page
    public void prev()
    {
      if(AccSetController.getHasPrevious())
      {
        AccSetController.previous();
      }
    }

    public List<Account> getAccounts()
    {
      return (List<Account>)AccSetController.getRecords();
    }

    //Get all available list view for Account
    public SelectOption[] getAccountExistingViews(){
        return AccSetController.getListViewOptions();
    }

    /**
    * Reset List View
    */
    public PageReference resetFilter()
    {
      AccSetController = null;
        AccSetController.setPageNumber(1);
        return null;
    }

}