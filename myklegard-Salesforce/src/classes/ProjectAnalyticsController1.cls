public class ProjectAnalyticsController1
{
    public List<SelectOption> PortfolioProjects 
    { 
        public get;
        private set;
    }
    
    public String xAxisOptions
    {
        public get;
        private set;

    }
    
    public String yAxisOptions
    {
        public get;
        private set;
    }    
    
    public String projDataPoints
    {
        public get;
        private set;
    }
    
    public Map<String,Integer> portfolioMap = new Map<String,Integer>();
    public Map<String,Integer> projectPhaseMap = new Map<String,Integer>();
    public Map<String,Integer> projectStatusMap = new Map<String,Integer>();
    private String xCategories;
    private String yCategories;
    public String projectData;
    
    
    public List<SelectOption> ProjectPhases
    { 
        public get;
        private set;
    }

    
    public List<SelectOption> ProjectStatusListing 
    { 
        public get;
        private set;
    }   

    public ProjectAnalyticsController1() 
    {    
        this.PortfolioProjects = getPortfolioProjects();
        this.ProjectPhases = getProjectPhases();
        this.ProjectStatusListing  = getProjectStatusListing ();
        this.xAxisOptions = xCategories;
        this.yAxisOptions = yCategories;
        this.projDataPoints = getHighChartData('','');
        system.debug(xCategories);
        system.debug(yCategories);
    }
    
    public List<SelectOption> getPortfolioProjects()    
    {
       List<SelectOption> options = new List<SelectOption>();            
       Schema.DescribeFieldResult fieldResult =
       Project__c.Portfolios__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       Integer i = 1;
       portfolioMap.clear();
       xCategories = '[';
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(),f.getValue()));
          portfolioMap.put(f.getValue(),i++);
          xCategories = xCategories + '\'' + f.getValue().Replace('\'', '') +'\',';
       }       
       xCategories = xCategories.removeEnd(',');
       xCategories = xCategories + ']';
       return options;
    }
    
    public List<SelectOption> getProjectPhases()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       Project__c.Project_Phase__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       Integer i = 1;
       projectPhaseMap.clear();
       yCategories = '[';
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(),f.getValue()));
          projectPhaseMap.put(f.getValue(),i++);
          yCategories = yCategories +'\'' +f.getValue() +'\',';
       }       
       yCategories = yCategories.removeEnd(',');
       yCategories = yCategories + ']';
       return options;
    }
    
    
    public List<SelectOption> getProjectStatusListing()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       Project__c.Project_Status__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       Integer i =1;
       projectStatusMap.clear();
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(),f.getValue()));
          projectStatusMap.put(f.getValue(),i++);
       }       
       return options;
     }
     
     public List<String> GetProjectStatusList()
     {
           Schema.DescribeFieldResult fieldResult = Project__c.Project_Status__c.getDescribe();    
           List<String> lsStatus = new List<String>();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           for( Schema.PicklistEntry f : ple)
           {
              lsStatus.add(f.getValue());
           }       
           return lsStatus;
      }
     
     
     public string getHighChartData(string portfolioName, string  projectPhase)
     {
         
        List<Project__c> rtprojects = new List<Project__c>();
        
        if(!string.IsEmpty(portfolioName) && !string.IsEmpty(projectPhase))
        {
            rtprojects = [SELECT Id, Name,Stoplight_Status__c,Project_Status__c, Portfolios__c,Project_Phase__c,Total_Funding1__c FROM
                    Project__c WHERE Portfolios__c =: portfolioName AND Project_Phase__c = :projectPhase];                  
            
        }
        else if(!string.IsEmpty(portfolioName) && string.IsEmpty(projectPhase))
        {
            rtprojects = [SELECT Id, Name, Stoplight_Status__c,Project_Status__c, Portfolios__c,Project_Phase__c,Total_Funding1__c FROM
                      Project__c WHERE Portfolios__c =: portfolioName];                                     
        }
        else if(!string.IsEmpty(portfolioName))
        {
            rtprojects = [SELECT Id, Name, Stoplight_Status__c, Project_Status__c, Portfolios__c,Project_Phase__c,Total_Funding1__c FROM
                    Project__c WHERE Project_Phase__c =: projectPhase];                                                 
        }        
        else
        {
            rtprojects = [SELECT Id, Name, Stoplight_Status__c, Project_Status__c, Portfolios__c,Project_Phase__c,Total_Funding1__c FROM
                    Project__c];                                                 
        }
        
        List<String> lsStatus = GetProjectStatusList();
        
        projDataPoints = '[';
        for(String indStatus : lsStatus)
        {
        
            projDataPoints = projDataPoints + '{data: [';   
            for(Project__c pc : rtprojects)
            {
                if(indStatus == pc.Project_Status__c)
                projDataPoints = projDataPoints + GenerateProjectData(pc) + ',';
            }
            
            projDataPoints = projDataPoints.removeEnd(',');
            projDataPoints = projDataPoints + ']},';
        }
        
         projDataPoints = projDataPoints.removeEnd(',');
         projDataPoints = projDataPoints + ']';
        
        return projDataPoints;     
     }
     
     
     public string GenerateProjectData(Project__c pc)
     {
         System.Debug('Project Info ' + pc);
         System.Debug('portfolioMap ' + portfolioMap);
         integer portfolio = 0;
         
         if(!string.IsEmpty(pc.Portfolios__c))          
         {
             System.Debug('Inside for loop ' + pc.Portfolios__c);
             portfolio = this.portfolioMap.get(pc.Portfolios__c);
             
             if(portfolio == null)
             {
                 portfolio =0;
             }         
         }
         System.Debug('portfolio ' + portfolio);         
         integer projectPhase = 0;
         if(!string.IsEmpty(pc.Project_Phase__c))          
         {
            projectPhase = this.projectPhaseMap.get(pc.Project_Phase__c);
         }         
         System.Debug('projectPhase ' + projectPhase);
         
         Decimal totFunding = 1; 
         if(pc.Total_Funding1__c != null)
         {
             totFunding = pc.Total_Funding1__c;
         }
         List<String> fillers = new String[]{string.valueof(portfolio),string.valueof(projectPhase),string.valueof(totFunding)};
         System.Debug('fillers ' + fillers);         
         return string.format('[{0},{1},{2}]',fillers);
     }
     
     
     
     public PageReference ChartGenerate() 
     {
        return null;
     }


}