public class ChatterMonitorController {
  public Boolean showRecords{get;set;}
    public List<FeedItem> cust {get;set;}
    public FeedItem startDate {get;set;}
    public FeedItem endDate {get;set;}
    
    //In constructor
    
    public ChatterMonitorController() {
      showRecords =false; 
        startDate = new FeedItem();        
        endDate = new FeedItem();
        
    }
    
    public void fetchRecords(){
            
    cust = [SELECT ID, CreatedDate, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, ParentId, Parent.Name, Body FROM FeedItem 
            where CreatedDate>= LAST_N_YEARS:4 and CreatedDate <=TODAY LIMIT 500  ];
    showRecords = true;
    }    

    
    }