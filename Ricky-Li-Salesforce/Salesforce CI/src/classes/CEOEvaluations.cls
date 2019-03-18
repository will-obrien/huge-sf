public class CEOEvaluations { 

  //Properties
    public List<Tour_Evaluation_Leader__c> listTEL{get;set;}
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}  
    
    public List<Summary> summaries{get;set;}            
    
    list <User> listUsers;
    String UserId;
    private String baseQuery; //= 'select Id, Tour_Evaluation__c,NPS__c, Trip_Code__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, CEO_Suggestions__c from Tour_Evaluation_Leader__c';
    private Integer totalNoOfRecs;
       
    public CEOEvaluations(ApexPages.StandardController controller) {
        pageSize = 10;
        //User Id    
        listUsers = [select id from User where Id =: Userinfo.getUserId()];
        userId = listUsers[0].Id;
        totalNoOfRecs = [select count() from Tour_Evaluation_Leader__c where SFUserID__c =: userId];
        baseQuery = 'select Id, Tour_Evaluation__c,NPS__c, Trip_Code__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, CEO_Suggestions__c from Tour_Evaluation_Leader__c where SFUserID__c =: userId and CEO_Overall_Average__c != NULL Order By CreatedDate Desc';
        
        getInitialTELSet();
    }

    public PageReference getInitialTELSet()
    {        
        pageNumber = 0;
        noOfPages = totalNoOfRecs/pageSize;
        decimal numTravellers = 0;
        decimal numTravellersThis = 0;
        decimal numTravellersLast = 0;
        decimal percentSubmit = 0;
        
        if (Math.mod(totalNoOfRecs, pageSize) > 0)
            noOfPages++;
        
        try{
           System.Debug(baseQuery +' order by CreatedDate DESC'+' limit '+pageSize);
           listTEL  = Database.query(baseQuery + ' limit '+pageSize);
           
           //get total travellers
           List<Leader__c> leaders = [select Trip_Code__c from Leader__c where SFUserID__c =: userId];
           
           Set<String> tripCodes = new Set<String>();
           for(Leader__c ld: leaders){
           	tripCodes.add(ld.Trip_Code__c);
           }
           List<Service__c> services = new List<Service__c>();
           List<Service__c> servicesThis = new List<Service__c>();
           List<Service__c> servicesLast = new List<Service__c>();
           
           Date startdate = date.parse('10/01/2012');//Only count service finish after 2012 Oct 1
           if(tripCodes.size() > 0){
           	services = [select Id from Service__c where Service_Status__c = 'Confirmed' and Service_Finish_Date__c <= Today and Service_Finish_Date__c >=:startdate and Trip_Code__c in: tripCodes];
           	servicesThis = [select Id from Service__c where Service_Status__c = 'Confirmed' and Service_Finish_Date__c = THIS_QUARTER and Trip_Code__c in: tripCodes];
           	servicesLast = [select Id from Service__c where Service_Status__c = 'Confirmed' and Service_Finish_Date__c = LAST_QUARTER and Trip_Code__c in: tripCodes];           	
           }
           
           Set<String> serviceId = new Set<String>();
           Set<String> serviceIdThis = new Set<String>();
           Set<String> serviceIdLast = new Set<String>();
           for(Service__c service: services){
           	serviceId.add(service.Id);
           }
           for(Service__c serviceThis: servicesThis){
           	serviceIdThis.add(serviceThis.Id);
           }
           for(Service__c serviceLast: servicesLast){
           	serviceIdLast.add(serviceLast.Id);
           }
           if(serviceId.size() > 0)
           	numTravellers = [select count() from TravellerServices__c where Traveller_Over_18__c = true and Service__c in: serviceId];
           if(serviceIdThis.size() > 0)
            numTravellersThis = [select count() from TravellerServices__c where Traveller_Over_18__c = true and Service__c in: serviceIdThis];
           if(serviceIdLast.size() > 0)
           	numTravellersLast = [select count() from TravellerServices__c where Traveller_Over_18__c = true and Service__c in: serviceIdLast];
           
           //get avg scores
           summaries = new list<Summary>();
           AggregateResult[] avgScores = [select avg(CEO_Communication__c) commu,avg(CEO_Enthusiasm__c) enthus,avg(CEO_Insight__c) insight,avg(CEO_Local_Knowledge__c) knowledge,avg(CEO_Management__c) management,avg(CEO_Professionalism__c) professional,avg(CEO_Overall_Average__c) overall from Tour_Evaluation_Leader__c  where SFUserID__c =: userId and CEO_Overall_Average__c != NULL];
           AggregateResult[] avgScoresThisQuarter = [select avg(CEO_Communication__c) commu,avg(CEO_Enthusiasm__c) enthus,avg(CEO_Insight__c) insight,avg(CEO_Local_Knowledge__c) knowledge,avg(CEO_Management__c) management,avg(CEO_Professionalism__c) professional,avg(CEO_Overall_Average__c) overall from Tour_Evaluation_Leader__c  where SFUserID__c =: userId and CEO_Overall_Average__c != NULL and Service_End_Date__c = THIS_QUARTER];
           AggregateResult[] avgScoresLastQuarter = [select avg(CEO_Communication__c) commu,avg(CEO_Enthusiasm__c) enthus,avg(CEO_Insight__c) insight,avg(CEO_Local_Knowledge__c) knowledge,avg(CEO_Management__c) management,avg(CEO_Professionalism__c) professional,avg(CEO_Overall_Average__c) overall from Tour_Evaluation_Leader__c  where SFUserID__c =: userId and CEO_Overall_Average__c != NULL and Service_End_Date__c = LAST_QUARTER];
           
           //Get number of submitted evaluations
           Integer thisQuarterNoOfEvals = [select count() from Tour_Evaluation_Leader__c where Service_End_Date__c = THIS_QUARTER and SFUserID__c =: userId];
           Integer lastQuarterNoOfEvals = [select count() from Tour_Evaluation_Leader__c where Service_End_Date__c = LAST_QUARTER and SFUserID__c =: userId];
		   
		   //Get overall nps score (#promoter/Total Eval - # detractor/Total Eval)*100%
		   Integer npsPromoter = [select count() from Tour_Evaluation_Leader__c where nps__c > 8 and SFUserID__c =: userId];
		   Integer npsDetractor = [select count() from Tour_Evaluation_Leader__c where nps__c < 7 and SFUserID__c =: userId];
		   decimal npsSummary = 0;
		   
		   If(totalNoOfRecs > 0)
		   	npsSummary = ((((decimal)npsPromoter - npsDetractor)*100/totalNoOfRecs)).setScale(0);
		   
		   //Get this quarter nps score 
		   Integer npsPromoterThis = [select count() from Tour_Evaluation_Leader__c where  Service_End_Date__c = THIS_QUARTER and nps__c > 8 and SFUserID__c =: userId];
		   Integer npsDetractorThis = [select count() from Tour_Evaluation_Leader__c where  Service_End_Date__c = THIS_QUARTER and nps__c < 7 and SFUserID__c =: userId];
		   decimal npsThisQuarter = 0;
		   If(thisQuarterNoOfEvals > 0)
		   	npsThisQuarter = ((((decimal)npsPromoterThis - npsDetractorThis)*100/thisQuarterNoOfEvals)).setScale(0);
		   
		   //Get last quarter nps score 
		   Integer npsPromoterLast = [select count() from Tour_Evaluation_Leader__c where Service_End_Date__c = LAST_QUARTER and nps__c > 8 and SFUserID__c =: userId];
		   Integer npsDetractorLast = [select count() from Tour_Evaluation_Leader__c where Service_End_Date__c = LAST_QUARTER and nps__c < 7 and SFUserID__c =: userId];
		   decimal npsLastQuarter = 0;
		   If(lastQuarterNoOfEvals > 0)
		   	npsLastQuarter = ((((decimal)npsPromoterLast - npsDetractorLast)*100/lastQuarterNoOfEvals)).setScale(0);
		   
		   if(avgScoresThisQuarter[0].get('overall') != null && numTravellersThis > 0){
		   	Summary sum = new Summary();
		   	sum.name = 'Current Quarter';
		   	sum.communication = ((decimal)avgScoresThisQuarter[0].get('commu')).setScale(2);
		   	sum.nps = npsThisQuarter;
		   	sum.enthusiasm = ((decimal)avgScoresThisQuarter[0].get('enthus')).setScale(2);
		   	sum.insight = ((decimal)avgScoresThisQuarter[0].get('insight')).setScale(2);
		   	sum.knowledge = ((decimal)avgScoresThisQuarter[0].get('knowledge')).setScale(2);
		   	sum.organization = ((decimal)avgScoresThisQuarter[0].get('management')).setScale(2);
		   	sum.professionalism = ((decimal)avgScoresThisQuarter[0].get('professional')).setScale(2);
		   	sum.total = ((decimal)avgScoresThisQuarter[0].get('overall')).setScale(2);
		   	sum.totalNoOfEvals = thisQuarterNoOfEvals;
		   	sum.numTravellers = numTravellersThis.intValue();
		   	sum.percentSubmit = (thisQuarterNoOfEvals/numTravellersThis * 100).setScale(2);
		   	summaries.add(sum);
		   }else if(listTEL.size() > 0){
		   	Summary sum = new Summary();
		   	sum.name = 'Current Quarter';
		   	sum.communication = 0.00;
		   	sum.nps = 0;
		   	sum.enthusiasm = 0.00;
		   	sum.insight = 0.00;
		   	sum.knowledge = 0.00;
		   	sum.organization = 0.00;
		   	sum.professionalism = 0.00;
		   	sum.total = 0.00;
		   	sum.totalNoOfEvals = 0;
		   	sum.numTravellers = 0;
		   	sum.percentSubmit = 0.00;
		   	summaries.add(sum);
		   }
		   if(avgScoresLastQuarter[0].get('overall') != null && numTravellersLast > 0){
		   	Summary sum = new Summary();
		   	sum.name = 'Last Quarter';
		   	sum.communication = ((decimal)avgScoresLastQuarter[0].get('commu')).setScale(2);
		   	sum.nps = npsLastQuarter;
		   	sum.enthusiasm = ((decimal)avgScoresLastQuarter[0].get('enthus')).setScale(2);
		   	sum.insight = ((decimal)avgScoresLastQuarter[0].get('insight')).setScale(2);
		   	sum.knowledge = ((decimal)avgScoresLastQuarter[0].get('knowledge')).setScale(2);
		   	sum.organization = ((decimal)avgScoresLastQuarter[0].get('management')).setScale(2);
		   	sum.professionalism = ((decimal)avgScoresLastQuarter[0].get('professional')).setScale(2);
		   	sum.total = ((decimal)avgScoresLastQuarter[0].get('overall')).setScale(2);
		   	sum.totalNoOfEvals = lastQuarterNoOfEvals;
		   	sum.numTravellers = numTravellersLast.intValue();
		   	sum.percentSubmit = (lastQuarterNoOfEvals/numTravellersLast * 100).setScale(2);
		   	summaries.add(sum);
		   }else if(listTEL.size() > 0){
		   	Summary sum = new Summary();
		   	sum.name = 'Last Quarter';
		   	sum.communication = 0.00;
		   	sum.nps = 0;
		   	sum.enthusiasm = 0.00;
		   	sum.insight = 0.00;
		   	sum.knowledge = 0.00;
		   	sum.organization = 0.00;
		   	sum.professionalism = 0.00;
		   	sum.total = 0.00;
		   	sum.totalNoOfEvals = 0;
		   	sum.numTravellers = 0;
		   	sum.percentSubmit = 0.00;
		   	summaries.add(sum);
		   }
		   if(listTEL.size() > 0 && numTravellers > 0){
		   	Summary sum = new Summary();
		   	sum.name = 'All Time';
		   	sum.communication = ((decimal)avgScores[0].get('commu')).setScale(2);
		   	sum.nps = npsSummary;
		   	sum.enthusiasm = ((decimal)avgScores[0].get('enthus')).setScale(2);
		   	sum.insight = ((decimal)avgScores[0].get('insight')).setScale(2);
		   	sum.knowledge = ((decimal)avgScores[0].get('knowledge')).setScale(2);
		   	sum.organization = ((decimal)avgScores[0].get('management')).setScale(2);
		   	sum.professionalism = ((decimal)avgScores[0].get('professional')).setScale(2);
		   	sum.total = ((decimal)avgScores[0].get('overall')).setScale(2);
		   	sum.totalNoOfEvals = totalNoOfRecs;
		   	sum.numTravellers = numTravellers.intValue();
		   	sum.percentSubmit = (totalNoOfRecs/numTravellers * 100).setScale(2);
		   	summaries.add(sum);
		   }
		     
           if(listTEL.size() == 0){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'Sorry! there is no evaluation records for you.'));
           }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;  
    }
    
    public PageReference next(){
        pageNumber++; 
        
        queryTEL();
        return null;
    }

    public PageReference previous(){
        pageNumber--;
        if (pageNumber < 0)
            return null;
        
        queryTEL();
        return null;
    }
    
    private void queryTEL()
    {
        Integer offset = pageNumber * pageSize;    
        String query = baseQuery +' limit '+pageSize +' offset '+ offset;
        System.debug('Query is'+query);
        try{
            listTEL = Database.query(query);

            if(listTEL.size() == 0)    
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'Sorry! there is no evaluation records for you.'));
        
        }
        catch(Exception e){
            ApexPages.addMessages(e);    
        }       
    }
    
    public class Summary {
    	public String name{get;set;}
    	public decimal nps{get;set;}
    	public decimal professionalism{get;set;}
		public decimal enthusiasm{get;set;}
		public decimal communication{get;set;}
		public decimal organization{get;set;}
		public decimal knowledge{get;set;}
		public decimal insight{get;set;}
		public decimal overallScore{get;set;}
		public decimal total{get;set;}   
    	public Integer totalNoOfEvals{get;set;}
    	public Integer numTravellers{get;set;}
    	public Decimal percentSubmit{get;set;}
    }
}