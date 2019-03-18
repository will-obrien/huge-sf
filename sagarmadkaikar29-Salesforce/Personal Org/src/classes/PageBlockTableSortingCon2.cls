public class PageBlockTableSortingCon2 
{

    private List<Position__c> positions;
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
   
    public String Status{get; set;}
    public String disable{get; set;}
    public Integer counter{get; set;}
    
    public  PageBlockTableSortingCon2 ()
    {
        counter = 0;
        status = 'False';
        disable = 'False';
       
    }
    
    public void send()
    {
        
        status= 'True' ;
        disable = 'True';
        counter++;
        
    }
    public void send2()
    {
        
        status= 'False' ;
        disable = 'False';
        counter++;
        
    }
    
    

    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            if (value == sortExp)
               sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                 sortDirection = 'ASC';
           sortExp = value;
        }
    
    }
    
    public String getSortDirection()
     {
        //if not column is selected 
        
        
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
     
     public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
     
    
    public List<Position__c> getPositions() 
    {
        return positions;
    }
    
     public PageReference ViewData() 
     {
       //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
      
       //query the database based on the sort expression
       positions= Database.query('Select id, Name, Open_Date__c, Status__c, Close_Date__c from Position__c order by ' + sortFullExp + ' limit 1000');
       return null;
   }


   

}