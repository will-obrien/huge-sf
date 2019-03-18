/*********************************************************************
Name : ShowIMReportController 
Created On : jan 04, 2012  
Created By : Lalit Bohra
Description : Controller for ShowIMReport page where we will show report for lead and contact object.
**********************************************************************/
public with sharing class ShowIMReportController {
	public PageReference ShowIMReport(){
	   String ReportId=null;	   
	   try{	   	   
		   String reportType= ApexPages.currentPage().getParameters().get('ReportType');
		   String imUserId= ApexPages.currentPage().getParameters().get('ImUserId');
		   // this will show lead report
		   if(reportType=='Lead' && imUserId!=null && imUserId != ''){	   
		   		for(Report Leadreport:[Select r.Name, r.Id From Report r where Name='LeadIMeetData']){
		   		   ReportId=LeadReport.Id;	   		    
				   PageReference pr = new PageReference('/'+ReportId+'?pv0='+imUserId);	   
			       pr.setRedirect(true);			       
			       return pr;
		   		}
		   }
		    // this will show contact report
		   else if(reportType=='Contact' && imUserId!=null && imUserId != ''){	   
		   		for(Report ContactReport:[Select r.Name, r.Id From Report r where Name='ContactIMeetData']){
		   		   ReportId=ContactReport.Id;	   		    
				   PageReference pr = new PageReference('/'+ReportId+'?pv0='+imUserId);	   
			       pr.setRedirect(true);			      
			       return pr;
		   		}
		   }
		   return null;	
	   }
	   catch(exception ex){
	   	//system.debug('-------------- Exception '+ ex);
	   	//ShowMessage=true;
	   	return null;
	   }
	}
}